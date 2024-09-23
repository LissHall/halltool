*! version 1.0.0, Hall, 23jul2024

* path
global png_fdr "/halltool/pngs"

*** Hall's Hue Collections - Plot
colorpalette hallshue, ///
	title("Hall's Hue Collection") ///
	rows(6) ///
	gr(subtitle("Xinya Hao (Hall), CityUHK") ///
	note("{it:Source: Hall's STATA Toolbox}" "{it:https://github.com/LissHall/halltool}"))

graph export "$png_fdr/hues.png", replace
	

*** examples using the scheme-hall.scheme, same graph (codes) from:
// https://www.stata.com/new-in-stata/new-graph-style/

* eg1 - scatter
sysuse auto, clear
twoway ///
    (scatter price mpg) (lowess price mpg), subtitle("Price vs. MPG") ///
    scheme(hall) plotregion(lalign(outside))
graph export "$png_fdr/eg1.png",replace

* eg2 - CIs (ci & ci2)
sysuse auto, clear
tw ///
    (lfitci price rep78 if rep <= 3, psty(ci)) ///
    (lfitci price rep78 if rep >= 3, psty(ci2) lc(black)) ///
    , scheme(hall)  plotregion(lalign(outside))
graph export "$png_fdr/eg2.png",replace

* eg3 - CI using p#area
tw ///
    lfitci price rep78, psty(p6area) lc(black) ///
    , scheme(hall)  plotregion(lalign(outside))
graph export "$png_fdr/eg3.png",replace

* eg4 - margin plot (line, CIs, and scatter)
webuse nhanes2, clear
	qui logistic highbp sex##agegrp##c.bmi
	qui margins sex, at(bmi=(10(5)65))
	marginsplot , scheme(hall) plotregion(lalign(outside))
graph export "$png_fdr/eg4.png",replace

* eg5 - scatter by
sysuse lifeexp, clear
	scatter lexp gnppc, by(region, total) plotregion(lalign(outside)) scheme(hall)
graph export "$png_fdr/eg5.png",replace

* eg6 - bar
sysuse educ99gdp, clear
generate total = private + public	
graph hbar (asis) public private, ///
    over(country, sort(total) descending) stack  ///
    title("Spending on tertiary education as % of GDP, 1999", span pos(11)) ///
    note("Source: OECD, Education at a Glance 2002", span) ///
    scheme(hall) plotregion(lalign(center)) ylab(, nogmin)
graph export "$png_fdr/eg6.png",replace

