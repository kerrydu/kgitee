*! version 0.0.2
cap program drop demo_updatecmd
program define demo_updatecmd
version 16

global c_m_d_0 `0'
local pkg updatecmd
cap which updatecmd
if _rc{
  cap net install updatecmd, from("https://gitee.com/kerrydu/kgitee/raw/master/") replace
  if _rc{
     cap net install updatecmd, from("https://github.com/kerrydu/kgitee/raw/master/") replace
     if _rc global up_grade_`pkg' "updatecmd_is_missing"
   }
  
}

 if "${up_grade_`pkg'}"==""{ // The first run of cmd is checking the update version
     updatecmd2 demo_updatecmd, from("https://gitee.com/kerrydu/kgitee/raw/master/") pkg(`pkg') 	
 } 
else{
  di "hello...."
}



end