*! version 1.2.0, Hall, 5nov2024
	// add directions
* version 1.1.1, Hall, 8oct2024
    // add up/dn option
* version 1.1.0, Hall, 7oct2024
    // use _gm_edit
* version 1.0.0, Hall, 5oct2024

*! Xinya HAO (Hall), CityUHK
* lisshall717@gmail.com
* add asterisk brackets to the current graph

cap program drop gradd_ab
program define gradd_ab
	
	version 12.0
	
	syntax [anything] , ///
		root1(string) root2(string) /// root1(x1 y1) root2(x2 y2)
		[ ///
			Direction(string) ///		Direction of the plot
			sig(string) ///       		Stars or texts
            gname(string) ///			Name of the Graph
			gap(real 200) ///			Gap between root-ends and lines
			len(real 500) ///			Length of the lines
			astgap(real 100) ///		Gap between sig-texts and the line
			color(string) ///			Color of the lines
			adlo(int 1) ///				The n-th plot
		]

	*** default values ---------------------------------------------------------
	if "`direction'" == "" {
		local direction "up"
	}
	
	if "`sig'" == "" {
		local sig ""
	}
	
	if "`gname'" == "" {
        local gname "Graph"
    }
	
	if "`color'" == "" {
		local color "black"
	}

	*** check direction --------------------------------------------------------
	if ///
		"`direction'" != "up" & "`direction'" != "down" & ///
		"`direction'" != "left" & "`direction'" != "right" & {
			dis as error "Wrong Specification about the Direction."
			exit 999
	}
	
    *** varlist ----------------------------------------------------------------
	local x1: word 1 of `root1'
	local y1: word 2 of `root1'
	local x2: word 1 of `root2'
	local y2: word 2 of `root2'
	
	*** ADLOs
	local adlo_1 = 3*`adlo'-2
	local adlo_2 = `adlo_1' + 1
	local adlo_3 = `adlo_1' + 2
	
    *** UP Plot ----------------------------------------------------------------
    if "`direction'" == "up" {
	
		* positions
		local y1_start = `y1' + `gap'
		local y2_start = `y2' + `gap'
		local _v_end   = max(`y1_start' + `len', `y2_start' + `len')
		local ast_x    = (`x1' + `x2')/2
		local ast_y    = `_v_end' + `astgap'
		
		* left v
        _add_line 1, gname(`gname') ///
            x1(`x1') y1(`y1_start') x2(`x1') y2(`_v_end') adlo(`adlo_1') color(`color')
        
        * right v
        _add_line 1, gname(`gname') ///
            x1(`x2') y1(`y2_start') x2(`x2') y2(`_v_end') adlo(`adlo_2') color(`color')
        
        * line horizontal
        _add_line 1, gname(`gname') ///
            x1(`x1') y1(`_v_end') x2(`x2') y2(`_v_end') adlo(`adlo_3') color(`color')
        
        * add asterisks
        _add_asterisks 1, gname(`gname') ///
            x(`ast_x') y(`ast_y') adlo(`adlo') text(`sig') color(`color')
        
        .`gname'.drawgraph
	}
    
    *** DOWN Plot --------------------------------------------------------------
    if "`direction'" == "down" {
		
		* positions
		local y1_start = `y1' - `gap'
		local y2_start = `y2' - `gap'
		local _v_end   = min(`y1_start' - `len', `y2_start' - `len')
		local ast_x    = (`x1' + `x2')/2
		local ast_y    = `_v_end' - `astgap'
		
		* left v
        _add_line 1, gname(`gname') ///
            x1(`x1') y1(`y1_start') x2(`x1') y2(`_v_end') adlo(`adlo_1') color(`color')
        
        * right v
        _add_line 1, gname(`gname') ///
            x1(`x2') y1(`y2_start') x2(`x2') y2(`_v_end') adlo(`adlo_2') color(`color')
        
        * line horizontal
        _add_line 1, gname(`gname') ///
            x1(`x1') y1(`_v_end') x2(`x2') y2(`_v_end') adlo(`adlo_3') color(`color')
        
        * add asterisks
        _add_asterisks 1, gname(`gname') ///
            x(`ast_x') y(`ast_y') adlo(`adlo') text(`sig') color(`color')
        
        .`gname'.drawgraph
	}
	
	*** Left Plot --------------------------------------------------------------
    if "`direction'" == "left" {
		
		* positions
		local x1_start = `x1' - `gap'
		local x2_start = `x2' - `gap'
		local _h_end   = min(`x1_start' - `len', `x2_start' - `len')
		local ast_x    = `_h_end' - `astgap'
		local ast_y    = (`y1' + `y2')/2
		
		* below h
        _add_line 1, gname(`gname') ///
            x1(`x1_start') y1(`y1') x2(`_h_end') y2(`y1') adlo(`adlo_1') color(`color')
        
        * right v
        _add_line 1, gname(`gname') ///
            x1(`x2_start') y1(`y2') x2(`_h_end') y2(`y2') adlo(`adlo_2') color(`color')
        
        * line horizontal
        _add_line 1, gname(`gname') ///
            x1(`_h_end') y1(`y1') x2(`_h_end') y2(`y2') adlo(`adlo_3') color(`color')
        
        * add asterisks
        _add_asterisks 1, gname(`gname') ///
            x(`ast_x') y(`ast_y') adlo(`adlo') text(`sig') color(`color') ver(1)
        
        .`gname'.drawgraph
	}
	
	*** right Plot --------------------------------------------------------------
    if "`direction'" == "right" {
		
		* positions
		local x1_start = `x1' + `gap'
		local x2_start = `x2' + `gap'
		local _h_end   = max(`x1_start' + `len', `x2_start' + `len')
		local ast_x    = `_h_end' + `astgap'
		local ast_y    = (`y1' + `y2')/2
		
		* below h
        _add_line 1, gname(`gname') ///
            x1(`x1_start') y1(`y1') x2(`_h_end') y2(`y1') adlo(`adlo_1') color(`color')
        
        * right v
        _add_line 1, gname(`gname') ///
            x1(`x2_start') y1(`y2') x2(`_h_end') y2(`y2') adlo(`adlo_2') color(`color')
        
        * line horizontal
        _add_line 1, gname(`gname') ///
            x1(`_h_end') y1(`y1') x2(`_h_end') y2(`y2') adlo(`adlo_3') color(`color')
        
        * add asterisks
        _add_asterisks 1, gname(`gname') ///
            x(`ast_x') y(`ast_y') adlo(`adlo') text(`sig') color(`color') ver(1)
        
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
			ver(real 0) ///
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
	
	if `ver' != 0 {
		_gm_edit .`gname'.plotregion1.added_text[`adlo']._set_orientation vertical
	}
	
end
