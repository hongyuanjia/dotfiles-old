# set a CRAN mirror
local({r <- getOption("repos")
      r["CRAN"] <- "https://mirrors.tuna.tsinghua.edu.cn/CRAN/"
      options(repos=r)
})

.First <- function () {
    options(
        datatable.print.class = TRUE,
        # default author name. change accordingly
        usethis.full_name = "Hongyuan Jia",
        # default values in the DESCRIPTION file. change accordingly
        usethis.description = list(
            "Authors@R" = utils::person(
                # default author name
                "Hongyuan", "Jia",
                # default author email
                email = "hongyuanjia@outlook.com",
                # default role, i.e. aut = author, cre = creator
                role = c("aut", "cre"),
                # default ORCID
                comment = c(ORCID = "0000-0002-0075-8183")
                ),
            # default license of the R code
            License = "MIT + file LICENSE",
            # default package initial version
            Version = "0.0.0.9000"
        ),
        # make nvimcom package from Nvim-R as an external library to ensure the
        # compatibility for renv 
        renv.settings.external.libraries = "nvimcom"
    )

    # always use English
    Sys.setenv(LANG = "en")
}

# custom start up
tryCatch(startup::startup(), error = function(ex) message(".Rprofile error: ", conditionMessage(ex)))

# vim: noai:ts=4:sw=4
