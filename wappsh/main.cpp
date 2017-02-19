
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
        qDebug()<<"Unknown webapp:"<<a.applicationName()<<", expected:"<<apps.keys();
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

    // systray 菜单
    auto *menu = sti.contextMenu();
    menu = new QMenu();
    auto *act_exit = menu->addAction("&Exit");
    auto *act_xdg = menu->addAction(QString("&Open %1 in browser").arg(a.applicationName()));

    QObject::connect(act_exit, &QAction::triggered, &a, &QApplication::quit);
    QObject::connect(act_xdg, &QAction::triggered, [&url] () {
        QProcess::startDetached(QString("xdg-open \"%1\"").arg(url));
    });

    QObject::connect(&sti, &QSystemTrayIcon::activated,
                     [&we, &sti, menu] (QSystemTrayIcon::ActivationReason reason) {

        switch (reason) {
        case QSystemTrayIcon::Trigger:
            we.isVisible() ? we.hide() : we.show();
            break;
        case QSystemTrayIcon::DoubleClick:
            break;
        case QSystemTrayIcon::Context:
            if (menu) menu->popup(sti.geometry().topRight());
            break;
        default: break;
        }
    });

    return a.exec();
}
