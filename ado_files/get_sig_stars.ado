*! version 1.0, Hall, 5oct2024
* Xinya HAO (Hall), CityUHK
* lisshall717@gmail.com
* get sig stars for p-value
program define get_sig_stars, rclass
    version 12
    syntax anything
    
    if `anything' < 0 {
        dis as error "p-value cannot < 0"
        exit 999
    }
    
    local _sig_stars " "
    if `anything' > 0.1 {
        local _sig_stars " "
    }
    else if `anything' > 0.05 {
        local _sig_stars "*"
    }
    else if `anything' > 0.01 {
        local _sig_stars "**"
    }
    else {
        local _sig_stars "***"
    }
	
	return local _sig_stars = "`_sig_stars'"
end
