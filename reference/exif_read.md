# Read EXIF and other metadata from files

Reads EXIF and other metadata into a `data.frame` by calling Phil
Harvey's ExifTool command-line application.

## Usage

``` r
exif_read(
  path,
  tags = NULL,
  recursive = FALSE,
  args = NULL,
  quiet = TRUE,
  pipeline = c("json", "csv")
)
```

## Arguments

- path:

  A vector of filenames.

- tags:

  A vector of tags to output. It is a good idea to specify this when
  reading large numbers of files, as it decreases the output overhead
  significantly. Spaces will be stripped in the output data frame. This
  parameter is not case-sensitive.

- recursive:

  `TRUE` to pass the `"-r"` option to ExifTool.

- args:

  Additional arguments.

- quiet:

  Use `FALSE` to display diagnostic information. Default value is `TRUE`

- pipeline:

  One of `"json"` (the default) or `"csv"`. Controls whether the
  exiftool executable, behind the scenes, extracts metadata into a JSON
  data structure or a tabular csv. The JSON pipeline works well in most
  cases, but (as documented at <https://exiftool.org/exiftool_pod.html>)
  does not properly handle non-UTF-8 character sets. If the metadata
  fields include characters that are not encoded using UTF-8 and that
  need to be handled by setting the `"-charset"` option, use the `"csv"`
  pipeline as demonstrated in the second example below.

## Value

A data frame of class `"exiftoolr"` with one row per file processed. The
first column, named `"SourceFile"` gives the name(s) of the processed
files. Subsequent columns contain info from the tags read from those
files.

Note that binary tags such as thumbnails are loaded as [base64-encoded
strings](https://en.wikipedia.org/wiki/Base64) that start with
`"base64:"`. Although these are truncated in the printed representation
of the `data.frame` returned by the function, they are left unaltered in
the `data.frame` itself.

## Details

From the [ExifTool website](https://exiftool.org): "ExifTool is a
platform-independent Perl library plus a command-line application for
reading, writing and editing meta information in a wide variety of
files. ExifTool supports many different metadata formats including EXIF,
GPS, IPTC, XMP, JFIF, GeoTIFF, ICC Profile, Photoshop IRB, FlashPix,
AFCP and ID3, as well as the maker notes of many digital cameras by
Canon, Casio, DJI, FLIR, FujiFilm, GE, GoPro, HP, JVC/Victor, Kodak,
Leaf, Minolta/Konica-Minolta, Motorola, Nikon, Nintendo, Olympus/Epson,
Panasonic/Leica, Pentax/Asahi, Phase One, Reconyx, Ricoh, Samsung,
Sanyo, Sigma/Foveon and Sony."

For more information, see the [ExifTool website](https://exiftool.org).

## References

<https://exiftool.org>

## Examples

``` r
if (FALSE) { # \dontrun{
files <- dir(system.file(package = "exiftoolr", "images"),
             pattern = "LaSals|Lizard", full.names = TRUE)
exif_read(files)
exif_read(files, tags = c("filename", "imagesize"))

## Use pipeline="csv" for images needing explicit specification
## and proper handling of a non-default character sets
img_file <- system.file(package = "exiftoolr", "images", "QS_Hongg.jpg")
args <- c("-charset", "exiftool=cp1250")
res <- exif_read(img_file, args = args, pipeline = "csv")
res[["City"]]  ## "Zurich", with an umlaut over the "u"
} # }
```
