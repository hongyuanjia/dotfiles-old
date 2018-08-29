# set the default help type
options(help_type="html")

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

if (Sys.info()[['sysname']] == 'Linux') library(colorout)

