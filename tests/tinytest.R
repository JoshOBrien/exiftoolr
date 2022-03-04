## Runs tests in "../inst/tinytest/" (currently just
## "../inst/tinytest/test_exiftoolr.R"

if ( requireNamespace("tinytest", quietly=TRUE) ){
  tinytest::test_package("exiftoolr")
}
