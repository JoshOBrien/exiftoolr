# Call ExifTool from R

Uses [`system2()`](https://rdrr.io/r/base/system2.html) to run a basic
call to `exiftool`.

## Usage

``` r
exif_call(
  args = NULL,
  path = NULL,
  stdout = TRUE,
  quiet = FALSE,
  ...,
  config_file = NULL,
  common_args = NULL
)

exif_version(quiet = TRUE)
```

## Arguments

- args:

  Character vector of arguments, each written in same form as you would
  if writing them on the command line (e.g. `"-n"` or `"-csv"`)

- path:

  A character vector giving one or more file paths.

- stdout:

  Where output to stdout should be sent. If `TRUE` (the default), the
  output is captured in a character vector. For other options, see the
  help file for [`system2`](https://rdrr.io/r/base/system2.html), the
  function to which this argument's value gets passed along.

- quiet:

  Use `FALSE` to display diagnostic information. Default value is
  `FALSE`.

- ...:

  Additional arguments to be passed to
  [`system2()`](https://rdrr.io/r/base/system2.html).

- config_file:

  Path to a config file of the format expected by Exiftool's command
  line `-config` option. (See Details for an explanation of why this one
  option cannot be passed directly to `args` via the `-config`
  argument.)

- common_args:

  A character vector of arguments to be applied to all executed commands
  when the Exiftool `-execute` option is being used. (See Details for an
  explanation of why this option cannot be passed directly to `args` via
  `-common_args` argument.)

## Value

The standard output as a character vector.

## Details

For examples of the command-line calls to ExifTool (all of which can be
reproduced by calls to `exif_call`), see
<https://exiftool.org/examples.html>.

Under the hood, `exif_call()` writes the options in `args` to a text
file and then calls Exiftool, passing that text file's contents to
Exiftool via its `-@ ARGFILE` option. `-config` and `-common_args` are
the two options that may not be used in such a `-@ ARGFILE`, so we
handle that option separately using `exif_call()`'s `config_file`
argument.

## Examples

``` r
if (FALSE) { # \dontrun{
## Find local ExifTool version using exif_version() or exif_call()
exif_version()
exif_call(args = "-ver")

## Make temporary copies of a couple jpeg files
tmpdir <- tempdir()
src_files <- dir(system.file(package = "exiftoolr", "images"),
                 full.names = TRUE)
files <- file.path(tmpdir, basename(src_files))
file.copy(src_files, files)

## Both of the following extract the same tags:
exif_read(files, tags = c("filename", "imagesize"))
exif_call(args = c("-n", "-j", "-q", "-filename", "-imagesize"),
          path = files)

## Set value of a new "Artist" field in photo's metadata
file1 <- files[1]
exif_read(file1, tags = "artist")
exif_call(path = file1, args = "-Artist=me")
exif_read(file1, tags = "artist")

## Remove all but a few essential fields
length(exif_read(file1))
exif_call(path = file1, args = "-all=")
length(exif_read(file1))
exif_read(file1)

## Clean up
unlink(files)
} # }
```
