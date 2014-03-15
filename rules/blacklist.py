# -*- coding: utf-8 -*-

"""
Contains a list of blacklisted functions, i.e. functions that cause iodog to
start barking^Wlogging.
"""

from rules.ruleset import Ruleset
from event import Event


class Blacklist(Ruleset):
    """Ruleset that triggers when an interesting function is called."""

    TRIGGERS = set([
        # Apache-specific functions
        "apache_child_terminate",
        "apache_setenv",

        # Logging-related functions
        "define_syslog_variables",
        "openlog",
        "syslog",

        # Shell-related  functions
        "escapeshellarg",
        "escapeshellcmd",
        "eval",
        "exec",
        "passthru",
        "shell_exec",
        "system",

        # FTP
        "ftp_connect",
        "ftp_exec",
        "ftp_get",
        "ftp_login",
        "ftp_nb_fput",
        "ftp_put",
        "ftp_raw",
        "ftp_rawlist",

        # INI
        "ini_alter",
        "ini_get_all",
        "ini_restore",

        # Processes
        "popen",
        "proc_close",
        "proc_get_status",
        "proc_nice",
        "proc_open",
        "proc_terminate",

        # POSIX
        "php_uname",
        "posix_getpwuid",
        "posix_kill",
        "posix_mkfifo",
        "posix_setpgid",
        "posix_setsid",
        "posix_setuid",
        "posix_setuid",
        "posix_uname",
    ])

    def __init__(self, app):
        Ruleset.__init__(self, app)

    def register(self):
        """Creates breakpoints for each of the listed functions."""
        for fn in self.TRIGGERS:
            self.app.api.breakpoint_set(call=fn)

    def annotate(self, event):
        """Marks the event as Risky and adds a blacklist tag."""

        if event.call in self.TRIGGERS:
            event.bump(Event.RISKY)
            event.add_tag("blacklist")

