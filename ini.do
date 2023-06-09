/*******************************************************************************
Author : Liss Hall
Email  : xxx@gmail.com
Ver    : 3.0
Date   : 2023-05-03
Des    : Describe what these codes do.

Version History
    V2.0   2023-01-01: Add ....... Add ......  Add ......  Add ......  Add .....
                       and Remove ......
    V1.0   2022-12-31: First Edition. Description of your codes. Description of 
                       your codes. Description of your codes. Description of 
                       your codes.

*******************************************************************************/
*>>>>>>>>>>>>>>>>>>>> Set the Directories, Data, and Macro
{
    *** INI
    clear
    macro drop _all
    mat drop _all
    set more off
    cap log close _all
    set seed 12345

    *** Stata version control
    version 17.0

    *** Path
    global p_project ""
        global p_data "$p_project/Data"
            global p_raw "$p_data/Raw"
            global p_clean "$p_data/Clean"
        
        // All result files are saved to:
        global p_result "$p_project/Results"
            global p_plots "$p_result/Plots"
        
        // Add ado path
        cap adopath + "$p_project/Programs"


    cd "$p_result"

    *** Macro define - the switches for code parts
        // 1 - will excute
        // 0 - will skip
    global SWITCH_Clean == 1    // gen clean data
    global SWITCH_ANA == 1      // do regressions
    global SWITCH_Plot == 1     // visualizations
        // This is also a table of content of your code
}
********************************************************************************
*** Dependency Checking
// Check and auto install the dependent packages
// need whichdep
cap which whichdep
if _rc == 0 {
    whichdep ///
        winsor2 ///
        reghdfe ///
        outreg2 ///
        ppmlhdfe ///  <<--- Add packages used here
        , net(dm79.pkg "http://www.stata.com/stb/stb56")
}


********************************************************************************
*** Programs
{
    // Put your self-defined programs here
}
    
********************************************************************************
********************   Part 1 - Data cleaning
if $SWITCH_Clean == 0 { // 0 - will be skipped
    // your data cleaning codes
}

********************************************************************************
********************   Part 2 - Data Analysis
if $SWITCH_ANA == 1 {
    // your analysis steps
}

********************************************************************************
********************   Part 3 - Visualization
if $SWITCH_Plot = 1 {
    // your plots/visualization steps
}


* EOF