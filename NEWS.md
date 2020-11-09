# Version 0.1.5

* Added a `pipeline` option to `exif_read()`, which allows users to
  direct the exif executable to output results in csv rather than json
  format. This is helpful for use with images whose metadata contains
  non-UTF-8-encoded characters. As is documented
  [here](https://exiftool.org/exiftool_pod.html#Input-output-text-formatting),
  ExifTool's JSON output does not properly handle non-UTF-8 character
  sets. Setting `pipeline="csv"` ensures that non-UTF-8 character sets
  **are** properly handled, as demonstrated in a new example in `?exif_read`.

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
