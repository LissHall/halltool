
![hallstoolbox](https://github.com/LissHall/halltool/blob/main/HallsSTATABox.svg)
# Hall's STATA Toolbox

Commands included in Hall's ToolBox:
1. `whichdep`
   - Install and update all specified `ssc` and `net` packages at once. 
   - Add this command at the beginning of the do file to avoid errors due to uninstalled dependencies after sharing the do file.
2. `xpctile` 
   - The `percentile` of a given `value` in a `variable`.
3. `rm2` 
   - Enhanced version of `rm`/`erase` command. 
   - Delete multiple files and delete files by file types in one command.
   - Avoid errors due to file not found.
4. `gradd_ab`
   - Add asterisk brackets to a bar graph.
<div>
<p align="center" width="100%">
    <img alt="_eg_gradd_ab" src="https://github.com/LissHall/halltool/blob/main/pngs/_eg_gradd_ab.png?raw=true" style="width:75%;"/>
</p>
<p align="center" width="100%">Origional bar plot (left)  --->  After <i>gradd_ab</i></p>
</div>

5. `csv2dta`
   - Transform all the .csv in a folder to .dta in one command.
6. `fmtstr`
   - Format long string variables in one command.



# How to install
You can install [`halltool`](https://github.com/LissHall/halltool) using [`github`](https://github.com/haghish/github) in Stata.

```{stata}
    * Install github
    net install github, from("https://haghish.github.io/github/")

    * Install halltool from github
    github install LissHall/halltool
    help rm2
```

and uninstall:

```{stata}
    github uninstall halltool
```