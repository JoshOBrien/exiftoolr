# Install ExifTool, downloading (by default) the current version

Install the current version of ExifTool

## Usage

``` r
install_exiftool(
  install_location = NULL,
  win_exe = NULL,
  local_exiftool = NULL,
  quiet = FALSE
)
```

## Arguments

- install_location:

  Path to the directory into which ExifTool should be installed. If
  `NULL` (the default), installation will be into the directory returned
  by `backports::R_user_dir("exiftoolr")`.

- win_exe:

  Logical, only used on Windows machines. Should we install the
  standalone ExifTool Windows executable or the ExifTool Perl library?
  (The latter relies, for its execution, on an existing installation of
  Perl being present on the user's machine.) If set to `NULL` (the
  default), the function installs the Windows executable on Windows
  machines and the Perl library on other operating systems.

- local_exiftool:

  If installing ExifTool from a local "\*.zip" or ".tar.gz", supply the
  path to that file as a character string. With default value, \`NULL\`,
  the function downloads ExifTool from <https://exiftool.org> and then
  installs it.

- quiet:

  Logical. Should function should be chatty?

## Value

Called for its side effect
