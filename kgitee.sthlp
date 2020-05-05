{smcl}
{right:version 1.0}
{title:Title}

{phang}
{cmd:kgitee} {hline 2} list/install Stata packages in 
kerrydu.gitee.com
 

{title:Syntax}

{p 8 16 2}
{cmd: kgitee}  [{it:pkgname}]  [{cmd:,} replace force]
{p_end}


{title:Options}

{p 4 4 2}

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}

{synopt:{opt replace}}specifies that the downloaded files replace existing 
files if any of the files already exists.{p_end}

{synopt:{opt force}}specifies that the downloaded files replace existing 
files if any of the files already exists, even if Stata thinks all the files 
are the same.  force implies replace.{p_end}

{synoptline}
{p2colreset}{...}



{title:Example(s)}

{p 4 4 2}

    list installable packages in kerrydu.gitee.com
        . kgitee
		   
    install gtfpch 
        . kgitee gtfpch
                

{title:Author}

{p 4 4 2}
Kerry Du     {break}
Xiamen University      {break}
Email:kerrydu@xmu.edu.cn     {break}
