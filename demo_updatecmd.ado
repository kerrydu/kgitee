*! version 0.2 
cap program drop demo_updatecmd
program define demo_updatecmd
version 16

global c_m_d_0 `0'
local pkg updatecmd
 if "${up_grade_`pkg'}"==""{ // The first run of cmd is checking the update version
     updatecmd demo_updatecmd, from("test") pkg(`pkg') 	
 } 

di "hello"


end