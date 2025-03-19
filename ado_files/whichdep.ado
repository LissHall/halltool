*! version 1.3 09 Nov 2024
* version 1.2 08 Nov 2023
* version 1.1 09 May 2023
*! Xinya Hao (Hall) xyhao5-c@my.cityu.edu.hk

//cap program drop whichdep
program define whichdep
    version 15.0
    capture syntax anything(name = pkglist) [,net(string) Replace *] 

    if "`options'" != "" {
        di as error "Unrecognized option in `options'"
        exit 198
    }

    // Check SSC packages
    foreach pkg of local pkglist {
        if "`replace'" == "replace" {
            cap ssc install `pkg' , `replace'
            if _rc != 0 {
                dis as error "-`pkg'- installation failed."
                local fail_install = "`fail_install' `pkg'"
            }
            else {
                dis as text "-`pkg'- installed and is up to date"
            }
        }
        else {
            qui capture which `pkg'
			local _rc1 `:dis _rc'
			qui cap ado des `pkg'
			local _rc2 `:dis _rc'
			if `_rc1' == 0 | `_rc2' == 0 {
				local _rc_check = 0
			}
			else {
				local _rc_check = 111
			}
			
            if `_rc_check' == 0 {
                dis as text "-`pkg'- already installed. Will not re-install."
                continue
            }
            else {
                cap ssc install `pkg'
                if _rc != 0 {
                    dis as error "-`pkg'- installation failed."
                    local fail_install = "`fail_install' `pkg'"
                }
                else {
                    dis as text "-`pkg'- installed."
                }
            }
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
            cap net install "``i''" , from("``j''")
            if _rc != 0 {
                local fail_install = "`fail_install' ``i''"
            }
            else {
                dis as text "-``i''- installed and is up to date"
            }

            local ++i
        }
    }

    // Print the Failed Packages
    local fail_install = trim("`fail_install'")
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

