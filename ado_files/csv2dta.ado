*! version 1.0.0, Hall, 27oct2024
*** Xform all the csv in a folder to dta
//cap program drop csv2dta
program define csv2dta
	
	version 10.0
	syntax [anything], From(str) To(str) *
	
	*** collect options
	local import_delimited_options `options'
	
	*** make the dir if not exist
	cap mkdir "`to'"
	
	*** start xform
	local i = 1
	local files: dir "`from'" files "*.csv"
	local len_files : word count `files'
	
	preserve
		foreach file in `files' {
			local pref = substr("`file'", 1, 1)
			local sufx = substr("`file'", -4, 4)
			qui if "`pref'" != "." & "`sufx'" == ".csv" {
				import delimited "`from'/`file'", ///
					`import_delimited_options'

					local sf = subinstr("`file'",".csv","",.)
					compress
				save "`to'/`sf'.dta", replace
				nois dis "`i' of `len_files' Xformed!"
				local ++i
			}
		}
	restore
end
