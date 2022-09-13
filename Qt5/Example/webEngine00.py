# -*- coding: utf-8 -*-
from datetime import time

from PyQt5.QtCore import QUrl
from PyQt5.QtWebEngineWidgets import QWebEngineView
from PyQt5.QtWidgets import QApplication

app = QApplication([])

view = QWebEngineView()

view.load(QUrl("url"))

view.show()
page = view.page()


# a = 0#global a

def test():
    page.runJavaScript("$('#account').val(123)")
    page.runJavaScript("$('#password').val(123)")
    page.runJavaScript("$('#btn-login').trigger('click')")

    time.sleep(1)


#    page.runJavaScript("alert($('#distance').html())")    page.runJavaScript("$('.smallImg').trigger('click')")

view.loadFinished.connect(test)

app.exec_()
