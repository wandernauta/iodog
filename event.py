# -*- coding: utf-8 -*-

"""
Contains the Event class.
"""

from xml.sax.saxutils import escape as e
from utils import t


class Event(object):
    """An event that caused iodog to start investigating."""

    LEVELS = "unknown harmless interesting suspicious risky bad".split()
    UNKNOWN = 0
    HARMLESS = 1
    INTERESTING = 2
    SUSPICIOUS = 3
    RISKY = 4
    BAD = 5

    t = None
    call = None

    level = 0
    tags = []

    def __init__(self, **kwargs):
        for key, value in kwargs.items():
            setattr(self, key, value)

    def to_xml(self):
        """Returns an XML representation of this Event."""
        out = list()
        out.append('<event t="%s" call="%s">' % (self.t.isoformat(), self.call))
        out.append(t('level', self.LEVELS[self.level]))

        for tag in self.tags:
            out.append(t('tag', tag))

        out.append('</event>')

        return ''.join(out)

    def bump(self, lvl):
        """
        Increases this Event's level to the parameter if it's not already
        higher.

        @param lvl: The new minimum level.
        """
        self.level = self.level if self.level >= lvl else lvl
