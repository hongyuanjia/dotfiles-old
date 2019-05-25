# set a CRAN mirror
local({r <- getOption("repos")
      r["CRAN"] <- "https://mirrors.tuna.tsinghua.edu.cn/CRAN"
      options(repos=r)
})

setHook(
    packageEvent("languageserver", "onLoad"),
    function(...) {
        options(languageserver.default_linters = lintr::with_defaults(
                line_length_linter = NULL,
                object_usage_linter = NULL
                ))
    }
)

# Suggestions from devtools
# https://github.com/hadley/devtools
.First <- function () {
    options(
        browserNLdisabled = TRUE,
        deparse.max.lines = 2,
        warnPartialMatchDollar = TRUE,
        warnPartialMatchArgs = TRUE,
        datatable.print.class = TRUE
    )

    if (.Platform$OS.type == "windows") {
        Sys.setlocale("LC_CTYPE", "Chinese (Simplified)_China.936")
    }
}

# vim: noai:ts=4:sw=4
