#### 合併舊資料與新資料 ####

if (!suppressMessages(require(dplyr))) install.packages("dplyr", repos="http://cran.rstudio.com/");
suppressMessages(library(dplyr))
if (!suppressMessages(require(magrittr))) install.packages("magrittr", repos="http://cran.rstudio.com/");
suppressMessages(library(magrittr))

args = commandArgs(TRUE)
setwd(args[1])
# args[1] = setwd("C:/Users/90813/Desktop/OI_Crawler/")

## 逐檔合併
fileList = expand.grid(c("TXF","MXF"),c("_Foreign","_Dealer","_InvestmentTrust")) %>% mutate(str=paste0(Var1,Var2,".csv")) %>% .$str
errMsg = ""

for(fname in fileList){
  # fname = fl[1]
  # 讀檔
  # cat(paste0(args[1],side,".csv\n"))
  NewData = read.csv(paste0("current_data/",fname),header=F);colnames(NewData)=c("date","OI")
  data = read.csv(paste0("history_data/",fname),header=F);colnames(data)=c("date","OI")
  
  # tail(NewData)
  # tail(data)
  #NewData = read.csv("TXF_Foreign_test.csv",header=F);colnames(NewData)=c("date","OI")
  
  # 合併後 1.去除重複值 2.去除OI為0的值
  a = rbind(data,NewData) %>% 
    unique() %$%
    .[which(.$OI!=0),]
  
  # 查看有無當天資料
  if( length(which(format.Date(as.Date(a$date),"%Y/%m/%d")
                   == format.Date(Sys.Date(),"%Y/%m/%d")))!=0 ){
    if( a[format.Date(as.Date(a$date),"%Y/%m/%d")
          == format.Date(Sys.Date(),"%Y/%m/%d"),]$OI != 0){
      haveToday = 1
    }else{
      haveToday = 0
    }
  }else{
    haveToday = 0
  }
  
  # 看看新舊資料有沒有同一天不同值的錯誤
  dateCount = a$date %>% droplevels %>% table  %>% data.frame
  different_data = dateCount %$% which(Freq!=1)
  
  # 確認無錯誤值 => 寫csv檔
  if( length(different_data)==0 & haveToday==1 ){
    write.table(a,file=paste0("history_data/",fname),sep=",",quote = F,row.names = FALSE,col.names = FALSE)
    cat("success_yesToday(Big3)\n")
    errMsg = "success_yesToday(Big3)\n"
  }else if( length(different_data)==0 & haveToday==0 ){
    write.table(a,file=paste0("history_data/",fname),sep=",",quote = F,row.names = FALSE,col.names = FALSE)
    cat("success_noToday(Big3)\n")
    errMsg = "success_noToday(Big3)\n"
  }else{
    #有錯誤的話 => 顯示出錯誤的日期
    wrongD = dateCount %>% .[different_data,1] %>% as.character() 
    cat( paste0("There have same wrong data in ",wrongD,"\n") )
    cat("error(Big3)\n")
    errMsg = "error(Big3)\n"
  }
}

cat(errMsg);

# rbind(data,NewData) %>%
#   unique() %$%
#   table(date) %>%
#   data.frame %$%
#   which(Freq!=1)

# a = unique(rbind(data,NewData))
# which(data.frame(table(a$date))$Freq!=1)





  

