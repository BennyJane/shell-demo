# -*- coding: utf-8 -*-
# @Author   : zbz

import sys
import time

from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import QApplication

select_opts = []  # ==> 记录 用户勾选的 选项
all_opts = []  # ==> 窗口中所有的可选选项


class Window(QWidget):
    def __init__(self):
        super(Window, self).__init__()
        self.ck1_info, self.ck2_info, self.ck3_info, self.all_ck_info = "抽烟", "喝酒", "烫头", "全选"
        self.init_ui()

    def init_ui(self):
        self.resize(1000, 600)
        self.setWindowTitle("910end")
        ico_file = "../qt/ico/Ferrari.ico"
        self.setWindowIcon(QIcon(ico_file))

        layout = QHBoxLayout()
        self.setLayout(layout)

        label = QLabel()
        label.setText("爱好：")
        self.ck1, self.ck2, self.ck3 = QCheckBox(self.ck1_info), QCheckBox(self.ck2_info), QCheckBox(self.ck3_info)

        self.all_ck = QCheckBox(self.all_ck_info)  # ==> 全选
        self.all_ck.setCheckState(0)  # ==> 默认不选中

        all_opts.append(self.ck1)
        all_opts.append(self.ck2)
        all_opts.append(self.ck3)
        all_opts.append(self.all_ck)

        # 添加控件到布局中
        layout.addWidget(label)
        layout.addWidget(self.ck1)
        layout.addWidget(self.ck2)
        layout.addWidget(self.ck3)
        layout.addWidget(self.all_ck)

        # 绑定信号和槽
        self.ck1.stateChanged.connect(self.func1)
        self.ck2.stateChanged.connect(self.func2)
        self.ck3.stateChanged.connect(self.func3)
        self.all_ck.stateChanged.connect(self.func4)

        btn = QPushButton(self)
        btn.setText("点我试试")
        btn.setToolTip("显示用户的勾选情况")
        btn.clicked.connect(self.when_btn_onclick)
        btn.move(300, 500)

        btn2 = QPushButton(self)
        btn2.setText("退出")
        btn2.setToolTip("退出窗口")
        btn2.clicked.connect(self.when_btn2_onclick)
        btn2.move(500, 500)

    # 点击按钮显示用户勾选的
    def when_btn_onclick(self):
        if len(select_opts):
            print("用户勾选了{}个 ==> ({})".format(len(select_opts), " ".join(select_opts)))
        else:
            print("用户没有勾选任何一项")

    # 点击按钮退出窗口
    def when_btn2_onclick(self):
        print("1s后退出窗口")
        time.sleep(1)
        QApplication.instance().quit()

    def func1(self, state):
        if state == 2:
            print('选中了{}'.format(self.ck1_info))
            select_opts.append(self.ck1_info)
            print("select_opts: {}".format(select_opts))
        elif state == 0:
            print('取消选中{}'.format(self.ck1_info))
            select_opts.remove(self.ck1_info)
            print("select_opts: {}".format(select_opts))

    def func2(self, state):
        if state == 2:
            print('选中了{}'.format(self.ck2_info))
            select_opts.append(self.ck2_info)
            print("select_opts: {}".format(select_opts))
        elif state == 0:
            print('取消选中{}'.format(self.ck2_info))
            select_opts.remove(self.ck2_info)
            print("select_opts: {}".format(select_opts))

    def func3(self, state):
        if state == 2:
            print('选中了{}'.format(self.ck3_info))
            select_opts.append(self.ck3_info)
            print("select_opts: {}".format(select_opts))
        elif state == 0:
            print('取消选中{}'.format(self.ck3_info))
            select_opts.remove(self.ck3_info)
            print("select_opts: {}".format(select_opts))

    def func4(self, state):
        if state == 2:
            for opt in all_opts:
                opt.setCheckState(2)
        elif state == 0:
            for opt in all_opts:
                opt.setCheckState(0)


if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = Window()
    window.show()
    sys.exit(app.exec_())

