*------------------------------------------------------------
* File: bdid_plot.ado
*------------------------------------------------------------
capture program drop bdid_plot
program define bdid_plot
    version 15

    * This command expects the ATT table in memory:
    * variables: s t est se lower upper

    syntax , ///
        [ ///
          S(varname) ///
          T(varname) ///
          EST(varname) ///
          LOWER(varname) ///
          UPPER(varname) ///
          TITLE(string asis) ///
          XTITLE(string asis) ///
          YTITLE(string asis) ///
          COLS(integer 2) ///
          NAME(string asis) ///
          SAVING(string asis) ///
          REPLACE ///
        ]

    * defaults
    if "`s'"==""     local s "s"
    if "`t'"==""     local t "t"
    if "`est'"==""   local est "est"
    if "`lower'"=="" local lower "lower"
    if "`upper'"=="" local upper "upper"
    if "`title'"=="" local title "ATT with 95% intervals by cohort"
    if "`xtitle'"=="" local xtitle "t"
    if "`ytitle'"=="" local ytitle "ATT"

    * basic checks
    foreach v in `s' `t' `est' `lower' `upper' {
        capture confirm variable `v'
        if _rc {
            di as error "bdid_plot: variable `v' not found. Expected ATT table with s,t,est,lower,upper."
            exit 111
        }
    }

    * ensure sorted as requested
    sort `s' `t'

    * build the graph:
    * - rcap for bands
    * - connected for estimate line/points
    * - by(s) for separate panels
    twoway ///
        (rcap `lower' `upper' `t', sort) ///
        (connected `est' `t', sort) ///
        , ///
        by(`s', cols(`cols') note("") title("`title'")) ///
        yline(0) ///
        xtitle("`xtitle'") ///
        ytitle("`ytitle'") ///
        legend(off) ///
        `= cond("`name'"!="","name(`name', replace)","")'

    * optionally save
    if "`saving'"!="" {
        graph export "`saving'", `replace'
    }

end
