*! version 1.1.1, Hall, 8oct2024..
    // add up/dn option
* version 1.1.0, Hall, 7oct2024
    // use _gm_edit
* version 1.0.0, Hall, 5oct2024

* Xinya HAO (Hall), CityUHK
* lisshall717@gmail.com
* add asterisk brackets to the current graph

cap program drop gradd_ab
program define gradd_ab
	
	version 12.0
	
	syntax varlist(min=2 max=2) , ///
		left(real) right(real) ///
		sig(string) ///
		[ ///
            gname(string) ///
			gap(real 200) /// 1st var for error_bar; 2nd var for x-axis
			len(real 500) ///
			astgap(real 100) ///
			color(string) ///
			adlo(int 1) ///
			up dn ///
		]

	* default
	if "`color'" == "" {
		local color "black"
	}
	
	if "`astgap'" == "" {
		local astgap = `gap'/2
	}

    if "`gname'" == "" {
        local gname "Graph"
    }
	
	* check direction
	if "`up'" == "" & "`dn'" == "" {
        local up "up"
    }

    if "`up'" != "" & "`dn'" != "" {
        di as err "up and dn cannot be both specified."
        exit 999
    }

    *** varlist ----------------------------------------------------------------
	local _var_eb : word 1 of `varlist'
	local _x_var  : word 2 of `varlist'
	
    *** UP Plot ----------------------------------------------------------------
    if "`up'" != "" {

        * _v_left_start and _v_right_start
        qui su `_var_eb' if `_x_var' == `left' , meanonly
        local _v_left_start = `r(mean)' + `gap'
        qui su `_var_eb' if `_x_var' == `right' , meanonly
        local _v_right_start = `r(mean)' + `gap'
        
        * _v_end
        local _v_end = max(`_v_left_start' + `len' , `_v_right_start' + `len')
        
        * postion of asterisks
        local ast_x = (`left' + `right')/2
        local ast_y = `_v_end' + `astgap'
    }
    
    *** DOWN Plot --------------------------------------------------------------
    if "`dn'" != "" {

        * _v_left_start and _v_right_start
        qui su `_var_eb' if `_x_var' == `left' , meanonly
        local _v_left_start = `r(mean)' - `gap'
        qui su `_var_eb' if `_x_var' == `right' , meanonly
        local _v_right_start = `r(mean)' - `gap'
        
        * _v_end
        local _v_end = min(`_v_left_start' - `len' , `_v_right_start' - `len')
        
        * postion of asterisks
        local ast_x = (`left' + `right')/2
        local ast_y = `_v_end' - `astgap'
    }

    *** PLOT UP | DN -----------------------------------------------------------
	* ADLOs
	local adlo_1 = 2*`adlo'-1
	local adlo_2 = `adlo_1' + 1
	local adlo_3 = `adlo_1' + 2
	
	*** PLOT
    if "`up'" != "" | "`dn'" != "" {
		
        * left v
        _add_line 1, gname(`gname') ///
            x1(`left') y1(`_v_left_start') x2(`left') y2(`_v_end') adlo(`adlo_1') color(`color')
        
        * right v
        _add_line 1, gname(`gname') ///
            x1(`right') y1(`_v_right_start') x2(`right') y2(`_v_end') adlo(`adlo_2') color(`color')
        
        * line horizontal
        _add_line 1, gname(`gname') ///
            x1(`left') y1(`_v_end') x2(`right') y2(`_v_end') adlo(`adlo_3') color(`color')
        
        * add asterisks
        _add_asterisks 1, gname(`gname') ///
            x(`ast_x') y(`ast_y') adlo(`adlo') text(`sig') color(`color')
        
        .`gname'.drawgraph
    }



end

//cap program drop _add_line //-------------------------------------------------
program define _add_line
	
	syntax anything, gname(string) ///
        x1(real) y1(real) x2(real) y2(real) adlo(int) ///
		[ ///
			color(string) ///
		]
	
	_gm_edit .`gname'.plotregion1.AddLine added_lines editor `x1' `y1' `x2' `y2'
	_gm_edit .`gname'.plotregion1.added_lines_new = `adlo'
	_gm_edit .`gname'.plotregion1.added_lines_rec = `adlo'
	_gm_edit .`gname'.plotregion1.added_lines[`adlo'].style.editstyle  ///
		linestyle( ///
			width(sztype(relative) val(.3) allow_pct(1)) ///
			color(`color') pattern(solid) align(outside)) ///
		headstyle( ///
			symbol(circle) ///
			linestyle( ///
				width(sztype(relative) val(0.2) allow_pct(1)) ///
				color(`color') pattern(solid) align(inside)) ///
			fillcolor(`color') ///
			size(sztype(relative) val(1.95) allow_pct(1)) ///
			angle(horizontal) ///
			symangle(zero) ///
			backsymbol(none) ///
			backline( ///
				width(sztype(relative) val(.2) allow_pct(1)) ///
				color(`color') pattern(solid) align(inside)) ///
			backcolor(`color') ///
			backsize(sztype(relative) val(0) allow_pct(1)) ///
			backangle(stdarrow) ///
			backsymangle(zero)) ///
		headpos(both) ///
		editcopy
end


//cap program drop _add_asterisks //--------------------------------------------
program define _add_asterisks

	syntax anything, gname(string) /// 
        x(real) y(real) adlo(int) text(string) ///
		[ ///
			color(string) ///
		]
	
	_gm_edit .`gname'.plotregion1.AddTextBox added_text editor `y' `x'
	_gm_edit .`gname'.plotregion1.added_text_new = `adlo'
	_gm_edit .`gname'.plotregion1.added_text_rec = `adlo'
	_gm_edit .`gname'.plotregion1.added_text[`adlo'].style.editstyle  ///
		angle(default) ///
		size( ///
			sztype(relative) val(3.5) allow_pct(1)) ///
		color(`color') horizontal(default) vertical(middle) ///
		margin( ///
			gleft(sztype(relative) val(0) allow_pct(1)) ///
			gright(sztype(relative) val(0) allow_pct(1)) ///
			gtop(sztype(relative) val(0) allow_pct(1)) ///
			gbottom(sztype(relative) val(0) allow_pct(1))) ///
		linegap( ///
			sztype(relative) val(0) allow_pct(1)) ///
		drawbox(no) ///
		boxmargin( ///
			gleft(sztype(relative) val(0) allow_pct(1)) ///
			gright(sztype(relative) val(0) allow_pct(1)) ///
			gtop(sztype(relative) val(0) allow_pct(1)) ///
			gbottom(sztype(relative) val(0) allow_pct(1))) ///
		fillcolor(bluishgray) ///
		linestyle( ///
			width(sztype(relative) val(.2) allow_pct(1)) ///
			color(`color') pattern(solid) align(inside)) ///
		box_alignment(center) editcopy
	
	_gm_edit .`gname'.plotregion1.added_text[`adlo'].text = {}
	_gm_edit .`gname'.plotregion1.added_text[`adlo'].text.Arrpush `text'
end
