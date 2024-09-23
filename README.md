# Hall's STATA Toolbox

Commands included in Hall's ToolBox:
1.  `whichdep`
   - Install and update all specified `ssc` and `net` packages at once. 
   - Add this command at the beginning of the do file to avoid errors due to uninstalled dependencies after sharing the do file!
2. `xpctile` 
   - The `percentile` of a given `value` in a `variable`.
3. `haversine`
    - [Haversine Formula](https://en.wikipedia.org/wiki/Haversine_formula) to calculate the geo-distance (km) between two locations with `latitude` and `longitude` coordinates.
4. `rm2` 
   - Enhanced version of `rm`/`erase` command. 
   - Delete multiple files and delete files by file types in one command.
   - Avoid errors due to file not found.


# How to install
You can install [`halltool`](https://github.com/LissHall/halltool) using [`github`](https://github.com/haghish/github) in Stata.

```{stata}
    github install LissHall/halltool
    help rm2
```

and uninstall:

```{stata}
    github uninstall halltool
```

If you do not have [`github`](https://github.com/haghish/github) installed, try run this in your Stata:

```{stata}
    net install github, from("https://haghish.github.io/github/")
```
