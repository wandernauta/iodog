# coding=utf-8

"""Assorted utilities."""

import subprocess
from xml.sax.saxutils import quoteattr, escape


def uidof(pid):
    """
    Returns the username that owns the process with the given pid

    @param pid: The process ID
    """
    cmd = ['ps', '-o', 'user', '--no-headers', pid]
    return subprocess.check_output(cmd).strip()


def t(tag, content='', **kwargs):
    """
    Generates an XML tag.

    @param tag: the tag name (as in <tag></tag>)
    @param content: The tag's content (<x>content</x>)
    @param kwargs: Any kwargs will be included as attributes.
    """
    out = ["<", tag]
    [out.append(" %s=%s" % (k, quoteattr(v))) for k, v in kwargs.items()]
    out.append(">")
    out.append(escape(str(content)))
    out.append("</%s>" % tag)
    return "".join(out)
