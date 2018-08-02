<!-- README.md is generated from README.Rmd. Please edit that file -->



# ExifTool functionality from R

The **exiftoolr** R package provides a thin wrapper around a local
installation of [ExifTool][ExifTool-home], giving its users easy
access to ExifTool functionality from within R. **exiftoolr** can be
configured to use any ExifTool installation, but many or most users
will prefer to simply run `install_exiftool()` once following package
installation to download and install the most up-to-date version of
ExifTool into the **exiftoolr** package
directory. (`install_exiftool()` can also be run subsequently, at any
time, to update the installed ExifTool to the most recent version.)

Once the package is installed and set up, a simple call to
`exif_read()` can be used to read metadata from one or more files into
a `data.frame` with one column per metadata field and one row per
file. Another function, `exif_call()`, supports more general calls to
the underlying ExifTool utility, examples of which are displayed
[here][ExifTool-examples].


## What is ExifTool?

Phil Harvey's ExifTool is an excellent and comprehensive open source
utility for reading, writing and editing meta information in a wide
variety of files. As noted on the [project homepage][ExifTool-home]:

> ExifTool supports many different metadata formats including EXIF, GPS,
> IPTC, XMP, JFIF, GeoTIFF, ICC Profile, Photoshop IRB, FlashPix, AFCP
> and ID3, as well as the maker notes of many digital cameras by Canon,
> Casio, FLIR, FujiFilm, GE, HP, JVC/Victor, Kodak, Leaf,
> Minolta/Konica-Minolta, Motorola, Nikon, Nintendo, Olympus/Epson,
> Panasonic/Leica, Pentax/Asahi, Phase One, Reconyx, Ricoh, Samsung,
> Sanyo, Sigma/Foveon and Sony.


## Why another R package for reading image file metadata?

Several existing R packages read EXIF metadata from image files. The
[**exif**](https://CRAN.R-project.org/package=exif),
[**exiv**](https://github.com/hrbrmstr/exiv), and
[**magick**](https://CRAN.R-project.org/package=magick) packages, all
include functions (`exif::read_exif()`, `exiv::read_exif()`, and
`magick::image_attributes()`, respectively) that extract files' EXIF
data. In many files, though, EXIF tags comprise only a subset of the
metadata, and even  well as EXIF maker notes and (despite its name) ExifTool
reads data stored in many additional metadata formats.

The [**exifr**](https://CRAN.R-project.org/package=exifr) package (of
which **exiftoolr** is essentially a much modified fork) is much more
similar in the functionality that it provides. Both packages construct
a thin wrapper around ExifTool, and so inherit its excellent support
for a large variety of file types and metadata formats. The packages
differ mainly in their support for easy installation and configuration
on all operating systems. **exiftoolr**, in particular, was designed
to make it as easy for Windows users -- even those without Python
installations -- to access ExifTool functionality as it is for *NIX
and Mac users. Relative to **exifr**, **exiftoolr** also makes it
easier to update ExifTool to its most current version.

## ExifTool and Perl

ExifTool is written and distributed as a Perl library. It can thus be
used "out of the box" on any computer that (like most Linux and Mac
machines) has a working Perl installation. Windows machines often do
**not** have Perl installed (though easy-to-use installers are
available from, e.g., [Strawberry Perl][Strawberry-Perl] and [Active
State Perl][ActiveState-Perl]).

Windows users do not, however, need to install Perl to accesss
ExifTool's functionality. They may instead install the standalone
ExifTool executable distributed on the ExifTool home page. Like the
Perl library, the Windows executable can be downloaded and installed
using the function `install_exiftool()`.


## Installation and setup

To install **exiftoolr** from GitHub, do:


```r
if(!require(devtools)) {install.packages("devtools")}
devtools::install_github("JoshOBrien/exiftoolr")
```

Then, to install a copy of the ExifTool library or executable into the
**exiftoolr** package's directory tree, where calls to functions in
the **exiftoolr** package will automatically find it, run
`install_exiftool()`:


```r
exiftoolr::install_exiftool()
```

**exiftoolr** makes a reasonable attempt to find local copies of Perl
and ExifTool, and in most cases will need no hints to find them. For
situations in which want more control over which Perl or ExifTool is
used, set their paths with either an explicit call to
`configure_exiftool()` or by setting the environment variables
`"ET_PERL_PATH"` and `"ET_EXIFTOOL_PATH"`.


## Usage

`exif_read()` will quickly read metadata from one or more image files,
returning the results in a plain `data.frame`: 


```r
library(exiftoolr)
image_files <- dir(system.file("images", package = "exiftoolr"), 
                   full.names = TRUE)
exifinfo <- exif_read(image_files)
#> Using ExifTool version 11.08
dim(exifinfo)
#> [1]   2 268
names(exifinfo)[1:60] ## List the first 60 metadata fields read by ExifTool
#>  [1] "SourceFile"              "ExifToolVersion"         "FileName"                "Directory"              
#>  [5] "FileSize"                "FileModifyDate"          "FileAccessDate"          "FileCreateDate"         
#>  [9] "FilePermissions"         "FileType"                "FileTypeExtension"       "MIMEType"               
#> [13] "JFIFVersion"             "ExifByteOrder"           "Make"                    "Model"                  
#> [17] "Orientation"             "XResolution"             "YResolution"             "ResolutionUnit"         
#> [21] "Software"                "ModifyDate"              "Artist"                  "YCbCrPositioning"       
#> [25] "ExposureTime"            "FNumber"                 "ExposureProgram"         "ISO"                    
#> [29] "SensitivityType"         "ExifVersion"             "DateTimeOriginal"        "CreateDate"             
#> [33] "ComponentsConfiguration" "CompressedBitsPerPixel"  "ExposureCompensation"    "MaxApertureValue"       
#> [37] "MeteringMode"            "LightSource"             "Flash"                   "FocalLength"            
#> [41] "Warning"                 "ImageQuality"            "FirmwareVersion"         "WhiteBalance"           
#> [45] "FocusMode"               "AFAreaMode"              "ImageStabilization"      "MacroMode"              
#> [49] "ShootingMode"            "Audio"                   "DataDump"                "WhiteBalanceBias"       
#> [53] "FlashBias"               "InternalSerialNumber"    "PanasonicExifVersion"    "ColorEffect"            
#> [57] "TimeSincePowerOn"        "BurstMode"               "SequenceNumber"          "ContrastMode"
```

As you can see, there are a lot of columns! To extract only those
tags that are actually needed, use the `tags` argument:


```r
exif_read(image_files, tags = c("filename", "imagesize"))
#>                                     SourceFile       FileName ImageSize
#> 1 C:/R/Library/exiftoolr/images/binary_tag.jpg binary_tag.jpg     30x25
#> 2      C:/R/Library/exiftoolr/images/Canon.jpg      Canon.jpg       8x8
```

The `tags` argument also accepts simple regular expressions. For
instance, to extract all fields with names containing the substring
`"GPS"`, you could use the following call:


```r
exif_read(image_files[1], tags = "*GPS*")[,-1]
#>   GPSVersionID GPSLatitudeRef GPSLongitudeRef GPSAltitudeRef GPSTimeStamp GPSSpeedRef GPSSpeed GPSDateStamp
#> 1      2 3 0 0              N               E              0     15:00:59           K 14.04868   2017:09:22
#>   GPSAltitude          GPSDateTime GPSLatitude GPSLongitude       GPSPosition
#> 1    263.5279 2017:09:22 15:00:59Z    48.70413     6.250123 48.70413 6.250123
```


To access more general ExifTool functionality, you can use the
function `exif_call()` to roll your own call to ExifTool. For the
previous example, it would look something like this:


```r
exif_call(args = c("-n", "-j", "-q", "-filename", "-imagesize"),
          fnames = image_files)
#> Error in system(command, intern = intern, ...): unused argument (fnames = image_files)
```





[ExifTool-home]: http://www.sno.phy.queensu.ca/%7Ephil/exiftool/
[ExifTool-examples]: http://owl.phy.queensu.ca/~phil/exiftool/examples.html
[Strawberry-Perl]: http://www.strawberryperl.com/
[ActiveState-Perl]: https://www.activestate.com/activeperl/downloads
