cap program drop compareversion
program define compareversion, rclass

version 14

args x y

local xx = usubinstr(`"`x'"',".","",.)
local yy = usubinstr(`"`y'"',".","",.)

local nreal = ustrregexm(`"`xx'"',"\D")
if `nreal'{
   di as error `"`x' is not a valid version number"'
   di `"Note: The format of version number is #.#.#"'
   exit
}

local nreal = ustrregexm(`"`yy'"',"\D")
if `nreal'{
   di as error `"`y' is not a valid version number"'
   di `"Note: The format of version number is #.#.#"'
   exit
}

mata: _compareversion2()

return scalar l=r(l)
end

cap mata mata drop _compareversion()
mata:
void function _compareversion()
{
    l=0
    vx=st_local("x")
    vy=st_local("y")
    vx=tokens(vx,".")
    vy=tokens(vy,".")
    vx=strtoreal(select(vx,vx:!="."))
    vy=strtoreal(select(vy,vy:!="."))
    vl =length(vx) -length(vy)
    if(vl>0) vy=vy,J(1,vl,0)
    else  vx=vx,J(1,vl,0)
    flag = vx - vy
    flag = select(flag,flag:!=0)
    if(length(flag)>0 & flag[1]>0){
       l=1
    }
 
    st_numscalar("r(l)",l)

	
}


end


cap mata mata drop _compareversion2()
cap mata mata drop _comparexy()
mata:
void function _compareversion2()
{
    l=0
    vx=st_local("x")
    vy=st_local("y")
    if(vx==vy){
    	st_numscalar("r(l)",l)
    	exit()
    }
    vx=tokens(vx,".")
    vy=tokens(vy,".")
    vx=select(vx,vx:!=".")
    vy=select(vy,vy:!=".")

    minl=min((length(vx),length(vy)))
    
    if(vx[1..minl]==vy[1..minl]){
    	l = (length(vx)>length(vy))
    	st_numscalar("r(l)",l)
    	exit()    	
    }

    c=1
    while(c<=minl|l<1){
       l= _comparexy(vx[c],vy[c])
       c=c+1

    }

    
    st_numscalar("r(l)",l)

	
}

real scalar function _comparexy(string scalar a, string scalar b)
{
	la=strlen(a)
	lb=strlen(b)
	minl=min((la,lb))
	if(substr(a,1,minl)==substr(b,1,minl)){
	   flag = (la>lb)
	   return(flag)
	   exit()
	}
	c=1
	flag=0
    while(c<=minl & flag<1){
       x = strtoreal(substr(a,c,c))
       y = strtoreal(substr(b,c,c))
       flag=(x>y)
       c=c+1
    }
    return(flag)

}


end

