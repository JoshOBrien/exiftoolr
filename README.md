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
dim(exifinfo)
#> [1]   2 267
names(exifinfo) ## List of metadata fields read by ExifTool
#>   [1] "SourceFile"                 "ExifToolVersion"           
#>   [3] "FileName"                   "Directory"                 
#>   [5] "FileSize"                   "FileModifyDate"            
#>   [7] "FileAccessDate"             "FileCreateDate"            
#>   [9] "FilePermissions"            "FileType"                  
#>  [11] "FileTypeExtension"          "MIMEType"                  
#>  [13] "JFIFVersion"                "ExifByteOrder"             
#>  [15] "Make"                       "Model"                     
#>  [17] "Orientation"                "XResolution"               
#>  [19] "YResolution"                "ResolutionUnit"            
#>  [21] "Software"                   "ModifyDate"                
#>  [23] "Artist"                     "YCbCrPositioning"          
#>  [25] "ExposureTime"               "FNumber"                   
#>  [27] "ExposureProgram"            "ISO"                       
#>  [29] "SensitivityType"            "ExifVersion"               
#>  [31] "DateTimeOriginal"           "CreateDate"                
#>  [33] "ComponentsConfiguration"    "CompressedBitsPerPixel"    
#>  [35] "ExposureCompensation"       "MaxApertureValue"          
#>  [37] "MeteringMode"               "LightSource"               
#>  [39] "Flash"                      "FocalLength"               
#>  [41] "Warning"                    "ImageQuality"              
#>  [43] "FirmwareVersion"            "WhiteBalance"              
#>  [45] "FocusMode"                  "AFAreaMode"                
#>  [47] "ImageStabilization"         "MacroMode"                 
#>  [49] "ShootingMode"               "Audio"                     
#>  [51] "DataDump"                   "WhiteBalanceBias"          
#>  [53] "FlashBias"                  "InternalSerialNumber"      
#>  [55] "PanasonicExifVersion"       "ColorEffect"               
#>  [57] "TimeSincePowerOn"           "BurstMode"                 
#>  [59] "SequenceNumber"             "ContrastMode"              
#>  [61] "NoiseReduction"             "SelfTimer"                 
#>  [63] "Rotation"                   "AFAssistLamp"              
#>  [65] "ColorMode"                  "OpticalZoomMode"           
#>  [67] "ConversionLens"             "TravelDay"                 
#>  [69] "WorldTimeLocation"          "ProgramISO"                
#>  [71] "AdvancedSceneType"          "FacesDetected"             
#>  [73] "AFPointPosition"            "NumFacePositions"          
#>  [75] "Face1Position"              "Face2Position"             
#>  [77] "Face3Position"              "Face4Position"             
#>  [79] "Face5Position"              "IntelligentExposure"       
#>  [81] "FacesRecognized"            "RecognizedFace1Name"       
#>  [83] "RecognizedFace1Position"    "RecognizedFace1Age"        
#>  [85] "RecognizedFace2Name"        "RecognizedFace2Position"   
#>  [87] "RecognizedFace2Age"         "RecognizedFace3Name"       
#>  [89] "RecognizedFace3Position"    "RecognizedFace3Age"        
#>  [91] "FlashWarning"               "Title"                     
#>  [93] "BabyName"                   "Location"                  
#>  [95] "IntelligentResolution"      "BurstSpeed"                
#>  [97] "ClearRetouch"               "SweepPanoramaDirection"    
#>  [99] "SweepPanoramaFieldOfView"   "InternalNDFilter"          
#> [101] "ClearRetouchValue"          "MakerNoteVersion"          
#> [103] "SceneMode"                  "WBRedLevel"                
#> [105] "WBGreenLevel"               "WBBlueLevel"               
#> [107] "FlashFired"                 "TextStamp"                 
#> [109] "BabyAge"                    "Transform"                 
#> [111] "FlashpixVersion"            "ColorSpace"                
#> [113] "ExifImageWidth"             "ExifImageHeight"           
#> [115] "InteropIndex"               "InteropVersion"            
#> [117] "SensingMethod"              "FileSource"                
#> [119] "SceneType"                  "CustomRendered"            
#> [121] "ExposureMode"               "DigitalZoomRatio"          
#> [123] "FocalLengthIn35mmFormat"    "SceneCaptureType"          
#> [125] "GainControl"                "Contrast"                  
#> [127] "Saturation"                 "Sharpness"                 
#> [129] "OffsetSchema"               "GPSVersionID"              
#> [131] "GPSLatitudeRef"             "GPSLongitudeRef"           
#> [133] "GPSAltitudeRef"             "GPSTimeStamp"              
#> [135] "GPSSpeedRef"                "GPSSpeed"                  
#> [137] "GPSDateStamp"               "PrintIMVersion"            
#> [139] "Compression"                "ThumbnailOffset"           
#> [141] "ThumbnailLength"            "MPFVersion"                
#> [143] "NumberOfImages"             "MPImageFlags"              
#> [145] "MPImageFormat"              "MPImageType"               
#> [147] "MPImageLength"              "MPImageStart"              
#> [149] "DependentImage1EntryNumber" "DependentImage2EntryNumber"
#> [151] "ImageWidth"                 "ImageHeight"               
#> [153] "EncodingProcess"            "BitsPerSample"             
#> [155] "ColorComponents"            "YCbCrSubSampling"          
#> [157] "AdvancedSceneMode"          "Aperture"                  
#> [159] "BlueBalance"                "GPSAltitude"               
#> [161] "GPSDateTime"                "GPSLatitude"               
#> [163] "GPSLongitude"               "GPSPosition"               
#> [165] "ImageSize"                  "Megapixels"                
#> [167] "RedBalance"                 "ScaleFactor35efl"          
#> [169] "ShutterSpeed"               "ThumbnailImage"            
#> [171] "CircleOfConfusion"          "FOV"                       
#> [173] "FocalLength35efl"           "HyperfocalDistance"        
#> [175] "LightValue"                 "ShutterSpeedValue"         
#> [177] "ApertureValue"              "Quality"                   
#> [179] "CanonFlashMode"             "ContinuousDrive"           
#> [181] "RecordMode"                 "CanonImageSize"            
#> [183] "EasyMode"                   "DigitalZoom"               
#> [185] "CameraISO"                  "FocusRange"                
#> [187] "CanonExposureMode"          "LensType"                  
#> [189] "MaxFocalLength"             "MinFocalLength"            
#> [191] "FocalUnits"                 "MaxAperture"               
#> [193] "MinAperture"                "FlashActivity"             
#> [195] "FlashBits"                  "ZoomSourceWidth"           
#> [197] "ZoomTargetWidth"            "ManualFlashOutput"         
#> [199] "ColorTone"                  "FocalPlaneXSize"           
#> [201] "FocalPlaneYSize"            "AutoISO"                   
#> [203] "BaseISO"                    "MeasuredEV"                
#> [205] "TargetAperture"             "SlowShutter"               
#> [207] "OpticalZoomCode"            "FlashGuideNumber"          
#> [209] "FlashExposureComp"          "AutoExposureBracketing"    
#> [211] "AEBBracketValue"            "ControlMode"               
#> [213] "FocusDistanceUpper"         "FocusDistanceLower"        
#> [215] "MeasuredEV2"                "BulbDuration"              
#> [217] "CameraType"                 "AutoRotate"                
#> [219] "NDFilter"                   "SelfTimer2"                
#> [221] "BracketMode"                "BracketValue"              
#> [223] "BracketShotNumber"          "CanonImageType"            
#> [225] "CanonFirmwareVersion"       "SerialNumber"              
#> [227] "SerialNumberFormat"         "FileNumber"                
#> [229] "OwnerName"                  "CanonModelID"              
#> [231] "CanonFileLength"            "MeasuredRGGB"              
#> [233] "WB_RGGBLevelsAuto"          "WB_RGGBLevelsDaylight"     
#> [235] "WB_RGGBLevelsShade"         "WB_RGGBLevelsCloudy"       
#> [237] "WB_RGGBLevelsTungsten"      "WB_RGGBLevelsFluorescent"  
#> [239] "WB_RGGBLevelsFlash"         "WB_RGGBLevelsCustom"       
#> [241] "WB_RGGBLevelsKelvin"        "WB_RGGBBlackLevels"        
#> [243] "ColorTemperature"           "NumAFPoints"               
#> [245] "ValidAFPoints"              "CanonImageWidth"           
#> [247] "CanonImageHeight"           "AFImageWidth"              
#> [249] "AFImageHeight"              "AFAreaWidth"               
#> [251] "AFAreaHeight"               "AFAreaXPositions"          
#> [253] "AFAreaYPositions"           "AFPointsInFocus"           
#> [255] "ThumbnailImageValidArea"    "UserComment"               
#> [257] "RelatedImageWidth"          "RelatedImageHeight"        
#> [259] "FocalPlaneXResolution"      "FocalPlaneYResolution"     
#> [261] "FocalPlaneResolutionUnit"   "DriveMode"                 
#> [263] "Lens"                       "LensID"                    
#> [265] "WB_RGGBLevels"              "DOF"                       
#> [267] "Lens35efl"
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
