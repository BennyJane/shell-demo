"""Package including ui for WidgetGallery."""
from .search_ui import SearchUI
from .widgets_ui import WidgetsUI
from .dock_ui import DockUI
from .frame_ui import FrameUI
from .dianxin_ui import DianXinUI

# 返回UI界面列表
UI_LIST = (
    SearchUI,
    DianXinUI,
    WidgetsUI,
    DockUI,
    FrameUI,
)
