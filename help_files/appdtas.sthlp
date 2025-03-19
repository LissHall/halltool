{smcl}
{* *! version 1.0.1, Jan 10'2025}{...}
{vieweralsosee "halltool" "help halltool"}{...}
{viewerjumpto "Authors" "appdtas##contact"}{...}
{hline}
Command from {help halltool:Hall's Stata Toolbox}. help for {hi:appdtas}{right: ({browse "https://econometrics.club/":blog})}
version 1.0.1, 19jan2025.{right: ({browse "https://github.com/LissHall/halltool":github})}
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:appdtas} {hline 2}}Append all .dta file(s) in a folder and save as .dta.{p_end}
{p2colreset}{...}

{title:Syntax}

{p 4 19 2}
{cmdab:appdtas} , {cmdab:F:}{cmd:rom(}path_string{cmd:)} {cmdab:S:}{cmd:aveas(}path_string{cmd:)} {cmdab:R:}eplace {cmdab:Q:}ui

{title:Options}

    {cmdab:F:}rom(path_string): Path of the folder that contains the .dta files. 
    {phang2}There will be a warning if no .dta files are found in the folder. No error will be returned.

    {cmdab:S:}aveas(path_string): Path and the name of the folder to save the .dta files. Must 
    
    {cmdab:R:}eplace: Replace the existing .dta file.

    {cmdab:Q:}ui: Quiet mode. Suppress the output information (number of files appeded and progress, etc.).

    -force- option is automatically used to append the .dta files.

{title:Example}
{phang2}{inp:.} appdtas, /// {break}
    f("this/is/my/folder/contains/dtafiles") /// {break}
    s(/Users/me/Downloads/all.dta) /// {break}
    q r  {p_end}

{marker contact}{...}
{title:Author}

{phang}
{cmd:Xinya,Hao (Hall)} School of Energy and Environment, City Univeersity of HK, HKSAR.{break}
E-mail: {browse "mailto:xyhao5-c@my.cityu.edu.hk":xyhao5-c@my.cityu.edu.hk}; {browse "mailto:lisshall717@gmail.com":lisshall717@gmail.com} {break}
Blog: {browse "https://econometrics.club/":https://econometrics.club/} {break}
Github: {browse "https://github.com/LissHall":https://github.com/LissHall} {break}
Hall's Stata Toolbox: {browse "https://github.com/LissHall/halltool":https://github.com/LissHall/halltool} {break}
{p_end}

