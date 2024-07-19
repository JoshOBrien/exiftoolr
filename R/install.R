
##' Install the current version of ExifTool
##'
##'
##' @title Install ExifTool, downloading (by default) the current version
##' @param install_location Path to the directory into which ExifTool should be
##'     installed. If \code{NULL} (the default), installation will be into the
##'     directory returned by \code{backports::R_user_dir("exiftoolr")}.
##' @param win_exe Logical, only used on Windows machines. Should we install the
##'     standalone ExifTool Windows executable or the ExifTool Perl library?
##'     (The latter relies, for its execution, on an existing installation of
##'     Perl being present on the user's machine.)  If set to \code{NULL} (the
##'     default), the function installs the Windows executable on Windows
##'     machines and the Perl library on other operating systems.
##' @param local_exiftool If installing ExifTool from a local "*.zip" or
##'     ".tar.gz", supply the path to that file as a character string. With
##'     default value, `NULL`, the function downloads ExifTool from
##'     \url{https://exiftool.org} and then installs it.
##' @param quiet Logical.  Should function should be chatty?
##' @return Called for its side effect
##' @export
##' @importFrom curl curl_download has_internet
##' @importFrom utils untar
##' @importFrom zip unzip
install_exiftool <- function(install_location = NULL,
                             win_exe = NULL,
                             local_exiftool = NULL,
                             quiet = FALSE) {
    tmpdir <- tempdir()
    if (is.null(win_exe)) {
        win_exe <- is_windows()
    }

    ##------------------------------------------------##
    ## If needed, download ExifTool *.zip or *.tar.gz ##
    ##------------------------------------------------##
    if (is.null(local_exiftool)) {
        tmpfile <- file.path(tmpdir, "xx")
        on.exit(unlink(tmpfile))
        download_exiftool(win_exe = win_exe,
                          download_path = tmpfile,
                          quiet = quiet)
    } else {
        tmpfile <- local_exiftool
        win_exe <- (tools::file_ext(tmpfile) == "zip")
    }

    ##---------------------------##
    ## Install *.zip or *.tar.gz ##
    ##---------------------------##
    if (is.null(install_location)) {
        ## Default install location
        install_location <- R_user_dir("exiftoolr", which = "data")
        if (!dir.exists(install_location)) {
            dir.create(install_location, recursive = TRUE)
        }
    }

    ## Find writable locations
    write_dir <- find_writable(install_location)
    if (win_exe) {
        write_dir <- file.path(write_dir, "win_exe")
    }
    if (!quiet) {
        message("Installing ExifTool in ", write_dir)
    }

    ## Install
    if (win_exe) {
        ## Windows executable
        if(!dir.exists(write_dir)) {
            dir.create(write_dir)
        }
        ## This calls zip::unzip, not utils::unzip
        unzip(tmpfile, exdir = tmpdir)
        exif_dir <- dir(tmpdir, pattern = "exiftool-", full.names = TRUE)
        file.copy(dir(exif_dir, full.names = TRUE), write_dir, recursive = TRUE)

    } else {
        ## Perl library
        untar(tmpfile, exdir = tmpdir)
        dd <- dir(tmpdir, pattern = "Image-ExifTool-", full.names = TRUE)
        if(!dir.exists(file.path(write_dir, "lib"))) {
            dir.create(file.path(write_dir, "lib"))
        }
        ## Install the `lib` directory, main Perl script, and `README`
        file.copy(from = file.path(dd, c("lib", "exiftool", "README")),
                  to = write_dir,
                  recursive = TRUE,
                  overwrite = TRUE)
    }
}



## ##' Download the current version of ExifTool
## ##'
## ##' @inheritParams install_exiftool
## ##' @param download_path Path indicating the location to which
## ##'     ExifTool should be downloaded.
## ##' @return A character string giving the path to the downloaded
## ##'     ExifTool.
## ##' @author Joshua O'Brien
download_exiftool <- function(win_exe = FALSE,
                              download_path = NULL,
                              quiet = FALSE) {
    base_url <- "https://exiftool.org"
    ## Got internet?
    if(!has_internet()) {
        stop("No internet connection detected, so cannot download ",
             "ExifTool from:\n  ", base_url)
    }
    ## Construct URL of file to be downloaded, uncompressed, &
    ## installed
    ver <- current_exiftool_version()
    exiftool_url <-
        if(win_exe & is_windows()) {
            platform <- ifelse(.Machine$sizeof.pointer == 8, "_64", "_32")
            file.path(base_url, paste0("exiftool-", ver, platform, ".zip"))
        } else {
            file.path(base_url, paste0("Image-ExifTool-", ver, ".tar.gz"))
        }
    if (is.null(download_path)) {
        download_path <- file.path(tempdir(), basename(exiftool_url))
    }
    ## Attempt to download the file
    if (!quiet) {
        message("Attempting to download ExifTool from ", exiftool_url)
    }
    curl_download(url = exiftool_url, destfile = download_path, quiet = quiet)
    return(download_path)
}
