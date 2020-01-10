# set a CRAN mirror
local({r <- getOption("repos")
      r["CRAN"] <- "https://cran.stat.nus.edu.sg/"
      options(repos=r)
})

setHook(
    packageEvent("languageserver", "onLoad"),
    function(...) {
        options(languageserver.default_linters = lintr::with_defaults(
                line_length_linter = NULL,
                object_usage_linter = NULL,
                infix_spaces_linter = NULL,
                spaces_left_parentheses_linter = NULL,
                absolute_path_linter = NULL,
                object_name_linter = NULL,
                blogdown.ext = ".Rmd",
                blogdown.author = "Hongyuan Jia"
                ))
    }
)

.First <- function () {
    options(
        # radian
        radian.editing_mode = "vi",
        radian.auto_match = TRUE,
        radian.escape_key_map = list(
            list(key = "-", value = " <- "),
            list(key = "=", value = " %>% "),
            list(key = ":", value = " := ")
        ),

        # Suggestions from devtools
        # https://github.com/hadley/devtools
        browserNLdisabled = TRUE,
        deparse.max.lines = 2,
        warnPartialMatchDollar = TRUE,
        warnPartialMatchArgs = TRUE,
        datatable.print.class = TRUE,

        # usethis
        usethis.full_name = "Hongyuan Jia",
        usethis.description = list(
            `Authors@R` = 'person("Hongyuan", "Jia", email = "hongyuan.jia@bears-berkeley.sg", role = c("aut", "cre"),
                                 comment = c(ORCID = "0000-0002-0075-8183"))',
            License = "MIT + file LICENSE",
            Version = "0.0.0.9000"
        )
    )

    if (.Platform$OS.type == "windows") {
        Sys.setlocale("LC_CTYPE", "Chinese (Simplified)_China.936")
    }
}

# vim: noai:ts=4:sw=4
