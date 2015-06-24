#include <QtNetwork>

#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_pushButton_clicked()
{
    QString urlstr = this->ui->lineEdit->text().trimmed();
    QUrl url(urlstr);
    qDebug()<<url;

    QString user_name = this->ui->comboBox->currentText().trimmed();
    QString password = this->ui->lineEdit_2->text();
    QString SESSION_TOKEN = "9FFD14CFE9B8ED5D0D07DFA9B8FCAFA6"; // "966D2373534B733BA75A6FCA77C14445";
    QString LoginType = "Explicit";

    if (password.isEmpty()) {
        this->ui->plainTextEdit->appendPlainText("password can not empty.");
        return;
    }

    QNetworkAccessManager *nam = new QNetworkAccessManager();
    QNetworkRequest req(url);
    QString data = QString("user=%1&").arg(user_name)
        + QString("SESSION_TOKEN=%1&").arg(SESSION_TOKEN)
        + QString("LoginType=%1&").arg(LoginType)
        + QString("password=%1").arg(password);

    qDebug()<<data;
    QNetworkReply *reply = nam->post(req, data.toLatin1());
//    connect(reply, &QNetworkReply::finished, [reply] () {
//        qDebug()<<"request finished."<<reply->rawHeaderList()
//               <<reply->readAll();
//        foreach (auto &i, reply->rawHeaderList()) {
//            qDebug()<<i<<reply->rawHeader(i);
//        }
//    });
    Q_UNUSED(reply);

    MainWindow *mw = this;

    auto req_callback =  [nam, url, mw] (QNetworkReply *reply) {
        QNetworkRequest req = reply->request();
        QString  reqpath = reply->request().url().path();
        qDebug()<<reply->attribute(QNetworkRequest::HttpStatusCodeAttribute)
        <<reply->header(QNetworkRequest::ContentLengthHeader)
        << req.url() << req.url().query() << req.url().hasQuery();
        
        if (reqpath.startsWith("/Citrix/XenApp/auth/login.aspx")) {
            // /Citrix/XenApp/auth/login.aspx%3FCTX_MessageType=ERROR&CTX_MessageKey=InvalidCredentials
            if (reqpath.indexOf("CTX_MessageType=ERROR") >= 0) {
                reqpath = reqpath.replace("%3F", "?");
                qDebug()<<"has error:"<<QUrl(reqpath).query();
            } else {
                QString loc = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toString();
                QVariant cookie = reply->header(QNetworkRequest::SetCookieHeader);
                QVariant cookie2 = reply->header(QNetworkRequest::CookieHeader);

                qDebug()<<loc<<cookie<<cookie2<<nam->cookieJar()->cookiesForUrl(url);

                QUrl newurl = url;
                newurl.setPath(loc);
                QNetworkRequest newreq(newurl);

                nam->get(newreq);
            }
        } else if (reqpath.startsWith("/Citrix/XenApp/site/default.aspx")) {
            qDebug()<<"to be impled";
            QByteArray html = reply->readAll();
            QString strhtml = html;

            QHash<QString, QString> acts;

            // QRegExp re("href=\"launcher.aspx\?CTX_Application=Citrix.MPS.App.GKGroup.(.*)&amp;CTX_Token=(.*)\"");
            QRegExp re("href=\"(launcher.aspx.CTX_Application=Citrix.MPS.App.GKGroup.(.*)&amp;CTX_Token=(.*))\"");
            re.setMinimal(true);
            int pos = 0;
            while ((pos = re.indexIn(strhtml, pos)) != -1) {
//                qDebug()<<pos<<re.captureCount()<<re.cap(re.captureCount()-1)
//                       <<re.cap(0)<<re.cap(1)<<re.cap(2)<<re.cap(3);
                pos += re.matchedLength();

                acts[re.cap(2)] = re.cap(1);
            }

            qDebug()<<acts;
            for (auto it = acts.begin(); it != acts.end(); it++) {
                acts[it.key()] = req.url().toString().replace(req.url().fileName(), acts.value(it.key()));
            }
            qDebug()<<acts;

            emit mw->set_act_url(acts);

            QNetworkRequest newreq(acts.value("SecureCRT"));
            nam->get(newreq);
        } else if (reqpath.startsWith("/Citrix/XenApp/site/launcher.aspx")) {
            QByteArray html = reply->readAll();
            QString strhtml = html;

            QRegExp re("/Citrix/XenApp/site/launch.ica.CTX_Application=Citrix.MPS.App.GKGroup.SecureCRT&CTX_AppFriendlyNameURLENcoded=SecureCRT");
            int pos = 0;
            re.setMinimal(true);
            pos = re.indexIn(strhtml, 0);
            if (pos != -1) {
                qDebug()<<re.captureCount()<<re.cap(0);

                QUrlQuery uqry(req.url().toString().replace("&amp;", "&"));
                qDebug()<<req.url();
                QString newurl = req.url().scheme() + "://" + req.url().host() + re.cap(0)
                        + "&CTX_Token=" + uqry.queryItemValue("CTX_Token");
                QNetworkRequest newreq(newurl);
                qDebug()<<"getting..."<<newurl;
                nam->get(newreq);
            } else {
                qDebug()<<"launch.ica link not found.";
            }
        } else if (reqpath.startsWith("/Citrix/XenApp/site/launch.ica")) {
            QByteArray html = reply->readAll();
            QString strhtml = html;

            mw->set_exec_icac(html);
        } else {
            qDebug()<<"unkwon reply:"<<reqpath<<reply->request().url();
        }
     };

    connect(nam, &QNetworkAccessManager::finished, req_callback);


}

void MainWindow::set_act_url(QHash<QString, QString> acts)
{
      qDebug()<<acts<<".............";
      foreach(auto &i, acts) {

      }

      QHash<QString, QToolButton*> tpls;
      tpls["SecureCRT"] = this->ui->toolButton_2;

      for (auto it = acts.begin(); it != acts.end(); it++) {
          qDebug()<<it.key()<<it.value();
          QToolButton *btn = tpls.value(it.key());
          if (!btn) continue;

          btn->setToolTip(QString("%1=>%2").arg(it.key()).arg(it.value()));
      }

}

void MainWindow::on_toolButton_2_clicked()
{
    QToolButton *btn = (QToolButton*)sender();
    QString tip = btn->toolTip();
    QStringList elems = tip.split("=>");
    qDebug()<<elems;


}

QProcess *icaproc = NULL;
qint64 gpid = 0;

void MainWindow::set_exec_icac(QByteArray &html)
{

    QString tname = QString("/tmp/launch.ica.%1").arg(QDateTime::currentDateTime().toMSecsSinceEpoch());

    QFile fp(tname);
    if (fp.open(QIODevice::WriteOnly)) {
        fp.write(html);
        fp.close();

        /*
more /opt/Citrix/ICAClient/wfica.sh
#!/bin/sh
export ICAROOT=/opt/Citrix/ICAClient
${ICAROOT}/wfica -file "$1"
        */

        icaproc = new QProcess();

        icaproc->setEnvironment({"ICAROOT=/opt/Citrix/ICAClient", "DISPLAY=:0.0"});
        setenv("ICAROOT", "/opt/Citrix/ICAClient", 0);

//        connect(icaproc, &QProcess::finished, [](int code, QProcess::ExitStatus status){
//            qDebug()<<code<<status;
//        });

        connect(icaproc, &QProcess::stateChanged, [] (QProcess::ProcessState state) {
            // icaproc 是全局变量，闭包自动capture
            qDebug()<<"stopped..."<<state<<icaproc->error()<<icaproc->errorString();
        });

        connect(icaproc, &QProcess::readyReadStandardError, []() {
            qDebug()<<icaproc->readAllStandardError();
        });

        connect(icaproc, &QProcess::readyReadStandardOutput, []() {
            qDebug()<<icaproc->readAllStandardOutput();
        });

        if (1) {
            QString icac = "/opt/Citrix/ICAClient/wfica";// -file";
            QStringList args = {"-file", tname};

            qDebug()<<"starting..."<<icac<<args;
//            icaproc->start(icac, args);
            QProcess::startDetached(icac, args, QString(), &gpid);
        } else {
            QString icac = "/opt/Citrix/ICAClient/wfica.sh";
            QString cmdline = QString("%1 %2").arg(icac).arg(tname);

            qDebug()<<"starting..."<<cmdline;
            icaproc->start(cmdline);
        }
    }
}

#include <unistd.h>
#include <signal.h>

void MainWindow::on_pushButton_2_clicked()
{
    qDebug()<<gpid<<icaproc->state();

    if (icaproc) {
        icaproc->terminate();
        icaproc->close();
        delete icaproc;
        icaproc = NULL;
        qDebug()<<"stop ed";
    } else {
        qDebug()<<"not exists.";
    }

    ::kill(gpid, 6);
    gpid = 0;
}

void MainWindow::on_pushButton_3_clicked()
{
    icaproc = new QProcess();

    icaproc->setEnvironment({"ICAROOT=/opt/Citrix/ICAClient", "DISPLAY=:0.0"});
    setenv("ICAROOT", "/opt/Citrix/ICAClient", 0);

//        connect(icaproc, &QProcess::finished, [](int code, QProcess::ExitStatus status){
//            qDebug()<<code<<status;
//        });

    connect(icaproc, &QProcess::stateChanged, [] (QProcess::ProcessState state) {
        // icaproc 是全局变量，闭包自动capture
        qDebug()<<"stopped..."<<state<<icaproc->error()<<icaproc->errorString();
    });

    connect(icaproc, &QProcess::readyReadStandardError, []() {
        qDebug()<<icaproc->readAllStandardError();
    });

    connect(icaproc, &QProcess::readyReadStandardOutput, []() {
        qDebug()<<icaproc->readAllStandardOutput();
    });

    QString icac = "/usr/bin/xterm";
    QString cmdline = QString("%1").arg(icac);

    qDebug()<<"starting..."<<cmdline;
//    icaproc->start(cmdline);
    QProcess::startDetached(cmdline, {}, QString(), &gpid);
}
