*! version 1.0
* By Kerry Du, May 5 2020

cap program drop kgitee
program define kgitee
	version 14

	if(`c(stata_version)'<16){
		kgitee14 `0'
		//discard
		exit
	}


	syntax [anything], [replace force statapath(string)]

	if `"`statapath'"'!=""{
		local pwd=c(pwd)
		local 0=subinstr(`"`0'"',`"statapath(`statapath')"',"",.)

		local sysdir_plus= c(sysdir_plus)

         mata: _wrdofile(`"`sysdir_plus'"',`"`0'"')

		winexec `statapath' do "`pwd'/_dotemp_kgitee_.do"

        //cap erase  _dotemp_kgitee_.do
        exit

	}
	
	preserve
	tokenize `"`0'"', p(",")
	
	tempfile temp
	
	! curl "https://gitee.com/kerrydu/kgitee/raw/master/pkglist.md" -o  "`temp'"
	mata: pkglist=cat("`temp'")
	mata: pkglist=select(pkglist,pkglist:!="")
	
	//preserve
	
	qui getmata plist=pkglist,replace
	//qui replace plist=subinstr(plist,"*",_n,1)
	qui drop if missing(plist) | ustrregexm(plist, "^( )+$")
	qui split plist, p("[[gitee]]")
	qui keep plist1 plist2
	qui gen n=_n-1
	qui replace plist1="  "+string(n)+"."+subinstr(plist1,"*","",1) if _n>1
	qui replace plist2=usubstr(plist2,2,.)
	qui replace plist2=usubstr(plist2,1,ustrlen(plist2)-1)
	qui drop n
	
	if `"`1'"'==""|`"`1'"'==","{
	    di 
	    local N=_N
		forv j=1/`N'{
		    local di=plist1[`j']
		    di `"  `di'"'
		}
		di 
		di "The packages listed above can be installed by"
		di "                       kgitee pkgname, [replace force]" 
		
		restore
		
	}
	else{
	    
		qui split plist1, p(". " :) gen(q)
		
		qui keep if q2==`"`1'"'
		if `=_N'==0{
		    di as red `"The specified pkgname [`1'] NOT found."'
		    restore
		}
		else{
			local pwd=c(pwd)
			cap mkdir _gitee_tempfiles_
			local dirfolder `c(pwd)'/_gitee_tempfiles_	
			local url=plist2[1]
			!curl "`url'/raw/master/`1'.pkg" -o  "`dirfolder'/`1'.pkg"
			!curl "`url'/raw/master/stata.toc" -o  "`dirfolder'/stata.toc"
			
			 mata: _dfstatafiles("`1'.pkg",`"`url'/raw/master/"',`"`dirfolder'"')
			
			 net install `1', from(`dirfolder') `3'
			 
			 cap erase "`dirfolder'/`1'.pkg"
			 cap erase "`dirfolder'/stata.toc"
			 foreach fi of local dfstata{ 
				 cap erase  "`dirfolder'/`fi'" 
			 }	
			 
			 cap erase "`dirfolder'"	
			 restore
			
		}
		

		
	}


	
end


//////////////////////////////

cap program drop kgitee14
program define kgitee14

	version 14
	syntax [anything], [replace force ]
	
	preserve
	tokenize `"`0'"', p(",")
	
	tempfile temp
	
	mata: pkglist=cat("https://gitee.com/kerrydu/kgitee/raw/master/pkglist.md")
	mata: pkglist=select(pkglist,pkglist:!="")
	
	//preserve
	
	qui getmata plist=pkglist,replace
	//qui replace plist=subinstr(plist,"*",_n,1)
	qui drop if missing(plist) | ustrregexm(plist, "^( )+$")
	qui split plist, p("[[gitee]]")
	qui keep plist1 plist2
	qui gen n=_n-1
	qui replace plist1="  "+string(n)+"."+subinstr(plist1,"*","",1) if _n>1
	qui replace plist2=usubstr(plist2,2,.)
	qui replace plist2=usubstr(plist2,1,ustrlen(plist2)-1)
	qui drop n
	
	if `"`1'"'==""|`"`1'"'==","{
	    di 
	    local N=_N
		forv j=1/`N'{
		    local di=plist1[`j']
		    di `"  `di'"'
		}
		di 
		di "The packages listed above can be installed by"
		di "                       kgitee pkgname, [replace force]" 
		
		restore
		
	}
	else{
	    
		qui split plist1, p(". " :) gen(q)
		
		qui keep if q2==`"`1'"'
		if `=_N'==0{
		    di as red `"The specified pkgname [`1'] NOT found."'
		    restore
		}
		else{
			 local url=plist2[1]
	         net install `1',from(`url'/raw/master)	`3'
			 restore
			
		}
		//discard
		

		
	}



end

cap mata mata drop notation()
cap mata mata drop strconcat()	
cap mata mata drop _dfstatafiles()	
cap mata mata drop _wrdofile()
mata:

void function notation(string colvector filenames)

{
			//flag=strpos(filenames,".pkg")
			   flag=regexm(filenames,"^.*(\.pkg)$")
			   //flag
				if(sum(flag)>0){
				  printf("note: the specified repository includes %s \n",strconcat(select(filenames,flag)))
				}
			


}

string function strconcat(string vector s)
{
   ss=""
   for(i=1;i<=length(s);i++){
   
	ss=ss+" " + s[i]
   
   }
   return(ss)


}



void function _dfstatafiles(string scalar pkg,string scalar url,string scalar dirfolder)
{
    pkg=dirfolder+"/"+pkg
	pkgfile=cat(pkg)	
	pathfile=select(pkgfile,regexm(pkgfile,"^(f|F)()"))
	pathfile=regexr(pathfile,"^(f|F)( )+","")
	pathfile=subinstr(pathfile," ","",.)
	pathfile=select(pathfile,pathfile:!="")
	pathfilename=regexr(pathfile,"^(.+)\/","")  
    st_local("dfstata",strconcat(pathfilename))
	for(j=1;j<=rows(pathfile);j++){
		
		p1="!curl "+ url + "/" + pathfile[j] +"  -o  "
		p2=dirfolder+"/"+pathfilename[j]
		stataexc=sprintf(`" %s  "%s" "',p1,p2)
		stata(stataexc)
	}


	pathfilename="F ":+ pathfilename

	pkgfile=select(pkgfile,!regexm(pkgfile,"^(f|F)( )")) \ pathfilename

	writefile = fopen(pkg, "rw")

	for(j=1;j<=rows(pkgfile);j++){
		
		fwrite(writefile, sprintf("%s\r\n", pkgfile[j]))
	}

	fclose(writefile)	
	
}

void function _wrdofile(string scalar sysdir_plus, string scalar cmdline)
  {  
     addplus="adopath ++ " + sysdir_plus

     setplus= "sysdir set PLUS  " +  sysdir_plus

     stataexc= "kgitee  " + cmdline
			
			
     writefile=fopen("_dotemp_kgitee_.do","rw")
     fwrite(writefile, sprintf("%s  \r\n", addplus))
     fwrite(writefile, sprintf("%s  \r\n", setplus))
     fwrite(writefile, sprintf("%s  \r\n", stataexc))
     fwrite(writefile, sprintf("exit  \r\n"))
     fclose(writefile)

  }

		
end
		
