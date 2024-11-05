*! version 1.0, 4nov2024.
* Xinya Hao (Hall) xyhao5-c@my.cityu.edu.hk

*** Format long string variables in one command.
//cap program drop fmtstr
program define fmtstr
    
    version 12.0
    
    syntax [anything(name=fmtvars)] ///
		[, ///
		Len(integer 30) ///
		]
	
	*** varlist
	if "`fmtvars'" == "" {
		local fmtvars _all
	}
	
	foreach var of varlist `fmtvars' {
		capture confirm string variable `var'
		if !_rc {
			local fmt: format `var'
			local fmt: subinstr local fmt "%" "", all
			local fmt: subinstr local fmt "s" "", all
			cap local fmt = (`fmt' > `len')
			if `fmt' == 1 {
				cap format `var' %`len's
			}
		}
	}

end
