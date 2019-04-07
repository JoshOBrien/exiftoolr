
##' Download and install the current version of ExifTool
##'
##' @param install_location Path to the directory into which ExifTool
##'     should be installed. If \code{NULL} (the default),
##'     installation will be into the (initially empty)
##'     \code{exiftool} folder in the \pkg{exiftoolr} package's
##'     directory tree.
##' @param win_exe Logical, only used on Windows machines. Should we
##'     install the standalone ExifTool Windows executable or the
##'     ExifTool Perl library?  (The latter relies, for its execution,
##'     on an existing installation of Perl being present on the
##'     user's machine.)  If set to \code{NULL} (the default), the
##'     function installs the Windows executable on Windows machines
##'     and the Perl library on other operating systems.
##' @param local_exiftool If installing ExifTool from a local "*.zip"
##'     or ".tar.gz", supply the path to that file as a character
##'     string. With default value, `NULL`, the function downloads
##'     ExifTool from \url{https://sno.phy.queensu.ca/~phil/exiftool}
##'     and then installs it.
##' @param quiet Logical.  Should function should be chatty?
##' @export
##' @importFrom curl curl_download has_internet
##' @importFrom utils untar unzip
install_exiftool <- function(install_location = NULL,
                             win_exe = NULL,
                             local_exiftool = NULL,
                             quiet = FALSE) {
    ##------------------------------------------------##
    ## If needed, download ExifTool *.zip or *.tar.gz ##
    ##------------------------------------------------##
    if(is.null(local_exiftool)) {
        base_url <- "https://sno.phy.queensu.ca/~phil/exiftool"

        ## Installing Windows executable?
        if(is.null(win_exe)) {
            win_exe <- is_windows()
        }

        if(!has_internet()) {
            stop("No internet connection detected, so cannot download ",
                 "ExifTool from:\n  ", base_url)
        }

        ## Construct URL of file to be downloaded, uncompressed, &
        ## installed
        ver <- current_exiftool_version()
        install_url <-
            if(win_exe & is_windows()) {
                file.path(base_url, paste0("exiftool-", ver, ".zip"))
            } else {
                file.path(base_url, paste0("Image-ExifTool-", ver, ".tar.gz"))
            }

        ## Attempt to download the file
        if(!quiet) {
            message("Attempting to download ExifTool from ", install_url)
        }
        tmpdir <- tempdir()
        tmpfile <- file.path(tmpdir, "xx")
        on.exit(unlink(tmpfile))
        curl_download(install_url, tmpfile, quiet = quiet)
    } else {
        tmpfile <- local_exiftool
        win_exe <- (tools::file_ext(tmpfile) == "zip")
    }

    ##---------------------------##
    ## Install *.zip or *.tar.gz ##
    ##---------------------------##
    if(is.null(install_location)) {
        ## Default install location
        install_location <- system.file("exiftool", package = "exiftoolr")
    }

    ## Find writable locations
    write_dir <- find_writable(install_location)
    if(!quiet) {
        message("Installing ExifTool in ", write_dir)
    }

    if(win_exe) {
        ## Windows executable
        win_exe_dir <- file.path(write_dir, "win_exe")
        if(!dir.exists(win_exe_dir)) {
            dir.create(win_exe_dir)
        }
        unzip(tmpfile, exdir = win_exe_dir)
    } else {
        ## Perl library
        untar(tmpfile, exdir = tmpdir)
        dd <- file.path(tmpdir, paste0("Image-ExifTool-", ver))
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


##' Configure package to point to ExifTool and/or Perl
##'
##' @param command Character string giving the exiftool command.
##' @param perl_path Path to a Perl executable.
##' @param allow_win_exe Logical. If running on a Windows machine, and
##'     if a standalone exiftool executable is available, should it be
##'     used?
##' @param quiet Logical. Should function should be chatty?
##' @return A character string giving the exiftool command, returned
##'     invisibly.
##' @export
##'
configure_exiftoolr <- function(command = NULL,
                                perl_path = NULL,
                                allow_win_exe = TRUE,
                                quiet = FALSE) {
    ## Configure Perl (returning NULL if none found)
    if(is.null(perl_path)) {
        perl_path <- configure_perl(quiet = quiet)
    }

    if(is.null(command)) {
        ## Construct default list of possible commands/locations
        ##
        ## ## (a) In case command has already been set by previous call
        ## ## to configure_exiftoolr()
        ## command <- get_exiftool_command()
        ##
        ## (a) Try path stored in environment variable
        command <- env_exiftool_path()
        ## (b) On Windows, check for a locally installed standalone
        ## executable
        if(allow_win_exe & is_windows()) {
            internal_win_exe <-
                system.file("exiftool/win_exe/exiftool(-k).exe",
                            package = "exiftoolr")
            if(nchar(internal_win_exe))
                command <- c(command, internal_win_exe)
        }
        ## (c) Maybe "exiftool" is on search path?
        command <- c(command, "exiftool")
        ## (d) Check for locally installed ExifTool Perl scripts
        if(!is.null(perl_path)) {
            internal_exiftool <-
                system.file("exiftool/exiftool", package = "exiftoolr")
            if(nchar(internal_exiftool)) {
                command <-
                    c(command,
                      paste(shQuote(perl_path), shQuote(internal_exiftool)))
        }
        }
    } else {
        ## For commands supplied as argument to configure_exiftoolr(), if
        ## Perl is present, try the command with and without prepended
        ## invocation of Perl
        if(!is.null(perl_path)) {
            command <- c(command,
                         paste(shQuote(perl_path), shQuote(command)))
        }
    }

    for(com in command) {
        ## automatically fail perl_path ''
        if(com == paste(shQuote(perl_path), shQuote(NULL))) {
            next
        }
        if(test_exiftool(paste(com, "-ver"), quiet = quiet)) {
            if(!quiet) message("ExifTool found at ", com)
            set_exiftool_command(com)
            return(invisible(com))
        }
    }

    stop("No functioning version of Exiftool has been found. To\n",
         "download and install a local version into the exiftoolr\n",
         "package, try doing install_exiftool().")
}


configure_perl <- function(perl_path = NULL, quiet = FALSE) {
    if(is.null(perl_path)) {
        ## use default list of possible locations
        perl_path <- c(get_perl_path(),
                       env_perl_path(),
                       "perl",
                       "C:\\Perl64\\bin\\perl",
                       "C:\\Perl\\bin\\perl",
                       "C:\\Strawberry\\perl\\bin\\perl")
    }

    for(p in perl_path) {
        if(test_perl(paste(shQuote(p), "--version"), quiet = quiet)) {
            if(!quiet) message("perl found at ", p)
            set_perl_path(p)
            return(invisible(p))
        }
    }

    ## warning("Could not find perl at any of the following locations: ",
    ##         paste(perl_path, collapse = ", "),
    ##         '. Specify perl location using set_perl_path("my/path/to/perl")')
    return(NULL)
}


test_perl <- function(command, quiet = TRUE) {
    if(!quiet) message("Trying perl command: ", command)
    suppressWarnings(
        suppressMessages(0 == try(system(command,
                                         ignore.stdout = TRUE,
                                         ignore.stderr = TRUE,
                                         show.output.on.console = TRUE),
                                  silent=TRUE)))
}

test_exiftool <- function(command, quiet = TRUE) {
    if(!quiet) message("Trying exiftool command: ", command)
    command_works <-
        suppressWarnings(
            suppressMessages(0 == try(system(command,
                                             ignore.stdout = TRUE,
                                             ignore.stderr = TRUE,
                                             show.output.on.console = TRUE),
                                      silent=TRUE)))
    if(command_works) {
        ## check that version is a numeric value like 10.96
        ver_string <- paste(system(command, intern = TRUE), collapse = "\n")
        ver_number <- suppressWarnings(as.numeric(ver_string))
        return(!is.na(ver_number))
    } else {
        return(FALSE)
    }
}


env_perl_path <- function() {
    path <- Sys.getenv("ET_PERL_PATH")
    if(is.na(path)) character(0) else path
}

env_exiftool_path <- function() {
    path <- Sys.getenv("ET_EXIFTOOL_PATH")
    if(is.na(path)) character(0) else path
}


is_windows <- function() {
    .Platform$OS.type == "windows"
}

find_writable <- function(install_location) {
    for(il in install_location) {
        testfile <- file.path(il, ".dummyfile")
        file.create(testfile, showWarnings = FALSE)
        if(file.exists(testfile)) {
            unlink(testfile)
            return(il)
        }
    }
    stop("Could not find a writable directory in which to install ExifTool.",
         " Tried ", paste(install_location, collapse = ", "))
}



current_exiftool_version <- function() {
    ## Holds current version of ExifTool, as announced by P. Harvey at:
    ## http://u88.n24.queensu.ca/exiftool/forum/index.php?topic=3754.0
    url <- "http://owl.phy.queensu.ca/~phil/exiftool/ver.txt"
    readLines(url, warn=FALSE)
}


##' @export
print.exiftoolr <- function(x, ...) {
    trunc64 <- function(X) {
        paste0(substr(X, 1, 60), "[..", nchar(X) - 60, " more..]")
    }
    ## Find columns of "base64:" strings more than 60 characters long
    ii <- which(grepl("base64:.{53,}", x[1,]))
    ## Replace those with truncated strings
    if(length(ii)) {
        for(i in ii) {
            x[, i] <- trunc64(x[, i])
        }
    }
    NextMethod(x, ...)
}









