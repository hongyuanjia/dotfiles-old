# Things you might want to change

# options(papersize="a4")
# options(editor="notepad")
# options(pager="internal")

# set the default help type
# options(help_type="text")
  options(help_type="html")

# set a site library
# .Library.site <- file.path(chartr("\\", "/", R.home()), "site-library")

# set a CRAN mirror
local({r <- getOption("repos")
      r["CRAN"] <- "https://mirrors.tuna.tsinghua.edu.cn/CRAN"
      options(repos=r)})

# Suggestions from devtools
# https://github.com/hadley/devtools
.First <- function() {
  options(
    browserNLdisabled = TRUE,
    deparse.max.lines = 2)
}

try(startup::startup())
