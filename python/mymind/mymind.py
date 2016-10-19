import os
import sys
from urllib.parse import urlparse

from PyQt5.QtCore import *
from PyQt5.QtNetwork import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
from PyQt5.QtWebEngineWidgets import *
from PyQt5.QtWebKit import *
from PyQt5.QtWebKitWidgets import *

from .ui_mymind import *


# TODO retina archlinux HIDPI with QWebEngineView and QWebEnginePage
class WebPage(QWebPage):

    def __init__(self, parent=None):
        super(WebPage, self).__init__(parent)
        return

    def createWindow(self, winType):
        print(winType, self)
        return self

    def acceptNavigationRequest(self, frame, request, navType):
        print(frame, request, navType)
        return True

    def javaScriptConfirm(self, frame, msg):
        print(frame, msg)
        if len(msg) == 0: return True
        return super(WebPage, self).javaScriptConfirm(frame, msg)

    def javaScriptConsoleMessage(self, message, lineNumber, sourceID):
        print(message, lineNumber, sourceID)
        return

    def javaScriptPrompt(self, frame, msg, defaultValue, result):
        print(frame, msg, defaultValue, result)
        return


class WebView(QWebView):
    linkHovered = pyqtSignal(str, str, str)

    def __init__(self, parent=None):
        super(WebView, self).__init__(parent)
        self.wp = WebPage()
        self.setPage(self.wp)
        self.wp.setLinkDelegationPolicy(QWebPage.DelegateAllLinks)
        self.wp.linkHovered.connect(self.linkHovered)
        return

    def createWindow(self, winType):
        print(winType, self)
        return

    def contextMenuEvent(self, ev):
        print(ev, self)
        return


class WebAppWin(QMainWindow):

    def __init__(self, parent=None):
        super(WebAppWin, self).__init__(parent)
        self.uiw = Ui_MainWindow()
        self.uiw.setupUi(self)
        from .mymcfg import HOMEURL
        self.homeUrl = HOMEURL
        self.urlObj = urlparse(HOMEURL)
        self.clo = QHBoxLayout()
        self.uiw.widget.setLayout(self.clo)

        self.uiw.toolButton.clicked.connect(self.onGoto)
        self.uiw.pushButton.clicked.connect(self.onHome)
        self.uiw.toolButton_4.clicked.connect(self.onNewMind)
        self.uiw.pushButton_3.clicked.connect(self.reset)
        self.uiw.comboBox.keyPressEvent = self.onAddressBoxKey

        QWebSettings.globalSettings().setAttribute(QWebSettings.PluginsEnabled, True)
        QWebSettings.globalSettings().setAttribute(QWebSettings.JavascriptEnabled, True)
        # very important setting
        QWebSettings.globalSettings().setAttribute(QWebSettings.LocalStorageEnabled, True)

        self.reset()
        return

    def reset(self):
        s = self.sender()
        if s is not None:
            self.clo.removeWidget(self.wv)
            wv2 = self.wv
            wv2.deleteLater()

        self.wv = WebView()
        self.clo.addWidget(self.wv)
        print(self.uiw.widget.layout())

        # connect signal/slots
        self.wv.urlChanged.connect(self.onChangeUrl)
        self.wv.linkClicked.connect(self.onClickLink)
        self.wv.loadProgress.connect(self.onLoadProgress)
        self.wv.titleChanged.connect(self.onChangeTitle)
        self.wv.linkHovered.connect(self.onHoverLink)

        return

    def onGoto(self):
        url = self.uiw.comboBox.currentText()
        self.wv.load(QUrl(url))
        return

    def onHome(self):
        hu = 'https://www.example.net/mym/save.php'
        hu = 'http://wwwi.example.net:443/mym/save.php'
        hu = self.homeUrl
        if self.uiw.pushButton_2.isChecked():
            hostSegs = self.urlObj.netloc.split(':')[0].split('.')
            hostSegs[0] = hostSegs[0] + 'i'
            host = '.'.join(hostSegs)
            hu = 'http://{}:443{}{}'.format(host, self.urlObj.path, self.urlObj.query)
        # hu = 'https://www.baidu.com/'
        print('loading: {}'.format(hu))
        self.wv.load(QUrl(hu))
        self.uiw.comboBox.setCurrentText(hu)
        return

    def onNewMind(self):
        hu = self.homeUrl + '?url=new'
        if self.uiw.pushButton_2.isChecked():
            hostSegs = self.urlObj.netloc.split(':')[0].split('.')
            hostSegs[0] = hostSegs[0] + 'i'
            host = '.'.join(hostSegs)
            hu = 'http://{}:443{}{}?url=new'.format(host, self.urlObj.path, self.urlObj.query)
        print('loading: {}'.format(hu))
        self.wv.load(QUrl(hu))
        self.uiw.comboBox.setCurrentText(hu)
        return

    def onChangeUrl(self, url: QUrl):
        self.uiw.comboBox.setCurrentText(url.toString())
        return

    def onClickLink(self, url: QUrl):
        print(url)
        # TODO 判断是否本app的域名
        self.wv.load(QUrl(url))
        return

    def onLoadProgress(self, progress: int):
        self.uiw.toolButton_2.setText(str(progress))
        return

    def onChangeTitle(self, title):
        self.setWindowTitle('mymind: {}'.format(title))
        return

    def onHoverLink(self, url, alt, title):
        self.statusBar().showMessage(url)
        return

    def onAddressBoxKey(self, evt):
        # print(evt, evt.key(), evt.text())
        # TODO accept() not usable
        evt.setAccepted(True)
        self.onGoto()
        return


def main():
    app = QApplication(sys.argv)
    app.setWindowIcon(QIcon(os.path.dirname(__file__) + '/logo64.png'))
    screens = QGuiApplication.screens()
    print('screen count:', len(screens))
    print(screens[0].devicePixelRatio(), screens[0].logicalDotsPerInch())

    cw = WebAppWin()
    cw.show()
    return app.exec_()

if __name__ == '__main__': main()
