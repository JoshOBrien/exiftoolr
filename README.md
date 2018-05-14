<!-- README.md is generated from README.Rmd. Please edit that file -->



# ExifTool functionality from R

The **exiftoolr** package provides a thin wrapper around a local
installation of ExifTool, giving users easy access to
[ExifTool][ExifTool-home] functionality from within R. The package can
be configured () to use an already existing ExifTool
installation. Alternatively, the utility function `install_exiftool()`
(run just once following package installation) can be used to download
and install the most up-to-date version of ExifTool into the
**exiftoolr** package directory.

A simple call to `exif_read()` then reads metadata from one or more
image or other files, while the function `exif_call()` supports more
general calls to underlying ExifTool utility.


## What is ExifTool?

Phil Harvey's [ExifTool][ExifTool-home] is an excellent and
comprehensive open source utility for reading, writing and editing
meta information in a wide variety of files. ExifTool supports many
different metadata formats including EXIF, GPS, IPTC, XMP, JFIF,
GeoTIFF, ICC Profile, Photoshop IRB, FlashPix, AFCP and ID3, as well
as the maker notes of many digital cameras by Canon, Casio, FLIR,
FujiFilm, GE, HP, JVC/Victor, Kodak, Leaf, Minolta/Konica-Minolta,
Motorola, Nikon, Nintendo, Olympus/Epson, Panasonic/Leica,
Pentax/Asahi, Phase One, Reconyx, Ricoh, Samsung, Sanyo, Sigma/Foveon
and Sony.


## ExifTool and Perl

ExifTool is written and primarily distributed as a Perl library which
can be used on any computer with a working Perl installation. Those
include most Linux and Mac machines, which typically have Perl
installed by default. Machines running Windows often do **not** have
Perl installed (though it may be easily installed using installers
distributed by [Strawberry Perl][Strawberry-Perl] or [Active State
Perl][ActiveState-Perl]).

Windows users without Perl do not, though, need to install Perl to
accesss ExifTool's functionality. They instead have the option of
installing stand-alone ExifTool compiled executable distributed on the
ExifTool home page. Like the Perl library, the Windows executable can
be downloaded using `exiftool()`


## Installation and setup

To install **exiftoolr** from GitHub, do:


```r
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
situations in which you need more control over which Perl or Exiftool
is used, use the `configure_exiftool()` function or, alternatively,
set the environment variables `"ET_PERL_PATH"` and/or
`"ET_EXIFTOOL_PATH"`.


## Usage

It makes the most sense to use the `exif_read()` function with
`list.files()`, but it will also process directories (when using
`recursive = TRUE`).


```r
library(exiftoolr)
image_files <- dir(system.file("images", package = "exiftoolr"), 
                   full.names = TRUE)
exifinfo <- exif_read(image_files)
dim(exifinfo)
#> [1]   2 267
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
#> [41] "ImageQuality"            "FirmwareVersion"         "WhiteBalance"            "FocusMode"              
#> [45] "AFAreaMode"              "ImageStabilization"      "MacroMode"               "ShootingMode"           
#> [49] "Audio"                   "DataDump"                "WhiteBalanceBias"        "FlashBias"              
#> [53] "InternalSerialNumber"    "PanasonicExifVersion"    "ColorEffect"             "TimeSincePowerOn"       
#> [57] "BurstMode"               "SequenceNumber"          "ContrastMode"            "NoiseReduction"
```

You'll notice there are a lot of columns! You can choose the exact
tags you want to extract using the `tags` argument:


```r
exif_read(image_files, tags = c("filename", "imagesize"))
#>                                     SourceFile       FileName ImageSize
#> 1 C:/R/Library/exiftoolr/images/binary_tag.jpg binary_tag.jpg     30x25
#> 2      C:/R/Library/exiftoolr/images/Canon.jpg      Canon.jpg       8x8
```

You can also roll your own call to ExifTool with the function
`exif_call()`. For the previous example, it would look something like
this:


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




[ExifTool-home]: http://www.sno.phy.queensu.ca/%7Ephil/exiftool/
[Strawberry-Perl]: http://www.strawberryperl.com/
[ActiveState-Perl]: https://www.activestate.com/activeperl/downloads
