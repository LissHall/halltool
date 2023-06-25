{smcl}
{* *! version 1.0 2023/05/09}{...}
{hline}
{cmd:help for {hi:haversine}}{right: ({browse "https://econometrics.club/":blog})}{right: ({browse "https://github.com/LissHall/halltool":github})}
{hline}

{title:Haversine formula}


{title:Syntax}

{p 4 19 2}
{cmdab:haversine} lat1 lon1 lat2 lon2 [if] [in] ,  
[
{cmdab:G:}{cmd:en(}string{cmd:)}
{cmdab:R:}{cmd:eplace}
]


{title:Description}

{p 4 4 2}
{cmd:haversine} uses Haversine Formula to calculate the distance (km) between two locations with latitude and longitude coordinates.

{phang2}{inp:.}  lat1: the varname of the latitude of the 1st location.{p_end}
{phang2}{inp:.}  lon1: the varname of the longitude of the 1st location.{p_end}
{phang2}{inp:.}  lat2: the varname of the latitude of the 2nd location.{p_end}
{phang2}{inp:.}  lon2: the varname of the longitude of the 2nd location.{p_end}


{title:Options}

{phang2}{cmdab:g:}en: You can specify the name of the distance variable generated. If not spicified, the default name is "_haversine_distance".{p_end}
{phang2}{cmdab:r:}eplace: Replace the existing distance variable if it exists.{p_end}


{title:Author}

{phang}
{cmd:Xinya,Hao (Hall)} School of Energy and Environment, City Univeersity of HK, HKSAR.{break}
E-mail: {browse "mailto:xyhao5-c@my.cityu.edu.hk":xyhao5-c@my.cityu.edu.hk}; {browse "mailto:lisshall717@gmail.com":lisshall717@gmail.com} {break}
Blog: {browse "https://econometrics.club/":https://econometrics.club/} {break}
Github: {browse "https://github.com/LissHall":https://github.com/LissHall} {break}
{p_end}

