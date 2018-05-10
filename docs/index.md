

# EXIF Data in R

Phil Harvey's [ExifTool][exiftool-home] is the most comprensive tool
available for reading, writing and editing metadata in a wide variety
of files. ExifTool supports many different metadata formats including
EXIF, GPS, IPTC, XMP, JFIF, GeoTIFF, ICC Profile, Photoshop IRB,
FlashPix, AFCP and ID3, as well as the maker notes of many digital
cameras by Canon, Casio, FLIR, FujiFilm, GE, HP, JVC/Victor, Kodak,
Leaf, Minolta/Konica-Minolta, Motorola, Nikon, Nintendo,
Olympus/Epson, Panasonic/Leica, Pentax/Asahi, Phase One, Reconyx,
Ricoh, Samsung, Sanyo, Sigma/Foveon and Sony.

**exiftoolr** provides a thin wrapper around ExifTool and allows one to
read image file metadata with a simple command:


{% highlight r %}
library(exiftoolr)
exif_read("my_file.jpg")
{% endhighlight %}

## Installation

[ExifTool][exiftool-home] is written and distributed as Perl library
that relies a working local installation of Perl. Perl is typically
present on most *NIX and Mac machines, but is not by default installed
on Windows.

To use ExifTool, Windows users may want to install Perl (e.g. from
[Strawberry Perl][Strawberry]). Alternatively, they can use the
stand-alone ExifTool executable kindly provided by Phil Harvey.

To install the **exiftoolr** package, use the
`devtools::install_github()` command like this:



{% highlight r %}
install.packages("devtools")
devtools::install_github("JoshOBrien/exiftoolr")
{% endhighlight %}


[exiftool-home]: http://www.sno.phy.queensu.ca/%7Ephil/exiftool/
[Strawberry]: http://www.strawberryperl.com/
