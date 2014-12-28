
#include <QApplication>
#include <QSystemTrayIcon>
#include <QtWebEngine>
#include <QtWebEngineWidgets>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    QHash<QString, QString> apps;
    apps.insert("nitro", "http://beta.nitrotasks.com/");
    apps.insert("weixin", "https://wx.qq.com/");
    apps.insert("webqq", "http://web2.qq.com/webqq.html");

    QStringList targs = a.arguments();

    if (!apps.contains(a.applicationName())) {
        return -1;
    }

    QString url = apps.value(a.applicationName());
    qDebug()<<QString("Runing app %1, %2").arg(a.applicationName()).arg(url);

    QWebEngineView we;
    we.load(url);

    QIcon ico(QPixmap(QString(":/%1.png").arg(a.applicationName())));

    QSystemTrayIcon sti(ico);
    sti.show();
    a.setWindowIcon(ico);

    we.showMaximized();
    return a.exec();
}
