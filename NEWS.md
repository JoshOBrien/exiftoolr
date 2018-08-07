

# Version 0.1.1

* Failure of `configure_exiftoolr()` to find a local installation of
  ExifTool now throws an error rather than just a warning, preventing
  infinite recursion by `exif_read()` and `exif_version()`.
