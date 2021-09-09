program define updateyorndlg
version 14

syntax, [yorn]

if `yorn'==1{
 
 	di "Updating $p_k_g_..."
    
	net install ${p_k_g_}, from(`"$f_r_o_m_"') force
	global up_grade_${p_k_g_} "updated"

}
discard
$c_m_d_0
cap macro drop f_r_o_m_
cap macro drop c_m_d_0
cap macro drop p_k_g_
end

