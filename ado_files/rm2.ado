*! version 1.2, 23sep2024.
* version 1.1, 10apr2024
* version 1.0, 9may2023
* Xinya Hao (Hall) xyhao5-c@my.cityu.edu.hk

*** An enhanced version of rm/erase
//cap program drop rm2
program define rm2
    
    version 12.0
    
    syntax [anything(name = filelist)] ///
        [, ///
        Type(string) ///
        Path(string) ///
        Report ///
        * ]

    *** No punishment for unrecognized options.
    if "`options'" != "" {
        di as red "Unrecognized option in `options'. Ignored."
    }

    *** rmccount
    local rmcount 0

    *** Remove the files specified
    tokenize `"`filelist'"'
    local i = 1
    while `i' > 0 {
        local file = "``i''"
        if "`file'" == "" {
            continue, break
        }
        if "`path'" != "" {
            local file = "`path'/`file'"
        }
        cap rm "`file'"
        if _rc == 0 {
            local filerm_`rmcount' "`file'"
            local ++rmcount
        }

        local ++i
    }

    *** Remove the types of files specified
    if "`type'" != "" {
        foreach tk of local type {
            if "`path'" == "" {
                local path "."
            }

            local files: dir "`path'" files "*`tk'"
            foreach file in `files' {
                if "`path'" != "" {
                    local file = "`path'/`file'"
                }
                cap rm "`file'"
                if _rc == 0 {
                    local filerm_`rmcount' "`file'"
                    local ++rmcount
                }
            }
        }
    }

    *** Report the files removed
    if "`report'" != "" {
        dis "----------------------------------------"
        if `rmcount' == 0 {
            di "No files have been removed."
        }
        else {
            di "The following files have been removed:"
            forvalues i = 0/`rmcount' {
                di "`filerm_`i''"
            }
        }
    }

end
