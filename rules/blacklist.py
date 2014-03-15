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

        # Mysql
        "mysql_affected_rows",
        "mysql_client_encoding",
        "mysql_close",
        "mysql_connect",
        "mysql_create_db",
        "mysql_data_seek",
        "mysql_db_name",
        "mysql_db_query",
        "mysql_drop_db",
        "mysql_errno",
        "mysql_error",
        "mysql_escape_string",
        "mysql_fetch_array",
        "mysql_fetch_assoc",
        "mysql_fetch_field",
        "mysql_fetch_lengths",
        "mysql_fetch_object",
        "mysql_fetch_row",
        "mysql_field_flags",
        "mysql_field_len",
        "mysql_field_name",
        "mysql_field_seek",
        "mysql_field_table",
        "mysql_field_type",
        "mysql_free_result",
        "mysql_get_client_info",
        "mysql_get_host_info",
        "mysql_get_proto_info",
        "mysql_get_server_info",
        "mysql_info",
        "mysql_insert_id",
        "mysql_list_dbs",
        "mysql_list_fields",
        "mysql_list_processes",
        "mysql_list_tables",
        "mysql_num_fields",
        "mysql_num_rows",
        "mysql_pconnect",
        "mysql_ping",
        "mysql_query",
        "mysql_real_escape_string",
        "mysql_result",
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

    def __init__(self, app):
        Ruleset.__init__(self, app)

    def register(self):
        """Creates breakpoints for each of the listed functions."""
        for fn in self.TRIGGERS:
            self.app.api.breakpoint_set(call=fn)

    def annotate(self, event):
        """Marks the event as Interesting."""
        event.bump(Event.INTERESTING)

