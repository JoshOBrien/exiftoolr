# Version 0.1.4

* Fixed `exif_read()` to now allow repeated elements in `args=`. This
  can be necessary when (to take one example) a user needs to
  separately specify the encoding used in the image file names and in
  the tags respectively. Now, a call like the following works as it
  should:
  
      exif_read(path = "myimage.jpg", 
	            args = c("-charset", "exiftool=cp850", "-charset", "filename=cp1250"))

# Version 0.1.1

* Failure of `configure_exiftoolr()` to find a local installation of
  ExifTool now throws an error rather than just a warning, preventing
  infinite recursion by `exif_read()` and `exif_version()`.
