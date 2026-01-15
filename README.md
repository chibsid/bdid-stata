# bdid-stata

Stata front-end for the **R** package **bdid** (Bayesian DiD).
This wrapper provides the Stata command `bdid_fgls`, which exports the current
Stata dataset to CSV, calls `Rscript` to run `bdid::bdid_stata()`, and then
imports the resulting **ATT table** back into Stata.

The package also provides `bdid_plot`, which plots the ATT estimates with
confidence bands in Stata.

---

## Requirements

1. **Stata** (tested with Stata 15+)
2. **R** installed (so `Rscript` is available)
3. The **R package `bdid`** installed in R

> This repository contains only the **Stata wrapper**. All estimation is
> performed by the R package `bdid`.

---

## Install (Stata)

```stata
net install bdid, from("https://chibsid.github.io/bdid-stata/stata_bdid") replace
help bdid_fgls
help bdid_plot
```

Verify installation:

```stata
which bdid_fgls
which bdid_plot
```

---

## Quick start (example dataset)

The package installs an example dataset illustrating staggered treatment
adoption: `mpdta.dta`.

On Windows, it is typically located under Stata's PLUS directory, e.g.

```
c:\ado\plus\b\data\mpdta.dta
```

Run:

```stata
use c:\ado\plus\b\data\mpdta.dta, clear
bdid_fgls
list, clean
bdid_plot
```

---

## Preserve your original data (recommended)

`bdid_fgls` replaces the dataset in memory with the ATT table.
To return to the original dataset afterward:

```stata
use c:\ado\plus\b\data\mpdta.dta, clear
preserve
bdid_fgls
bdid_plot
restore
```

---

## Using your own dataset

Your dataset must contain:

- a subject/cluster id variable (default: `countyreal`)
- a time variable (default: `year`)
- an outcome variable (default: `lemp`)
- a first-treated (cohort) variable (default: `first_treat`)
- covariates (default: `lpop`)

Basic usage with defaults:

```stata
use mypanel.dta, clear
bdid_fgls
bdid_plot
```

Specify variables explicitly:

```stata
bdid_fgls, id(countyreal) time(year) y(lemp) first(first_treat) w(lpop) level(0.95)
bdid_plot
```

Multiple covariates (space- or comma-separated):

```stata
bdid_fgls, w(lpop x1 x2)
bdid_fgls, w(lpop, x1, x2)
```

---

## Rscript path (if needed)

The wrapper attempts to auto-detect `Rscript`. If this fails, specify it
explicitly.

Windows example:

```stata
bdid_fgls, rscript("C:/Program Files/R/R-4.5.1/bin/Rscript.exe")
```

macOS examples:

```stata
bdid_fgls, rscript("/opt/homebrew/bin/Rscript")
bdid_fgls, rscript("/usr/local/bin/Rscript")
```

---

## Output

### `bdid_fgls`

After execution, the dataset in memory becomes the ATT table with variables:

- `s`     — cohort index
- `t`     — time index
- `est`   — ATT estimate
- `se`    — standard error
- `lower` — lower confidence bound
- `upper` — upper confidence bound

### `bdid_plot`

`bdid_plot` expects the ATT table produced by `bdid_fgls` to be in memory and
produces a Stata graph with:

- horizontal axis: `t`
- vertical axis: `est`
- confidence band: `[lower, upper]`
- separate panels by cohort `s`

To save the plot:

```stata
bdid_plot, saving("att_plot.png") replace
```

---

## Citation

If you use this software, please cite:

Chib, S. and Shimizu, K. (2026).
*Potential Outcome Modeling and Estimation in Difference-in-Differences Designs
with Staggered Treatments*.

---

## License

MIT License (Stata wrapper).

The R package **bdid** is distributed under its own license.
