
##' Read EXIF and other metadata from files
##'
##' Reads EXIF and other metadata into a \code{data.frame} by calling
##' Phil Harvey's ExifTool command-line application.
##'
##' From the \href{https://exiftool.org}{ExifTool website}:
##' "ExifTool is a platform-independent Perl library plus a
##' command-line application for reading, writing and editing meta
##' information in a wide variety of files. ExifTool supports many
##' different metadata formats including EXIF, GPS, IPTC, XMP, JFIF,
##' GeoTIFF, ICC Profile, Photoshop IRB, FlashPix, AFCP and ID3, as
##' well as the maker notes of many digital cameras by Canon, Casio,
##' DJI, FLIR, FujiFilm, GE, GoPro, HP, JVC/Victor, Kodak, Leaf,
##' Minolta/Konica-Minolta, Motorola, Nikon, Nintendo, Olympus/Epson,
##' Panasonic/Leica, Pentax/Asahi, Phase One, Reconyx, Ricoh, Samsung,
##' Sanyo, Sigma/Foveon and Sony."
##'
##' For more information, see the \href{https://exiftool.org}{ExifTool
##' website}.
##'
##' @param path A vector of filenames.
##' @param tags A vector of tags to output. It is a good idea to
##'     specify this when reading large numbers of files, as it
##'     decreases the output overhead significantly. Spaces will be
##'     stripped in the output data frame. This parameter is not
##'     case-sensitive.
##' @param recursive \code{TRUE} to pass the \code{"-r"} option to
##'     ExifTool.
##' @param args Additional arguments.
##' @param quiet Use \code{FALSE} to display diagnostic
##'     information. Default value is \code{TRUE}
##' @param pipeline One of \code{"json"} (the default) or
##'     \code{"csv"}. Controls whether the exiftool executable, behind
##'     the scenes, extracts metadata into a JSON data structure or a
##'     tabular csv. The JSON pipeline works well unless some of the
##'     values in the tag fields contain non-ASCII characters. If the
##'     fields do include non-ASCII characters, and you are needing to
##'     set the \code{"-charset"} option, use the \code{"csv"}
##'     pipeline instead.
##' @return A data frame of class \code{"exiftoolr"} with one row per
##'     file processed. The first column, named \code{"SourceFile"}
##'     gives the name(s) of the processed files. Subsequent columns
##'     contain info from the tags read from those files.
##'
##'     Note that binary tags such as thumbnails are loaded as
##'     \href{https://en.wikipedia.org/wiki/Base64}{base64-encoded
##'     strings} that start with \code{"base64:"}. Although these are
##'     truncated in the printed representation of the
##'     \code{data.frame} returned by the function, they are left
##'     unaltered in the \code{data.frame} itself.
##' @references \url{https://exiftool.org}
##' @importFrom jsonlite fromJSON
##' @importFrom data.table fread
##' @export
##'
##' @examples
##' \dontrun{
##' files <- dir(system.file(package = "exiftoolr", "images"),
##'              pattern = "*.jpg", full.names = TRUE)
##' exif_read(files)
##' exif_read(files, tags = c("filename", "imagesize"))
##' }
exif_read <- function(path, tags = NULL,
                      recursive = FALSE,
                      args = NULL,
                      quiet = TRUE,
                      pipeline = c("json", "csv")) {
    pipeline <- match.arg(pipeline)
    ## Ensure that exiftoolr is properly configured
    if (!is_exiftoolr_configured()) {
        configure_exiftoolr(quiet = quiet)
        message("Using ExifTool version ", exif_version(), "\n")
    }

    ## ---- general input processing ----
    ## expand path
    path <- path.expand(path)

    ## check that all files exist (files that do not exist cause
    ## problems later, as do directories without recursive = TRUE)
    if (recursive) {
        missing_dirs <- path[!dir.exists(path)]
        if (length(missing_dirs)) {
            stop("Did you mean recursive = TRUE? ",
                 "The following directories are missing",
                 "(or are not directories): ",
                 paste(missing_files, collapse = ", "))
        }
    } else {
        missing_files <- path[!file.exists(path) | dir.exists(path)]
        if (length(missing_files)) {
            stop("Did you mean recursive = TRUE? ",
                 "The following files are missing (or are not files): ",
                 paste(missing_files, collapse = ", "))
        }
    }

    if (recursive) {
        args <- c(args, "-r")
    }

    ## an extra -q further silences warnings
    if (quiet) {
        args <- c(args, "-q")
    }

    if (!is.null(tags)) {
        ## tags cannot have spaces...whitespace is stripped by ExifTool
        tags <- gsub("\\s", "", tags)
        args <- c(paste0("-", tags), args)
    }

    ##-----------------------------------------##
    ## Process using JSON intermediate output  ##
    ##-----------------------------------------##

    ## required args:
    ##   -n for numeric output
    ##   -j for JSON output
    ##   -q for quiet
    ##   -b to ensure output is base64 encoded
    json_args <- c("-n", "-j", "-q", "-b", args)
    ## Construct and execute a call to Exiftool
    return_value <-
        exif_call(args = json_args, path = path, intern = TRUE)
    ## Postprocess the results
    return_value <- fromJSON(paste0(return_value, collapse = ""))


    if (pipeline == "csv") {
        ## required args:
        ##   -n for numeric output
        ##   -T for tabular output
        ##   -csv for CSV output
        ##   -api filter to properly handle tag values containing commas, double
        ##        quotes, newline characters, or leading or trailing spaces.
        ##   -q for quiet
        ##   -b to ensure output is base64 encoded
        filter <-
          if (.Platform$OS.type == "windows") {
             x <- '$_ = qq($_) if s/""/""""/g or /(^\\s+|\\s+$)/ or /[,\\n\\r]/'
             shQuote(x)
          } else {
             x <- '$_ = qq{"$_"} if s/"/""/g or /(^\\s+|\\s+$)/ or /[,\\n\\r]/'
             sQuote(x)
          }
        filter <- paste0("filter=", filter)
        csv_args <- c("-n", "-T", "-csv", "-q", "-b", "-api", filter, args)
        ## Use data read by json to get classes of each column
        colClasses <- unname(sapply(return_value, class))
        ## Construct and execute a call to Exiftool
        return_value <-
            exif_call(args = csv_args, path = path, intern = TRUE)
        ## Postprocess the results. (Uses fread because it does not
        ## convert "T" to TRUE and "F" to FALSE)
        return_value <- fread(text = return_value, colClasses = colClasses,
                              data.table = FALSE)
    }

    class(return_value) <- c("exiftoolr", class(return_value))
    return_value
}


##' Call ExifTool from R
##'
##' Uses \code{system()} to run a basic call to \code{exiftool}.
##' @param args Character vector of arguments, each written in same
##'     form as you would if writing them on the command line
##'     (e.g. \code{"-n"} or \code{"-csv"})
##' @param path A character vector giving one or more file paths.
##' @param intern \code{TRUE} if output should be returned as a
##'     character vector. Default value is \code{FALSE}.
##' @param quiet Use \code{FALSE} to display diagnostic
##'     information. Default value is \code{FALSE}.
##' @param ... Additional arguments to be passed to \code{system()}.
##' @details For examples of the command-line calls to ExifTool (all
##'     of which can be reproduced by calls to \code{exif_call}), see
##'     \url{https://exiftool.org/examples.html}.
##' @return The exit code (if \code{intern = FALSE}) or the standard
##'     output as a character vector (if \code{intern = TRUE}).
##' @export
##'
##' @examples
##' \dontrun{
##' ## Find local ExifTool version using exif_version() or exif_call()
##' exif_version()
##' exif_call(args = "-ver", intern = TRUE)
##'
##' ## Make temporary copies of a couple jpeg files
##' tmpdir <- tempdir()
##' src_files <- dir(system.file(package = "exiftoolr", "images"),
##'                  full.names = TRUE)
##' files <- file.path(tmpdir, basename(src_files))
##' file.copy(src_files, files)
##'
##' ## Both of the following extract the same tags:
##' exif_read(files, tags = c("filename", "imagesize"))
##' exif_call(args = c("-n", "-j", "-q", "-filename", "-imagesize"),
##'           path = files, intern = TRUE)
##'
##' ## Set value of a new "Artist" field in photo's metadata
##' file1 <- files[1]
##' exif_read(file1, tags = "artist")
##' exif_call(path = file1, args = "-Artist=me")
##' exif_read(file1, tags = "artist")
##'
##' ## Remove all but a few essential fields
##' length(exif_read(file1))
##' exif_call(path = file1, args = "-all=")
##' length(exif_read(file1))
##' exif_read(file1)
##'
##' ## Clean up
##' unlink(files)
##' }
exif_call <- function(args = NULL,
                      path = NULL,
                      intern = FALSE,
                      quiet = FALSE,
                      ...) {
    ## Ensure that exiftoolr is properly configured
    if (!is_exiftoolr_configured()) {
        configure_exiftoolr(quiet = quiet)
        message("Using ExifTool version ", exif_version(), "\n")
    }

    ## Exiftool command
    exiftoolpath <- get_exiftool_command()
    if (is.null(exiftoolpath)) {
        stop("ExifTool not properly installed or configured")
    }

    ## Put all 'command-line' arguments in a file
    argfile <- construct_argfile(args = args, path = path)
    on.exit(unlink(argfile))

    ## Construct and then execute the command-line call
    command <- paste(exiftoolpath, "-@", shQuote(argfile), collapse = " ")
    system(command, intern = intern, ...)
}

##' @rdname exif_call
##' @export
exif_version <- function(quiet = TRUE) {
    exif_call(args = "-ver", intern = TRUE, quiet = quiet)
}

## private helper command to generate call to exiftool
construct_argfile <- function(args, path) {
    all_args <- c(args, path)
    tmpfile <- tempfile("args.cmd")
    writeLines(all_args, tmpfile, sep="\n")
    tmpfile
}


