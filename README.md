 ##  kgitee 

​          list/install Stata packages in gitee.com/kerrydu



## Installation

* Stata 14/15

  ```
  net install kgitee, from(https://gitee.com/kerrydu/kgitee/raw/master) replace
  ```

* Stata 16

  Following the Notation to install `curl` first, and then copy `kgitee` into `c(pwd)` directory in your Stata 16. Prompt `kgitee kgitee` for installation.

### Notation

Stata 16 is blocked by Gitee.com due to its user agent. curl is used to download the Stata files. Thus, you should install [**curl**](https://curl.haxx.se/windows/)  and add curl into the system path before using **gitee** in Stata 16.



![](https://i.loli.net/2020/05/05/EbomXYCZ3pzhKnt.png)



## 解压后将curl.exe所在路劲添加到系统环境变量



![](https://i.loli.net/2020/05/05/5utXDxJRw9iKvyk.png)

![](https://i.loli.net/2020/05/05/SM3kqo84vFyrY6j.png)





![](https://i.loli.net/2020/05/05/IOLknuzoY6xfP25.png)

