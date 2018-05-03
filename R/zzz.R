.globals <- new.env(parent = emptyenv())
.globals$exifr_configured <- FALSE
.globals$exiftool_command <- NULL
.globals$perl_path <- NULL


is_exifr_configured <- function() {
    .globals$exifr_configured
}

## Replacing `options(exifr.exiftoolcommand = com)`
set_exiftool_command <- function(com) {
    .globals$exiftool_command <- com
    .globals$exifr_configured <- TRUE
}

## Replacing `getOption("exifr.exiftoolcommand")`
get_exiftool_command <- function() {
    .globals$exiftool_command
}


## Replacing `options(exifr.perlpath = p)`
set_perl_path <- function(path) {
    .globals$perl_path <- path
}

## Replacing `getOption("exifr.perlpath")`
get_perl_path <- function() {
    .globals$perl_path
}


is_windows <- function() {
    .Platform$OS.type == "windows"
}
