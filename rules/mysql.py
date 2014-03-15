# -*- coding: utf-8 -*-

"""
Logs interesting MySQL/MySQLi functions.
"""

from rules.ruleset import Ruleset
from event import Event


class Mysql(Ruleset):
    """Ruleset that triggers when an interesting MySQL function is called."""

    TRIGGERS = set([
        # Mysql
        "mysql_close",
        "mysql_connect",
        "mysql_create_db",
        "mysql_db_name",
        "mysql_db_query",
        "mysql_drop_db",
        "mysql_get_client_info",
        "mysql_get_host_info",
        "mysql_get_proto_info",
        "mysql_get_server_info",
        "mysql_info",
        "mysql_list_dbs",
        "mysql_list_fields",
        "mysql_list_processes",
        "mysql_list_tables",
        "mysql_pconnect",
        "mysql_ping",
        "mysql_query",
        "mysql_select_db",
        "mysql_set_charset",
        "mysql_stat",
        "mysql_tablename",
        "mysql_thread_id",
        "mysql_unbuffered_query",

        # Mysqli
        "mysqli_affected_rows",
        "mysqli_get_client_info",
        "mysqli_get_client_version",
        "mysqli_connect_errno",
        "mysqli_connect_error",
        "mysqli_errno",
        "mysqli_error",
        "mysqli_field_count",
        "mysqli_get_host_info",
        "mysqli_get_proto_info",
        "mysqli_get_server_info",
        "mysqli_get_server_version",
        "mysqli_info",
        "mysqli_insert_id",
        "mysqli_sqlstate",
        "mysqli_warning_count",
        "mysqli_autocommit",
        "mysqli_change_user",
        "mysqli_character_set_name",
        "mysqli_close",
        "mysqli_commit",
        "mysqli_connect",
        "mysqli_debug",
        "mysqli_dump_debug_info",
        "mysqli_get_charset",
        "mysqli_get_connection_stats",
        "mysqli_get_client_info",
        "mysqli_get_client_stats",
        "mysqli_get_cache_stats",
        "mysqli_get_server_info",
        "mysqli_get_warnings",
        "mysqli_init",
        "mysqli_kill",
        "mysqli_more_results",
        "mysqli_multi_query",
        "mysqli_next_result",
        "mysqli_options",
        "mysqli_ping",
        "mysqli_prepare",
        "mysqli_query",
        "mysqli_real_connect",
        "mysqli_real_escape_string",
        "mysqli_real_query",
        "mysqli_refresh",
        "mysqli_rollback",
        "mysqli_select_db",
        "mysqli_set_charset",
        "mysqli_set_local_infile_default",
        "mysqli_set_local_infile_handler",
        "mysqli_ssl_set",
        "mysqli_stat",
        "mysqli_stmt_init",
        "mysqli_store_result",
        "mysqli_thread_id",
        "mysqli_thread_safe",
        "mysqli_use_result",
    ])

    QUERY_FUNCTIONS = set([
        "mysql_db_query",
        "mysql_query",
        "mysql_unbuffered_query",
        "mysqli_query",
    ])

    CONNECT_FUNCTIONS = set([
        "mysql_connect",
        "mysql_pconnect",
        "mysqli_init",
    ])

    def __init__(self, app):
        Ruleset.__init__(self, app)

    def register(self):
        """Creates breakpoints for each of the listed functions."""
        for fn in self.TRIGGERS:
            self.app.api.breakpoint_set(call=fn)

    def annotate(self, event):
        """Marks the event as Interesting."""

        if event.call in self.TRIGGERS:
            event.bump(Event.HARMLESS)
            event.add_tag("mysql")

            if event.call in self.CONNECT_FUNCTIONS:
                event.bump(Event.INTERESTING)

            if event.call in self.QUERY_FUNCTIONS:
                if not event.args[0].startswith("SELECT "):
                    event.bump(Event.SUSPICIOUS)
