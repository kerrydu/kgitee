{smcl}
{right:version 1.0}
{title:Title}

{phang}
{cmd:kgitee} {hline 2} list/install Stata packages in 
gitee.com/kerrydu


{title:Syntax}

{p 8 16 2}
{cmd: kgitee}  [{it:pkgname}]  [{cmd:,} replace force statapath({it:Stata_directory})]
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

{synopt:{opt statapath(string)}}specifies using another Stata software as 
the exteneral installer. {p_end}

{synoptline}
{p2colreset}{...}



{title:Example(s)}

{p 4 4 2}

    list installable packages in kerrydu.gitee.com
        . kgitee
    	   
    install gtfpch 
        . kgitee gtfpch

    install gtfpch for Stata 16 using Stata 14 as the exteneral installer
        . kgitee gtfpch, statapath(D:\Stata14\StataMP-64.exe)


{title:Notation}

{p 4 4 2}

    Stata 16 is blocked by Gitee.com. Thus, to use kgitee in Stata 16, either curl or Stata 14 
    should be intalled first as an external installer.



{title:Author}

{p 4 4 2}
Kerry Du     {break}
Xiamen University      {break}
Email:kerrydu@xmu.edu.cn     {break}
