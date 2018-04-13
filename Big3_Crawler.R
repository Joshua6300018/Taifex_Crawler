#### 下載期交所依契約到日的未平倉量(OI) ####
if (!suppressMessages(require(dplyr))) install.packages("dplyr", repos="http://cran.rstudio.com/");
suppressMessages(library(dplyr))
if (!suppressMessages(require(stringi))) install.packages("stringi", repos="http://cran.rstudio.com/");
suppressMessages(library(stringi))

args = commandArgs(TRUE)
id = args[1]
setwd(args[2])
# setwd("C:/Users/90813/Desktop/OI_Crawler/")
# id = "MXF"

## 下載三大法人未平倉檔案
i=0
while(!file.exists(paste0("Temp_data/",id,"_Big3OI_tmp.csv"))|i==0){
  
  # 設定日期參數
  SD = Sys.Date()-365*3
  ED = Sys.Date()
  SYear = format(SD,"%Y") 
  SMonth = format(SD,"%m") 
  SDay = format(SD,"%d") 
  EYear = format(ED,"%Y") 
  EMonth = format(ED,"%m")
  EDay = format(ED-i,"%d")
  # 下載檔案
  para = paste0("?syear=",SYear,"&smonth=",SMonth,"&sday=",SDay,"&eyear=",EYear,"&emonth=",EMonth,"&eday=",EDay,"&COMMODITY_ID=",id)
  download.file(paste0('http://www.taifex.com.tw/chinese/3/7_12_8dl.asp',para),paste0("Temp_data/",id,"_Big3OI_tmp.csv"),mode="wb",quiet=T)
  # 如果檔案錯誤 --> 刪除檔案
  if(grepl("<!DOCTYPE",readChar(paste0("Temp_data/",id,"_Big3OI_tmp.csv"),100,useBytes=T))){
    file.remove(paste0("Temp_data/",id,"_Big3OI_tmp.csv"))
  }
  # 遞增回扣天數
  i = i +1
  if(i>15){
    cat("File URL error!!! please check ~~ ")
    q() #跳出腳本
  }
}

## 把檔案拆成 {外資、自營、投信}
data = read.csv(paste0("Temp_data/",id,"_Big3OI_tmp.csv"),stringsAsFactors = F) %>% .[,c(1,3,14)] %>% `colnames<-`(c("Date","side","OI"))
Foreign = data %>% mutate(len=nchar(side)) %>% filter( len==5 )
Dealer = data %>% mutate(len=nchar(side)) %>% filter( len==3 )
InvestTrust = data %>% mutate(len=nchar(side)) %>% filter( len==2 )

# ## 用中文程式碼會出錯
# data = read.csv(paste0("Temp_data/",id,"_Big3OI_tmp.csv")) %>% select("日期","身份別","多空未平倉口數淨額")
# Foreign = data %>% filter(`身份別`=="外資及陸資") %>% `colnames<-`(c("Date","side","OI"))
# Dealer = data %>% filter(`身份別`=="自營商") %>% `colnames<-`(c("Date","side","OI"))
# InvestTrust = data %>% filter(`身份別`=="投信") %>% `colnames<-`(c("Date","side","OI"))

# Foreign[1:5,]
# Dealer[1:5,]
# InvestTrust[1:5,]

## 輸出檔案
write.table(Foreign[c("Date","OI")],file=paste0("current_data/",id,"_Foreign.csv"),sep=",",quote = F,row.names = FALSE,col.names = FALSE)
write.table(Dealer[c("Date","OI")],file=paste0("current_data/",id,"_Dealer.csv"),sep=",",quote = F,row.names = FALSE,col.names = FALSE)
write.table(InvestTrust[c("Date","OI")],file=paste0("current_data/",id,"_InvestmentTrust.csv"),sep=",",quote = F,row.names = FALSE,col.names = FALSE)

cat("  From R: ",id," Big3_OI ~~ Completed\n")

## End


