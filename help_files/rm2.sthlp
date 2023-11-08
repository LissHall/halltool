{smcl}
{* *! version 1.0 Nov 8, 2023}{...}
{hline}
{cmd:help for {hi:xpctile}}{right: ({browse "https://econometrics.club/":blog})}{right: ({browse "https://github.com/LissHall/halltool":github})}
{hline}

{title:RM2}


{title:Syntax}

{p 4 19 2}
{cmdab:rm2} [filename] 
[,  
{cmdab:T:}{cmd:ype(}filetype{cmd:)}
{cmdab:P:}{cmd:ath(}filepath{cmd:)}
]

{title:Options}

    filename: Zero, 1, or multiple file names. Separated by spaces

    {cmdab:t:}ype(filetype): One or multiple file types. Separated by spaces. 
                    All files in the format of .filetype will be deleted.

    {cmdab:p:}ath(filepath): You can specify the specific path to find and delete the files. 
                    If not specified, the current folder will be used.

{title:Description}

{p 4 4 2}
{cmd:rm2} rm/erase multiple files in one command.

{p 4 4 2}
You can specify the specific file ({cmd:filename}) or a file type ({cmd:filetype}).

{p 4 4 2}
You can also specify the {cmd:filepath} to delete files in a specific folder.

{p 4 4 2}
This commands utilize the{stata "help rm": rm/erase} command to delete files. The files are deleted permanently.

{title:Example}
{phang2} To delete -results.txt-{p_end}
{phang2}{inp:.} rm2 results.txt{p_end}

{phang2} To delete -My Data.dta-{p_end}
{phang2}{inp:.} rm2 "My Data.dta"{p_end}

{phang2} To delete -results.txt- in a specific folder{p_end}
{phang2}{inp:.} rm2 results.txt, p("this/is/my/folder"){p_end}

{phang2} To delete -results1.txt- and -results2.txt- in a specific folder{p_end}
{phang2}{inp:.} rm2 "results1.txt" "results2.txt", p("this/is/my/folder"){p_end}

{phang2} To delete all .txt file in the current folder{p_end}
{phang2}{inp:.} rm2, t(txt){p_end}

{phang2} To delete all .txt file in a specific folder{p_end}
{phang2}{inp:.} rm2, t(txt) p("this/is/my/folder"){p_end}

{phang2} To delete all .txt and .xls file in a specific folder{p_end}
{phang2}{inp:.} rm2, t(txt xls) p("this/is/my/folder"){p_end}

{phang2} To delete -results.xls- and all .txt file in a specific folder{p_end}
{phang2}{inp:.} rm2 results.xls, t(txt) p("this/is/my/folder"){p_end}


{title:Author}

{phang}
{cmd:Xinya,Hao (Hall)} School of Energy and Environment, City Univeersity of HK, HKSAR.{break}
E-mail: {browse "mailto:xyhao5-c@my.cityu.edu.hk":xyhao5-c@my.cityu.edu.hk}; {browse "mailto:lisshall717@gmail.com":lisshall717@gmail.com} {break}
Blog: {browse "https://econometrics.club/":https://econometrics.club/} {break}
Github: {browse "https://github.com/LissHall":https://github.com/LissHall} {break}
{p_end}

