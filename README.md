---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



# exiftoolr

Ever needed to read in EXIF data from images or other files in R?
Phil Harvey's [ExifTool][exiftool-home] by Phil Harvey is the most
comprehensive tool available for reading, writing and editing meta
information in a wide variety of files. ExifTool supports many
different metadata formats including EXIF, GPS, IPTC, XMP, JFIF,
GeoTIFF, ICC Profile, Photoshop IRB, FlashPix, AFCP and ID3, as well
as the maker notes of many digital cameras by Canon, Casio, FLIR,
FujiFilm, GE, HP, JVC/Victor, Kodak, Leaf, Minolta/Konica-Minolta,
Motorola, Nikon, Nintendo, Olympus/Epson, Panasonic/Leica,
Pentax/Asahi, Phase One, Reconyx, Ricoh, Samsung, Sanyo, Sigma/Foveon
and Sony. This package provides a thin wrapper around
[ExifTool][exiftool-home] allowing the reading of image file metadata
with a single command.

## Installation

You will need Perl to use **exiftoolr**, which may already be
installed on your system (Mac, Linux). 

To use ExifTool, Windows users may want to install Perl (e.g. from
[Strawberry Perl][Strawberry]). Alternatively, they can use the
stand-alone ExifTool executable kindly provided by Phil Harvey.


Mac users can also install ExifTool directly from
[sourceforge](https://sourceforge.net/projects/exiftool/files/), which
is not necessary but may be useful if ExifTool is to be used outside
of R.

You can install **exiftoolr** from GitHub with:


```r
# install.packages("devtools")
devtools::install_github("paleolimbot/exiftoolr")
```

If you can load the package, everything should be installed correctly:


```r
library(exiftoolr)
```

## Example

It makes the most sense to use the `exif_read()` function with
`list.files()`, but it will also process directories (when using
`recursive = TRUE`).


```r
image_files <-
    list.files(system.file("images", package = "exiftoolr"), 
               full.names = TRUE)
exifinfo <- exif_read(image_files)
#> Using ExifTool version 10.96
exifinfo[, 1:10] ## Only display the first 10 columns
#>                                     SourceFile ExifToolVersion
#> 1 C:/R/Library/exiftoolr/images/binary_tag.jpg           10.96
#> 2      C:/R/Library/exiftoolr/images/Canon.jpg           10.96
#>         FileName                     Directory FileSize
#> 1 binary_tag.jpg C:/R/Library/exiftoolr/images    13726
#> 2      Canon.jpg C:/R/Library/exiftoolr/images     2697
#>              FileModifyDate            FileAccessDate
#> 1 2018:05:10 11:09:04-07:00 2018:05:10 11:09:04-07:00
#> 2 2018:05:10 11:09:04-07:00 2018:05:10 11:09:04-07:00
#>              FileCreateDate FilePermissions FileType
#> 1 2018:05:10 11:09:04-07:00             666     JPEG
#> 2 2018:05:10 11:09:04-07:00             666     JPEG
```

You'll notice there are a lot of columns! You can choose the exact
tags you want to extract using the `tags` argument:


```r
exif_read(image_files, tags = c("filename", "imagesize"))
#>                                     SourceFile       FileName ImageSize
#> 1 C:/R/Library/exiftoolr/images/binary_tag.jpg binary_tag.jpg     30x25
#> 2      C:/R/Library/exiftoolr/images/Canon.jpg      Canon.jpg       8x8
```

## Details

In the background, `exif_read()` is calling `exiftool` on the console,
and reading the results to R. You can see the exact command used by
`exif_read()` by passing `quiet = FALSE`. This can be useful when
debugging, as occasionally images need to get read in that need some
kind of special treatment.


```r
exif_read(image_files, tags = c("filename", "imagesize"), quiet = FALSE)
#>                                     SourceFile       FileName ImageSize
#> 1 C:/R/Library/exiftoolr/images/binary_tag.jpg binary_tag.jpg     30x25
#> 2      C:/R/Library/exiftoolr/images/Canon.jpg      Canon.jpg       8x8
```

You can also roll-your-own `exiftool` call by using
`exif_call()`. For the previous example, it would look something
like this:


```r
exif_call(args = c("-n", "-j", "-q", "-filename", "-imagesize"),
          fnames = image_files)
```


```
#> [{
#>   "SourceFile": "C:/R/Library/exiftoolr/images/binary_tag.jpg",
#>   "FileName": "binary_tag.jpg",
#>   "ImageSize": "30x25"
#> },
#> {
#>   "SourceFile": "C:/R/Library/exiftoolr/images/Canon.jpg",
#>   "FileName": "Canon.jpg",
#>   "ImageSize": "8x8"
#> }]
```

[exiftool-home]: http://www.sno.phy.queensu.ca/%7Ephil/exiftool/
[Strawberry]: http://www.strawberryperl.com/
