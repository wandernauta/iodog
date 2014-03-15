# -*- coding: utf-8 -*-

"""Common ruleset-related functionality."""


class Ruleset():
    """Superclass for all the ruleset classes."""
    app = None

    def __init__(self, iodog):
        self.app = iodog

    def register(self):
        """Set up this Ruleset with the debugger."""
        return

    def annotate(self, event):
        """
        Investigate the given Event, adding more info if possible.

        @param event: The event to annotate.
        """
        return

    def __str__(self):
        return self.__module__ + "." + self.__class__.__name__

