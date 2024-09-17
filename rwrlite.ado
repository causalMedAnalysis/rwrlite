*!TITLE: RWRLITE - causal mediation analysis using regression-with-residuals
*!AUTHOR: Geoffrey T. Wodtke, Department of Sociology, University of Chicago
*!
*! version 0.1
*!
 

program define rwrlite, eclass
	
	version 14	

	syntax varlist(min=1 numeric) [if][in] [pweight], ///
		dvar(varname numeric) /// 
		mvar(varname numeric) ///
		d(real) /// 
		dstar(real) /// 
		m(real) /// 
		[cvars(varlist numeric) /// 
		CAT(varlist numeric) ///
		cxd ///
		cxm ///
		lxm ///
		NOINTERaction ///
		detail * ]
							
	qui {
		marksample touse
		count if `touse'
		if r(N) == 0 error 2000
		local N = r(N)
	}

	gettoken yvar lvar : varlist

	local mreg regress
	
	type_text , mreg(`mreg')
	
	local NDE "e(`r(NDEtype)')"
	local NIE "e(`r(NIEtype)')"
	local ATE "e(`r(ATEtype)')"
			
	type_text , mreg(`mreg') lvar(`lvar') cvar(`cvars')	

	if ("`detail'" != "") {		
		rwrlitebs `varlist' if `touse' [`weight' `exp'], ///
			dvar(`dvar') mvar(`mvar') d(`d') dstar(`dstar') m(`m') ///
			cvar(`cvars') cat(`cat') `cxd' `cxm' `lxm' `nointeraction'
	}
		
	bootstrap ///
		`r(ATEtype)'=`ATE' ///
		`r(NDEtype)'=`NDE' ///
		`r(NIEtype)'=`NIE' ///
		CDE=e(CDE), ///
			force `options' noheader notable: ///
				rwrlitebs `varlist' if `touse' [`weight' `exp'], ///
					dvar(`dvar') mvar(`mvar') d(`d') dstar(`dstar') m(`m') ///
					cvar(`cvars') cat(`cat') `cxd' `cxm' `lxm' `nointeraction'

		
	estat bootstrap, p noheader

	type_text , mreg(`mreg') lvar(`lvar') cvar(`cvars')
	
	local CDE_col = strpos("`r(NDEtext)'", ":") + 2
	di as txt "CDE:" _column(`CDE_col') "controlled direct effect at m=`m'"
	di as txt "{p2col 1 `CDE_col' `CDE_col' 0: `r(NDEtext)'}{p_end}"
	di as txt "{p2col 1 `CDE_col' `CDE_col' 0: `r(NIEtext)'}{p_end}"
	di as txt "{p2col 1 `CDE_col' `CDE_col' 0: `r(ATEtext)'}{p_end}"
				
	ereturn local cmdline `"rwrlite `0'"'

end


capture program drop type_text
program type_text, rclass

    version 14
	
    syntax [varlist(default=none)] [, mreg(string) lvar(string) cvar(string) ]

		* regress
		if substr("`mreg'", 1, 3) == "reg" {
		
			// text to accompany estimates
			if "`lvar'"=="" {
			    local NDEtype "NDE"
				local NDEtext NDE: natural direct effect
				local NIEtype "NIE"
				local NIEtext NIE: natural indirect effect
				local ATEtype "ATE"
				local ATEtext ATE: average total effect
			}
			else {
				local NDEtype "IDE"
				local NDEtext IDE: interventional direct effect
				local NIEtype "IIE"
				local NIEtext IIE: interventional indirect effect
				local ATEtype "OE"
			    local ATEtext OE: overall effect
			}
		} // mregs = regress
	
		*return clear
		return local NDEtype `NDEtype'
		return local NDEtext `NDEtext'
		return local NIEtype `NIEtype'
		return local NIEtext `NIEtext'
		return local ATEtype `ATEtype'
		return local ATEtext `ATEtext'
		
end



			





