
* add asterisk brackets to the current graph
graph close _all
sysuse auto, clear
    
    *** get sig stars
    replace price = price * 1.2 if foreign == 1
    ttest price, by(foreign)
    get_sig_stars `r(p)'
    global sig_stars: dis "`r(_sig_stars)'"

    *** twoway bar plot
    collapse (mean) price_m = price (sd) price_sd = price (count) n = price, by(foreign)
    gen errorbar_h = price_m + invttail(n-1,0.025)*(price_sd / sqrt(n))
    gen errorbar_l = price_m - invttail(n-1,0.025)*(price_sd / sqrt(n))
        
    tw ///
        (bar price_m foreign, barw(0.5)) ///
        (rcap errorbar_h errorbar_l foreign) ///
        , ///
        ylabel(2000(1000)11000) ///
        legend(off) ///
        xlabel(0 "Domestic" 1 "Foreign")
	
	graph save b1.gph, replace
        
    *** Add asterisk brackets --------------------------------------------------
	qui su errorbar_h in 1, mean
	local y1 = r(mean)
	qui su errorbar_h in 2, mean
	local y2 = r(mean)
	
    gradd_ab , root1(0 `y1') root2(1 `y2') sig($sig_stars)
	
	graph save b2.gph, replace

    * add asterisk brackets >>> Down side --------------------------------------
    qui su errorbar_l in 1, mean
	local y1 = r(mean)
	qui su errorbar_l in 2, mean
	local y2 = r(mean)
	
    gradd_ab , root1(0 `y1') root2(1 `y2') sig($sig_stars) ///
		d(down) astgap(150) adlo(2) color(orange)

    *** Save the graph
    graph combine b1.gph b2.gph, ///
        col(2)
    graph export _eg_gradd_ab.png, replace

    rm b1.gph
    rm b2.gph
