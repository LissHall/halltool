{smcl}
{* *! version 1.0.0, Nov 4'2024}{...}

{hline}
{cmd:help for {hi:fmtstr}}{right: ({browse "https://econometrics.club/":blog})}
version 1.0.0, 4nov2024.{right: ({browse "https://github.com/LissHall/halltool":github})}
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:fmtstr} {hline 2}}Format the display lenth of string variables.{p_end}
{p2colreset}{...}

{title:Syntax}

{p 4 19 2}
{cmdab:fmtstr} [varlist], {cmdab:L:}{cmd:en(}integer 30{cmd:)} 

{title:Options}

    {cmdab:varlist:}: The list of string variables to be formatted.
    {pmore}- If not specified, all string variables will be formatted. {break} 
    - Non-string variables will be ignored. {p_end}

    {cmdab:L:}en(integer): The display length of string variables. Default is 30. 

{title:Author}

{phang}
{cmd:Xinya,Hao (Hall)} School of Energy and Environment, City Univeersity of HK, HKSAR.{break}
E-mail: {browse "mailto:xyhao5-c@my.cityu.edu.hk":xyhao5-c@my.cityu.edu.hk}; {browse "mailto:lisshall717@gmail.com":lisshall717@gmail.com} {break}
Blog: {browse "https://econometrics.club/":https://econometrics.club/} {break}
Github: {browse "https://github.com/LissHall":https://github.com/LissHall} {break}
Hall's Stata Toolbox: {browse "https://github.com/LissHall/halltool":https://github.com/LissHall/halltool} {break}
{p_end}

