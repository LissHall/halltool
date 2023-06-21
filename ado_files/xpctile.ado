
*! version 0.1.0 Hall 21jun2023
cap program drop xpctile
program define xpctile, rclass
    syntax varlist(min=1 max=1) [if] [in], Xvar(real)
    
    qui summarize `varlist' `if' `in', detail
    local TOTAL_COUNT = r(N)

    if "`if'" == ""{
        qui su `varlist' if `varlist' < `xvar' `in', detail
    }
    else {
        qui su `varlist' `if' & (`varlist' < `xvar') `in', detail
    }
    local TOTAL_COUNT_S = r(N)

    local pct = 100 * `TOTAL_COUNT_S' / `TOTAL_COUNT'
    di "`xvar' is at the " round(`pct', 0.01) "% percentile of `varlist'"
    return scalar pct = `pct'
end