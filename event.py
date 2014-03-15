# -*- coding: utf-8 -*-

"""
Contains the Event class.
"""

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
    args = None

    stack = None

    level = None
    tags = None

    def __init__(self, **kwargs):
        self.level = 0
        self.tags = set()
        self.args = list()
        self.stack = ""
        self.call = ""

        for key, value in kwargs.items():
            setattr(self, key, value)

    def to_xml(self):
        """Returns an XML representation of this Event."""
        out = list()
        out.append('<event t="%s" call="%s">' % (self.t.isoformat(), self.call))
        out.append(t('level', self.LEVELS[self.level]))

        for tag in self.tags:
            out.append(t('tag', tag))

        out.append('<frames>')
        out.append(self.stack)
        out.append('</frames>')

        out.append('<args>')
        for arg in self.args:
            out.append(t('arg', arg))
        out.append('</args>')

        out.append('</event>')

        return ''.join(out)

    def bump(self, lvl):
        """
        Increases this Event's level to the parameter if it's not already
        higher.

        @param lvl: The new minimum level.
        """
        self.level = self.level if self.level >= lvl else lvl

    def add_tag(self, tag):
        """
        Adds a tag.

        @param tag: The tag to add as a string.
        """
        self.tags.add(tag)
