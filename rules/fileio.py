# -*- coding: utf-8 -*-

"""
Triggers on functions that do file I/O (specifically opening and writing to
files).
"""

from rules.ruleset import Ruleset
from event import Event


class FileIO(Ruleset):
    """Ruleset that triggers on functions that can do file I/O."""

    TRIGGERS = set([
        "fopen",
        "tmpfile",
        "bzopen",
        "gzopen",
        "chgrp",
        "chmod",
        "chown",
        "copy",
        "file_put_contents",
        "lchgrp",
        "lchown",
        "link",
        "mkdir",
        "move_uploaded_file",
        "rename",
        "rmdir",
        "symlink",
        "tempnam",
        "touch",
        "unlink",
        "imagepng",
        "imagewbmp",
        "image2wbmp",
        "imagejpeg",
        "imagexbm",
        "imagegif",
        "imagegd",
        "imagegd2",
        "iptcembed",
        "ftp_get",
        "ftp_nb_get",
        "file_exists",
        "file_get_contents",
        "file",
        "fileatime",
        "filectime",
        "filegroup",
        "fileinode",
        "filemtime",
        "fileowner",
        "fileperms",
        "filesize",
        "filetype",
        "glob",
        "is_dir",
        "is_executable",
        "is_file",
        "is_link",
        "is_readable",
        "is_uploaded_file",
        "is_writable",
        "is_writeable",
        "linkinfo",
        "lstat",
        "parse_ini_file",
        "pathinfo",
        "readfile",
        "readlink",
        "realpath",
        "stat",
        "gzfile",
        "readgzfile",
        "getimagesize",
        "imagecreatefromgif",
        "imagecreatefromjpeg",
        "imagecreatefrompng",
        "imagecreatefromwbmp",
        "imagecreatefromxbm",
        "imagecreatefromxpm",
        "ftp_put",
        "ftp_nb_put",
        "exif_read_data",
        "read_exif_data",
        "exif_thumbnail",
        "exif_imagetype",
        "hash_file",
        "hash_hmac_file",
        "hash_update_file",
        "md5_file",
        "sha1_file",
        "highlight_file",
        "show_source",
        "php_strip_whitespace",
        "get_meta_tags",
    ])

    def __init__(self, app):
        Ruleset.__init__(self, app)

    def register(self):
        """Creates breakpoints for each of the listed functions."""
        for fn in self.TRIGGERS:
            self.app.api.breakpoint_set(call=fn)

    def annotate(self, event):
        """Marks the event as Interesting and adds a fileio tag."""

        if event.call in self.TRIGGERS:
            event.bump(Event.INTERESTING)
            event.add_tag("fileio")
