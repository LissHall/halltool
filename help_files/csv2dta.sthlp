{smcl}
{* *! version 1.0.0, Oct 27'2024}{...}

{hline}
{cmd:help for {hi:csv2dta}}{right: ({browse "https://econometrics.club/":blog})}
version 1.0.0, 27oct2024.{right: ({browse "https://github.com/LissHall/halltool":github})}
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:csv2dta} {hline 2}}Import all .csv file(s) from a folder and save as .dta.{p_end}
{p2colreset}{...}

{title:Syntax}

{p 4 19 2}
{cmdab:csv2dta} , {cmdab:F:}{cmd:rom(}path_string{cmd:)} {cmdab:T:}{cmd:o(}path_string{cmd:)}
[{it:{cmd:}{help import_delimited##import_delimited_options:import_delimited_options}}]

{title:Options}

    {cmdab:F:}rom(path_string): Path of the folder that contains the .csv files. 

    {cmdab:T:}o(path_string): Path of the folder to save the .dta files. Will create the folder if not exist.
    
    {cmdab:import_delimited_options:}: Other options for {it:{cmd:}{help import delimited:import delimited}} command.

{title:Example}
{phang2}{inp:.} csv2dta, /// {break}
    f("this/is/my/folder/contains/csvfiles") /// {break}
    t(/Users/me/Downloads) /// {break}
    bindquote(strict) maxquotedrows(10000) clear  {p_end}

{title:Author}

{phang}
{cmd:Xinya,Hao (Hall)} School of Energy and Environment, City Univeersity of HK, HKSAR.{break}
E-mail: {browse "mailto:xyhao5-c@my.cityu.edu.hk":xyhao5-c@my.cityu.edu.hk}; {browse "mailto:lisshall717@gmail.com":lisshall717@gmail.com} {break}
Blog: {browse "https://econometrics.club/":https://econometrics.club/} {break}
Github: {browse "https://github.com/LissHall":https://github.com/LissHall} {break}
Hall's Stata Toolbox: {browse "https://github.com/LissHall/halltool":https://github.com/LissHall/halltool} {break}
{p_end}

