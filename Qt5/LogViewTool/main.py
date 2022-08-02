import sys

from PySide6.QtCore import QCoreApplication
from PySide6.QtCore import Qt
from PySide6.QtWidgets import QApplication

from View.core_gallery import CoreGallery

if __name__ == '__main__':
    QCoreApplication.setAttribute(Qt.AA_EnableHighDpiScaling)
    QCoreApplication.setAttribute(Qt.AA_UseHighDpiPixmaps)

    app = QApplication()
    # 加载css文件
    with open("View/src/style.css", "r") as f:
        _style = f.read()
        app.setStyleSheet(_style)
    gallery = CoreGallery()
    gallery.show()
    sys.exit(app.exec())


