

## Overview

Phil Harvey's [ExifTool][exiftool-home] is the most comprensive tool
available for reading, writing and editing the metadata contained in a
wide variety of files. 

**exiftoolr** is an R package that provides a thin wrapper around
ExifTool and allows one to read image file metadata from one or more
files into a `data.frame` with a simple command:


{% highlight r %}
library(exiftoolr)
exif_read(path = c("my_file_1.jpg", "my_file_2.jpg"))
{% endhighlight %}

## Basic installation

To download and install **exiftoolr**, run the following:


{% highlight r %}
if(!require(devtools)) {install.packages("devtools")}
devtools::install_github("JoshOBrien/exiftoolr")
{% endhighlight %}

Before using the package, you will need a working copy of ExifTool
installed on your computer. **exiftoolr** does not ship with a copy of
ExifTool. Instead, it provides a convenience function that allows you
to effortlessly download and install the latest version of ExifTool
into your local **exiftoolr** package directory:


{% highlight r %}
library(exiftoolr)
install_exiftool()
{% endhighlight %}

To check that ExifTool has been properly installed, run:


{% highlight r %}
exif_version()
{% endhighlight %}
	   

## More installation details

[ExifTool][exiftool-home] is written and primarily distributed as Perl
library that relies on a working local installation of Perl. Perl is
present on most *NIX and Mac machines, but is not by default installed
on Windows machines. Fortunately, for Windows users, Phil Harvey
distributes a stand-alone ExifTool executable that does not require
Perl. (Windows users who do have Perl installed (from, for example,
[Strawberry Perl][Strawberry]) may of course alternatively use the
Perl library).

Depending on one's operating system, running `install_exiftool()` will
install either the ExifTool Perl library (on *NIX and Mac machines) or
a stand-alone executable that works without a local Perl installation
(on Windows machines). For more details, see the `install_exiftool`
help page.



[exiftool-home]: http://www.sno.phy.queensu.ca/%7Ephil/exiftool/
[Strawberry]: http://www.strawberryperl.com/
