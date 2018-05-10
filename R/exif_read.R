
##' Read EXIF data from files
##'
##' Reads EXIF data into a \code{data.frame} by calling Phil Harvey's
##' ExifTool command-line application.
##'
##' From the
##' \href{http://www.sno.phy.queensu.ca/~phil/exiftool/}{ExifTool
##' website}: ExifTool is a platform-independent Perl library plus a
##' command-line application for reading, writing and editing meta
##' information in a wide variety of files. ExifTool supports many
##' different metadata formats including EXIF, GPS, IPTC, XMP, JFIF,
##' GeoTIFF, ICC Profile, Photoshop IRB, FlashPix, AFCP and ID3, as
##' well as the maker notes of many digital cameras by Canon, Casio,
##' FLIR, FujiFilm, GE, HP, JVC/Victor, Kodak, Leaf,
##' Minolta/Konica-Minolta, Motorola, Nikon, Nintendo, Olympus/Epson,
##' Panasonic/Leica, Pentax/Asahi, Phase One, Reconyx, Ricoh, Samsung,
##' Sanyo, Sigma/Foveon and Sony. For more information, see the
##' \href{http://www.sno.phy.queensu.ca/~phil/exiftool/}{ExifTool
##' website}.
##'
##' Note that binary tags such as thumbnails are loaded as
##' base64-encoded strings that start with "base64:".
##'
##' @param path A vector of filenames
##' @param tags A vector of tags to output. It is a good idea to
##'     specify this when reading large numbers of files, as it
##'     decreases the output overhead significantly. Spaces will be
##'     stripped in the output data frame. This parameter is not
##'     case-sensitive.
##' @param recursive TRUE to pass the "-r" option to ExifTool
##' @param args Additional arguments
##' @param quiet Use FALSE to display diagnostic information
##'
##' @return A data frame with columns SourceFile and one per tag read
##'     in each file. The number of rows may differ, particularly if
##'     recursive is set to TRUE, but in general will be one per file.
##'
##' @importFrom jsonlite fromJSON
##' @export
##'
##' @examples
##' files <- dir(system.file(package = "exiftoolr", "images"),
##'                   pattern = "*.jpg", full.names = TRUE)
##' exifinfo <- exif_read(files)
##' exif_read(files, tags = c("filename", "imagesize"))
##'
exif_read <- function(path, tags = NULL,
                      recursive = FALSE,
                      args = NULL,
                      quiet = TRUE) {

    ## Ensure that exiftoolr is properly configured
    if(!is_exiftoolr_configured()) {
        configure_exiftoolr(quiet = quiet)
        message("Using ExifTool version ", exif_version(), "\n")
    }

    ## ---- general input processing ----
    ## expand path
    path <- path.expand(path)

    ## check that all files exist (files that do not exist cause
    ## problems later, as do directories without recursive = TRUE)
    if(recursive) {
        missing_dirs <- path[!dir.exists(path)]
        if(length(missing_dirs)) {
            stop("Did you mean recursive = TRUE? ",
                 "The following directories are missing",
                 "(or are not directories): ",
                 paste(missing_files, collapse = ", "))
        }
    } else {
        missing_files <- path[!file.exists(path) | dir.exists(path)]
        if(length(missing_files)) {
            stop("Did you mean recursive = TRUE? ",
                 "The following files are missing (or are not files): ",
                 paste(missing_files, collapse = ", "))
        }
    }

    if(recursive) {
        args <- c(args, "-r")
    }

    if(!is.null(tags)) {
        ## tags cannot have spaces...whitespace is stripped by ExifTool
        tags <- gsub("\\s", "", tags)
        args <- c(paste0("-", tags), args)
    }

    ## required args:
    ##   -n for numeric output
    ##   -j for JSON output
    ##   -q for quiet
    ##   -b to ensure output is base64 encoded
    args <- unique(c("-n", "-j", "-q", "-b", args))
    ## an extra -q further silences warnings
    if(quiet) {
        args <- c(args, "-q")
    }

    ## Construct and execute a call to Exiftool
    return_value <-
        exif_call(args = args, fname = path, intern = TRUE)

    ## Postprocess the results
    fromJSON(paste0(return_value, collapse = ""))
}


##' Call exiftool from R
##'
##' Uses \code{system()} to run a basic call to \code{exiftool}.
##' @param args List of non-shell quoted arguments (e.g. \code{-n
##'     -csv})
##' @param fnames Character vector giving one or more file paths
##' @param intern \code{TRUE} if output should be returned as a
##'     character vector.
##' @param ... Additional arguments to be passed to \code{system()}
##'
##' @return The exit code if \code{intern=FALSE}, or the standard
##'     output as a character vector if \code{intern=TRUE}.
##' @export
##'
##' @examples
##' exif_call()
##' exif_version()
##'
exif_call <- function(args = NULL,
                          fnames = NULL,
                          intern = FALSE,
                          ...) {
    ## Exiftool command
    exiftoolpath <- get_exiftool_command()
    if(is.null(exiftoolpath)) {
        stop("ExifTool not properly installed or configured")
    }

    ## Put all 'command-line' arguments in a file
    argfile <- construct_argfile(args = args, fnames = fnames)
    on.exit(unlink(argfile))

    ## Construct and then execute the command-line call
    command <- paste(exiftoolpath, "-@", shQuote(argfile), collapse = " ")
    system(command, intern = intern, ...)
}

##' @rdname exif_call
##' @export
exif_version <- function() {
    as.numeric(exif_call(args = "-ver", intern = TRUE))
}

## private helper command to generate call to exiftool
construct_argfile <- function(args, fnames) {
    all_args <- c(args, fnames)
    tmpfile <- tempfile("args.cmd")
    writeLines(all_args, tmpfile, sep="\n")
    tmpfile
}


