# coding=utf-8

"""Assorted utilities."""

import subprocess


def uidof(pid):
    """
    Returns the username that owns the process with the given pid

    @param pid: The process ID
    """
    cmd = ['ps', '-o', 'user', '--no-headers', pid]
    return subprocess.check_output(cmd).strip()