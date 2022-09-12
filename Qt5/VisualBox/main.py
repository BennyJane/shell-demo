# -*- coding: utf-8 -*-
import sys
from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import QApplication

from widget_gallery.config import load_stylesheet
from widget_gallery.mainwindow import WidgetGallery

if __name__ == "__main__":
    THEME = "light"

    app = QApplication(sys.argv)
    if hasattr(Qt.ApplicationAttribute, "AA_UseHighDpiPixmaps"):  # Enable High DPI display with Qt5
        app.setAttribute(Qt.ApplicationAttribute.AA_UseHighDpiPixmaps)  # type: ignore
    win = WidgetGallery()
    win.menuBar().setNativeMenuBar(False)
    win.setMinimumWidth(1200)
    # 引入默认主题
    app.setStyleSheet(load_stylesheet(THEME))
    win.show()
    app.exec()
