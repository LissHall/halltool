
* add asterisk brackets to the current graph

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
        
    *** Add asterisk brackets
    gradd_ab errorbar_h foreign, left(0) right(1) sig($sig_stars)

    * add asterisk brackets >>> Down side
    gradd_ab errorbar_l foreign, left(0) right(1) sig($sig_stars) dn
    
    *** Save the graph
    graph save b2.gph, replace
    graph combine b1.gph b2.gph, ///
        col(2)
    graph export _eg_gradd_ab.png, replace

    rm b1.gph
    rm b2.gph

