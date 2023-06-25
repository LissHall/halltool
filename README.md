# Hall's STATA Toolbox

This is an Index Page for Hall's Stata tools.

1. 👉 [ini.do](/ini.do) General initial steps before your stata codings. 
2. 👉 [whichdep](/README_whichdep.md) Install and update all specified `ssc` and `net` packages at once. 
3. 👉 [xpctile] The percentile of a given `value` in a `variable`.
4. 👉 [haversine] [Haversine Formula](https://en.wikipedia.org/wiki/Haversine_formula) to calculate the distance (km) between two locations with `latitude` and `longitude` coordinates.


# How to install
You can install [`halltool`](https://github.com/LissHall/halltool) using [`github`](https://github.com/haghish/github) in Stata.

```{stata}
    github install LissHall/halltool
```

and uninstall:

```{stata}
    github uninstall halltool
```

If you do not have [`github`](https://github.com/haghish/github) installed, try run this in your Stata:

```{stata}
    net install github, from("https://haghish.github.io/github/")
```
