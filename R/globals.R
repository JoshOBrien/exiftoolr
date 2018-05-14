.globals <- new.env(parent = emptyenv())
.globals$exiftoolr_configured <- FALSE
.globals$exiftool_command <- NULL
.globals$perl_path <- NULL


is_exiftoolr_configured <- function() {
    .globals$exiftoolr_configured
}


set_exiftool_command <- function(com) {
    .globals$exiftool_command <- com
    .globals$exiftoolr_configured <- TRUE
}

get_exiftool_command <- function() {
    .globals$exiftool_command
}


set_perl_path <- function(path) {
    .globals$perl_path <- path
}

get_perl_path <- function() {
    .globals$perl_path
}
