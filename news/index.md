# Changelog

## Version 0.2.8

CRAN release: 2025-04-20

- [`configure_exiftoolr()`](https://joshobrien.github.io/exiftoolr/reference/configure_exiftoolr.md)
  now checks for and more gracefully handles zero length string command
  candidates. (Those had caused a problem on, at least, MacOS.) Thanks
  to George Ostrouchov for describing the issue and suggesting the fix.

## Version 0.2.7

CRAN release: 2025-01-14

- On Windows,
  [`install_exiftool()`](https://joshobrien.github.io/exiftoolr/reference/install_exiftool.md)
  now changes the name of the installed executable from
  `"exiftool(-k).exe"` to `"exiftool.exe"` as recommended for
  command-line use by Phil Harvey here:
  <https://exiftool.org/install.html#Windows>.
  `exiftoolr:::configure_exiftoolr()`, which searches for locally
  available executables, now searches first for `"exiftool.exe"` and
  then for `"exiftool(-k).exe"`, so that it will still find ExifTool
  executables installed by previous versions of this R package. Thanks
  to Andy Lyons for suggesting this change, which fixes a problem that
  plagued at least some Windows users.

## Version 0.2.6

CRAN release: 2024-07-19

- One more modification to
  [`install_exiftool()`](https://joshobrien.github.io/exiftoolr/reference/install_exiftool.md)
  needed to handle changes in how Phil Harvey’s <http://exiftool.org>
  provides Windows ExifTool executables.

## Version 0.2.5

CRAN release: 2024-07-18

- Modified
  [`install_exiftool()`](https://joshobrien.github.io/exiftoolr/reference/install_exiftool.md)
  (and its helper function, `download_exiftool()`) to handle a couple of
  changes in how Phil Harvey’s <http://exiftool.org> provides Windows
  ExifTool executables.

## Version 0.2.4

CRAN release: 2024-03-28

- Ensures that Unicode tags are correctly written to files even in
  non-Unicode locales. Thanks to Trevor Davis for the excellent, as
  usual, issue description and PR.

- Improves the error message returned to the user when the call to
  Exiftool finds no files to act upon. In addition to more gracefully
  relaying the error message emitted by Exiftool, such calls now return
  a value of `NULL`. Thanks to jcblum for reporting this issue.

## Version 0.2.3

CRAN release: 2023-10-17

- Adds arguments `config_file=` and `common_args=` to
  [`exif_call()`](https://joshobrien.github.io/exiftoolr/reference/exif_call.md).
  These are passed on to exiftool options `-config` and `-common_args`
  respectively, neither of which was supported here before due to their
  not being allowed in the `-@ ARGFILE` option used ‘behind the scenes’
  by all calls to
  [`exif_call()`](https://joshobrien.github.io/exiftoolr/reference/exif_call.md).

## Version 0.2.2

CRAN release: 2023-02-22

- Fixes bug that could cause a failure to locate an already-installed
  version of ExifTool on MacOS (and possibly also on \*NIX OS’s). Thanks
  to Courtney Meier for the bug report.

## Version 0.2.0

CRAN release: 2022-10-04

- Changes default location into which exiftool executable is downloaded
  by a call to
  [`install_exiftool()`](https://joshobrien.github.io/exiftoolr/reference/install_exiftool.md).
  Formerly, the executable was installed into the directory returned by
  `system.file("exiftool", package = "exiftoolr")`, which will not
  always be writable (as, e.g., when the package is installed by an
  admin in the shared library of a multi-user server, and hence is owned
  by “root”). Now, the executable is by default installed to the
  directory given by
  [`backports::R_user_dir()`](https://rdrr.io/pkg/backports/man/R_user_dir.html),
  which should be more generally writable.

## Version 0.1.8

CRAN release: 2022-06-09

- Fixes an issue that caused
  [`configure_exiftoolr()`](https://joshobrien.github.io/exiftoolr/reference/configure_exiftoolr.md)
  (and thus essentially all **exiftoolr** functionality) to fail on
  Windows machines that do not have Perl installed in a location
  findable by the `exiftoolr:::configure_perl()`. Thanks to Tom
  Yamashita for reporting this issue.

- Adds tests (using the **tinytest** package).

## Version 0.1.7

CRAN release: 2021-11-18

- Fixes an issue that could cause
  [`configure_exiftoolr()`](https://joshobrien.github.io/exiftoolr/reference/configure_exiftoolr.md)
  to fail if the path to the ExifTool executable on a user’s computer
  contained any spaces. Now
  [`configure_exiftoolr()`](https://joshobrien.github.io/exiftoolr/reference/configure_exiftoolr.md)
  should work even if there are spaces in the path(s) to the user’s
  installation of Perl and/or their ExifTool executable or library.
  Thanks to Lafont Rapnouil Tristan for reporting the issue.

## Version 0.1.6

CRAN release: 2021-11-06

- Fixes a problem likely to affect Linux users (but also any others
  relying on a local installation of Perl to execute calls to ExifTool),
  caused by the internal change in
  [`exif_call()`](https://joshobrien.github.io/exiftoolr/reference/exif_call.md)
  in 0.1.5 from [`system()`](https://rdrr.io/r/base/system.html) to
  [`system2()`](https://rdrr.io/r/base/system2.html). Thanks to Daniel
  Baumgartner for bringing this to my attention.

## Version 0.1.5

CRAN release: 2020-11-09

- Added a `pipeline` option to
  [`exif_read()`](https://joshobrien.github.io/exiftoolr/reference/exif_read.md),
  which allows users to direct the exif executable to output results in
  csv rather than json format. This is helpful for use with images whose
  metadata contains non-UTF-8-encoded characters. As is documented
  [here](https://exiftool.org/exiftool_pod.html#Input-output-text-formatting),
  ExifTool’s JSON output does not properly handle non-UTF-8 character
  sets. Setting `pipeline="csv"` ensures that non-UTF-8 character sets
  **are** properly handled, as demonstrated in a new example in
  [`?exif_read`](https://joshobrien.github.io/exiftoolr/reference/exif_read.md).

## Version 0.1.4

CRAN release: 2020-09-03

- Fixed
  [`exif_read()`](https://joshobrien.github.io/exiftoolr/reference/exif_read.md)
  to now allow repeated elements in `args=`. This can be necessary when
  (to take one example) a user needs to separately specify the encoding
  used in the image file names and in the tags respectively. Now, a call
  like the following works as it should:

  ``` R
  exif_read(path = "myimage.jpg", 
            args = c("-charset", "exiftool=cp850", "-charset", "filename=cp1250"))
  ```

## Version 0.1.1

CRAN release: 2018-09-12

- Failure of
  [`configure_exiftoolr()`](https://joshobrien.github.io/exiftoolr/reference/configure_exiftoolr.md)
  to find a local installation of ExifTool now throws an error rather
  than just a warning, preventing infinite recursion by
  [`exif_read()`](https://joshobrien.github.io/exiftoolr/reference/exif_read.md)
  and
  [`exif_version()`](https://joshobrien.github.io/exiftoolr/reference/exif_call.md).
