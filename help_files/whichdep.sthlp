{smcl}
{* *! version 1.2 Nov 08, 2023}{...}
{hline}
{cmd:help for {hi:whichdep}}{right: ({browse "https://econometrics.club/":blog})}
version 1.2, 08nov2024.{right: ({browse "https://github.com/LissHall/halltool":github})}
{hline}


{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:whichdep} {hline 2}}Install and update all specified dependencies.{p_end}
{p2colreset}{...}

{title:Syntax}

{p 4 19 2}
{cmdab:whichdep} {varlist} ,  
[
{cmdab:net:}{cmd:(}string{cmd:)}
{cmdab:r:}eplace
]


{title:Description}

{p 4 4 2}
{cmd:whichdep} checks whether the packages in the {varlist} are installed.
Packages that are not installed will be installed using {help ssc install}. 
You can also use the net() option to give packages to be installed with {help net install}.


{title:Options}

    {cmdab:r:}eplace: Replace with new version if new version found.

{p 4 4 2}{cmd:net(}{it:string}{cmd:)} specifies the packages and addresses for net install. 


{phang2}{inp:.}  whichdep pkg0 , net(pkg1 "add1" pkg2 "add2"){p_end}

    Same as:
{phang2}{inp:.}  ssc install pkg0{p_end}
{phang2}{inp:.}  net install pkg1, from("add1"){p_end}
{phang2}{inp:.}  net install pkg2, from("add2"){p_end}


{title:Example}

{phang2}{inp:.} {stata "whichdep winsor2 outreg2":  whichdep winsor2 outreg2}{p_end}
{phang2}{inp:.}  whichdep winsor2 outreg2, net(dm79.pkg "http://www.stata.com/stb/stb56"){p_end}


{title:Author}

{phang}
{cmd:Xinya,Hao (Hall)} School of Energy and Environment, City Univeersity of HK, HKSAR.{break}
E-mail: {browse "mailto:xyhao5-c@my.cityu.edu.hk":xyhao5-c@my.cityu.edu.hk}; {browse "mailto:lisshall717@gmail.com":lisshall717@gmail.com} {break}
Blog: {browse "https://econometrics.club/":https://econometrics.club/} {break}
Github: {browse "https://github.com/LissHall":https://github.com/LissHall} {break}
Hall's Stata Toolbox: {browse "https://github.com/LissHall/halltool":https://github.com/LissHall/halltool} {break}
{p_end}

