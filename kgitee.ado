cap program drop kgitee
program define kgitee
	version 16 
	syntax [anything], [replace force ]
	
	//preserve
	tokenize `"`0'"', p(",")
	
	tempfile temp
	
	! curl "https://gitee.com/kerrydu/kgitee/raw/master/README.md" -o  "`temp'"
	mata: pkglist=cat("`temp'")
	mata: pkglist=select(pkglist,pkglist:!="")
	
	//preserve
	
	qui getmata plist=pkglist,replace
	//qui replace plist=subinstr(plist,"*",_n,1)
	qui drop if missing(plist) | ustrregexm(plist, "^( )+$")
	qui split plist, p("[[gitee]]")
	qui keep plist1 plist2
	qui gen n=_n-1
	qui replace plist1=string(n)+"."+subinstr(plist1,"*","",1) if _n>1
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
		list 
		/*
		qui keep if q2==`"`1'"'
		if `=_N'==0{
		    di as red `"The specified pkgname [`1'] NOT found."'
		}
		else{
			local pwd=c(pwd)
			cap mkdir _gitee_tempfiles_
			local dirfolder `c(pwd)'/_gitee_tempfiles_	
			local url=plist2[1]
			*!curl "`url'/raw/master/`1'.pkg" -o  "`dirfolder'/`pkg'.pkg"
			
			 mata: _dfstatafiles("`1'.pkg",`"`url'/raw/master/"',`"`dirfolder'"')
			
			 net install `pkg', from(`dirfolder') `rnew'
			 
			 erase "`dirfolder'/`pkg'.pkg"
			 foreach fi of local dfstata{ 
				 cap erase  "`dirfolder'/`fi'" 
			 }	
			 
			 cap erase "`dirfolder'"	
			// restore
			
		}
		*/

		
	}


	
end



cap mata mata drop notation()
cap mata mata drop strconcat()	
cap mata mata drop _dfstatafiles()	
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
		
end
		
