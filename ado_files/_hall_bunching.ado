*! version 1.1.4, Hall, 2oct2024.
    // Fix the within_interval bug.
    // Add meqb/beqm option.
* version 1.1.3, Hall, 21sep2024.
    // Fix the ITT calculation.
* version 1.1.2, Hall, 20sep2024. 
    // Fix the %9.3f errors.
    // Remove id().
    // Add xlabel_c().
* version 1.1.1, Hall, 18sep2024
* version 1.0.0, Hall, 22may2024
capture program drop hall_bunching
program define hall_bunching, rclass
    version 15
    syntax [anything] [if] [in], ///
        Basis(varname numeric) ///
        Cutoff(integer) ///
        BOOTtimes(integer) ///
        [ /// Optional Options
            Qmax(numlist int max=1) ///
            intu(numlist int max=1) ///
            intl(numlist int max=1) ///
            fixq(numlist int max=1) ///
            fixintu(numlist int max=1) ///
            fixintl(numlist int max=1) ///
            DTAsaving(string) /// dtasaving is optional
            GRAPHsaving(string) /// no plot if not specified
                title(string) ///
                xtitle(string) ///
                ytitle(string) ///
            graphsaving_cut(string) /// no plot if not specified
                gcut_left(numlist int max=1) ///
                gcut_right(numlist int max=1) ///
            graphsaving_y(string) /// no plot if not specified
                title_y(string) ///
                xtitle_y(string) ///
                ytitle_y(string) ///
            graphsaving_y_cut(string) /// no plot if not specified
                gycut_left(numlist int max=1) ///
                gycut_right(numlist int max=1) ///
            nodraw /// supress the plot showing up. But will save the graph(s).
            xlabel(passthru) /// xlabel impact non-cut graphs(s).
            xlabel_c(passthru) /// xlabel impact cut graphs(s).
            NOINTeger ///
            second ///
            dots ///
            meqb /// Left: factual > counterfactual
            beqm ///
            tolerance(integer 10) ///
            strictdbm ///
        ]

    *** Clear related scalars in case of re-run --------------------------------
    clean_my_scalars 1
    
    *** ------------------------------------------------------------------------
    local yvar : word 1 of `anything'
    scalar cutoff = `cutoff'
    if "`qmax'" != "" {
        scalar qmax = `qmax'
    }
    scalar intu = `intu'
    scalar intl = `intl'
    scalar boottimes = `boottimes'

    *** Check model
    if "`qmax'" == "" & "`fixq'" == "" {
        dis as error "Please specify either qmax() or fixq()."
        error 198
    }

    if "`intu'" == "" & "`fixintu'" == "" {
        dis as error "Please specify either intu() or fixintu()."
        error 198
    }

    if "`intl'" == "" & "`fixintl'" == "" {
        dis as error "Please specify either intl() or fixintl()."
        error 198
    }

    if "`meqb'" != "" & "`beqm'" != "" {
        dis as error "You cannot specify both meqb and beqm."
        error 198
    }

    *** clean xlabel_c if specifie
    if "`xlabel_c'" != "" {
        local xlabel_c = subinstr("`xlabel_c'", "xlabel_c(", "xlabel(", .)
    }

*** Data Preparation -----------------------------------------------------------
// suppress the output 
qui {
    *** save current data
    save "__temp_datarestore.dta", replace

    *** IF and IN
    cap keep `if'
    cap keep `in'

    *** Data Preparation
    cap drop __basis_bin
    cap gen __basis_bin = `basis'

    cap drop freq
    bys __basis_bin: gen freq = _N
    duplicates drop __basis_bin, force
    keep __basis_bin freq

    cap drop __basis_bin_diff
    gen __basis_bin_diff = __basis_bin - `=scalar(cutoff)'

    su freq
    scalar _OBS = r(sum)
    return scalar _OBS = r(sum)

    * the integer effect
    if "`nointeger'" != "" {
        local add_intger_var 
        local noint_warning "(No integer effect)"
    }
    else {
        cap drop z_5
        cap drop z_10
        gen z_5 = 0
        gen z_10 = 0
        replace z_5 = 1 if mod(__basis_bin,5)==0 
        replace z_10 = 1 if mod(__basis_bin,10)==0

        local add_intger_var z_5 z_10
    }

    dis as red "Data Preparation Done. Start Estimating..."
    dis as red "`noint_warning'"

    * if the fixq is specified
    if "`fixq'" != "" {
        dis as red "(Fix q = `fixq')"
    }

    * if the fixintu is specified
    if "`fixintu'" != "" {
        dis as red "(Fix Int_u = `fixintu')"
    }

    * if the fixintl is specified
    if "`fixintl'" != "" {
        dis as red "(Fix Int_l = `fixintl')"
    }

}

*** Data driven: est best q and Int --------------------------------------------
// suppress the output 
qui {
    mat _est_mse = J(1,7,.)
    
    * Start looping q
    // the dots
    if "`dots'" != "" {
        nois _dots 0, title(Finding the best q and Ints)
        local _dot_i = 1
    }

    // loop from 0/0 if fixq is specified
    if "`fixq'" != "" {
        local q_looptimes = 0
    }
    else {
        local q_looptimes = `qmax'
    }

    if "`fixintu'" != "" {
        local intu_looptimes = 0
    }
    else {
        local intu_looptimes = `intu'
    }

    if "`fixintl'" != "" {
        local intl_looptimes = 0
    }
    else {
        local intl_looptimes = `intl'
    }

    forvalues q = 0/`q_looptimes' {
        * Fix the q if fixq is specified
        if "`fixq'" != "" {
            local q = `fixq'
        }

        // Start looping Int_u
        forvalues Int_u = 0/`intu_looptimes' {
            * Fix the intu if fix is specified
            if "`fixintu'" != "" {
                local Int_u = `fixintu'
            }

            // Start looping Int_l
            forvalues Int_l = 0/`intl_looptimes' {
                * Fix the intl if fix is specified
                if "`fixintl'" != "" {
                    local Int_l = `fixintl'
                }

                preserve // <<< PRESERVE HERE

                // gen inside_interval_indicators
                if `Int_u' == 0 & `Int_l' == 0{
                    gen _I_indicator_0 = (__basis_bin_diff == 0)
                }
                else {
                    scalar _NUM_I_indicator = `Int_u' + `Int_l' + 1
                    local _runner = -1 * `Int_l'
                    forvalues i = 1/`=scalar(_NUM_I_indicator)' {
                        gen _I_indicator_`i' = (__basis_bin_diff == `_runner')
                        local _runner = `_runner' + 1
                    }
                }
                
                // gen ploys
                forvalues power = 0/`q' {
                    gen _power_freq_`power' = __basis_bin^`power'
                }

                // est the MSE
                reg freq ///
                    _power_freq_* ///
                    `add_intger_var' ///
                    _I_indicator_*

                // Save MSE
                mat mse = e(rmse)^2

                // calculate M, B, and DMB
                if "`meqb'" != "" | "`beqm'" != "" {
                    cap drop freq_predict_xb
                    predict freq_predict_xb, xb

                    if `Int_u' == 0 & `Int_l' == 0{
                        // "The Int_u and Int_l cannot be 0 at the same time. Cannot calculate M, B, and DMB."
                        local _est_Mhat = .
                        local _est_Bhat = .
                        local _est_DMB = .
                    }
                    else {
                        forvalues i = 1/`=scalar(_NUM_I_indicator)' {
                            gen _del_coef_I_`i' = _b[_I_indicator_`i'] * _I_indicator_`i'
                        }

                        cap drop _del_coef_I_total
                        cap drop freq_predict_adj // the counterfactual freq
                        egen _del_coef_I_total = rowtotal(_del_coef_I_*)
                        gen freq_predict_adj = freq_predict - _del_coef_I_total

                        // the actual - counterfactual
                        cap drop _freq_diff_acf
                        gen _freq_diff_acf = freq - freq_predict_adj

                        // calculate _est_Mhat and _est_Bhat
                        // Mhat is always positive
                        // Bhat is always negative
                        cap drop _est_Mhat
                        cap drop _est_Bhat
                        if "`meqb'" != "" {
                            egen _est_Mhat = sum(cond((__basis_bin_diff >= -1 * `Int_l' & __basis_bin_diff <= 0) & _freq_diff_acf > 0, _freq_diff_acf, .))
                            egen _est_Bhat = sum(cond((__basis_bin_diff > 0 & __basis_bin_diff <= `Int_u') & _freq_diff_acf < 0, _freq_diff_acf, .))
                        }
                        else {
                            egen _est_Mhat = sum(cond((__basis_bin_diff >= 0 & __basis_bin_diff <= `Int_u') & _freq_diff_acf > 0, _freq_diff_acf, .))
                            egen _est_Bhat = sum(cond((__basis_bin_diff >= -1 * `Int_l' & __basis_bin_diff < 0) & _freq_diff_acf < 0, _freq_diff_acf, .))
                        }

                        local _est_Mhat = _est_Mhat
                        local _est_Bhat = _est_Bhat
                        local _est_DMB = abs(_est_Mhat + _est_Bhat)
                    }
                }
                else {
                    local _est_Mhat = .
                    local _est_Bhat = .
                    local _est_DMB = .
                }

                // mat
                mat _est_row = (`q', `Int_u', `Int_l', mse[1,1], `_est_Mhat', `_est_Bhat', `_est_DMB')
                mat _est_mse = _est_mse \ _est_row
                
                restore // <<< RESTORE HERE
                
                *** The _dots prints
                if "`dots'" != "" {
                    nois _dots `_dot_i' 0
                    local _dot_i = `_dot_i' + 1
                }
            } // end of looping Int_l
        } // end of looping Int_u
    } // end of looping q

    // save the results
    preserve
        svmat _est_mse
        drop in 1
        sort _est_mse4

        ren _est_mse1 var_est_mse1
        ren _est_mse2 var_est_mse2
        ren _est_mse3 var_est_mse3
        ren _est_mse4 var_est_mse4
        ren _est_mse5 var_est_Mhat
        ren _est_mse6 var_est_Bhat
        ren _est_mse7 var_est_DMB

        // if the meqb or beqm is specified
        // then use the best fit only for the one with DMB < tolerance
        if "`meqb'" != "" | "`beqm'" != "" {
            su if var_est_DMB < `tolerance'
            if `r(N)' == 0 {
                if "`strictdbm'" != "" {
                    nois dis _newline
                    nois dis as error "Not possible to find the best q and Ints with DMB <= `tolerance'."
                    error 499
                }
                dis _newline
                nois dis as red "Not possible to find the best q and Ints with DMB <= `tolerance'. Will ignore the tolerance."
            }
            else {
                keep if var_est_DMB <= `tolerance'
                nois dis _newline
                nois dis as red "`meqb'`beqm' specified. The best fit is the (q, l, u) with the smallest MSE & DMB <= `tolerance'."
            }

            // sort again
            sort var_est_mse4
        }

        // save and return the best results
        scalar _best_q = var_est_mse1[1]
        scalar _best_Int_u = var_est_mse2[1]
        scalar _best_Int_u_show = var_est_mse2[1] + `=scalar(cutoff)'
        scalar _best_Int_l = var_est_mse3[1]
        scalar _best_Int_l_show = -1 * var_est_mse3[1] + `=scalar(cutoff)'
        scalar _best_mse = var_est_mse4[1]
        scalar _best_est_Mhat = var_est_Mhat[1]
        scalar _best_est_Bhat = var_est_Bhat[1]
        scalar _best_est_DMB = var_est_DMB[1]

        return scalar _best_q = var_est_mse1[1]
        return scalar _best_Int_u = var_est_mse2[1]
        return scalar _best_Int_u_show = var_est_mse2[1] + `=scalar(cutoff)'
        return scalar _best_Int_l = var_est_mse3[1]
        return scalar _best_Int_l_show = -1 * var_est_mse3[1] + `=scalar(cutoff)'
        return scalar _best_mse = var_est_mse4[1]
        return scalar _best_est_Mhat = var_est_Mhat[1]
        return scalar _best_est_Bhat = var_est_Bhat[1]
        return scalar _best_est_DMB = var_est_DMB[1]

        // save and return the 2nd best results
        scalar _2ndbest_q = var_est_mse1[2]
        scalar _2ndbest_Int_u = var_est_mse2[2]
        scalar _2ndbest_Int_u_show = var_est_mse2[2] + `=scalar(cutoff)'
        scalar _2ndbest_Int_l = var_est_mse3[2]
        scalar _2ndbest_Int_l_show = -1 * var_est_mse3[2] + `=scalar(cutoff)'
        scalar _2ndbest_mse = var_est_mse4[2]
        scalar _2ndbest_est_Mhat = var_est_Mhat[2]
        scalar _2ndbest_est_Bhat = var_est_Bhat[2]
        scalar _2ndbest_est_DMB = var_est_DMB[2]

        return scalar _2ndbest_q = var_est_mse1[2]
        return scalar _2ndbest_Int_u = var_est_mse2[2]
        return scalar _2ndbest_Int_u_show = var_est_mse2[2] + `=scalar(cutoff)'
        return scalar _2ndbest_Int_l = var_est_mse3[2]
        return scalar _2ndbest_Int_l_show = -1 * var_est_mse3[2] + `=scalar(cutoff)'
        return scalar _2ndbest_mse = var_est_mse4[2]
        return scalar _2ndbest_est_Mhat = var_est_Mhat[2]
        return scalar _2ndbest_est_Bhat = var_est_Bhat[2]
        return scalar _2ndbest_est_DMB = var_est_DMB[2]

    restore

    // print the best q and Int
    local _best_q = _best_q
    local _best_Int_l_show = _best_Int_l_show
    local _best_Int_u_show = _best_Int_u_show
    local _best_mse = _best_mse
    
    #delimit ;
    dis as red ///
        _newline ///
        "--------------------------------------------------------------------------------" _newline ///
        "The Best q: `_best_q'"                                     _newline ///
        "The Bunching Interval: [`_best_Int_l_show', `_best_Int_u_show']." _newline ///
        "The Best MSE: `_best_mse'"  _newline ///
        "--------------------------------------------------------------------------------" _newline ///
        ;
    #delimit cr

    // print the 2nd best q and Int
    if "`second'" != "" {
        local _2ndbest_q = _2ndbest_q
        local _2ndbest_Int_l_show = _2ndbest_Int_l_show
        local _2ndbest_Int_u_show = _2ndbest_Int_u_show
        local _2ndbest_mse = _2ndbest_mse

        #delimit ;
        dis as red ///
            "--------------------------------------------------------------------------------" _newline ///
            "The 2nd Best q: `_2ndbest_q'"                              _newline ///
            "The Bunching Interval: [`_2ndbest_Int_l_show', `_2ndbest_Int_u_show']." _newline ///
            "The 2nd Best MSE: `_2ndbest_mse'"  _newline ///
            "--------------------------------------------------------------------------------" _newline ///
            ;
        #delimit cr
    }

    // print the M, B, and DMB
    if "`meqb'" != "" | "`beqm'" != "" {
        local _best_est_Mhat = _best_est_Mhat
        local _best_est_Bhat = _best_est_Bhat
        local _best_est_DMB = _best_est_DMB

        #delimit ;
        dis as red ///
            "--------------------------------------------------------------------------------" _newline ///
            "The Best Mhat: `_best_est_Mhat'"                          _newline ///
            "The Best Bhat: `_best_est_Bhat'"                          _newline ///
            "The Best DMB: `_best_est_DMB'"                            _newline ///
            "--------------------------------------------------------------------------------" _newline ///
            ;
        #delimit cr

        if "`second'" != "" {
            local _2ndbest_est_Mhat = _2ndbest_est_Mhat
            local _2ndbest_est_Bhat = _2ndbest_est_Bhat
            local _2ndbest_est_DMB = _2ndbest_est_DMB

            #delimit ;
            dis as red ///
                "--------------------------------------------------------------------------------" _newline ///
                "The 2nd Best Mhat: `_2ndbest_est_Mhat'"                  _newline ///
                "The 2nd Best Bhat: `_2ndbest_est_Bhat'"                  _newline ///
                "The 2nd Best DMB: `_2ndbest_est_DMB'"                    _newline ///
                "--------------------------------------------------------------------------------" _newline ///
                ;
            #delimit cr
        }
    }
}

*** re-estimate with the best q and Inn and gen predicts -----------------------
qui {

    * restore the bese q and Ints
    local q = _best_q
    local Int_l = _best_Int_l
    local Int_u = _best_Int_u

    if "`second'" != "" {
        dis as red "The 2nd best q and Ints are used."
        local q = _2ndbest_q
        local Int_l = _2ndbest_Int_l
        local Int_u = _2ndbest_Int_u
    }

    if `Int_u' == 0 & `Int_l' == 0 {
        cap drop _I_indicator_0
        gen _I_indicator_0 = (__basis_bin_diff == 0)
    }
    else {
        scalar _NUM_I_indicator = `Int_u' + `Int_l' + 1
        local _runner = -1 * `Int_l'
        forvalues i = 1/`=scalar(_NUM_I_indicator)' {
            cap drop _I_indicator_`i'
            gen _I_indicator_`i' = (__basis_bin_diff == `_runner')
            local _runner = `_runner' + 1
        }
    }

    forvalues power = 0/`q' {
        cap drop _power_freq_`power'
        gen _power_freq_`power' = __basis_bin^`power'
    }
    
    // est the MSE
    reg freq ///
        _power_freq_* ///
        `add_intger_var' ///
        _I_indicator_*
    
    // calculate counterfacutal freq_predict
    cap drop freq_predict
    predict freq_predict , xb
    forvalues i = 1/`=scalar(_NUM_I_indicator)' {
        cap drop _del_coef_I_`i'
        gen _del_coef_I_`i' = _b[_I_indicator_`i'] * _I_indicator_`i'
    }

    cap drop _del_coef_I_total
    cap drop freq_predict_adj
    cap drop _est_B
    cap drop _est_predict_freqsum
    egen _del_coef_I_total = rowtotal(_del_coef_I_*)
    gen freq_predict_adj = freq_predict - _del_coef_I_total
    egen _est_B = sum(_del_coef_I_total)
    egen _est_predict_freqsum = sum(cond(_del_coef_I_total==0,.,freq_predict_adj))

    // add vars for the dbm
    if "`meqb'" != "" | "`beqm'" != "" {
        // the actual - counterfactual
        cap drop _freq_diff_acf
        gen _freq_diff_acf = freq - freq_predict_adj

        // calculate _est_Mhat and _est_Bhat
        // Mhat is always positive
        // Bhat is always negative
        cap drop _est_Mhat
        cap drop _est_Bhat
        if "`meqb'" != "" {
            egen _est_Mhat = sum(cond((__basis_bin_diff >= -1 * `Int_l' & __basis_bin_diff <= 0) & _freq_diff_acf > 0, _freq_diff_acf, .))
            egen _est_Bhat = sum(cond((__basis_bin_diff > 0 & __basis_bin_diff <= `Int_u') & _freq_diff_acf < 0, _freq_diff_acf, .))

            gen _I_forMhat = ((__basis_bin_diff >= -1 * `Int_l' & __basis_bin_diff <= 0) & _freq_diff_acf > 0)
            gen _I_forBhat = ((__basis_bin_diff > 0 & __basis_bin_diff <= `Int_u') & _freq_diff_acf < 0)
        }
        else {
            egen _est_Mhat = sum(cond((__basis_bin_diff >= 0 & __basis_bin_diff <= `Int_u') & _freq_diff_acf > 0, _freq_diff_acf, .))
            egen _est_Bhat = sum(cond((__basis_bin_diff >= -1 * `Int_l' & __basis_bin_diff < 0) & _freq_diff_acf < 0, _freq_diff_acf, .))

            gen _I_forMhat = ((__basis_bin_diff >= 0 & __basis_bin_diff <= `Int_u') & _freq_diff_acf > 0)
            gen _I_forBhat = ((__basis_bin_diff >= -1 * `Int_l' & __basis_bin_diff < 0) & _freq_diff_acf < 0)
        }
    }

    // save _est_B and _est_b
    scalar _est_B = _est_B[1]
    scalar _est_predict_freqsum = _est_predict_freqsum[1]
    scalar _est_b = _est_B / (_est_predict_freqsum / _NUM_I_indicator)
    return scalar _est_B = _est_B[1]
    return scalar _est_b = _est_B / (_est_predict_freqsum / _NUM_I_indicator)
}

*** Bootstrapping --------------------------------------------------------------
qui {
    dis as red "Start Bootstrapping for SE of _est_b and _est_B..."

    * the bootstrapping __temp_restore.dta
    mat B_se_est = J(`=scalar(boottimes)',1,.)
    mat b_se_est = J(`=scalar(boottimes)',1,.)
    scalar _est_N = _N
    cap drop _I_within
    gen _I_within = (_del_coef_I_total != 0)
    bys _I_within: gen _merge_index = _n
    replace _merge_index = . if _I_within == 1
    drop _I_within
    sort __basis_bin
    qui save "__temp_restore.dta", replace

    if "`dots'" != "" {
        nois _dots 0, title(Bootstrapping SE) reps(`=scalar(boottimes)')
    }
    forvalues boot = 1/`=scalar(boottimes)' {
        use "__temp_restore.dta", clear

        // gen simulated freq
        preserve
            drop if _del_coef_I_total != 0
            gen _freq_diff = freq - freq_predict_adj
            keep _freq_diff
            bsample 
            ren _freq_diff _new_error
            gen _merge_index = _n
            save "__temp__errors.dta", replace
        restore
        merge m:1 _merge_index using "__temp__errors.dta" , nogen
        gen new_freq = cond(_new_error == ., freq, freq + _new_error)

        // new reg
        qui reg new_freq _power_freq_* `add_intger_var' _I_indicator_*
        predict _new_freq_predict , xb
        forvalues i = 1/`=scalar(_NUM_I_indicator)' {
            gen _new_del_coef_I_`i' = _b[_I_indicator_`i'] * _I_indicator_`i'
        }
        egen _new_del_coef_I_total = rowtotal(_new_del_coef_I_*)
        gen _new_freq_predict_adj = _new_freq_predict - _new_del_coef_I_total
        egen _new_est_B = sum(_new_del_coef_I_total)
        egen _new_est_predict_freqsum = sum(cond(_new_del_coef_I_total==0,.,_new_freq_predict_adj))

        // save _new_est_B and _new_est_b
        mat B_se_est[`boot',1] = _new_est_B[1]
        scalar _new_est_predict_freqsum = _est_predict_freqsum[1]
        scalar _new_est_b = _new_est_B[1] / (_new_est_predict_freqsum / _NUM_I_indicator)
        mat b_se_est[`boot',1] = _new_est_b

        *** The _dots prints
        if "`dots'" != "" {
            nois _dots `boot' 0
        }
    }

    // save the Bootstrapping results
    nois dis ""
    nois dis as red "Bootstrapping Done. Saving the results..."
    
    scalar drop _new_est_b
    scalar drop _new_est_predict_freqsum

    svmat B_se_est
    svmat b_se_est

    su B_se_est
    scalar _est_B_se = r(sd)
    return scalar _est_B_se = r(sd)

    su b_se_est
    scalar _est_b_se = r(sd)
    return scalar _est_b_se = r(sd)

    sort __basis_bin

    qui drop if __basis_bin == .
    drop _I_indicator_* _power_freq_* _del_coef_I_* _new_* _est_* ?_se_est* _merge_index new_freq

    // Save the parameters used in the estimation
    gen _best_q = _best_q
    gen _best_Int_l_show = _best_Int_l_show
    gen _best_Int_u_show = _best_Int_u_show
    gen _best_mse = _best_mse
    if "`second'" != "" {
        gen _2ndbest_q = _2ndbest_q
        gen _2ndbest_Int_l_show = _2ndbest_Int_l_show
        gen _2ndbest_Int_u_show = _2ndbest_Int_u_show
        gen _2ndbest_mse = _2ndbest_mse
        gen _parameter_used = "2nd best"
    }
    else {
        gen _parameter_used = "best"
    }

    gen _est_B = _est_B
    gen _est_b = _est_b
    gen _est_B_se = _est_B_se
    gen _est_b_se = _est_b_se

    *** Save the results into a dta file
    if "`dtasaving'" != "" {
        save "`dtasaving'", replace
        dis as red "Bootstrapping Results Saved."
    }

    *** Save the results anyway if the yvar specified
    if "`yvar'" != "" {
        save "__temp_bunching_results.dta", replace
    }

}

*** Plot the bunching results --------------------------------------------------
    * Default value of title, xtitle, ytitle
    if "`title'" == "" {
        local title "Title"
    }
    if "`xtitle'" == "" {
        local xtitle "X"
    }
    if "`ytitle'" == "" {
        local ytitle "Y"
    }

    if "`second'" != "" {
        local plot_xline_left = `=scalar(_2ndbest_Int_l_show)'
        local plot_xline_right = `=scalar(_2ndbest_Int_u_show)'
    }
    else {
        local plot_xline_left = `=scalar(_best_Int_l_show)'
        local plot_xline_right = `=scalar(_best_Int_u_show)'
    }

if "`graphsaving'" != "" {
    hall_bunching_plot , ///
            cutoff(`=scalar(cutoff)') ///
            left(`plot_xline_left') ///
            right(`plot_xline_right') ///
            coef_b1(`=scalar(_est_B)') ///
            coef_b2(`=scalar(_est_b)') ///
            se_b1(`=scalar(_est_B_se)') ///
            se_b2(`=scalar(_est_b_se)') ///
                title("`title'") ///
                xtitle("`xtitle'") ///
                ytitle("`ytitle'") ///
            n(`=scalar(_OBS)') ///
            `draw' ///
            `xlabel' ///
            saving(`graphsaving')
}

if "`graphsaving_cut'" != "" {
    local trunc_left = `cutoff' - `gcut_left'
    local trunc_right = `cutoff' + `gcut_right'
    keep if __basis_bin >= `trunc_left' & __basis_bin <= `trunc_right'

    hall_bunching_plot , ///
            cutoff(`=scalar(cutoff)') ///
            left(`plot_xline_left') ///
            right(`plot_xline_right') ///
            coef_b1(`=scalar(_est_B)') ///
            coef_b2(`=scalar(_est_b)') ///
            se_b1(`=scalar(_est_B_se)') ///
            se_b2(`=scalar(_est_b_se)') ///
                title("`title'") ///
                xtitle("`xtitle'") ///
                ytitle("`ytitle'") ///
            n(`=scalar(_OBS)') ///
            `draw' ///
            `xlabel_c' ///
            saving(`graphsaving_cut')
}

*** Bunching for yvar ----------------------------------------------------------
qui if "`yvar'" != "" {
    nois dis as red "Start Bunching for (`yvar')..." 
    use "__temp_datarestore.dta", clear

    *** IF and IN
    cap keep `if'
    cap keep `in'

    *** Data Preparation
    cap drop __basis_bin
    cap gen __basis_bin = `basis'
    cap drop __id
    cap gen __id = _n

    // gen indicator for within_interval
    if "`second'" != "" {
        local zlt_intl = `=scalar(_2ndbest_Int_l_show)'
        local zlt_intu = `=scalar(_2ndbest_Int_u_show)'
    }
    else {
        local zlt_intl = `=scalar(_best_Int_l_show)'
        local zlt_intu = `=scalar(_best_Int_u_show)'
    }
    scalar zlt_intl = `zlt_intl'
    scalar zlt_intu = `zlt_intu'

    // gen dummy for within_interval
    cap drop _within_interval
    gen _within_interval = (__basis_bin >= `zlt_intl' & __basis_bin <= `zlt_intu')

    // generate poly terms
    forvalues power = 0/`_best_q' {
        cap drop _power_freq_`power'
        gen _power_freq_`power' = __basis_bin^`power'
    }

    scalar _NUM_B_indicator = `zlt_intu' - `zlt_intl' + 1
    local _runner = `zlt_intl'
    forvalues i = 1/`=scalar(_NUM_B_indicator)' {
        cap drop _B_indicator_`i'
        gen _B_indicator_`i' = (__basis_bin == `_runner')
        local _runner = `_runner' + 1
    }

    // eq (7)
    reg `yvar' _power_freq_* _B_indicator_* , noconstant
    cap drop _resid
    cap drop _simu_esample
    predict _resid , residuals // 生成y的残差
    gen _simu_esample = (e(sample) == 1)
    save "__temp_restore_1.dta", replace

    // eq (8), the counterfactual y
    forvalues power = 0/`_best_q' {
        cap drop _yp_`power'
        gen _yp_`power' = _b[_power_freq_`power'] * _power_freq_`power'
    }
    cap drop _yp
    egen _yp = rowtotal(_yp_*)

    // eq (9), calculate ITT
    // merge with previous bunching results
    cap drop freq
    cap drop freq_predict_adj
    merge m:1 __basis_bin using "__temp_bunching_results.dta" ///
        , keepusing(freq freq_predict_adj) nogen
    
    cap drop _y_real_sum
    cap drop _y_real_mean
    cap drop _y_pred_mean
    cap drop c_real
    cap drop _y_pred_freq_pred
    bys __basis_bin: egen _y_real_sum = sum(`yvar') // 每个bin上的y_qta的真实值的和
    bys __basis_bin: egen _y_real_mean = mean(`yvar') // 每个bin上的y_qta的真实值的均值
    bys __basis_bin: egen _y_pred_mean = mean(_yp) // 每个bin上的y_qta的预测值的均值
    bys __basis_bin: gen c_real = _N // 每个bin上的企业数量的真实值
    gen _y_pred_freq_pred = _y_pred_mean * freq_predict_adj // 每个bin上y_qta的预测值的均值*预测的频率

    duplicates drop __basis_bin, force

    cap drop _ITT_1
    cap drop _ITT_2
    cap drop _ITT_3
    cap drop _ITT_4
    cap drop _ITT
    egen _ITT_1 = sum(cond(_within_interval == 1, _y_real_sum, .))
    egen _ITT_2 = sum(cond(_within_interval == 1, c_real, .))
    egen _ITT_3 = sum(cond(_within_interval == 1, _y_pred_freq_pred, .))
    egen _ITT_4 = sum(cond(_within_interval == 1, freq_predict_adj, .))
    gen _ITT = (_ITT_1 / _ITT_2) - (_ITT_3 / _ITT_4)
    scalar ITT_real = _ITT

    keep __basis_bin _y_real_mean _y_pred_mean
    save "__temp_restore_forplot.dta", replace

    *** bootstrapping the se of ITT
    dis as red "Start Bootstrapping for SE of ITT..."
    mat ITT_se_est = J(`=scalar(boottimes)',1,.)

    // 从对公式（7）的估计中抽取残差
    use "__temp_restore_1.dta", clear
        keep if _simu_esample == 1 & _within_interval == 0
        gen _simu_id = _n
        keep __id _simu_id _resid
    save "__temp_restore_2.dta", replace

    if "`dots'" != "" {
        nois _dots 0, title(Bootstrapping SE) reps(`=scalar(boottimes)')
    }
    forvalues boot = 1/`=scalar(boottimes)' {
        use  "__temp_restore_2.dta", clear
            keep _resid
            bsample
            gen _simu_id = _n
            ren _resid _simu_resid
        save "_temp_simu_errors.dta", replace

        use "__temp_restore_1.dta", clear
            merge 1:1 __id using "__temp_restore_2.dta", keepusing(_simu_id) nogen
            merge m:1 _simu_id using "_temp_simu_errors.dta", keepusing(_simu_resid) nogen

            // 生成重新组合的y
            cap drop _y_simu
            gen _y_simu = `yvar' + _simu_resid

            // 使用重新组的y重新估计公式（7）并计算ITT
            reg _y_simu _power_freq_* _B_indicator_* , noconstant
            
            // 计算公式（8），生成y的反事实估计量
            forvalues power = 0/`_best_q' {
                cap drop _yp_`power'
                gen _yp_`power' = _b[_power_freq_`power'] * _power_freq_`power'
            }
            egen _yp = rowtotal(_yp_*)

            // 根据公式（9），计算ITT
            // 和此前bunching中的结果合并
            cap drop freq
            cap drop freq_predict_adj
            merge m:1 __basis_bin using "__temp_bunching_results.dta" ///
                , keepusing(freq freq_predict_adj) nogen
            
            cap drop _y_real_sum
            cap drop _y_real_mean
            cap drop _y_pred_mean
            cap drop c_real
            cap drop _y_pred_freq_pred
            bys __basis_bin: egen _y_real_sum = sum(_y_simu) // 每个bin上的y_qta的真实值的和
            bys __basis_bin: egen _y_real_mean = mean(_y_simu) // 每个bin上的y_qta的真实值的均值
            bys __basis_bin: egen _y_pred_mean = mean(_yp) // 每个bin上的y_qta的预测值的均值
            bys __basis_bin: gen c_real = _N // 每个bin上的企业数量的真实值
            gen _y_pred_freq_pred = _y_pred_mean * freq_predict_adj // 每个bin上y_qta的预测值的均值*预测的频率

            duplicates drop __basis_bin, force

            cap drop _ITT_1
            cap drop _ITT_2
            cap drop _ITT_3
            cap drop _ITT_4
            cap drop _ITT
            egen _ITT_1 = sum(cond(_within_interval == 1, _y_real_sum, .))
            egen _ITT_2 = sum(cond(_within_interval == 1, c_real, .))
            egen _ITT_3 = sum(cond(_within_interval == 1, _y_pred_freq_pred, .))
            egen _ITT_4 = sum(cond(_within_interval == 1, freq_predict_adj, .))
            gen _ITT = (_ITT_1 / _ITT_2) - (_ITT_3 / _ITT_4)
            scalar ITT = _ITT

            mat ITT_se_est[`boot',1] = ITT
        
        *** The _dots prints
        if "`dots'" != "" {
            nois _dots `boot' 0
        }
    }

    svmat ITT_se_est
    su ITT_se_est
    scalar _est_ITT_se = r(sd)

    *** 计算t
    local t_value = `=scalar(ITT_real)' / `=scalar(_est_ITT_se)'
    scalar t_value = `t_value'
    local t_value_display: dis %24.3f t_value
    local t_value_display: dis subinstr("`t_value_display'"," ","",.)

    *** Print the results
    #delimit ;
    nois dis as red ///
        _newline ///
        "--------------------------------------------------------------------------------" _newline ///
        "The Effect of Bunching on `yvar'"                          _newline ///
        "The Bunching Interval: [`zlt_intl', `zlt_intu']"           _newline ///
        "Cutoff: `cutoff'"                                          _newline ///
        "ITT : `=scalar(ITT_real)'"                                 _newline ///
        "SE(ITT): `=scalar(_est_ITT_se)'"                           _newline ///
		"t: `t_value_display'" _newline ///
        "--------------------------------------------------------------------------------" _newline ///
        _newline ;
    #delimit cr

    *** PLOT Graph-Y------------------------------------------------------------
    if "`graphsaving_y'" != "" {
        use "__temp_restore_forplot.dta", clear
        duplicates drop __basis_bin , force
        sort __basis_bin

        local ITT: dis %24.3f ITT_real
        local ITT: dis subinstr("`ITT'"," ","",.)
        local ITT_se: dis %24.3f _est_ITT_se
        local ITT_se: dis subinstr("`ITT_se'"," ","",.)

        local _sig_starts = ""
        if ITT_real - 1.6449 *  _est_ITT_se > 0 | ITT_real + 1.6449 *  _est_ITT_se < 0 {
            local _sig_starts = "*"
        }
        if ITT_real - 1.96 *  _est_ITT_se > 0 | ITT_real + 1.96 *  _est_ITT_se < 0 {
            local _sig_starts = "**"
        }
        if ITT_real - 2.5758 *  _est_ITT_se > 0 | ITT_real + 2.5758 *  _est_ITT_se < 0 {
            local _sig_starts = "***"
        }

        * font - Chinese and English
        //local font_ch `"fontface "SourceHanSerifCN-Regular":"'
        local font_ch `"fontface "times":"'
        local font_en `"fontface "times":"'

        tw ///
            (line _y_real_mean __basis_bin, lc("40 133 169") lw(medium) ) ///
            (scatter _y_real_mean __basis_bin, msize(tiny) mcolor("40 133 169") ) ///
            (line _y_pred_mean __basis_bin, lc("187 30 56") lw(medthick) ) ///
            , ///
            title(`"{`font_en' `title_y'}"') ///
            xline(`=scalar(cutoff)' , lc(gray%50) lp(solid)) ///
            xline(`=scalar(zlt_intl)' , lc(gray%50) lp(dash)) ///
            xline(`=scalar(zlt_intu)' , lc(gray%50) lp(dash)) ///
            xlabel(, nogrid angle(90) ) ///
            `xlabel' ///
            ylabel(, nogrid format(%9.2fc)) ///
            xtitle(`"{`font_ch' `xtitle_y'}"') ///
            ytitle(`"{`font_ch' `ytitle_y'}"') ///
            legend(off) ///
            plotregion(margin(0 0 0 0) lalign(center) lc(black)) ///
            graphregion(color(white)) ///
            note("ITT: `ITT'`_sig_starts' (`ITT_se');  t: `t_value_display'") /// 
            `draw' ///
            saving("`graphsaving_y'", replace)
    } // end of Graph-Y

    *** PLOT Graph-Y-Cut -------------------------------------------------------
    if "`graphsaving_y_cut'" != "" {
        use "__temp_restore_forplot.dta", clear
        duplicates drop __basis_bin , force
        sort __basis_bin

        local ITT: dis %24.3f ITT_real
        local ITT: dis subinstr("`ITT'"," ","",.)
        local ITT_se: dis %24.3f _est_ITT_se
        local ITT_se: dis subinstr("`ITT_se'"," ","",.)

        local _sig_starts = ""
        if ITT_real - 1.6449 *  _est_ITT_se > 0 | ITT_real + 1.6449 *  _est_ITT_se < 0 {
            local _sig_starts = "*"
        }
        if ITT_real - 1.96 *  _est_ITT_se > 0 | ITT_real + 1.96 *  _est_ITT_se < 0 {
            local _sig_starts = "**"
        }
        if ITT_real - 2.5758 *  _est_ITT_se > 0 | ITT_real + 2.5758 *  _est_ITT_se < 0 {
            local _sig_starts = "***"
        }

        * font - Chinese and English
        //local font_ch `"fontface "SourceHanSerifCN-Regular":"'
        local font_ch `"fontface "times":"'
        local font_en `"fontface "times":"'

        if "`gycut_left'" == "" {
            local gycut_left = 30
            nois dis as red "gycut_left is not specified. set to 30."
        }
        if "`gycut_right'" == "" {
            local gycut_right = 30
            nois dis as red "gycut_right is not specified. set to 30."
        }

        local trunc_left = `cutoff' - `gycut_left'
        local trunc_right = `cutoff' + `gycut_right'

        tw ///
            (line _y_real_mean __basis_bin if __basis_bin >= `trunc_left' & __basis_bin <= `trunc_right', lc("40 133 169") lw(medium) ) ///
            (scatter _y_real_mean __basis_bin if __basis_bin >= `trunc_left' & __basis_bin <= `trunc_right', msize(tiny) mcolor("40 133 169") ) ///
            (line _y_pred_mean __basis_bin if __basis_bin >= `trunc_left' & __basis_bin <= `trunc_right', lc("187 30 56") lw(medthick) ) ///
            , ///
            title(`"{`font_en' `title_y'}"') ///
            xline(`=scalar(cutoff)' , lc(gray%50) lp(solid)) ///
            xline(`=scalar(zlt_intl)' , lc(gray%50) lp(dash)) ///
            xline(`=scalar(zlt_intu)' , lc(gray%50) lp(dash)) ///
            xlabel(, nogrid angle(90)) ///
            `xlabel_c' ///
            ylabel(, nogrid format(%9.2fc)) ///
            xtitle(`"{`font_ch' `xtitle_y'}"') ///
            ytitle(`"{`font_ch' `ytitle_y'}"') ///
            legend(off) ///
            plotregion(margin(0 0 0 0) lalign(center) lc(black)) ///
            graphregion(color(white)) ///
            note("ITT: `ITT'`_sig_starts' (`ITT_se');  t: `t_value_display'") ///
            `draw' ///
            saving("`graphsaving_y_cut'", replace)
    
    } // end of Graph-Y-Cut

} // end of yvar

*** Restore data ---------------------------------------------------------------
qui use "__temp_datarestore.dta", clear
    cap rm "__temp_restore.dta"
    cap rm "__temp__errors.dta"
    cap rm "__temp_datarestore.dta"
    cap rm "__temp_bunching_results.dta"

    cap rm "__temp_restore_1.dta"
    cap rm "__temp_restore_2.dta"
    cap rm "__temp_restore_forplot.dta"
    cap rm "_temp_simu_errors.dta"

*** Clear related scalars in case of re-run ------------------------------------
    clean_my_scalars 1

end // end of main program *****************************************************

*** Program: hall_bunching_plot ------------------------------------------------
cap program drop hall_bunching_plot
program define hall_bunching_plot
    syntax , Cutoff(real) left(real) right(real) ///
        coef_b1(real) coef_b2(real) se_b1(real) se_b2(real) ///
        N(real) saving(string) ///
        [title(string) xtitle(string) ytitle(string)] ///
        [nodraw] [xlabel(passthru)]

    * display format of coef and se
    local coef_b1 : dis %24.3f `coef_b1'
    local coef_b1 : dis subinstr("`coef_b1'"," ","",.)
    local coef_b2 : dis %24.3f `coef_b2'
    local coef_b2 : dis subinstr("`coef_b2'"," ","",.)
    local se_b1 : dis %24.3f `se_b1'
    local se_b1 : dis subinstr("`se_b1'"," ","",.)
    local se_b2 : dis %24.3f `se_b2'
    local se_b2 : dis subinstr("`se_b2'"," ","",.)

    * font - Chinese and English
    //local font_ch `"fontface "SourceHanSerifCN-Regular":"'
    local font_ch `"fontface "times":"'
    local font_en `"fontface "times":"'

    * significance stars
    local _sig_starts = ""
    if `coef_b2' - 1.6449 * `se_b2' > 0 | `coef_b2' + 1.6449 * `se_b2' < 0 {
        local _sig_starts = "*"
    }
    if `coef_b2' - 1.96 * `se_b2' > 0 | `coef_b2' + 1.96 * `se_b2' < 0 {
        local _sig_starts = "**"
    }
    if `coef_b2' - 2.5758 * `se_b2' > 0 | `coef_b2' + 2.5758 * `se_b2' < 0 {
        local _sig_starts = "***"
    }

    * Plot
    tw ///
        (line freq __basis_bin, lc("40 133 169") lw(medium) ) ///
        (scatter freq __basis_bin, msize(tiny) mcolor("40 133 169")) ///
        (line freq_predict_adj __basis_bin, lc("187 30 56") lw(medthick)) ///
        , ///
        title(`"{`font_en' `title'}"') ///
        xline(`cutoff' , lc(gray%50) lp(solid)) ///
        xline(`left' , lc(gray%50) lp(dash)) ///
        xline(`right' , lc(gray%50) lp(dash)) ///
        xlabel(, nogrid angle(90)) ///
        `xlabel' ///
        ylabel(, nogrid format(%9.2fc)) ///
        xtitle(`"{`font_ch' `xtitle'}"') ///
        ytitle(`"{`font_ch' `ytitle'}"') ///
        legend(off) ///
        plotregion(margin(0 0 0 0) lalign(center) lc(black)) ///
        graphregion(color(white)) ///
        note("N = `n'; Interval: [`left', `right']" "B = `coef_b1'`_sig_starts' (`se_b1');  b = `coef_b2'`_sig_starts' (`se_b2')") ///
        `draw' ///
        saving("`saving'", replace)

end

*** Program: clean_my_scalars --------------------------------------------------
cap program drop clean_my_scalars
program define clean_my_scalars
    syntax anything
    local sca_names ///
        cutoff qmax intu intl boottimes _OBS ///
        _best_q _best_Int_u _best_Int_l ///
        _best_Int_u_show _best_Int_l_show _best_mse ///
        _2ndbest_q _2ndbest_Int_u _2ndbest_Int_l ///
        _2ndbest_Int_u_show _2ndbest_Int_l_show _2ndbest_mse ///
        _NUM_I_indicator _est_B _est_predict_freqsum ///
        _est_b _est_N _new_est_predict_freqsum ///
        _new_est_b _est_B_se _est_b_se zlt_intl zlt_intu _NUM_B_indicator ///
        ITT_real ITT_est_ITT_se ///
        t_value _est_ITT_se ITT ///
        _best_est_DMB _best_est_Bhat _best_est_Mhat ///
        _2ndbest_est_DMB _2ndbest_est_Bhat _2ndbest_est_Mhat
    
    foreach sca in `sca_names' {
        cap scalar drop `sca'
    }
end