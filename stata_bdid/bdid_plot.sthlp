*------------------------------------------------------------
* File: bdid_plot.sthlp
*------------------------------------------------------------
{smcl}
{title:bdid_plot}

{p 4 4 2}
{cmd:bdid_plot} plots the ATT table produced by {cmd:bdid_fgls}.
The horizontal axis is {bf:t}, the vertical axis is {bf:est}, and the confidence
band is drawn using {bf:lower} and {bf:upper}. Panels are split by cohort {bf:s}.

{title:Syntax}

{p 8 8 2}
{cmd:bdid_plot}
[{cmd:,}
{opt s(varname)}
{opt t(varname)}
{opt est(varname)}
{opt lower(varname)}
{opt upper(varname)}
{opt title("text")}
{opt xtitle("text")}
{opt ytitle("text")}
{opt cols(#)}
{opt name("graphname")}
{opt saving("filename")}
{opt replace}
]

{title:Description}

{p 4 4 2}
{cmd:bdid_plot} expects the dataset in memory to be the ATT table created by
{cmd:bdid_fgls}. It sorts by {bf:s} and {bf:t}, plots interval bands with
{cmd:rcap lower upper t}, overlays the estimate line with {cmd:connected est t},
and uses {cmd:by(s)} to produce one panel per cohort.

{title:Examples}

{p 4 4 2}
Run estimation and plot:
{p 8 8 2}
{cmd:. bdid_fgls}
{cmd:. bdid_plot}

{p 4 4 2}
Save as PNG:
{p 8 8 2}
{cmd:. bdid_plot, saving("att_plot.png") replace}

{title:Author}

{p 4 4 2}
Siddhartha Chib
