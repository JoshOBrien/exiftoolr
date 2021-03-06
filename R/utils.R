
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
    if (is.null(perl_path)) {
        perl_path <- configure_perl(quiet = quiet)
    }

    if (is.null(command)) {
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
        if (allow_win_exe & is_windows()) {
            internal_win_exe <-
                system.file("exiftool/win_exe/exiftool(-k).exe",
                            package = "exiftoolr")
            if (nchar(internal_win_exe))
                command <- c(command, internal_win_exe)
        }
        ## (c) Maybe "exiftool" is on search path?
        command <- c(command, "exiftool")
        ## (d) Check for locally installed ExifTool Perl scripts
        if (!is.null(perl_path)) {
            internal_exiftool <-
                system.file("exiftool/exiftool", package = "exiftoolr")
            if (nchar(internal_exiftool)) {
                command <-
                    c(command,
                      paste(shQuote(perl_path), shQuote(internal_exiftool)))
        }
        }
    } else {
        ## For commands supplied as argument to configure_exiftoolr(), if
        ## Perl is present, try the command with and without prepended
        ## invocation of Perl
        if (!is.null(perl_path)) {
            command <- c(command,
                         paste(shQuote(perl_path), shQuote(command)))
        }
    }

    for(com in command) {
        ## automatically fail perl_path ''
        if (com == paste(shQuote(perl_path), shQuote(NULL))) {
            next
        }
        if (test_exiftool(paste(com, "-ver"), quiet = quiet)) {
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
    if (is.null(perl_path)) {
        ## use default list of possible locations
        perl_path <- c(get_perl_path(),
                       env_perl_path(),
                       "perl",
                       "C:\\Perl64\\bin\\perl",
                       "C:\\Perl\\bin\\perl",
                       "C:\\Strawberry\\perl\\bin\\perl")
    }

    for(p in perl_path) {
        if (test_perl(paste(shQuote(p), "--version"), quiet = quiet)) {
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
    if (command_works) {
        ## check that version is a numeric value like 10.96
        ver_string <- paste(system(command, ignore.stderr=TRUE, intern=TRUE),
                            collapse = "\n")
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
        if (file.exists(testfile)) {
            unlink(testfile)
            return(il)
        }
    }
    stop("Could not find a writable directory in which to install ExifTool.",
         " Tried ", paste(install_location, collapse = ", "))
}



current_exiftool_version <- function() {
    ## Holds current version of ExifTool, as announced by P. Harvey at:
    ## https://exiftool.org/forum/index.php?topic=3754.0
    url <- "https://exiftool.org/ver.txt"
    readLines(url, warn=FALSE)
}



##' @export
print.exiftoolr <- function(x, ...) {
    trunc64 <- function(X) {
        paste0(substr(X, 1, 60), "[..", nchar(X) - 60, " more..]")
    }
    ## Find columns of "base64:" strings more than 60 characters long
    ii <- which(grepl("base64:.{53,}", x[1,], perl = TRUE))
    ## Replace those with truncated strings
    if (length(ii)) {
        for(i in ii) {
            x[, i] <- trunc64(x[, i])
        }
    }
    NextMethod(x, ...)
}









