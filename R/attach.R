
pkgs <- c("chevreulShiny", "chevreulProcess", "chevreulPlot")

chevreul_attach <- function() {
  # Create `to_load` which is a character vector of all chevreul
  # packages not loaded in the current R session.
  to_load <- check_loaded()

  # If to_load has length 0, all main packages are loaded.
  # Nothing will be attached.
  if (length(to_load) == 0) {
    return(invisible())
  }

  # Create a line rule with two text labels:
  # "Attaching packages" on the left-hand side and
  # chevreul with the package version on the right-hand side
  load_header <- cli::rule(
    left = crayon::bold("Attaching packages"),
    right = paste0("chevreul ", package_version("chevreul"))
  )

  # Return a character string containing the package version for each of chevreul's constituents
  versions <- vapply(to_load, package_version, character(1))

  packages <- paste0(
    crayon::green(cli::symbol$tick), " ", crayon::blue(format(to_load)), " ",
    crayon::col_align(versions, max(crayon::col_nchar(versions)))
  )

  # Format for two columns
  # if there is an odd number of packages, add ""
  if (length(packages) %% 2 == 1) {
    packages <- append(packages, "")
  }
  # Divide the packages into column 1 and 2
  col1 <- seq_len(length(packages) / 2)
  # paste the packages in column one with a space and those not in column 1
  info <- paste0(packages[col1], "     ", packages[-col1])

  # display the message!
  msg(load_header)
  msg(paste(info, collapse = "\n"))

  # Load the constituent packages!
  # character.only = TRUE must be used in order to
  # supply character strings to `library()`
  suppressPackageStartupMessages(
    lapply(to_load, library, character.only = TRUE)
  )

  # Thanks for playing
  invisible()

}

# Detach all loaded packages for seeing the pretty startup message (:
chevreul_detach <- function() {
  pak <- paste0("package:", c(pkgs, "chevreul"))
  lapply(pak[pak %in% search()], detach, character.only = TRUE)
  invisible()
}

#' List all packages imported by chevreul
#'
#' @export
#'
#' @examples
#' chevreul_packages()
chevreul_packages <- function() {
  # get all imports from chevreul's package description file
  raw <- utils::packageDescription("chevreul")$Imports
  # return a character vector of all the imports
  imports <- strsplit(raw, ",")[[1]]
  # "^\\s+" matches white space at the beginning of a character string
  # "\\s+$ matches white space at the end of a character string
  parsed <- gsub("^\\s+|\\s+$", "", imports)
  # for each import, take only the first complete word (i.e. the package name)
  names <- vapply(strsplit(parsed, "\\s+"), "[[", 1, FUN.VALUE = character(1))

  return(names)

}
