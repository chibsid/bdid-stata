{smcl}
{title:bdid_fgls}

{p 4 4 2}
{cmd:bdid_fgls} runs the {bf:bdid} R package from Stata (via {bf:Rscript}) to estimate
average treatment effects on the treated (ATTs) in difference-in-differences designs
with staggered treatment adoption, and imports the resulting ATT table back into Stata.

{title:Syntax}

{p 8 8 2}
{cmd:bdid_fgls}
[{cmd:,}
{opt rscript("path/to/Rscript")}
{opt id(varname)}
{opt time(varname)}
{opt y(varname)}
{opt first(varname)}
{opt w(varlist)}
{opt level(#)}
{opt verbose}
]

{title:Description}

{p 4 4 2}
The command exports the current Stata dataset to a temporary CSV file,
calls {bf:Rscript} to run {cmd:bdid::bdid_stata()}, and then imports the resulting
ATT table (in long format) into Stata.
The ATT table replaces the dataset in memory.
The original dataset on disk is not modified.

{title:Options}

{p 4 8 2}
{opt rscript("...")} Full path to {bf:Rscript}.
If omitted, {cmd:bdid_fgls} attempts to auto-detect {bf:Rscript} using common
installation locations and the system PATH.
If auto-detection fails, the user must supply this option explicitly.

{p 4 8 2}
{opt id(varname)} Subject or cluster identifier variable.
Default: {cmd:countyreal}.

{p 4 8 2}
{opt time(varname)} Time variable.
Default: {cmd:year}.

{p 4 8 2}
{opt y(varname)} Outcome variable.
Default: {cmd:lemp}.

{p 4 8 2}
{opt first(varname)} First-treated date variable (cohort indicator).
Default: {cmd:first_treat}.

{p 4 8 2}
{opt w(varlist)} Covariate list.
May be space- or comma-separated.
Default: {cmd:lpop}.

{p 4 8 2}
{opt level(#)} Confidence level for confidence intervals.
Default: {cmd:0.95}.

{p 4 8 2}
{opt verbose} Prints R-side iteration and diagnostic output (if enabled in the R wrapper).

{title:Output}

{p 4 4 2}
After execution, the dataset in memory is replaced by the ATT table with variables:

{p 8 8 2}
{cmd:s} (cohort index),

{cmd:t} (time index),

{cmd:est} (ATT estimate),

{cmd:se} (standard error),

{cmd:lower} (lower confidence bound),

{cmd:upper} (upper confidence bound).

{title:Examples}

{p 4 4 2}
Default run (uses default variable names):
{p 8 8 2}
{cmd:. use mpdta.dta, clear}
{cmd:. bdid_fgls}
{cmd:. list, clean}

{p 4 4 2}
Specify inputs explicitly:
{p 8 8 2}
{cmd:. bdid_fgls, id(countyreal) time(year) y(lemp) first(first_treat) w(lpop) level(0.95)}

{p 4 4 2}
Specify the path to {bf:Rscript} manually:
{p 8 8 2}
{cmd:. bdid_fgls, rscript("C:/Program Files/R/R-4.5.1/bin/Rscript.exe")}

{p 4 4 2}
Preserve the original dataset:
{p 8 8 2}
{cmd:. preserve}
{cmd:. bdid_fgls}
{cmd:. list, clean}
{cmd:. restore}

{title:Citation}

{p 4 4 2}
If you use this software, please cite:

{p 8 8 2}
Chib, S. and Shimizu, K. (2026).
{it:Potential Outcome Modeling and Estimation in Difference-in-Differences Designs with Staggered Treatments}.

{title:Author}

{p 4 4 2}
Siddhartha Chib
