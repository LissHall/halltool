*! version 1.0.1, Hall, 10jan2025.
	// add Qui, Replace options
* version 1.0.0, Hall, 27oct2024
*** Append all dta files into one dta file
//cap program drop appdtas
program define appdtas
	
	syntax [anything], From(str) Saveas(str) [Qui] [Replace]
	
	*** check saveas is a dta file
	local sufx = substr("`saveas'", -4, 4)
	if "`sufx'" != ".dta" {
		dis as error "SAVEAS file must be in .dta format"
		error 999
	}
	
	*** start xform
	local i = 2
	local files: dir "`from'" files "*.dta"
	local len_files : word count `files'
	local first_file : word 1 of `files'
	
	// in case len_files, display a warning but no error returned.
	if `len_files' == 0 {
		dis as red "No Files to Merge."
		dis as text "" _c
	}
	else {
		// merge all files
		preserve
			use "`from'/`first_file'", clear
			
			foreach file in `files' {
				local pref = substr("`file'", 1, 1)
				qui if "`pref'" != "." & "`file'" != "`first_file'" {
					append using "`from'/`file'", force
					
					// print info.
					if "`qui'" == "qui" {
						local ++i
					}
					else {
						nois dis "`i' of `len_files' Appended!"
						local ++i
					}
				}
			}
			
			// save the file
			qui compress
			if "`qui'" == "qui" {
				qui save "`saveas'", `replace'
			}
			else {
				save "`saveas'", `replace'
			}
			
		restore
	}
end
