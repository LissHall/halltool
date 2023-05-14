# whichdep
`whichdep` is a Stata program that check and install packages automatically.

Click  👉 [hall-stata-toll](https://github.com/LissHall/hall-stata-tool) to view more Stata tools

# How to install
You can install `whichdep` directly using `github` in Stata:

```{js}
    github install LissHall/halltool
```

If you do not have `github` installed, try run this in your Stata:

```{js}
    net install github, from("https://haghish.github.io/github/")
```

# How to use and examples

Syntax:
```{js}
    whichdep pkglist [, net(pkg1 "address1" pkg2 "address2" ...) Quick Replace]
```
Options:
```{js}
    net(pkg "add" ...) - Net install `pkg` from `add`
    quick              - Do not check version update
    replace            - Install new version if new version found
```

Try `help whichdep` after installation:

```{js}
    help whichdep
```

Install `ssc` packages:

```{js}
    whichdep outreg2 winsor2 csdid , quick
```

`quick` or `q` option can be specified to skip the new version checking and run faster.

Install `net` packages using `net()` option:

```{js}
    whichdep pkg_a pkg_b , net(pkg1 "add1" pkg2 "add2")
```

For example, you can install `svmat2` by:

```{js}
    whichdep , net(dm79.pkg "http://www.stata.com/stb/stb56")
```


Author
------
  **Xinya Hao (Hall)**  

  School of Energy and Environment

  City University of Hong Kong 
