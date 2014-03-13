# -*- coding: utf-8 -*-

"""Common ruleset-related functionality."""


class Ruleset():
    """Superclass for all the ruleset classes."""
    app = None

    def __init__(self, iodog):
        self.app = iodog
