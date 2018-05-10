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
dim(exifinfo)
#> [1]   2 267
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
#>  [40] "FocalLength"                "Warning"                    "ImageQuality"              
#>  [43] "FirmwareVersion"            "WhiteBalance"               "FocusMode"                 
#>  [46] "AFAreaMode"                 "ImageStabilization"         "MacroMode"                 
#>  [49] "ShootingMode"               "Audio"                      "DataDump"                  
#>  [52] "WhiteBalanceBias"           "FlashBias"                  "InternalSerialNumber"      
#>  [55] "PanasonicExifVersion"       "ColorEffect"                "TimeSincePowerOn"          
#>  [58] "BurstMode"                  "SequenceNumber"             "ContrastMode"              
#>  [61] "NoiseReduction"             "SelfTimer"                  "Rotation"                  
#>  [64] "AFAssistLamp"               "ColorMode"                  "OpticalZoomMode"           
#>  [67] "ConversionLens"             "TravelDay"                  "WorldTimeLocation"         
#>  [70] "ProgramISO"                 "AdvancedSceneType"          "FacesDetected"             
#>  [73] "AFPointPosition"            "NumFacePositions"           "Face1Position"             
#>  [76] "Face2Position"              "Face3Position"              "Face4Position"             
#>  [79] "Face5Position"              "IntelligentExposure"        "FacesRecognized"           
#>  [82] "RecognizedFace1Name"        "RecognizedFace1Position"    "RecognizedFace1Age"        
#>  [85] "RecognizedFace2Name"        "RecognizedFace2Position"    "RecognizedFace2Age"        
#>  [88] "RecognizedFace3Name"        "RecognizedFace3Position"    "RecognizedFace3Age"        
#>  [91] "FlashWarning"               "Title"                      "BabyName"                  
#>  [94] "Location"                   "IntelligentResolution"      "BurstSpeed"                
#>  [97] "ClearRetouch"               "SweepPanoramaDirection"     "SweepPanoramaFieldOfView"  
#> [100] "InternalNDFilter"           "ClearRetouchValue"          "MakerNoteVersion"          
#> [103] "SceneMode"                  "WBRedLevel"                 "WBGreenLevel"              
#> [106] "WBBlueLevel"                "FlashFired"                 "TextStamp"                 
#> [109] "BabyAge"                    "Transform"                  "FlashpixVersion"           
#> [112] "ColorSpace"                 "ExifImageWidth"             "ExifImageHeight"           
#> [115] "InteropIndex"               "InteropVersion"             "SensingMethod"             
#> [118] "FileSource"                 "SceneType"                  "CustomRendered"            
#> [121] "ExposureMode"               "DigitalZoomRatio"           "FocalLengthIn35mmFormat"   
#> [124] "SceneCaptureType"           "GainControl"                "Contrast"                  
#> [127] "Saturation"                 "Sharpness"                  "OffsetSchema"              
#> [130] "GPSVersionID"               "GPSLatitudeRef"             "GPSLongitudeRef"           
#> [133] "GPSAltitudeRef"             "GPSTimeStamp"               "GPSSpeedRef"               
#> [136] "GPSSpeed"                   "GPSDateStamp"               "PrintIMVersion"            
#> [139] "Compression"                "ThumbnailOffset"            "ThumbnailLength"           
#> [142] "MPFVersion"                 "NumberOfImages"             "MPImageFlags"              
#> [145] "MPImageFormat"              "MPImageType"                "MPImageLength"             
#> [148] "MPImageStart"               "DependentImage1EntryNumber" "DependentImage2EntryNumber"
#> [151] "ImageWidth"                 "ImageHeight"                "EncodingProcess"           
#> [154] "BitsPerSample"              "ColorComponents"            "YCbCrSubSampling"          
#> [157] "AdvancedSceneMode"          "Aperture"                   "BlueBalance"               
#> [160] "GPSAltitude"                "GPSDateTime"                "GPSLatitude"               
#> [163] "GPSLongitude"               "GPSPosition"                "ImageSize"                 
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
