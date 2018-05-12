<!-- README.md is generated from README.Rmd. Please edit that file -->



# ExifTool functionality from R

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

The **exiftoolr** package provides a thin wrapper around a local
installation of ExifTool, giving users easy access to
[ExifTool][ExifTool-home] functionality from within R. The package can
be configured () to use an already existing ExifTool
installation. Alternatively, the utility function
`exiftoolr::install_exiftool()` (run just once following package
installation) can be used to download and install the most up-to-date
version of ExifTool into the **exiftoolr** package directory. 

A simple call to `exiftoolr::exif_read()` then reads metadata from one
or more image or other files, while the function
`exiftoolr::exif_call()` supports more general calls to underlying
ExifTool utility.


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
be downloaded using `exiftoolr::install_exiftool()`


# Installation

To install **exiftoolr** from GitHub, do:


```r
## install.packages("devtools")
devtools::install_github("JoshOBrien/exiftoolr")
```



## Example

It makes the most sense to use the `exif_read()` function with
`list.files()`, but it will also process directories (when using
`recursive = TRUE`).


```r
library(exiftoolr)
image_files <-
    dir(system.file("images", package = "exiftoolr"), 
        full.names = TRUE)
exifinfo <- exif_read(image_files)
#> Using ExifTool version 10.96
dim(exifinfo)
#> [1]   4 267
names(exifinfo) ## List of metadata fields read by ExifTool
#>   [1] "SourceFile"                 "ExifToolVersion"            "FileName"                  
#>   [4] "Directory"                  "FileSize"                   "FileModifyDate"            
#>   [7] "FileAccessDate"             "FileCreateDate"             "FilePermissions"           
#>  [10] "FileType"                   "FileTypeExtension"          "MIMEType"                  
#>  [13] "JFIFVersion"                "ExifByteOrder"              "Make"                      
#>  [16] "Model"                      "Orientation"                "XResolution"               
#>  [19] "YResolution"                "ResolutionUnit"             "Software"                  
#>  [22] "ModifyDate"                 "Artist"                     "YCbCrPositioning"          
#>  [25] "ExposureTime"               "FNumber"                    "ExposureProgram"           
#>  [28] "ISO"                        "SensitivityType"            "ExifVersion"               
#>  [31] "DateTimeOriginal"           "CreateDate"                 "ComponentsConfiguration"   
#>  [34] "CompressedBitsPerPixel"     "ExposureCompensation"       "MaxApertureValue"          
#>  [37] "MeteringMode"               "LightSource"                "Flash"                     
#>  [40] "FocalLength"                "ImageQuality"               "FirmwareVersion"           
#>  [43] "WhiteBalance"               "FocusMode"                  "AFAreaMode"                
#>  [46] "ImageStabilization"         "MacroMode"                  "ShootingMode"              
#>  [49] "Audio"                      "DataDump"                   "WhiteBalanceBias"          
#>  [52] "FlashBias"                  "InternalSerialNumber"       "PanasonicExifVersion"      
#>  [55] "ColorEffect"                "TimeSincePowerOn"           "BurstMode"                 
#>  [58] "SequenceNumber"             "ContrastMode"               "NoiseReduction"            
#>  [61] "SelfTimer"                  "Rotation"                   "AFAssistLamp"              
#>  [64] "ColorMode"                  "OpticalZoomMode"            "ConversionLens"            
#>  [67] "TravelDay"                  "WorldTimeLocation"          "ProgramISO"                
#>  [70] "AdvancedSceneType"          "FacesDetected"              "AFPointPosition"           
#>  [73] "NumFacePositions"           "Face1Position"              "Face2Position"             
#>  [76] "Face3Position"              "Face4Position"              "Face5Position"             
#>  [79] "IntelligentExposure"        "FacesRecognized"            "RecognizedFace1Name"       
#>  [82] "RecognizedFace1Position"    "RecognizedFace1Age"         "RecognizedFace2Name"       
#>  [85] "RecognizedFace2Position"    "RecognizedFace2Age"         "RecognizedFace3Name"       
#>  [88] "RecognizedFace3Position"    "RecognizedFace3Age"         "FlashWarning"              
#>  [91] "Title"                      "BabyName"                   "Location"                  
#>  [94] "IntelligentResolution"      "BurstSpeed"                 "ClearRetouch"              
#>  [97] "SweepPanoramaDirection"     "SweepPanoramaFieldOfView"   "InternalNDFilter"          
#> [100] "ClearRetouchValue"          "MakerNoteVersion"           "SceneMode"                 
#> [103] "WBRedLevel"                 "WBGreenLevel"               "WBBlueLevel"               
#> [106] "FlashFired"                 "TextStamp"                  "BabyAge"                   
#> [109] "Transform"                  "FlashpixVersion"            "ColorSpace"                
#> [112] "ExifImageWidth"             "ExifImageHeight"            "InteropIndex"              
#> [115] "InteropVersion"             "SensingMethod"              "FileSource"                
#> [118] "SceneType"                  "CustomRendered"             "ExposureMode"              
#> [121] "DigitalZoomRatio"           "FocalLengthIn35mmFormat"    "SceneCaptureType"          
#> [124] "GainControl"                "Contrast"                   "Saturation"                
#> [127] "Sharpness"                  "OffsetSchema"               "GPSVersionID"              
#> [130] "GPSLatitudeRef"             "GPSLongitudeRef"            "GPSAltitudeRef"            
#> [133] "GPSTimeStamp"               "GPSSpeedRef"                "GPSSpeed"                  
#> [136] "GPSDateStamp"               "PrintIMVersion"             "Compression"               
#> [139] "ThumbnailOffset"            "ThumbnailLength"            "MPFVersion"                
#> [142] "NumberOfImages"             "MPImageFlags"               "MPImageFormat"             
#> [145] "MPImageType"                "MPImageLength"              "MPImageStart"              
#> [148] "DependentImage1EntryNumber" "DependentImage2EntryNumber" "ImageWidth"                
#> [151] "ImageHeight"                "EncodingProcess"            "BitsPerSample"             
#> [154] "ColorComponents"            "YCbCrSubSampling"           "AdvancedSceneMode"         
#> [157] "Aperture"                   "BlueBalance"                "GPSAltitude"               
#> [160] "GPSDateTime"                "GPSLatitude"                "GPSLongitude"              
#> [163] "GPSPosition"                "ImageSize"                  "Warning"                   
#> [166] "Megapixels"                 "RedBalance"                 "ScaleFactor35efl"          
#> [169] "ShutterSpeed"               "ThumbnailImage"             "CircleOfConfusion"         
#> [172] "FOV"                        "FocalLength35efl"           "HyperfocalDistance"        
#> [175] "LightValue"                 "ShutterSpeedValue"          "ApertureValue"             
#> [178] "Quality"                    "CanonFlashMode"             "ContinuousDrive"           
#> [181] "RecordMode"                 "CanonImageSize"             "EasyMode"                  
#> [184] "DigitalZoom"                "CameraISO"                  "FocusRange"                
#> [187] "CanonExposureMode"          "LensType"                   "MaxFocalLength"            
#> [190] "MinFocalLength"             "FocalUnits"                 "MaxAperture"               
#> [193] "MinAperture"                "FlashActivity"              "FlashBits"                 
#> [196] "ZoomSourceWidth"            "ZoomTargetWidth"            "ManualFlashOutput"         
#> [199] "ColorTone"                  "FocalPlaneXSize"            "FocalPlaneYSize"           
#> [202] "AutoISO"                    "BaseISO"                    "MeasuredEV"                
#> [205] "TargetAperture"             "SlowShutter"                "OpticalZoomCode"           
#> [208] "FlashGuideNumber"           "FlashExposureComp"          "AutoExposureBracketing"    
#> [211] "AEBBracketValue"            "ControlMode"                "FocusDistanceUpper"        
#> [214] "FocusDistanceLower"         "MeasuredEV2"                "BulbDuration"              
#> [217] "CameraType"                 "AutoRotate"                 "NDFilter"                  
#> [220] "SelfTimer2"                 "BracketMode"                "BracketValue"              
#> [223] "BracketShotNumber"          "CanonImageType"             "CanonFirmwareVersion"      
#> [226] "SerialNumber"               "SerialNumberFormat"         "FileNumber"                
#> [229] "OwnerName"                  "CanonModelID"               "CanonFileLength"           
#> [232] "MeasuredRGGB"               "WB_RGGBLevelsAuto"          "WB_RGGBLevelsDaylight"     
#> [235] "WB_RGGBLevelsShade"         "WB_RGGBLevelsCloudy"        "WB_RGGBLevelsTungsten"     
#> [238] "WB_RGGBLevelsFluorescent"   "WB_RGGBLevelsFlash"         "WB_RGGBLevelsCustom"       
#> [241] "WB_RGGBLevelsKelvin"        "WB_RGGBBlackLevels"         "ColorTemperature"          
#> [244] "NumAFPoints"                "ValidAFPoints"              "CanonImageWidth"           
#> [247] "CanonImageHeight"           "AFImageWidth"               "AFImageHeight"             
#> [250] "AFAreaWidth"                "AFAreaHeight"               "AFAreaXPositions"          
#> [253] "AFAreaYPositions"           "AFPointsInFocus"            "ThumbnailImageValidArea"   
#> [256] "UserComment"                "RelatedImageWidth"          "RelatedImageHeight"        
#> [259] "FocalPlaneXResolution"      "FocalPlaneYResolution"      "FocalPlaneResolutionUnit"  
#> [262] "DriveMode"                  "Lens"                       "LensID"                    
#> [265] "WB_RGGBLevels"              "DOF"                        "Lens35efl"
```

You'll notice there are a lot of columns! You can choose the exact
tags you want to extract using the `tags` argument:


```r
exif_read(image_files, tags = c("filename", "imagesize"))
#>                                              SourceFile                FileName ImageSize
#> 1          C:/R/Library/exiftoolr/images/binary_tag.jpg          binary_tag.jpg     30x25
#> 2 C:/R/Library/exiftoolr/images/binary_tag.jpg_original binary_tag.jpg_original     30x25
#> 3               C:/R/Library/exiftoolr/images/Canon.jpg               Canon.jpg       8x8
#> 4      C:/R/Library/exiftoolr/images/Canon.jpg_original      Canon.jpg_original       8x8
```

## Details

In the background, `exif_read()` is calling `exiftool` on the console,
and reading the results to R. You can see the exact command used by
`exif_read()` by passing `quiet = FALSE`. This can be useful when
debugging, as occasionally images need to get read in that need some
kind of special treatment.


```r
exif_read(image_files, tags = c("filename", "imagesize"), quiet = FALSE)
#>                                              SourceFile                FileName ImageSize
#> 1          C:/R/Library/exiftoolr/images/binary_tag.jpg          binary_tag.jpg     30x25
#> 2 C:/R/Library/exiftoolr/images/binary_tag.jpg_original binary_tag.jpg_original     30x25
#> 3               C:/R/Library/exiftoolr/images/Canon.jpg               Canon.jpg       8x8
#> 4      C:/R/Library/exiftoolr/images/Canon.jpg_original      Canon.jpg_original       8x8
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
#>   "SourceFile": "C:/R/Library/exiftoolr/images/binary_tag.jpg_original",
#>   "FileName": "binary_tag.jpg_original",
#>   "ImageSize": "30x25"
#> },
#> {
#>   "SourceFile": "C:/R/Library/exiftoolr/images/Canon.jpg",
#>   "FileName": "Canon.jpg",
#>   "ImageSize": "8x8"
#> },
#> {
#>   "SourceFile": "C:/R/Library/exiftoolr/images/Canon.jpg_original",
#>   "FileName": "Canon.jpg_original",
#>   "ImageSize": "8x8"
#> }]
```

[ExifTool-home]: http://www.sno.phy.queensu.ca/%7Ephil/exiftool/
[Strawberry-Perl]: http://www.strawberryperl.com/
[ActiveState-Perl]: https://www.activestate.com/activeperl/downloads
