
##' Configure perl, ExifTool
##'
##' @param command The exiftool command or location of exiftool.pl
##' @param perl_path The path to the perl executable
##' @param install_url The url from which exiftool could be installed
##' @param install_location The location to install exiftool
##' @param quiet Use quiet = FALSE to display status updates
##'
##' @return The exiftool command, invisibly
##' @export
##'
configure_exifr <- function(command = NULL,
                            perl_path = NULL,
                            install_url = NULL,
                            install_location = NULL,
                            quiet = FALSE) {
    ## Configure Perl (returning NULL if none found)
    if(is.null(perl_path)) {
        perl_path <- configure_perl(quiet = quiet)
    }

    if(is.null(command)) {
        ## Construct default list of possible commands/locations
        ##
        ## (a) In case command has already been set by previous call
        ## to configure_exifr()
        command <- get_exiftool_command()
        ## (b) On Windows, check for a locally installed standalone
        ## executable
        if(is_windows()) {
            internal_win_exe <-
                system.file("__WINDOWS/exiftool.exe", package = "exifr")
            if(nchar(internal_win_exe))
                command <- c(command, internal_win_exe)
        }
        ## (c) Maybe "exiftool" is on search path?
        command <- c(command, "exiftool")
        ## (d) Check for locally installed ExifTool Perls cripts
        if(!is.null(perl_path)) {
            internal_exiftool <-
                system.file("exiftool/exiftool.pl", package = "exifr")
            if(nchar(internal_exiftool)) {
                command <-
                    c(command,
                      paste(shQuote(perl_path), shQuote(internal_exiftool)))
        }
        }
    } else {
        ## For commands supplied as argument to configure_exifr(), if
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

    message("No functioning version of Exiftool has been found. To download\n",
            "and install a local version into the exifr package, try doing\n",
            "install_exiftool().")
}


##' @export
##' @importFrom curl curl_download
install_exiftool <- function(command = NULL,
                             perl_path = NULL,
                             install_url = NULL,
                             install_location = NULL,
                             quiet = FALSE) {
    if(is.null(install_url)) {
        install_url <- "http://paleolimbot.github.io/exifr/exiftool.zip"
    }

    message("Attempting to install ExifTool from ",
            install_url)

    if(is.null(install_location)) {
        ## define default install locations
        install_location <- system.file(package = "exifr")
    }

    ## find writable locations
    write_dir <- find_writable(install_location)

    ## attempt to download the file
    download_file <- tempfile()
    on.exit(unlink(download_file))
    curl_download(install_url, download_file, quiet = quiet)

    ## extract downloaded file
    if(!quiet) message("Extracting exiftool to ", write_dir)
    unzip(download_file, exdir = write_dir)
}



find_perl_paths <- function(perl_path = NULL) {
    paths <- character(0)
    if(!is.na(Sys.getenv("EXIFR_PERL_PATH", unset = NA))) {
        paths <- c(paths, Sys.getenv("EXIFR_PERL_PATH"))
    }
}


##' @rdname configure_exifr
##' @export
configure_perl <- function(perl_path = NULL, quiet = FALSE) {
    if(is.null(perl_path)) {
        ## use default list of possible locations
        perl_path <- c(get_perl_path(),
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
                                         show.output.on.console = FALSE),
                                  silent=TRUE)))
}

test_exiftool <- function(command, quiet = TRUE) {
    if(!quiet) message("Trying exiftool command: ", command)
    command_works <-
        suppressWarnings(
            suppressMessages(0 == try(system(command,
                                             ignore.stdout = TRUE,
                                             ignore.stderr = TRUE,
                                             show.output.on.console = FALSE),
                                      silent=TRUE)))
    if(command_works) {
        ## check that version is a numeric value like 10.111
        ver_string <- paste(system(command, intern = TRUE), collapse = "\n")
        ver_number <- suppressWarnings(as.numeric(ver_string))
        return(!is.na(ver_number))
    } else {
        return(FALSE)
    }
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

    stop("Could not find a writable directory in which to install ExifTool. Tried ",
         paste(install_location, collapse = ", "))
}




