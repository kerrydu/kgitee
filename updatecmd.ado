	
cap program drop updatecmd
program define updatecmd
version 14
	syntax anything, from(string) [pkg(string)]  
	 confirm names `anything' 
    if `"`pkg'"'==""  local pkg `anything'
    global p_k_g_ `pkg'
    global c_m_d_0 `anything' ${c_m_d_0}    
    global up_grade_`pkg' "tocheck" 
	cap mata: vfile = cat(`"`from'/`anything'.ado"') 
	if _rc{ //failed to connnect the web, excute the cmd
		global up_grade_`pkg' `"failedto{`from'}"'
		$c_m_d_0
		cap macro drop p_k_g_
		cap macro drop c_m_d_0
		exit
	}
	else global up_grade_`pkg' `"copyfrom{`from'}"'
	//mata: st_local("versiongit",subinstr(vfile[1]," ","",.))
	//mata: st_local("versiongit",subinstr(vfile[1],char(9),"",.))
	mata: st_local("versiongit",vfile[1])
	local versiongit = subinstr("`versiongit'",char(9),"",.)
	local versiongit = upper("`versiongit'")
	local versiongit = subinstr("`versiongit'","VERSION","",.)
	local versiongit = subinstr("`versiongit'","*","",.)
	local versiongit = subinstr("`versiongit'","!","",.)
	gettoken vers versiongit:versiongit, p(", ")
	//di "`vers'"
	gettoken i j:vers, p(".")
	//di "`i'"
	//di "`j'"
	local j =subinstr("`j'",".","",.)
	if "`j'"=="" local j 0
   local versiongit `i'.`j'
	qui findfile `anything'.ado
	mata: vfile = cat("`r(fn)'")
	//mata: st_local("versionuse",subinstr(vfile[1]," ","",.))
	mata: st_local("versionuse",vfile[1])
	local versionuse = upper("`versionuse'")
	local versionuse = subinstr("`versiongit'","VERSION","",.)	//
	local versionuse = subinstr("`versionuse'",char(9),"",.)
	local versionuse = subinstr("`versionuse'","version","",.)
	local versionuse = subinstr("`versionuse'","*","",.)
	local versionuse = subinstr("`versionuse'","!","",.)
	gettoken vers versionuse:versionuse, p(", ")
	//di "`vers'"
	gettoken i j:vers, p(".")
	//di "`i'"
	//di "`j'"
	local j =subinstr("`j'",".","",.)
	if "`j'"=="" local j 0
   local versionuse `i'.`j'	
	if(`versionuse'<`versiongit'){
		global f_r_o_m_ `from'
		db updateyorn
	}

end


