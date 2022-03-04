## library(tinytest)
library(exiftoolr)


## Is csv pipeline correctly reading in non-ascii characters?
## (See https://github.com/JoshOBrien/exiftoolr/issues/3 .)
arglist <- c("-charset", "exiftool=cp1250", "-charset", "filename=cp1252")
res <- exif_read("test_images/QS_Höngg.jpg", args = arglist, pipeline = "csv")
expect_equal(res[["City"]], "Zürich")

