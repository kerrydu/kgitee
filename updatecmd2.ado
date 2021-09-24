*! version 1.0, 24-9-2021	
cap program drop updatecmd2
program define updatecmd2
version 14
	syntax anything, from(string) [froma(string) pkg(string)]  
	 confirm names `anything' 
    if `"`pkg'"'==""  local pkg `anything'
	confirm names `pkg'
    global p_k_g_ `pkg'
    global c_m_d_0 `anything' ${c_m_d_0}    
    global up_grade_`pkg' "tocheck" 
	cap mata: vfile = cat(`"`from'/`anything'.ado"') 
	if _rc{
		cap mata: vfile = cat(`"`froma'/`anything'.ado"')
		if _rc{ //failed to connnect the web, excute the cmd
			global up_grade_`pkg' `"failedto{`from'}"'
			$c_m_d_0
			cap macro drop p_k_g_
			cap macro drop c_m_d_0
			exit
		}		
	}
	else global up_grade_`pkg' `"copyfrom{`from'}"'
	mata: vfile = select(vfile,vfile:!="")
	mata: vfile = usubinstr(vfile,char(9)," ",.)
	mata: vfile = select(vfile,!ustrregexm(vfile,"^( )+$"))
	mata: st_local("versiongit",vfile[1])
	local versiongit = ustrregexrf("`versiongit'","^[\D]+","")
	gettoken vers versiongit:versiongit, p(", ")
	local versiongit `vers'
	qui findfile `anything'.ado
	mata: vfile = cat("`r(fn)'")
	//mata: st_local("versionuse",subinstr(vfile[1]," ","",.))
	mata: vfile = select(vfile,vfile:!="")
	mata: vfile = usubinstr(vfile,char(9)," ",.)
	mata: vfile = select(vfile,!ustrregexm(vfile,"^( )+$"))
	mata: st_local("versionuse",vfile[1])
	local versionuse = ustrregexrf("`versionuse'","^[\D]+","")
	gettoken vers versionuse:versionuse, p(", ")
    local versionuse `vers'	

    compareversion `versiongit' `versionuse'
    local newv = r(l)
	if(`newv'){
		global f_r_o_m_ `from'
		db updateyorn
	}
	else{
		$c_m_d_0
		cap macro drop c_m_d_0
		cap macro drop p_k_g_
	}

end


