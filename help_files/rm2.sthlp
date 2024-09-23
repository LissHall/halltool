{smcl}
{* *! version 1.2, Sep 23'2024}{...}
{hline}
{cmd:help for {hi:rm2}}{right: ({browse "https://econometrics.club/":blog})}
version 1.2, 23sep2024.{right: ({browse "https://github.com/LissHall/halltool":github})}
{hline}

{title:RM2}

    Just like command {stata "help rm":rm/erase}, but more powerful.

{title:Syntax}

{p 4 19 2}
{cmdab:rm2} [filename] 
[,  
{cmdab:T:}{cmd:ype(}filetype{cmd:)}
{cmdab:P:}{cmd:ath(}filepath{cmd:)}
{cmdab:R:}{cmd:eport}
]

{title:Options}

    filename: Zero, 1, or multiple file names. Separated by spaces

    {cmdab:T:}ype(filetype): One or multiple file types. Separated by spaces. 
                    All files with names ending in "filetype" will be deleted.

    {cmdab:P:}ath(filepath): You can specify the specific path to find and delete the files. 
                    If not specified, the program will try to find the specified files in the working directory.
    
    {cmdab:R:}eport: Report the files that have been removed if specified.

{title:Description}

{p 4 4 2}
{cmd:rm2} rm/erase multiple files in one command. Will ignore the error and continue to delete other files if a specified file does not exist.

{p 4 4 2}
You can specify the exact file ({cmd:filename}) or a file type ({cmd:filetype}).

{p 4 4 2}
You can also specify the {cmd:filepath} to delete files in a specific folder.

{p 4 4 2}
This commands utilize the {stata "help rm":rm/erase} command to delete files. The files are deleted permanently and unrestorable.

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
{phang2}{inp:.} rm2, t(.txt){p_end}

{phang2} To delete all .txt file in a specific folder{p_end}
{phang2}{inp:.} rm2, t(.txt) p("this/is/my/folder"){p_end}

{phang2} To delete all .txt and .xls file in a specific folder{p_end}
{phang2}{inp:.} rm2, t(.txt .xls) p("this/is/my/folder"){p_end}

{phang2} To delete -results.xls- and all .txt file in a specific folder{p_end}
{phang2}{inp:.} rm2 results.xls, t(.txt) p("this/is/my/folder"){p_end}


{title:Author}

{phang}
{cmd:Xinya,Hao (Hall)} School of Energy and Environment, City Univeersity of HK, HKSAR.{break}
E-mail: {browse "mailto:xyhao5-c@my.cityu.edu.hk":xyhao5-c@my.cityu.edu.hk}; {browse "mailto:lisshall717@gmail.com":lisshall717@gmail.com} {break}
Blog: {browse "https://econometrics.club/":https://econometrics.club/} {break}
Github: {browse "https://github.com/LissHall":https://github.com/LissHall} {break}
{p_end}

