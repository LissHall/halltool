*! version 1.1  09 May 2023
*! Xinya Hao (Hall) xyhao5-c@my.cityu.edu.hk

cap program drop whichdep
program define whichdep
   
    capture syntax anything(name = pkglist) [,net(string) Replace Quick *] 

    if "`options'" != "" {
        dis in red "Error. `options' not allowed"
        exit
    }

    // Check SSC packages
    foreach pkg of local pkglist {
        // check installation if quick option specified
        if "`quick'" == "quick" {
            qui capture which `pkg'
            if _rc == 0 {
                dis "`pkg' already installed"
                continue
            }
        }
        
        qui cap ssc install `pkg' , `replace'
        if _rc != 0 {
            local fail_install = "`fail_install' `pkg'"
        }
        else {
            dis "`pkg' installed and is up to date"
        }        
    }

    // install from net 
    if "`net'" != "" {
        tokenize `net'
        local i = 1
        foreach tk of local net {
            if mod(`i', 2) == 0 {
                local ++i
                continue
            }

            if "``i''" == "" {
                continue, break
            }

            local j = `i' + 1
            cap net install "``i''" , from("``j''") `replace'
            if _rc != 0 {
                local fail_install = "`fail_install' ``i''"
            }
            else {
                dis "``i'' already installed and is up to date."
            }
            local ++i
        }
    }

    // Print the Failed Packages
    local fail_install = trim("`fail_install'")
    if "`quick'" == "quick" {
            dis in red "Quick Check. Programs may not be up to date"
    }
    if "`fail_install'" == "" {
        dis in red "All dependencies are installed"
    }
    else {
        dis in red "Installation Failed:"
        foreach f_pkg of local fail_install {
            dis in red "    `f_pkg'"
        }
    }


end

