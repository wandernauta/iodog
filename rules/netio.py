# -*- coding: utf-8 -*-

"""
Triggers on functions that do 'raw' network I/O.
"""

from rules.ruleset import Ruleset
from event import Event


class NetIO(Ruleset):
    """Ruleset that triggers on functions that do network I/O."""

    TRIGGERS = set([
        "checkdnsrr",
        "dns_check_record",
        "dns_get_mx",
        "dns_get_record",
        "fsockopen",
        "gethostbyaddr",
        "gethostbyname",
        "gethostbynamel",
        "gethostname",
        "getmxrr",
        "getprotobyname",
        "getprotobynumber",
        "getservbyname",
        "getservbyport",
        "pfsockopen",
        "socket_get_status",
        "socket_set_blocking",
        "socket_set_timeout",

        "stream_socket_accept",
        "stream_socket_client",
        "stream_socket_pair",
        "stream_socket_recvfrom",
        "stream_socket_sendto",
        "stream_socket_server",
    ])

    def __init__(self, app):
        Ruleset.__init__(self, app)

    def register(self):
        """Creates breakpoints for each of the listed functions."""
        for fn in self.TRIGGERS:
            self.app.api.breakpoint_set(call=fn)

    def annotate(self, event):
        """Marks the event as Interesting and adds a netio tag."""

        if event.call in self.TRIGGERS:
            event.bump(Event.INTERESTING)
            event.add_tag("netio")
