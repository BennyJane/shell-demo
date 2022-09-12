"""Module setting up ui of dock window."""
# from qdarktheme.qtpy.QtCore import Qt
# from qdarktheme.qtpy.QtWidgets import QDockWidget, QMainWindow, QTextEdit, QVBoxLayout, QWidget
from PyQt5.QtCore import Qt
from PyQt5.QtGui import QCursor
from PyQt5.QtWebEngineWidgets import QWebEngineView
from PyQt5.QtWidgets import QWidget, QDockWidget, QTextEdit, QMainWindow, QVBoxLayout, QTabWidget, QTextBrowser, QMenu, \
    QAction


class SearchUI:
    """The ui class of dock window."""

    title = "LogBoxUI"

    icon = "search_128dp.svg"

    def __init__(self) -> None:
        self.table = None
        self.content = None

    def setup_ui(self, win: QWidget) -> None:
        """Set up ui."""
        # Widgets: 工具面板或者是工具窗口
        left_dock = QDockWidget("Left dock")
        right_dock = QDockWidget("Right dock")
        bottom_dock = QDockWidget("Bottom dock")

        # Setup widgets
        left_dock.setWidget(QTextEdit("This is the left widget."))
        table = QTabWidget()
        right_dock.setWidget(table)
        bottom_dock.setWidget(QTextEdit("This is the bottom widget."))
        for dock in (left_dock, right_dock, bottom_dock):
            dock.setAllowedAreas(
                Qt.DockWidgetArea.LeftDockWidgetArea
                | Qt.DockWidgetArea.RightDockWidgetArea
                | Qt.DockWidgetArea.BottomDockWidgetArea
                | Qt.DockWidgetArea.TopDockWidgetArea
            )

        # Layout
        main_win = QMainWindow()
        html = self.reload_html()
        row_html = "<tr><td>{}</td><td>{}</td>"
        for i in range(100):
            row_html.format(i, f"log- {1}")
        # content = QTextBrowser()
        content = QWebEngineView()
        content.setHtml(html)
        content.setContextMenuPolicy(Qt.CustomContextMenu)
        content.customContextMenuRequested.connect(lambda x: self.create_right_menu(win))
        self.create_right_menu(content)

        self.content = content
        main_win.setCentralWidget(content)
        main_win.addDockWidget(Qt.DockWidgetArea.LeftDockWidgetArea, left_dock)
        main_win.addDockWidget(Qt.DockWidgetArea.RightDockWidgetArea, right_dock)
        main_win.addDockWidget(Qt.DockWidgetArea.BottomDockWidgetArea, bottom_dock)

        layout = QVBoxLayout(win)
        layout.addWidget(main_win)
        layout.setContentsMargins(0, 0, 0, 0)

    def reload_html(self):
        html = ""
        with open("widget_gallery/log_content.html", "r", encoding="utf-8") as f:
            html = f.read()
        return html

    def create_right_menu(self, widget):
        # 设置右键功能
        menu = QMenu(widget)

        actionA = QAction("复制", widget)
        actionA.triggered.connect(lambda x: self.copy(widget))
        actionB = QAction("注释", widget)
        actionB.triggered.connect(lambda x: self.noting(widget))
        actionC = QAction("搜索", widget)
        actionC.triggered.connect(lambda x: self.search_word(widget))
        actionD = QAction("转JSON", widget)

        menu.addAction(actionA)
        menu.addAction(actionB)
        menu.addAction(actionC)
        menu.addAction(actionD)
        menu.popup(QCursor.pos())

    def copy(self, widget):
        print(self.content.selectedText())
        print("copy")

    def noting(self, widget):
        print("noting")

    def search_word(self, widget):
        print("search_word")