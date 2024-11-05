{smcl}
{* *! version 1.1 Jun 25'2024}{...}
{vieweralsosee "halltool" "help halltool"}{...}
{viewerjumpto "Authors" "xpctile##contact"}{...}
{hline}
Command from {help halltool:Hall's Stata Toolbox}. help for {hi:xpctile}{right: ({browse "https://econometrics.club/":blog})}
version 1.1, 25jun2024.{right: ({browse "https://github.com/LissHall/halltool":github})}
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:xpctile} {hline 2}}The percentile of a given value in a variable.{p_end}
{p2colreset}{...}

{title:Syntax}

{p 4 19 2}
{cmdab:xpctile} {varname} [if] [in] ,  
[
{cmdab:x:}{cmd:val(}real{cmd:)}
]


{title:Description}

{p 4 4 2}
{cmd:xpctile} returns the percentile of a given value in a variable.

{p 4 4 2}
The returned values are saved in {cmd: rclass}. Try {stata "return list":  returen list} to see the returned values.


{title:Options}

    {cmdab:x:}val: Specify a number

{title:Example}
{phang2}{inp:.} {stata "sysuse auto, clear":  sysuse auto, clear}{p_end}
{phang2}{inp:.} {stata "xpctile mpg, xval(30)":  xpctile mpg, xval(30)}{p_end}
{phang2}{inp:.}  {space 4}30 is at the 90.54% percentile of mpg{p_end}
{phang2}{inp:.} {stata "ret list":  ret list}{p_end}
{phang2}{inp:.}  scalars:{p_end}
{phang2}{inp:.}  {space 8}(pct) =  90.54054054054053{p_end}
{phang2}{inp:.} {stata "dis r(pct)":  dis r(pct)}{p_end}
{phang2}{inp:.}  {space 8}90.540541{p_end}

{marker contact}{...}
{title:Author}

{phang}
{cmd:Xinya,Hao (Hall)} School of Energy and Environment, City Univeersity of HK, HKSAR.{break}
E-mail: {browse "mailto:xyhao5-c@my.cityu.edu.hk":xyhao5-c@my.cityu.edu.hk}; {browse "mailto:lisshall717@gmail.com":lisshall717@gmail.com} {break}
Blog: {browse "https://econometrics.club/":https://econometrics.club/} {break}
Github: {browse "https://github.com/LissHall":https://github.com/LissHall} {break}
Hall's Stata Toolbox: {browse "https://github.com/LissHall/halltool":https://github.com/LissHall/halltool} {break}
{p_end}

