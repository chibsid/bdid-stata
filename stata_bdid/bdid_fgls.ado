program define bdid_fgls
    version 15

    * Options (all optional; defaults match your current workflow)
    syntax , ///
        [ RSCRIPT(string asis) ///
          ID(varname) TIME(varname) Y(varname) FIRST(varname) ///
          W(string asis) ///
          LEVEL(real 0.95) ///
          VERBOSE ]

    * defaults
    if "`id'"==""     local id "countyreal"
    if "`time'"==""   local time "year"
    if "`y'"==""      local y "lemp"
    if "`first'"==""  local first "first_treat"
    if "`w'"==""      local w "lpop"

    * allow w() as space- or comma-separated
    local wclean : subinstr local w "," " ", all
    local wclean : list retokenize wclean

    *------------------------------------------------------------
    * Determine Rscript executable (cross-platform, conservative)
    * Priority:
    *   1) user-supplied rscript()
    *   2) common install locations
    *   3) PATH via where/which
    *------------------------------------------------------------
    if "`rscript'"=="" {

        local os "`c(os)'"

        * ---- Windows candidates
        if strpos("`os'","Windows") {
            local cand1 "C:\Program Files\R\R-4.5.1\bin\Rscript.exe"
            local cand2 "C:\Program Files\R\R-4.5.0\bin\Rscript.exe"
            local cand3 "C:\Program Files\R\R-4.4.2\bin\Rscript.exe"
            local cand4 "C:\Program Files\R\R-4.4.1\bin\Rscript.exe"
            local cand5 "C:\Program Files\R\R-4.4.0\bin\Rscript.exe"
            local cand6 "C:\Program Files\R\R-4.3.3\bin\Rscript.exe"
            local cand7 "C:\Program Files\R\R-4.3.2\bin\Rscript.exe"
            local cand8 "C:\Program Files\R\R-4.3.1\bin\Rscript.exe"
            local cand9 "C:\Program Files\R\R-4.3.0\bin\Rscript.exe"

            foreach p in "`cand1'" "`cand2'" "`cand3'" "`cand4'" "`cand5'" "`cand6'" "`cand7'" "`cand8'" "`cand9'" {
                capture confirm file "`p'"
                if !_rc {
                    local rscript "`p'"
                    continue, break
                }
            }

            * If not found in common locations, try PATH via "where"
            if "`rscript'"=="" {
                tempfile wh
                local whf "`wh'.txt"
                shell cmd /c "where Rscript > ""`whf'"" 2>nul"
                quietly file open fh using "`whf'", read text
                quietly file read fh line
                quietly file close fh
                capture confirm file "`line'"
                if !_rc local rscript "`line'"
            }
        }

        * ---- macOS / Linux candidates
        else {
            local cand1 "/usr/local/bin/Rscript"
            local cand2 "/opt/homebrew/bin/Rscript"
            local cand3 "/usr/bin/Rscript"
            local cand4 "/Library/Frameworks/R.framework/Resources/bin/Rscript"

            foreach p in "`cand1'" "`cand2'" "`cand3'" "`cand4'" {
                capture confirm file "`p'"
                if !_rc {
                    local rscript "`p'"
                    continue, break
                }
            }

            * If not found, try PATH via "which"
            if "`rscript'"=="" {
                tempfile wh
                local whf "`wh'.txt"
                shell sh -c "which Rscript > '`whf'' 2>/dev/null"
                quietly file open fh using "`whf'", read text
                quietly file read fh line
                quietly file close fh
                capture confirm file "`line'"
                if !_rc local rscript "`line'"
            }
        }

        if "`rscript'"=="" {
            di as error "bdid_fgls: could not find Rscript automatically."
            di as error "Please install R (and Rscript), or pass rscript(""full path to Rscript"")."
            exit 198
        }
    }

    tempfile incsv outcsv logtxt
    local in  "`incsv'.csv"
    local out "`outcsv'.csv"
    local log "`logtxt'.txt"

    * export current data to CSV
    export delimited using "`in'", replace

    * file paths for R
    local inR "`in'"
    local outR "`out'"
    if strpos("`c(os)'","Windows") {
        * Windows backslashes -> forward slashes for R
        local inR  : subinstr local in  "\" "/" , all
        local outR : subinstr local out "\" "/" , all
    }

    * build wnames=c('a','b',...) for R
    local wvec ""
    foreach v of local wclean {
        if "`wvec'"=="" local wvec "'`v''"
        else            local wvec "`wvec','`v''"
    }
    local wvec "c(`wvec')"

    * verbose flag
    local rverb "FALSE"
    if "`verbose'"!="" local rverb "TRUE"

    * one-line R expression
    local rexpr "bdid::bdid_stata(infile='`inR'',outfile='`outR'',clusterid='`id'',time='`time'',yname='`y'',datefirsttreated='`first'',wnames=`wvec',verbose=`rverb',level=`level')"

    * run R, capture output (cross-platform)
    if strpos("`c(os)'","Windows") {
        shell cmd /c ""`rscript'" -e "`rexpr'" > ""`log'"" 2>&1"
    }
    else {
        * Use sh -c; escape quotes for -e
        shell sh -c "'`rscript'' -e \"`rexpr'\" > '`log'' 2>&1"
    }

    * show R log
    type "`log'"

    * require output file
    capture confirm file "`out'"
    if _rc {
        di as error "bdid_fgls: R did not produce output file."
        exit 198
    }

    * import ATT (replaces dataset in memory)
    import delimited using "`out'", clear
end
