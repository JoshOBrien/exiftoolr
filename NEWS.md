# Version 0.2.4

* Ensures that Unicode tags are correctly written to files even in non-Unicode
  locales. Thanks to Trevor Davis for the excellent, as usual, issue description
  and PR.

* Improves the error message returned to the user when the call to Exiftool
  finds no files to act upon. In addition to more gracefully relaying the error
  message emitted by Exiftool, such calls now return a value of `NULL`. Thanks
  to jcblum for reporting this issue.

# Version 0.2.3

* Adds arguments `config_file=` and `common_args=` to `exif_call()`. These are
  passed on to exiftool options `-config` and `-common_args` respectively,
  neither of which was supported here before due to their not being allowed in
  the `-@ ARGFILE` option used 'behind the scenes' by all calls to
  `exif_call()`.

# Version 0.2.2

* Fixes bug that could cause a failure to locate an already-installed version of
  ExifTool on MacOS (and possibly also on *NIX OS's). Thanks to Courtney Meier
  for the bug report.

# Version 0.2.0

* Changes default location into which exiftool executable is downloaded by a
  call to `install_exiftool()`. Formerly, the executable was installed into the
  directory returned by `system.file("exiftool", package = "exiftoolr")`, which
  will not always be writable (as, e.g., when the package is installed by an
  admin in the shared library of a multi-user server, and hence is owned by
  "root"). Now, the executable is by default installed to the directory given by
  `backports::R_user_dir()`, which should be more generally writable.

# Version 0.1.8

* Fixes an issue that caused `configure_exiftoolr()` (and thus essentially all
  **exiftoolr** functionality) to fail on Windows machines that do not have Perl
  installed in a location findable by the `exiftoolr:::configure_perl()`. Thanks
  to Tom Yamashita for reporting this issue.
  
* Adds tests (using the **tinytest** package).

# Version 0.1.7

* Fixes an issue that could cause `configure_exiftoolr()` to fail if the path to
  the ExifTool executable on a user's computer contained any spaces. Now
  `configure_exiftoolr()` should work even if there are spaces in the path(s) to
  the user's installation of Perl and/or their ExifTool executable or
  library. Thanks to Lafont Rapnouil Tristan for reporting the issue.

# Version 0.1.6

* Fixes a problem likely to affect Linux users (but also any others relying on a
  local installation of Perl to execute calls to ExifTool), caused by the
  internal change in `exif_call()` in 0.1.5 from `system()` to
  `system2()`. Thanks to Daniel Baumgartner for bringing this to my attention.

# Version 0.1.5

* Added a `pipeline` option to `exif_read()`, which allows users to direct the
  exif executable to output results in csv rather than json format. This is
  helpful for use with images whose metadata contains non-UTF-8-encoded
  characters. As is documented
  [here](https://exiftool.org/exiftool_pod.html#Input-output-text-formatting),
  ExifTool's JSON output does not properly handle non-UTF-8 character
  sets. Setting `pipeline="csv"` ensures that non-UTF-8 character sets **are**
  properly handled, as demonstrated in a new example in `?exif_read`.

# Version 0.1.4

* Fixed `exif_read()` to now allow repeated elements in `args=`. This can be
  necessary when (to take one example) a user needs to separately specify the
  encoding used in the image file names and in the tags respectively. Now, a
  call like the following works as it should:
  
      exif_read(path = "myimage.jpg", 
	            args = c("-charset", "exiftool=cp850", "-charset", "filename=cp1250"))

# Version 0.1.1

* Failure of `configure_exiftoolr()` to find a local installation of ExifTool
  now throws an error rather than just a warning, preventing infinite recursion
  by `exif_read()` and `exif_version()`.
