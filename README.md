<!-- README.md is generated from README.Rmd. Please edit that file -->



# ExifTool functionality from R

[ExifTool][ExifTool-home] is a comprehensive open source utility for
reading, writing and editing meta information in a wide variety of
files. As noted on the [project homepage][ExifTool-home]:

> ExifTool supports many different metadata formats including EXIF, GPS,
> IPTC, XMP, JFIF, GeoTIFF, ICC Profile, Photoshop IRB, FlashPix, AFCP
> and ID3, as well as the maker notes of many digital cameras by Canon,
> Casio, DJI, FLIR, FujiFilm, GE, GoPro, HP, JVC/Victor, Kodak, Leaf,
> Minolta/Konica-Minolta, Motorola, Nikon, Nintendo, Olympus/Epson,
> Panasonic/Leica, Pentax/Asahi, Phase One, Reconyx, Ricoh, Samsung,
> Sanyo, Sigma/Foveon and Sony.

The **exiftoolr** R package provides a thin wrapper around a local
installation of ExifTool, giving its users easy access to ExifTool
functionality from within R. **exiftoolr** can be configured to use
any ExifTool installation, but many or most users will prefer to
simply run `install_exiftool()` once following package installation to
download and install the most up-to-date version of ExifTool into the
**exiftoolr** package directory. (`install_exiftool()` can also be run
subsequently, at any time, to update the installed ExifTool to the
most recent version.)

Once the package is installed and set up, a simple call to
`exif_read()` can be used to read metadata from one or more files into
a `data.frame` with one column per metadata field and one row per
file. Another function, `exif_call()`, supports more general calls to
the underlying ExifTool utility, examples of which are displayed
[here][ExifTool-examples].

## Example

First up, an example of what ExifTool (via **exiftoolr**) can do. Say
that you have an image onto which you would like to add a bit of text
indicating the time and place at which it was taken. Here is a photo
taken in the LaSal mountains in southeastern Utah, USA.

![](img/LaSals.jpg)

Here is one way to do that, using **exiftoolr** to extract the
relevant data, and the
[**magick**](https://CRAN.R-project.org/package=magick) package to
annotate the image with it:


```r
library(exiftoolr)
library(magick)

## Read and extract image metadata
dat <- exif_read("LaSals.jpg")
DateTime  <- dat[["CreateDate"]]
Longitude <- dat[["GPSLongitude"]]
Latitude  <- dat[["GPSLatitude"]]

## Prepare annotation text
txt <- paste0(DateTime, "\n",
              "Longitude: ", round(Longitude, 5), "\n",
              "Latitude:  ", round(Latitude, 5))

## Annotate image and write to file
out <- image_annotate(image_read(infile), txt,
                      gravity = "northwest", color = "red",
                      boxcolor = adjustcolor("black", alpha=0.2),
                      size = 15, location = "+10+10")
image_write(out, "LaSals_annotated.jpg")
```

![](img/LaSals_annotated.jpg)


# Installation

Released versions of **exiftoolr** are available via
[CRAN](https://cran.r-project.org/) and may be installed by doing:


```r
install.packages("devtools")
```

To install the most recent version from GitHub, do:


```r
if(!require(devtools)) {install.packages("devtools")}
devtools::install_github("JoshOBrien/exiftoolr")
```


# Setup

To install a copy of the ExifTool library or executable into the
installed **exiftoolr** package's directory tree, where calls to
functions in the **exiftoolr** package will automatically find it, run
`install_exiftool()`:


```r
exiftoolr::install_exiftool()
```

**exiftoolr** makes a reasonable attempt to find local copies of Perl
and ExifTool and in most cases will need no hints to find them. For
direct control over which Perl or ExifTool is used, set their paths
with either an explicit call to `configure_exiftool()` or by setting
the environment variables `"ET_PERL_PATH"` and `"ET_EXIFTOOL_PATH"`.


# Usage

`exif_read()` reads metadata from one or more image files, returning
the results in a plain `data.frame`:


```r
library(exiftoolr)
image_files <- dir(system.file("images", package = "exiftoolr"), 
                   full.names = TRUE)
exifinfo <- exif_read(image_files)
#> Using ExifTool version 11.99
dim(exifinfo)
#> [1]  2 99
names(exifinfo)[1:20] ## List the first 20 metadata fields read by ExifTool
#>  [1] "SourceFile"        "ExifToolVersion"   "FileName"          "Directory"         "FileSize"         
#>  [6] "FileModifyDate"    "FileAccessDate"    "FileCreateDate"    "FilePermissions"   "FileType"         
#> [11] "FileTypeExtension" "MIMEType"          "ExifByteOrder"     "Make"              "Model"            
#> [16] "Orientation"       "XResolution"       "YResolution"       "ResolutionUnit"    "Software"
```

To extract only those tags that are actually needed, use the `tags`
argument:


```r
exif_read(image_files, tags = c("filename", "imagesize"))
#>                                    SourceFile   FileName ImageSize
#> 1 C:/R/Library363/exiftoolr/images/LaSals.jpg LaSals.jpg   640 480
#> 2 C:/R/Library363/exiftoolr/images/Lizard.jpg Lizard.jpg 4032 3024
```

The `tags` argument also accepts simple regular expressions. For
instance, to extract all fields with names containing the substring
`"GPS"`, you could use the following call:


```r
exif_read(image_files[1], tags = "*GPS*")
#>                                    SourceFile GPSLatitudeRef GPSLongitudeRef GPSAltitudeRef GPSTimeStamp
#> 1 C:/R/Library363/exiftoolr/images/LaSals.jpg              N               W              0     23:05:36
#>   GPSSpeedRef GPSSpeed GPSImgDirectionRef GPSImgDirection GPSDestBearingRef GPSDestBearing GPSDateStamp
#> 1           K        0                  T        107.2073                 T       107.2073   2016:09:21
#>   GPSHPositioningError GPSAltitude          GPSDateTime GPSLatitude GPSLongitude
#> 1                    5    2257.414 2016:09:21 23:05:36Z    39.64798    -111.3705
#>                          GPSPosition
#> 1 39.6479805555556 -111.370505555556
```


To access more general ExifTool functionality (many examples of which
are shown [here][ExifTool-examples]), you can use the
function `exif_call()` to roll your own ExifTool call. For the
previous example, it would look something like this:


```r
exif_call(args = c("-n", "-j", "-q", "-*GPS*"), path = image_files[1])
```


# Why another R package for reading image file metadata?

Several existing R packages can read EXIF metadata from image
files. The [**exif**](https://CRAN.R-project.org/package=exif),
[**exiv**](https://github.com/hrbrmstr/exiv), and
[**magick**](https://CRAN.R-project.org/package=magick) packages, all
include functions (`exif::read_exif()`, `exiv::read_exif()`, and
`magick::image_attributes()`, respectively) that extract files' EXIF
data. In many files, though, EXIF tags comprise only a subset of the
metadata, and even well as EXIF maker notes and (despite its name)
ExifTool reads data stored in many additional metadata formats.

The [**exifr**](https://CRAN.R-project.org/package=exifr) package is
much more similar in the functionality that it provides. Both it and
**exiftoolr** construct a thin wrapper around ExifTool, and so inherit
its excellent support for a large variety of file types and many
metadata formats beyond EXIF tags. The packages differ mainly in their
support for easy installation and configuration on all operating
systems. **exiftoolr**, in particular, was designed to make it as easy
for Windows users -- even those without Python installations -- to
access ExifTool functionality as it is for *NIX and Mac
users. Relative to **exifr**, **exiftoolr** also makes it easier to
update ExifTool to its most current version.



[ExifTool-home]: https://exiftool.org/
[ExifTool-examples]: https://exiftool.org/examples.html
