{smcl}
{* *! version 1.2.0, Nov 5'2024}{...}
{vieweralsosee "halltool" "help halltool"}{...}
{viewerjumpto "Authors" "gradd_ab##contact"}{...}
{hline}
Command from {help halltool:Hall's Stata Toolbox}. help for {hi:gradd_ab}{right: ({browse "https://econometrics.club/":blog})}
version 1.2.0, 5nov2024.{right: ({browse "https://github.com/LissHall/halltool":github})}
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:gradd_ab} {hline 2}}Add asterisk brackets to a graph.{p_end}
{p2colreset}{...}

	      {it:y}
	      {c |}
	      {c |}         sig(string)
	      {c |}    {c TLC}{hline 10}{c TRC}
	      {c |}    {c |}          {c |}
	      {c |}    {c |}          {c |}root2(x2,y2)
	      {c |}    {c |}        {c TLC}{hline 3}{c TRC}
	      {c |}    {c |}root(x1,y1) {c |}
	      {c |}  {c TLC}{hline 3}{c TRC}      {c |}   {c |}
	      {c |}  {c |}   {c |}      {c |}   {c |}
	      {c |}  {c |}   {c |}      {c |}   {c |}
	      {c |}  {c |}   {c |}      {c |}   {c |}
	      {c BLC}{hline 2}{c BT}{hline 3}{c BT}{hline 6}{c BT}{hline 3}{c BT}{hline 9} {it:x}
		 First      Second    {bf:...}
		 group       group
{title:Syntax}

{p 4 19 2}
{cmdab:gradd_ab} 
,
{cmd:root1(}x1 y1{cmd:)}
{cmd:root2(}x2 y2{cmd:)}
[{help gradd_ab##options:options}]

{title:Required Options}

    {phang}{cmd:root1(x1 y1)}: The first root of the graph. {break}
        The coordinates are in the graph coordinate system. {break}
        For up/down graphs, the first root is the left line. {break}
        For left/right graph, the first root is the below line. 
    {p_end}
    {phang}{cmd:root2(x2 y2)}: The second root of the graph. {break}
    {p_end}
    {phang}{cmd:x1 y1 x2 y2}: real numbers{p_end}

{marker options}{...}
{title:Options}
    {phang}{cmdab:D:}{cmd:irection(}up | down | left | right{cmd:)}: The direction of the graph. {break}
        The 'direction' is the relative position of the closed end of the asterisk bracket.
    {p_end}
    {phang}{cmd:sig(}string{cmd:)}: Texts indicating the significance level. (or any texts) {break}
        For example: "***" or "p=xxx".
    {p_end}
    {phang}{cmd:gname(}string{cmd:)}: The name of the graph.
    {p_end}
    {phang}{cmd:gap(}real 200{cmd:)}: The gap between the brackets and the root points.
    {p_end}
    {phang}{cmd:len(}real 500{cmd:)}: The length of the brackets.
    {p_end}
    {phang}{cmd:astgap(}real 100{cmd:)}: The gap between the asterisk brackets and the text.
    {p_end}
    {phang}{cmd:color(}string{cmd:)}: The color of the brackets and the text.
    {p_end}
    {phang}{cmd:adlo(}int 1{cmd:)}: The n-th added plot. {break}
        Use this option when multiple asterisk brackets are needed. {break}
        1, 2, ...
    {p_end}

{marker contact}{...}
{title:Author}

{phang}
{cmd:Xinya,Hao (Hall)} School of Energy and Environment, City Univeersity of HK, HKSAR.{break}
E-mail: {browse "mailto:xyhao5-c@my.cityu.edu.hk":xyhao5-c@my.cityu.edu.hk}; {browse "mailto:lisshall717@gmail.com":lisshall717@gmail.com} {break}
Blog: {browse "https://econometrics.club/":https://econometrics.club/} {break}
Github: {browse "https://github.com/LissHall":https://github.com/LissHall} {break}
Hall's Stata Toolbox: {browse "https://github.com/LissHall/halltool":https://github.com/LissHall/halltool} {break}
{p_end}

