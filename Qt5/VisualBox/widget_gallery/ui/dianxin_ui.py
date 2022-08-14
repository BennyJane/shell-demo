# -*- coding: utf-8 -*-
from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import QWidget, QGroupBox, QSplitter, QVBoxLayout, QPushButton, QGridLayout, QLabel, QCheckBox, \
    QFileDialog, QListWidget, QHBoxLayout, QLineEdit, QDateTimeEdit, QTextEdit, QRadioButton

from server.dianxin_core import DianXinCore


class _OpenFileGroup(QGroupBox):
    def __init__(self) -> None:
        # 设置当前QGroupBox属性
        super().__init__("导入待处理文件")
        self.setCheckable(True)
        self.setMaximumWidth(450)  # 设置最大宽度

        # 关键属性初始化
        self.select_all_checkbox = None
        self.import_files_btn = None
        self.deal_with_files_btn = None
        self.file_list_table = None

        self.import_files_btn = QPushButton("导入文件")
        self.import_files_btn.clicked.connect(self.import_files)

        self.select_all_checkbox = QCheckBox("全选")
        self.select_all_checkbox.setChecked(True)
        self.select_all_checkbox.stateChanged.connect(self.select_all)

        self.file_list_table = QListWidget()
        self.file_list_table.addItems([f"Item {i + 1}" for i in range(30)])
        self.file_list_table.setAlternatingRowColors(True)

        self.deal_with_files_btn = QPushButton("处理选中的文件并重命名")

        # Layout
        layout = QGridLayout(self)
        # layout.setContentsMargins(5, 10, 5, 10)
        layout.addWidget(self.import_files_btn, 0, 0, 1, 2)
        layout.addWidget(self.select_all_checkbox, 0, 2)
        layout.addWidget(self.file_list_table, 1, 0, 4, 3)
        layout.addWidget(self.deal_with_files_btn, 5, 0, 1, 3)

    def select_all(self):
        print(self.select_all_checkbox.isChecked())

    def import_files(self):
        filenames = QFileDialog.getOpenFileNames(self.import_files_btn, "选择日志文件",
                                                 filter="*.log",
                                                 options=QFileDialog.Option.DontUseNativeDialog)
        print(filenames)


class _SearchGroup(QGroupBox):

    def __init__(self) -> None:
        # 设置当前QGroupBox属性
        super().__init__("筛选数据")
        self.setCheckable(True)

        # 关键属性初始化
        self.import_csv_btn = None
        self.target_file_label = None
        self.target_file_name = "选择处理后的文件"
        self.start_time_edit = None
        self.end_time_edit = None
        self.func_radios = list()
        self.start_btn = None

        # 第一行布局
        self.import_csv_btn = QPushButton("选择文件")
        # self.import_csv_btn.setStyleSheet('border-color: rgb(0, 0, 0, 0);text-align:left')
        self.import_csv_btn.clicked.connect(self.import_files)

        self.target_file_label = QLabel(self.target_file_name)
        # https://blog.csdn.net/Nin7a/article/details/104533138
        self.target_file_label.setStyleSheet('border-color: rgb(0, 0, 0, 0);')

        first_row = QHBoxLayout()
        first_row.addWidget(self.import_csv_btn, 0)
        first_row.addWidget(self.target_file_label, 3)

        # 第二行布局
        self.start_time_edit = QDateTimeEdit()
        start_label = QLabel("起止时间")
        start_label.setStyleSheet('border-color: rgb(0, 0, 0, 0)')
        self.end_time_edit = QDateTimeEdit()
        end_label = QLabel("终止时间")
        end_label.setStyleSheet('border-color: rgb(0, 0, 0, 0)')
        second_row = QGridLayout()
        second_row.addWidget(start_label, 0, 0)
        second_row.addWidget(self.start_time_edit, 0, 1, 1, 3)
        second_row.addWidget(end_label, 1, 0)
        second_row.addWidget(self.end_time_edit, 1, 1, 1, 3)

        # 功能筛选
        group_funcs = QGroupBox("选择统计目的")
        func_modules_radios = QVBoxLayout()
        for func_module in DianXinCore.CORE_MODULE_NAMES:
            radio_btn = QRadioButton(func_module["name"])
            self.func_radios.append(radio_btn)
            func_modules_radios.addWidget(radio_btn)
        self.func_radios[0].setChecked(True)
        group_funcs.setLayout(func_modules_radios)

        self.start_btn = QPushButton("确定")

        # 整体布局
        layout = QVBoxLayout(self)
        layout.setAlignment(Qt.AlignTop)
        layout.setSpacing(10)
        layout.addLayout(first_row)
        layout.addLayout(second_row)
        layout.addStretch(1)  # 添加空白占位
        layout.addWidget(group_funcs)
        layout.addWidget(self.start_btn, 0, alignment=Qt.AlignBottom)

    def import_files(self):
        filenames = QFileDialog.getOpenFileNames(self.import_csv_btn, "选择日志文件",
                                                 filter="*.csv",
                                                 options=QFileDialog.Option.DontUseNativeDialog)
        print(filenames)


class _DisplayGroup(QGroupBox):
    def __init__(self) -> None:
        super().__init__("数据展示")
        self.setCheckable(False)

        group_table = QGroupBox()
        group_pic = QGroupBox("Check Box")

        h_splitter = QSplitter(Qt.Orientation.Horizontal)
        h_splitter.addWidget(group_table)
        h_splitter.addWidget(group_pic)

        layout = QVBoxLayout(self)
        layout.addWidget(h_splitter)


class DianXinUI(object):
    title = "电信"

    icon = "dianxin_24dp.svg"

    def setup_ui(self, win: QWidget) -> None:
        # 两个水平组件
        h_splitter_1, h_splitter_2 = QSplitter(Qt.Orientation.Horizontal), QSplitter(Qt.Orientation.Horizontal)

        # Setup widgets：设置固定宽度
        # h_splitter_1.setMinimumWidth(210)  # Fix bug layout crush
        h_splitter_1.setMinimumHeight(210)

        # Layout
        h_splitter_1.addWidget(_OpenFileGroup())
        h_splitter_1.addWidget(_SearchGroup())
        h_splitter_2.addWidget(_DisplayGroup())

        main_win = QWidget()
        v_layout = QVBoxLayout(main_win)
        v_layout.addWidget(h_splitter_1)
        v_layout.addWidget(h_splitter_2)

        layout = QVBoxLayout(win)
        layout.addWidget(main_win)
        layout.setContentsMargins(0, 0, 0, 0)
