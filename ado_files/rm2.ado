*! version 1.1 10 Apr 2024
*! version 1.0 09 May 2023
*! Xinya Hao (Hall) xyhao5-c@my.cityu.edu.hk
*** An enhanced version of rm/erase

cap program drop rm2
program define rm2

    capture syntax [anything(name = filelist)] ///
        [, ///
        Type(string) ///
        Path(string) ///
        *]

    // No punishment for unrecognized options.
    if "`options'" != "" {
        di as error "Unrecognized option in `options'. Ignored"
    }

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
        qui cap rm "`file'"

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
                qui rm "`file'"
            }
        }
    }

end