# -*- coding: utf-8 -*-
import os
import sys

from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import QApplication

from common.config import WIN_WIDTH, WIN_HEIGHT, PANDAS_OUTPUT_FILE_DIR, LOG_PATH_DIR, IsDebug
from common.log import logger
from gallery.config import load_stylesheet
from gallery.mainwindow import WidgetGallery


def init_dir():
    # 初始化目录：data 存储处理后的文件；log存储日志文件
    if not os.path.exists(PANDAS_OUTPUT_FILE_DIR):
        logger.warning(f"{PANDAS_OUTPUT_FILE_DIR} is not exist")
        os.mkdir(PANDAS_OUTPUT_FILE_DIR)

    if not os.path.exists(LOG_PATH_DIR):
        logger.warning(f"{LOG_PATH_DIR} is not exist")
        os.mkdir(LOG_PATH_DIR)


def start():
    THEME = "light"
    init_dir()

    app = QApplication(sys.argv)
    if hasattr(Qt.ApplicationAttribute, "AA_UseHighDpiPixmaps"):  # Enable High DPI display with Qt5
        app.setAttribute(Qt.ApplicationAttribute.AA_UseHighDpiPixmaps)  # type: ignore
    win = WidgetGallery()
    win.resize(WIN_WIDTH, WIN_HEIGHT)
    win.menuBar().setNativeMenuBar(False)
    # 引入默认主题
    app.setStyleSheet(load_stylesheet(THEME))
    win.show()
    app.exec()


if __name__ == "__main__":
    start()
    try:
        pass
    except Exception as e:
        logger.debug(e)
        print(e)

