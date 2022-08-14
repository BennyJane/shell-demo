from PyQt5.QtCore import QDir, Qt
from PyQt5.QtCore import pyqtSlot as Slot
from PyQt5.QtGui import QIcon, QFont
from PyQt5.QtWidgets import QMainWindow, QAction, QStackedWidget, QToolBar, QToolButton, QSizePolicy, QActionGroup, \
    QStatusBar, QMenuBar, QWidget, QFileDialog, QColorDialog, QFontDialog, QLabel, QApplication, QMessageBox

from widget_gallery.config import load_stylesheet
from widget_gallery.ui import UI_LIST
from widget_gallery.util import get_project_root_path

import ctypes

ctypes.windll.shell32.SetCurrentProcessExplicitAppUserModelID("myappid")


class _WidgetGalleryUI:
    def setup_ui(self, main_win: QMainWindow) -> None:
        """
        --------------------------------------------------------------------------------
        图标
        --------------------------------------------------------------------------------
        """
        # 工具栏图标
        self.action_open_folder = QAction(QIcon("icons:folder_open_24dp.svg"), "Open folder dialog")
        self.action_open_color_dialog = QAction(QIcon("icons:palette_24dp.svg"), "Open color dialog")
        self.action_open_font_dialog = QAction(QIcon("icons:font_download_24dp.svg"), "Open font dialog")
        self.action_enable = QAction(QIcon("icons:circle_24dp.svg"), "Enable")
        self.action_disable = QAction(QIcon("icons:clear_24dp.svg"), "Disable")
        self.actions_theme = [QAction(theme, main_win) for theme in ["dark", "light"]]

        # 左侧竖向工具图标集合
        self.actions_page = [QAction(QIcon(f"icons:{ui_cls.icon}"), ui_cls.title) for ui_cls in UI_LIST]

        # 弹窗图标集合
        self.actions_message_box = (
            QAction(text="Open question dialog"),
            QAction(text="Open information dialog"),
            QAction(text="Open warning dialog"),
            QAction(text="Open critical dialog"),
        )

        """
        --------------------------------------------------------------------------------
        界面元素
        --------------------------------------------------------------------------------
        """
        # 主题切换图标集合
        self.actions_corner_radius = (QAction(text="rounded"), QAction(text="sharp"))

        # 主窗口
        self.central_window = QMainWindow()
        # 提供了多页面切换的布局，一次只能看到一个界面。
        self.stack_widget = QStackedWidget()

        # 左侧菜单栏：不可移动
        activitybar = QToolBar("activitybar")
        activitybar.setMovable(False)

        # 空白占据功能：填充空白区域
        spacer = QToolButton()
        spacer.setSizePolicy(QSizePolicy.Policy.Preferred, QSizePolicy.Policy.Expanding)
        spacer.setEnabled(False)

        # 设置左侧菜单效果，并默认选择第一个
        action_group_toolbar = QActionGroup(main_win)
        for action in self.actions_page:
            action.setCheckable(True)
            action_group_toolbar.addAction(action)
        self.actions_page[0].setChecked(True)

        activitybar.addActions(self.actions_page)
        activitybar.addWidget(spacer)

        tool_btn_settings, tool_btn_theme, tool_btn_enable, tool_btn_disable, tool_btn_message_box = (
            QToolButton() for _ in range(5)
        )
        # tool_btn_settings: 工具图标按钮
        # activitybar.addWidget(tool_btn_settings)

        tool_btn_settings.setIcon(QIcon("icons:settings_24dp.svg"))
        tool_btn_settings.setPopupMode(QToolButton.ToolButtonPopupMode.InstantPopup)
        tool_btn_enable.setDefaultAction(self.action_enable)
        tool_btn_disable.setDefaultAction(self.action_disable)
        tool_btn_message_box.setIcon(QIcon("icons:announcement_24dp.svg"))
        tool_btn_message_box.setPopupMode(QToolButton.ToolButtonPopupMode.InstantPopup)
        tool_btn_theme.setIcon(QIcon("icons:contrast_24dp.svg"))
        tool_btn_theme.setPopupMode(QToolButton.ToolButtonPopupMode.InstantPopup)

        # 可移动工具栏
        self.toolbar = QToolBar("Toolbar")
        self.toolbar.setMovable(False)
        self.toolbar.addActions((self.action_open_folder, self.action_open_color_dialog, self.action_open_font_dialog))
        self.toolbar.addSeparator()  # 分隔符号
        self.toolbar.addWidget(QLabel("Popup"))
        self.toolbar.addWidget(tool_btn_message_box)
        self.toolbar.addWidget(tool_btn_theme)

        # 底部提示信息
        statusbar = QStatusBar()
        statusbar.addPermanentWidget(tool_btn_enable)
        statusbar.addPermanentWidget(tool_btn_disable)
        statusbar.showMessage("Enable")

        """
        --------------------------------------------------------------------------------
        顶部菜单栏
        --------------------------------------------------------------------------------
        """
        menubar = QMenuBar()
        # 锁定/解锁 菜单
        # menu_toggle = menubar.addMenu("&Toggle")
        # menu_toggle.addActions((self.action_enable, self.action_disable))
        # 主题菜单
        menu_theme = menubar.addMenu("主题切换")
        menu_theme.addActions(self.actions_theme)
        # 提示框菜单
        # menu_dialog = menubar.addMenu("&Dialog")
        # menu_dialog.addActions((self.action_open_folder, self.action_open_color_dialog, self.action_open_font_dialog))
        # Dialog下的子菜单
        # menu_message_box = menu_dialog.addMenu("&Messages")
        # menu_message_box.addActions(self.actions_message_box)

        # 选项菜单
        menu_option = menubar.addMenu("配置项")
        menu_option.addActions(self.actions_corner_radius)

        # 按钮绑定菜单
        tool_btn_theme.setMenu(menu_theme)
        # tool_btn_settings.setMenu(menu_toggle)
        # tool_btn_message_box.setMenu(menu_message_box)

        # 设置默认值
        self.action_enable.setEnabled(False)

        # 不同页面布局
        for ui in UI_LIST:
            container = QWidget()
            ui().setup_ui(container)
            self.stack_widget.addWidget(container)

        # central_window：中间工作区间
        self.central_window.setCentralWidget(self.stack_widget)  # 不同界面
        # self.central_window.addToolBar(self.toolbar)  # 横向工具栏

        # main_win 主界面
        main_win.setCentralWidget(self.central_window)
        main_win.addToolBar(Qt.ToolBarArea.LeftToolBarArea, activitybar)  # 左侧竖向工具栏
        main_win.setMenuBar(menubar)  # 顶部菜单栏
        main_win.setStatusBar(statusbar)  # 提示框


class WidgetGallery(QMainWindow):
    """The main window class of example app."""

    def __init__(self, theme=None) -> None:
        """Initialize the WidgetGallery class."""
        super().__init__()

        # 添加图片搜索目录: x需要配置绝对路径
        QDir.addSearchPath("icons", f"{get_project_root_path()}/widget_gallery/svg")
        self._ui = _WidgetGalleryUI()
        self._ui.setup_ui(self)
        # 全局属性
        self._theme = theme if theme is not None else "light"
        self._border_radius = "rounded"

        # 设置窗口标题、图标
        self.setWindowTitle("Visual Box 1.0")
        self.setWindowIcon(QIcon("icons:logo_128dp.svg"))

        """
        --------------------------------------------------------------------------------
        Signal:信号
        --------------------------------------------------------------------------------
        """
        # 打开文件
        self._ui.action_open_folder.triggered.connect(
            lambda: QFileDialog.getOpenFileName(self, "Open File", options=QFileDialog.Option.DontUseNativeDialog)
        )
        # 打开颜色盘
        self._ui.action_open_color_dialog.triggered.connect(
            lambda: QColorDialog.getColor(parent=self, options=QColorDialog.ColorDialogOption.DontUseNativeDialog)
        )
        # 打开字体
        self._ui.action_open_font_dialog.triggered.connect(
            lambda: QFontDialog.getFont(QFont(), parent=self, options=QFontDialog.FontDialogOption.DontUseNativeDialog)
        )
        self._ui.action_enable.triggered.connect(self._toggle_state)
        self._ui.action_disable.triggered.connect(self._toggle_state)
        for action in self._ui.actions_theme:
            action.triggered.connect(self._change_theme)
        for action in self._ui.actions_page:
            action.triggered.connect(self._change_page)
        for action in self._ui.actions_message_box:
            action.triggered.connect(self._popup_message_box)
        for action in self._ui.actions_corner_radius:
            action.triggered.connect(self._change_corner_radius)

    @Slot()
    def _change_page(self) -> None:
        """
        切换主界面
        """
        action_name: str = self.sender().text()  # type: ignore
        titles = [ui_cls.title for ui_cls in UI_LIST]
        try:
            index = titles.index(action_name)  # 当不存在时，默认显示第一个界面
        except ValueError as e:
            index = 0
        self._ui.stack_widget.setCurrentIndex(index)

    @Slot()
    def _toggle_state(self) -> None:
        state: str = self.sender().text()  # type: ignore
        self._ui.central_window.centralWidget().setEnabled(state == "Enable")
        self._ui.toolbar.setEnabled(state == "Enable")
        self._ui.action_enable.setEnabled(state == "Disable")
        self._ui.action_disable.setEnabled(state == "Enable")
        self.statusBar().showMessage(state)

    @Slot()
    def _change_theme(self) -> None:
        self._theme = self.sender().text()  # type: ignore
        QApplication.instance().setStyleSheet(load_stylesheet(self._theme, self._border_radius))

    @Slot()
    def _change_corner_radius(self) -> None:
        self._border_radius: str = self.sender().text()  # type: ignore
        QApplication.instance().setStyleSheet(load_stylesheet(self._theme, self._border_radius))

    @Slot()
    def _popup_message_box(self) -> None:
        action_name: str = self.sender().text()  # type: ignore
        if "question" in action_name:
            QMessageBox.question(self, "Question", "Question")
        elif "information" in action_name:
            QMessageBox.information(self, "Information", "Information")
        elif "warning" in action_name:
            QMessageBox.warning(self, "Warning", "Warning")
        elif "critical" in action_name:
            QMessageBox.critical(self, "Critical", "Critical")
