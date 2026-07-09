# Configure package to point to ExifTool and/or Perl

Configure package to point to ExifTool and/or Perl

## Usage

``` r
configure_exiftoolr(
  command = NULL,
  perl_path = NULL,
  allow_win_exe = TRUE,
  quiet = FALSE
)
```

## Arguments

- command:

  Character string giving the exiftool command.

- perl_path:

  Path to a Perl executable.

- allow_win_exe:

  Logical. If running on a Windows machine, and if a standalone exiftool
  executable is available, should it be used?

- quiet:

  Logical. Should function should be chatty?

## Value

A character string giving the exiftool command, returned invisibly.
