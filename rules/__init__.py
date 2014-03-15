# -*- coding: utf-8 -*-

"""
Contains rules that allow iodog to decide whether a certain behaviour is
suspicious or not.
"""


def get_rulesets(app):
    """
    Returns an instance of each registered ruleset.

    @param app: The Iodog instance to pass on to the ruleset.
    """
    from rules import blacklist, mysql, fileio

    return [
        blacklist.Blacklist(app),
        mysql.Mysql(app),
        fileio.FileIO(app)
    ]
