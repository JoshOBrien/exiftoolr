
##' Configure package to point to ExifTool and/or Perl
##'
##' @param command Character string giving the exiftool command.
##' @param perl_path Path to a Perl executable.
##' @param allow_win_exe Logical. If running on a Windows machine, and if a
##'     standalone exiftool executable is available, should it be used?
##' @param quiet Logical. Should function should be chatty?
##' @return A character string giving the exiftool command, returned invisibly.
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
                file.path(R_user_dir("exiftoolr", which = "data"),
                          "win_exe", "exiftool(-k).exe")
            if (nchar(internal_win_exe))
                command <- c(command, internal_win_exe)
        }
        ## (c) Maybe "exiftool" is on search path?
        command <- c(command, "exiftool")
        ## (d) Check for locally installed ExifTool Perl scripts
        if (!is.null(perl_path)) {
            internal_exiftool <-
                file.path(R_user_dir("exiftoolr", which = "data"),
                          "exiftool")
            if (nchar(internal_exiftool)) {
                command <-
                    c(command,
                      shQuote(internal_exiftool),
                      paste(shQuote(perl_path), shQuote(internal_exiftool)))
        }
        }
    } else {
        ## For commands supplied as argument to configure_exiftoolr(), if Perl
        ## is present, try the command with and without prepended invocation of
        ## Perl
        if (!is.null(perl_path)) {
            command <- c(command,
                         paste(shQuote(perl_path), shQuote(command)))
        }
    }

    for(com in command) {
        ## automatically fail perl_path ''
        if (!is.null(perl_path) &&
            com == paste(shQuote(perl_path), shQuote(NULL))) {
            next
        }
        ## If the command string includes single-quoted substrings split them
        ## out into a character vector. (This is most likely due to
        ## shQuote()'ing of perl_path and command above, but could also be from
        ## the value supplied to command= or to ET_EXIFTOOL_PATH (and retrieved
        ## using env_exiftool_path())),
        ##
        ## So, for example, convert this:
        ##
        ##     "'/path/to/perl' '/path/to/exiftool'"
        ##
        ## to this:
        ##
        ##     c("/path/to/perl", "/path/to/exiftool"))
        ##
        ## This addresses the issue described at:
        ## https://github.com/JoshOBrien/exiftoolr/issues/4
        if(grepl("'", com)) {
            ## Use of scan() here based on:
            ## https://stackoverflow.com/a/13628436/980833
            com <- scan(text = com, what = "character", quiet = TRUE)
        }
        if (test_exiftool(com, quiet = quiet)) {
            if(!quiet) message("ExifTool found at: ",
                               paste(shQuote(com), collapse = " "))
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
        if (test_perl(p, quiet = quiet)) {
            if(!quiet) message("Perl found at: ",
                               paste(shQuote(p), collapse = " "))
            set_perl_path(p)
            return(invisible(p))
        }
    }

    ## warning("Could not find Perl at any of the following locations: ",
    ##         paste(perl_path, collapse = ", "),
    ##         '. Specify perl location using set_perl_path("my/path/to/perl")')
    return(NULL)
}



test_perl <- function(command, quiet = TRUE) {
    if(!quiet) message("Trying perl command: ",
                       paste(shQuote(command), collapse = " "),
                       " --version")
    suppressWarnings(
        suppressMessages(0 == try(system2(command,
                                          args = "--version",
                                          stdout = FALSE,
                                          stderr = FALSE),
                                  silent = TRUE)))
}



test_exiftool <- function(command, quiet = TRUE) {
    if(!quiet) message("Trying exiftool command: ",
                       paste(shQuote(command), collapse = " "),
                       " -ver")
    args <- "-ver"
    if (length(command) > 1) {
        args <- c(command[-1], args)
        command <- command[1]
    }
    command_works <-
        suppressWarnings(
            suppressMessages(0 == try(system2(command,
                                              args = args,
                                              stdout = FALSE,
                                              stderr = FALSE),
                                      silent = TRUE)))
    if (command_works) {
        ## check that version is a numeric value like 10.96
        ver_string <- paste(system2(command, args = args, stdout = TRUE, stderr = FALSE),
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









