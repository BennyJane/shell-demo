import inspect
import os
import re
import logging
import operator as ope

# greater_equal and less_equal must be evaluated before greater and less.
from pathlib import Path

OPERATORS = {"==": ope.eq, "!=": ope.ne, ">=": ope.ge, "<=": ope.le, ">": ope.gt, "<": ope.lt}


def multi_replace(target: str, replacements) -> str:
    """Given a string and a replacement map, it returns the replaced string.

    See https://gist.github.com/bgusach/a967e0587d6e01e889fd1d776c5f3729.

    Args:
        target: String to execute replacements on.
        replacements: Replacement dictionary {value to find: value to replace}.

    Returns:
        str: Target string that replaced with `replacements`.
    """
    if len(replacements) == 0:
        return target

    replacements_sorted = sorted(replacements, key=len, reverse=True)
    replacements_escaped = [re.escape(i) for i in replacements_sorted]
    pattern = re.compile("|".join(replacements_escaped))
    return pattern.sub(lambda match: replacements[match.group()], target)


def get_logger(logger_name: str) -> logging.Logger:
    """Return the logger with the name specified by logger_name arg.

    Args:
        logger_name: The name of logger.

    Returns:
        Logger reformatted for this package.
    """
    logger = logging.getLogger(logger_name)
    logger.propagate = False
    logger.setLevel(logging.INFO)
    ch = logging.StreamHandler()
    ch.setFormatter(logging.Formatter("[%(name)s] [%(levelname)s] %(message)s"))
    logger.addHandler(ch)
    return logger


def compare_v(v1: str, operator: str, v2: str) -> bool:
    """Comparing two versions."""
    v1_list, v2_list = (tuple(map(int, (v.split(".")))) for v in (v1, v2))
    return OPERATORS[operator](v1_list, v2_list)


# 返回项目主目录
def get_project_root_path() -> Path:
    return os.path.abspath(os.path.dirname(os.path.dirname(__file__)))
