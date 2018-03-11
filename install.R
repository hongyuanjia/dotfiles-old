#######################################################################
#                               helpers                               #
#######################################################################
# require2: Load a package and install it if not installed
# {{{
require2 <- function (package, character.only = FALSE, ...) {
   if (!character.only)
       package <- as.character(substitute(package))
   if(!suppressWarnings(require(package = package, character.only = TRUE))) {
       install.packages(pkgs=package)
   }
   require(package = package, character.only = TRUE)
}
# }}}
# os_type: Return operation system type
# {{{
os_type <- function () {
    if (.Platform$OS.type == 'windows') {
        return("windows")
    } else if (Sys.info()[['sysname']] == 'Darwin') {
        return("macos")
    } else {
        return("linux")
    }
}
# }}}
# os_arch: Return the architecture
# {{{
os_arch <- function () {
    if (identical(Sys.info()[['machine']], "x86-64")) {
        c("64bit")
    } else {
        c("32bit")
    }
}
# }}}
# os_ext: Return system-dependent typical file extensions of releases on GitHub
# {{{
os_ext <- function () {
    switch(os_type(),
           windows = c("exe", "zip"),
           macos = c("dmg", "gz"),
           linux = c("deb", "sh", "gz"))
}
# }}}
# choco_install: Install packages using Chocolatey
# {{{
choco_install <- function (pkgs, ignore_deps = FALSE) {
    command <- paste("choco -install -y", pkgs)
    if (ignore_deps) command <- paste(command, "--ignore-dependencies")
    shell(command, intern = TRUE)
}
# }}}
# clone_repo: Git clone
# {{{
clone_repo <- function (repo, dest = NULL) {
    system2("git", paste0("clone ", repo, ".git ", dest))
}
# }}}
# create_link: Create symbolic link
# {{{
create_link <- function (from, to) {
    from <- fs::path_tidy(fs::path_real(from))
    to <- fs::path_tidy(to)

    # if dir of target does not exists, create it
    if (!dir.exists(dirname(to))) {
        dir.create(dirname(to), recursive = TRUE)
    }

    # test if target already exists
    if (file_test("-d", from)) {
        flag_exists <- dir.exists(to)
        keyword <- "directory"
    } else {
        flag_exists <- file.exists(to)
        keyword <- "file"
    }

    if (flag_exists) {
        to_real <- fs::path_real(to)
        if (identical(from, to_real)) {
            cat(sprintf("    Symbol link from %s %s to %s already exists. Skipping link creation.\n",
                        keyword, sQuote(from), sQuote(to)))
            return(invisible())
        } else {
            cat(sprintf("    Symbol link %s already exists but is directed to a different path %s. A new one directed to %s will be created.\n",
                        sQuote(to), sQuote(to_real), sQuote(from)))
            unlink(to, force = TRUE)
        }
    }

    flag_link <- file.symlink(from, to)

    if (flag_link) {
        cat(sprintf("    Symbol link from %s %s to %s has been successfully created.\n",
                    keyword, sQuote(from), sQuote(to)))
    } else {
        cat(sprintf("  Failed to create symbol link from %s %s to %s.\n",
                    keyword, sQuote(from), sQuote(to)))
    }
}
# }}}
# repo_releases: Get release versions and download URL using GitHub API
# {{{
repo_releases <- function (owner, repo, ver = "latest", pre_release = FALSE,
                           type = c("binary", "source")) {
    # get query response
    # {{{
    rels <- gh::gh("GET /repos/:owner/:repo/releases", repo = repo, owner = owner)
    if (all(rels == "")) {
        stop("GitHub repository ", sQuote(paste0(owner, "/", repo)),
                " does not have any release.", call. = FALSE)
    }
    # get all tags
    tags <- vapply(rels, "[[", "", "tag_name")
    # get all versions
    vers <- gsub("^v", "", tags)
    # check if the version is a major.minor format
    not_patch <- grepl("^\\d+\\.\\d+(\\.0){0,1}$", vers)
    # get pre-release indicator
    prerels <- vapply(rels, "[[", logical(1), "prerelease")
    # get tarball download URL
    tars <- paste0(vapply(rels, "[[", "", "tarball_url"), ".tar.gz")
    # get zipball download URL
    zips <- paste0(vapply(rels, "[[", "", "zipball_url"), ".zip")
    # combine into a data.table
    res <- data.table::data.table(tag = tags, version = vers, patch = !not_patch,
        prerelease = prerels, tarball = tars, zipball = zips)
    # }}}

    # get download binary file data
    # {{{
    assets <- lapply(rels, "[[", "assets")
    name <- purrr::modify_depth(assets, 2, "name")
    url <- purrr::modify_depth(assets, 2, "browser_download_url")
    # combine into the data.table
    res[, `:=`(file = name, url = url)]
    # }}}

    # check the version
    # {{{
    ver <- as.character(ver)
    # if only major and minor version are given, add patch version ".0"
    if (grepl("^\\d+\\.\\d+$", ver)) ver <- paste0(ver, ".0")

    if (ver != "latest") {
        targ <- res[version == as.character(ver)]
        # check if version is correct
        if (nrow(targ) == 0L) {
            msg_ver <- res[, paste0("  Version: ", sQuote(version), ifelse(prerelease, " (Pre-release)", ""),
                                     collapse = "\n")]
            stop("Could not find ", sQuote(paste0(repo, " v", ver)), ". ",
                 "Possible values are:\n", msg_ver, call. = FALSE)
        }
    } else {
        if (pre_release) targ <- res[1L] else targ <- res[prerelease == FALSE][1L]
    }
    # }}}

    type <- match.arg(type)
    if (type == "binary") {
        # {{{
        links <- targ[, lapply(.SD, unlist), .SDcol = c("file", "url")]

        # check if there is no binary releases
        if (nrow(links) == 0L) {
            stop(sQuote(repo), " ", targ[["tag"]], " does not release any binary file. ",
                 "Only source code is available.", call. = FALSE)
        }

        # check if there are other files such as release notes, dependencies on
        # the release file list
        repo_lcase <- tolower(repo)
        links[, core_file := FALSE]
        links[grepl(repo, file, ignore.case = TRUE), core_file := TRUE]

        # get file extension
        links[, ext := tools::file_ext(file)]

        # guess platform using file extension and file name
        links[, os := NA_character_]
        links[ext %in% c("zip", "exe"), os := "windows"]
        links[ext %in% c("dmg"), os := "macos"]
        links[ext %in% c("deb", "sh"), os := "linux"]
        links[is.na(os) & grepl("[-._](win(dows){0,1})[-._]", file, ignore.case = TRUE), os := "windows"]
        links[is.na(os) & grepl("[-._](darwin|mac(os){0,1}|apple)[-._]", file, ignore.case = TRUE), os := "macos"]
        links[is.na(os) & grepl("[-._](linux)[-._]", file, ignore.case = TRUE), os := "linux"]
        links[is.na(os) & grepl("[-._](ubuntu)[-._]", file, ignore.case = TRUE), os := "ubuntu"]

        # guess architecture using file name
        links[, arch := NA_character_]
        links[grepl("i386|32bit|x86", file, ignore.case = TRUE), arch := "32bit"]
        links[grepl("x86_64|64bit|x64", file, ignore.case = TRUE), arch := "64bit"]

        # if platform specific released core files found, then only return those
        if (links[core_file == TRUE & !is.na(os), .N] > 0L) {
            links <- links[os == os_type() | is.na(os)]
        }
        # }}}
    } else {
        # {{{
        url <- ifelse(os_type() == "windows", targ[["zipball"]], targ[["tarball"]])
        links <- data.table::data.table(
           file = paste0(repo, tools::file_path_sans_ext(basename(url)), "_src",
                         ".", tools::file_ext(url)),
           url = url, core_file = TRUE, ext = tools::file_ext(url),
           os = os_type(), arch = NA_character_)
        # }}}
    }

    attr(links, "tag") <- targ[["tag"]]
    attr(links, "version") <- targ[["version"]]
    attr(links, "prerelease") <- targ[["prerelease"]]

    return(links)
}
# }}}
# download_file
# {{{
download_file <- function (url, dest) {
    res <- download.file(url, dest, mode = "wb")
    dest_dir <- dirname(dest)
    if (!dir.exists(dest_dir)) dir.create(dest_dir, recursive = TRUE)
    attr(res, "url") <- url
    attr(res, "file") <- basename(dest)
    return(res)
}
# }}}
# installer
# {{{
installer <- function (exec) {
    ext <- tools::file_ext(exec)
    if (ext == "zip") {
        res <- unzip(zipfile = exec, exdir = dirname(exec))
    } else if (ext == "tar") {
        res <- untar(tarfile = exec, exdir = dirname(exec))
    } else if (ext == "7z") {
        has_7z <- unname(Sys.which("7z") != "")
        if (has_7z) {
            res <- system(paste0("7z x -aoa -o", normalizePath(dirname(exec)), " ",
                                 normalizePath(exec)), show.output.on.console = FALSE)
        } else {
            stop("The target file ", sQuote(basename(exec)),
                 " has an extenstion of '7z', which is unavaible on this sytem.",
                 call. = FALSE)
        }
    } else {
        has_ps <- unname(Sys.which("powershell") != "")
        win_exec <- normalizePath(exec)

        if (has_ps) {
            cmd <- sprintf("& %s /S | Out-Null", exec)
            res <- system2("powershell", cmd)
        } else {
            res <- shell(exec)
        }
    }

    if (!res) {
        return(res)
    } else {
        stop("Cannot install file ", sQuote(exec), ".", call. = FALSE)
    }

}
# }}}
# install_wox
# {{{
install_wox <- function (ver = "latest", download_dir = getwd(), clean_up = TRUE) {

    # get download link
    rel <- repo_releases(owner = "Wox-launcher", repo = "Wox", ver = ver)
    tag <- attr(rel, "version")
    url <- rel[core_file == TRUE & ext == "exe", url]
    dest <- file.path(download_dir, basename(url))

    # download and install
    download_file(url, dest)
    installer(dest)
    if (clean_up) unlink(dest, force = TRUE)

    cat("Wox", paste0("v", ver), "has been installed successfully into",
        sQuote(normalizePath(file.path(dir_home, "AppData", "Local", "Wox"))), "\n")
}
# }}}
# install_eplus
# {{{
install_eplus <- function (ver = "latest", download_dir = getwd(), clean_up = TRUE,
                           pre_release = FALSE) {

    # get download link
    rel <- repo_releases(owner = "NREL", repo = "EnergyPlus", ver = ver, pre_release = pre_release)
    ver <- attr(rel, "version")
    url <- rel[core_file == TRUE & ext == "exe" & arch == os_arch(), url]
    dest <- file.path(download_dir, basename(url))

    # download and install
    download_file(url, dest)
    installer(dest)
    if (clean_up) unlink(dest, force = TRUE)

    cat("EnergyPlus", paste0("v", ver), "has been installed successfully into",
        sQuote(paste0("C:\\EnergyPlusV", gsub(".", "-", ver, fixed = TRUE))), "\n")
}
# }}}
# install_vimdesktop
# {{{
install_vimdesktop <- function (ver = "latest", dest_dir = "C:/Program Files") {
    rel <- repo_releases("goreliu", "vimdesktop", ver = ver)

    ver <- attr(rel, "version")

    if (as.numeric_version(ver) >= "2.2.0") {
        if (os_arch() == "64bit") {
            url <- rel[core_file == TRUE & arch == "64bit", url]
        } else {
            url <- rel[core_file == TRUE & arch != "64bit", url]
        }
    } else {
        url <- rel[core_file == TRUE, url]
    }

    dest <- file.path(dest_dir, basename(url))

    # download and install
    download_file(url, dest)
    installer(dest)
    cat("VimDesktop", paste0("v", ver), "has been installed successfully into",
        sQuote(normalizePath(dest_dir)), "\n")
    unlink(dest, force = TRUE)
}
# }}}
# install_spacevim
# {{{
install_spacevim <- function () {
    repo_spacevim <- "https://github.com/liuchengxu/space-vim"
    dir_spacevim <- normalizePath(file.path(dir_home, ".space-vim"),
                                  winslash = "/", mustWork = FALSE)
    if (Sys.which("git") != "") {
        cmd <- paste0("git clone ", repo_spacevim, " ", dir_spacevim)
        res <- system(cmd)
    } else {
        stop("Git is required to be installed before insatll Space-Vim.",
             call. = FALSE)
    }

    # Download Vim-Plug
    url_plug <- 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    dest_plug <- file.path(dir_home, ".vim", "autoload")
    download_file(url_plug, dest_plug)

    # Create the symlinks
    create_link(file.path(dir_spacevim, "init.vim"),
                file.path(dir_home, ".vimrc"))
    create_link(file.path(dir_spacevim, "init.spacevim"),
                file.path(dir_home, ".spacevim"))

    # Link dot files and directories
    # {{{
    dir_dotfiles <- fs::path_real(file.path(dir_home, "Dropbox", "github_repo", "dotfiles"))
    if (!dir.exists(dir_dotfiles)) {
        cat("Space-Vim has been successfully.",
            "However, your dotfiles and direcotories were not found.")
        return(0)
    } else {
        targ <- fs::path_real(dir_dotfiles)
        if (length(targ)) dir_dotfiles <- targ
    }

    targ_files <- c(".spacevim", ".gitconfig")
    targ_rfiles <- c(".Rprofile", "Rconsole")
    targ_vim_dirs <- c("Ultisnips", "dict", "ftplugin", "autoload/unite", "syntax")

    lapply(targ_files,
           function (x) create_link(file.path(dir_dotfiles, x),
                                    file.path(dir_home, x))
    )
    lapply(targ_rfiles,
           function (x) create_link(file.path(dir_dotfiles, x),
                                    file.path(dir_rhome, x))
    )
    lapply(targ_vim_dirs,
           function (x) create_link(file.path(dir_dotfiles, x),
                                    file.path(dir_home, ".vim", x))
    )
    # }}}

    cat("Space-Vim has been successfully. Linking to your dot files and directories have also been created.")
    return(0)
}
# }}}

# Use Tsinghua CRAN mirror
tsinghua_cran <- "https://mirrors.tuna.tsinghua.edu.cn/CRAN"
options(repos = tsinghua_cran)

# Install required packages
require2(fs)
require2(gh)
require2(data.table)
require2(purrr)

#######################################################################
#                               Actions                               #
#######################################################################
# Change directory to $HOME
dir_home <- fs::path_real(fs::path_tidy(Sys.getenv("USERPROFILE")))
dir_rhome <- fs::path_real(Sys.getenv("HOME"))
setwd(dir_home)
