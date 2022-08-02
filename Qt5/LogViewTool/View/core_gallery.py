# -*- coding: utf-8 -*-
import sys

from PyQt6.QtCore import QStringListModel
from PySide6.QtWidgets import *

from PySide6.QtGui import (QCursor, QDesktopServices, QGuiApplication, QIcon,
                           QKeySequence, QShortcut, QStandardItem,
                           QStandardItemModel, QScreen, QWindow)
from PySide6.QtCore import (QDateTime, QDir, QLibraryInfo, QMetaObject,
                            QSysInfo, QTextStream, QTimer, Qt, qVersion)

DIR_OPEN_ICON = ":/qt-project.org/styles/commonstyle/images/diropen-128.png"

COMPUTER_ICON = ":/qt-project.org/styles/commonstyle/images/computer-32.png"

SYSTEMINFO = """<html><head/><body>
<h3>Python</h3><p>{}</p>
<h3>Qt Build</h3><p>{}</p>
<h3>Operating System</h3><p>{}</p>
<h3>Screens</h3>
{}
</body></html>"""


def help_url(page):
    """Build a Qt help URL from the page name"""
    major_version = qVersion().split('.')[0]
    return "https://doc.qt.io/qt-{}/{}.html".format(major_version, page)


def launch_help(widget):
    """Launch a widget's help page"""
    url = help_url(class_name(widget).lower())
    QDesktopServices.openUrl(url)


def launch_module_help():
    QDesktopServices.openUrl(help_url("qtwidgets-index"))


def embed_into_hbox_layout(w, margin=5):
    """Embed a widget into a layout to give it a frame"""
    result = QWidget()
    layout = QHBoxLayout(result)
    layout.setContentsMargins(margin, margin, margin, margin)
    layout.addWidget(w)
    return result


def format_geometry(rect):
    """Format a geometry as a X11 geometry specification"""
    return "{}x{}{:+d}{:+d}".format(rect.width(), rect.height(),
                                    rect.x(), rect.y())


def screen_info(widget):
    """Format information on the screens"""
    policy = QGuiApplication.highDpiScaleFactorRoundingPolicy()
    policy_string = str(policy).split('.')[-1]
    result = "<p>High DPI scale factor rounding policy: {}</p><ol>".format(policy_string)
    for screen in QGuiApplication.screens():
        current = screen == widget.screen()
        result += "<li>"
        if current:
            result += "<i>"
        result += '"{}" {} {}DPI, DPR={}'.format(screen.name(),
                                                 format_geometry(screen.geometry()),
                                                 int(screen.logicalDotsPerInchX()),
                                                 screen.devicePixelRatio())
        if current:
            result += "</i>"
        result += "</li>"
    result += "</ol>"
    return result


def class_name(o):
    return o.metaObject().className()


def init_widget(w, name):
    """
    给widget组件设置组件命，并设置提示框，提示组件类名称
    Init a widget for the gallery, give it a tooltip showing the class name"""
    w.setObjectName(name)
    w.setToolTip(class_name(w))


def style_names():
    """
    返回一系列界面风格名称
    Return a list of styles, default platform style first"""
    # 默认风格
    default_style_name = QApplication.style().objectName().lower()
    result = []
    for style in QStyleFactory.keys():
        if style.lower() == default_style_name:
            result.insert(0, style)
        else:
            result.append(style)
    return result


class CoreGallery(QWidget):

    def __init__(self):
        super(CoreGallery, self).__init__()

        # 设置主窗口Icon:需要使用绝对路径
        # self.setWindowIcon(QIcon(':/qt-project.org/logos/pysidelogo.png'))
        self.setWindowIcon(QIcon('G:\BennyOfProjects\LogViewTool\View\src\logo.png'))
        # 设置窗口标题
        self.setWindowTitle("log view: v{}".format("1.0"))

        # 设置进度条：QProgressBar
        self._progress_bar = self.create_progress_bar()

        # 【界面风格选项-01】设置下拉选择框：QComboBox
        self._style_combobox = QComboBox()
        init_widget(self._style_combobox, "styleComboBox")
        self._style_combobox.addItems(style_names())

        # 【界面风格选项-02】设置文本名称
        self.style_label = QLabel("界面风格: ")
        init_widget(self.style_label, "style_label")
        self.style_label.setBuddy(self._style_combobox)

        # 【界面风格选项-03】设置选项切换的功能
        self._style_combobox.textActivated.connect(self.change_style)

        # 【提示信息-01】设置提示文本
        help_label = QLabel("Press F1 over a widget to see Documentation")
        init_widget(help_label, "help_label")

        # 完整页面布局
        top_layout = self.set_top_layout()  # 第一行
        select_file_groupbox = self.create_select_file_groupbox()  # 设置第二行左侧分区
        search_groupbox = self.create_search_groupbox()  # 第二行右侧分区
        dashboard_groupbox = self.create_dashboard_groupbox()  # 第二行右侧分区

        # 设置布局：QGridLayout
        main_layout = QGridLayout(self)
        main_layout.addLayout(top_layout, 0, 0, 1, 2)
        main_layout.addWidget(select_file_groupbox, 1, 0)
        main_layout.addWidget(search_groupbox, 1, 1)
        main_layout.addWidget(dashboard_groupbox, 2, 0, 1, 2)
        main_layout.addWidget(self._progress_bar, 3, 0, 1, 2)

    # 进度条1：初始化属性
    def create_progress_bar(self):
        result = QProgressBar()
        init_widget(result, "progressBar")
        result.setRange(0, 10000)
        result.setValue(0)

        timer = QTimer(self)
        timer.timeout.connect(self.advance_progressbar)
        timer.start(1000)
        return result

    # 进度条2：设置进度变化
    def advance_progressbar(self):
        cur_val = self._progress_bar.value()
        max_val = self._progress_bar.maximum()
        self._progress_bar.setValue(cur_val + (max_val - cur_val) / 100)

    # 【界面风格选项-04】根据不同选项，设置界面风格
    def change_style(self, style_name):
        QApplication.setStyle(QStyleFactory.create(style_name))

    def set_top_layout(self):
        # 水平布局
        top_layout = QHBoxLayout()
        top_layout.addWidget(self.style_label)
        top_layout.addWidget(self._style_combobox)
        top_layout.addStretch(1)

        return top_layout

    # 设置第二列左侧分区
    def create_select_file_groupbox(self):
        select_files_groupbox = QGroupBox("选择文件")
        init_widget(select_files_groupbox, "select_files_groupbox")

        # 【导入文件-01】：定义按钮，绑定事件
        select_files_pushbutton = QPushButton("导入日志文件")
        init_widget(select_files_pushbutton, "select_files_pushbutton")
        select_files_pushbutton.setDefault(False)
        select_files_pushbutton.clicked.connect(self.open_files)

        # 【开始处理数据-01】
        start_running_pushbutton = QPushButton("开始处理数据")
        init_widget(start_running_pushbutton, "start_running_pushbutton")

        # 【已选择文件列表-01】
        list_view = QListView(select_files_groupbox)
        init_widget(list_view, "list_view")

        model = QStandardItemModel(list_view)
        foods = [
            'Cookie dough',  # Must be store-bought
            'Hummus',  # Must be homemade
            'Spaghetti',  # Must be saucy
            'Dal makhani',  # Must be spicy
            'Chocolate whipped cream'  # Must be plentiful
        ]

        for food in foods:
            # Create an item with a caption
            item = QStandardItem(food)
            # Add a checkbox to it
            item.setCheckable(True)
            item.setEditable(False)
            # Add the item to the model
            model.appendRow(item)
        list_view.setModel(model)

        # 布局
        fileLayout = QVBoxLayout()
        fileLayout.addWidget(select_files_pushbutton)
        # 伸缩比例，默认值0为不伸缩
        fileLayout.addWidget(list_view, stretch=3)
        fileLayout.addWidget(start_running_pushbutton)
        # 添加水平伸缩效果
        fileLayout.addStretch()

        main_layout = QHBoxLayout(select_files_groupbox)
        main_layout.addLayout(fileLayout, stretch=1)
        main_layout.addStretch()  # 可以去除，不影响最终效果
        return select_files_groupbox

    def create_search_groupbox(self):
        search_groupbox = QGroupBox("筛选条件")
        init_widget(search_groupbox, "search_groupbox")

        main_layout = QHBoxLayout(search_groupbox)
        main_layout.addStretch()
        return search_groupbox

    def create_dashboard_groupbox(self):
        dashboard_groupbox = QGroupBox("结果展示")
        init_widget(dashboard_groupbox, "dashboard_groupbox")
        dashboard_groupbox.setMinimumWidth(900)
        dashboard_groupbox.setMinimumHeight(200)

        # 创建水平Tab页面
        dashboard = QTabWidget()
        init_widget(dashboard, "toolBox")
        dashboard.setLayoutDirection(Qt.LayoutDirection.LeftToRight)

        self.stats_textbrowser = QTextBrowser()
        init_widget(self.stats_textbrowser, "stats_textbrowser")
        self.update_systeminfo()

        plain_textedit = QPlainTextEdit("Hello World!!")
        init_widget(plain_textedit, "plainTextEdit")

        # 先添加到工具栏
        dashboard.addTab(self.stats_textbrowser, "统计数据")
        dashboard.addTab(plain_textedit, "统计图表")

        main_layout = QHBoxLayout(dashboard_groupbox)
        main_layout.addWidget(dashboard, 1)
        main_layout.addStretch()
        return dashboard_groupbox

    # 导入文件事件
    def open_files(self):
        openfile_name = QFileDialog.getOpenFileNames(self, "选择文件", '', 'Excel files(*.xlsx , *.xls)')
        print(openfile_name)

    # 更新统计数据
    def update_systeminfo(self):
        system_info = SYSTEMINFO.format(sys.version,
                                        QLibraryInfo.build(),
                                        QSysInfo.prettyProductName(),
                                        screen_info(self))
        self.stats_textbrowser.setHtml(system_info)