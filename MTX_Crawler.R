#### 下載期交所依契約到日的未平倉量(OI) ####
if (!suppressMessages(require(dplyr))) install.packages("dplyr", repos="http://cran.rstudio.com/");
suppressMessages(library(dplyr))
if (!suppressMessages(require(stringi))) install.packages("stringi", repos="http://cran.rstudio.com/");
suppressMessages(library(stringi))

args = commandArgs(TRUE)
id = args[1]
setwd(args[2])

# id = "MTX"
# setwd("C:/Users/90813/Desktop/OI_Crawler/")

#### 取得一段時間內的data ####
get_interval = function(datestart,dateend,id){
  
  ## 下載檔案
  # datestart = "2018/01/22"
  # dateend = "2018/02/11"
  
  download.file(paste0('http://www.taifex.com.tw/chinese/3/3_1_2dl.asp?datestart=',datestart,'&dateend=',dateend,'&COMMODITY_ID=',id),
                paste0("Temp_data/",id,"_tmp.csv"),mode="wb",quiet=T)
  
  ## 清理資料(轉為連續月)
  data = read.csv(paste0("Temp_data/",id,"_tmp.csv"),stringsAsFactors=FALSE)[,c(1,2,3,12)] %>% 
         .[which(.[,4]!="-"),] %>% 
         `colnames<-`(c("Date","contract","expiration","OI"))
  
  gb_data = group_by(.data=data,Date,len = nchar(expiration)) %>% mutate( FM = order(expiration) )
  gb_data = cbind(gb_data, wm = gsub(8,"W",gb_data$len) %>% gsub(6,"",.))
  fn_data = cbind.data.frame(date = gb_data$Date, contract = paste0(gb_data$contract,gb_data$wm,gb_data$FM),OI = as.numeric(gb_data$OI))
  fn_data[1:10,]
  
  return(fn_data)
}

#### 更新最近的data ####
update_recent = function(id){
  
  ## 設定下載參數
  datestart=format(Sys.Date()-20,"%Y/%m/%d") #最近20天
  dateend=format(Sys.Date(),"%Y/%m/%d")
  # id = args[1]
  # id = "MTX"
  
  ## 下載近期資料
  fn_data = get_interval(datestart,dateend,id)
  
  ## 依到期合約分成不同變數
  MTX1 = filter(fn_data, (contract==paste0(id,"1")|contract==paste0(id,"W1")|contract==paste0(id,"W2")) ) %>% group_by(date) %>% summarise(OI = sum(OI))
  MTX2 = filter(fn_data, contract==paste0(id,"2") ) %>% select("date","OI")
  MTX3 = filter(fn_data, contract==paste0(id,"3") ) %>% select("date","OI")
  MTX4 = filter(fn_data, contract==paste0(id,"4") ) %>% select("date","OI")
  MTX5 = filter(fn_data, contract==paste0(id,"5") ) %>% select("date","OI")
  
  ## 讀取歷史資料
  tryCatch({
    if(file.exists(paste0("current_data/",id,"1.csv"))){
      MTX1_past=data.frame();MTX2_past=data.frame();MTX3_past=data.frame();
      MTX4_past=data.frame();MTX5_past=data.frame();
      
      MTX1_past = read.table(file=paste0("current_data/",id,"1.csv"),sep = ",") %>% `colnames<-`(c("date","OI"))
      MTX2_past = read.table(file=paste0("current_data/",id,"2.csv"),sep = ",") %>% `colnames<-`(c("date","OI"))
      MTX3_past = read.table(file=paste0("current_data/",id,"3.csv"),sep = ",") %>% `colnames<-`(c("date","OI"))
      MTX4_past = read.table(file=paste0("current_data/",id,"4.csv"),sep = ",") %>% `colnames<-`(c("date","OI"))
      MTX5_past = read.table(file=paste0("current_data/",id,"5.csv"),sep = ",") %>% `colnames<-`(c("date","OI"))
      
      ## 合併歷史資料與新資料 + distinct
      MTX1 = distinct(rbind(MTX1,MTX1_past)) %>% arrange(.,as.Date(date))
      MTX2 = distinct(rbind(MTX2,MTX2_past)) %>% arrange(.,as.Date(date))
      MTX3 = distinct(rbind(MTX3,MTX3_past)) %>% arrange(.,as.Date(date))
      MTX4 = distinct(rbind(MTX4,MTX4_past)) %>% arrange(.,as.Date(date))
      MTX5 = distinct(rbind(MTX4,MTX4_past)) %>% arrange(.,as.Date(date))
    }
  },error=function(e){
    conditionMessage(e)
  })
  
  ## 輸出檔案
  write.table(MTX1[,c("date","OI")],file=paste0("current_data/",id,"1.csv"),sep=",",quote = F,row.names = FALSE,col.names = FALSE)
  write.table(MTX2[,c("date","OI")],file=paste0("current_data/",id,"2.csv"),sep=",",quote = F,row.names = FALSE,col.names = FALSE)
  write.table(MTX3[,c("date","OI")],file=paste0("current_data/",id,"3.csv"),sep=",",quote = F,row.names = FALSE,col.names = FALSE)
  write.table(MTX4[,c("date","OI")],file=paste0("current_data/",id,"4.csv"),sep=",",quote = F,row.names = FALSE,col.names = FALSE)
  write.table(MTX5[,c("date","OI")],file=paste0("current_data/",id,"5.csv"),sep=",",quote = F,row.names = FALSE,col.names = FALSE)
  ## End
}

#### 取得歷史的data ####
history_data = function(id){
  
  ## 分成兩部分: 1.過去的年資料 2.今年1/1到現在的資料
  ## 分別合併到 tt_data中
  tt_data = data.frame()
  
  ## ------- 1.取年資料 -------
  
  ## 取出指定年資料的檔名
  fl = list.files("Temp_data/") %>% .[grep("*_fut.csv",.)]
  
  # id = "MTX"
  
  ## 逐個檔整理+合併
  for(i in fl){
    
    his_year = substr(i,1,4) %>% as.numeric()
    cat(his_year,"\n")
    ## 清理資料(轉為連續月)
    data = read.csv(paste0("Temp_data/",i),stringsAsFactors=FALSE)[,c(1,2,3,12)] %>% 
           .[which(.[,4]!="-"),] %>% 
           `colnames<-`(c("Date","contract","expiration","OI")) %>%
           filter(.,contract==id)
  
    gb_data = group_by(.data=data,Date,len = nchar(expiration)) %>% mutate( FM = order(contract) )
    gb_data = cbind(gb_data, wm = gsub(8,"W",gb_data$len) %>% gsub(6,"",.))
    
    fn_data = cbind.data.frame(date = gb_data$Date, contract = paste0(gb_data$contract,gb_data$wm,gb_data$FM),OI = as.numeric(gb_data$OI))
    fn_data[1:10,]
    ## 合併
    tt_data = rbind.data.frame(tt_data,fn_data)
  }
  
  tt_data[1:10,]
  tail(tt_data)
  ## ------- 2.取得當年度之前的資料 --------
  cat(paste0("Get current year(",format(Sys.Date(),"%Y"),") data\n"))
  lastDay = 0
  cnt = 0
  while(lastDay <= Sys.Date() ){
    
    start_num = format(as.Date(paste0(format(Sys.Date(),"%Y"),"/01/01")) + cnt ,"%Y/%m/%d")
    end_num = format(as.Date(start_num) + 20,"%Y/%m/%d")
    lastDay = end_num
    
    # print(paste0(start_num," -- ",end_num))
    cnt = cnt + 21
    tt_data = rbind.data.frame(tt_data, get_interval(start_num,end_num,id))
  }
  
  # tail(tt_data)
  
  ## 依到期合約分成不同變數
  MTX1 = filter(tt_data, (contract==paste0(id,"1")|contract==paste0(id,"W1")|contract==paste0(id,"W2")) ) %>% group_by(date) %>% summarise(OI = sum(OI))
  MTX2 = filter(tt_data, contract==paste0(id,"2") ) %>% select("date","OI")
  MTX3 = filter(tt_data, contract==paste0(id,"3") ) %>% select("date","OI")
  MTX4 = filter(tt_data, contract==paste0(id,"4") ) %>% select("date","OI")
  MTX5 = filter(tt_data, contract==paste0(id,"5") ) %>% select("date","OI")
  
  ## 輸出檔案
  write.table(MTX1[,c("date","OI")],file=paste0("current_data/",id,"1.csv"),sep=",",quote = F,row.names = FALSE,col.names = FALSE)
  write.table(MTX2[,c("date","OI")],file=paste0("current_data/",id,"2.csv"),sep=",",quote = F,row.names = FALSE,col.names = FALSE)
  write.table(MTX3[,c("date","OI")],file=paste0("current_data/",id,"3.csv"),sep=",",quote = F,row.names = FALSE,col.names = FALSE)
  write.table(MTX4[,c("date","OI")],file=paste0("current_data/",id,"4.csv"),sep=",",quote = F,row.names = FALSE,col.names = FALSE)
  write.table(MTX5[,c("date","OI")],file=paste0("current_data/",id,"5.csv"),sep=",",quote = F,row.names = FALSE,col.names = FALSE)
  
}

## 執行

## mode變依據傳入的第三個參數決定
## 若無第三個參數      => 則只更新最近的資料
## 若第三個參數為"all" => 則包含年度歷史資料一併更新
mode = "recent"
if(length(args)==3){
  if(args[3]=="all"){
    mode = "history"
  }
}

if(mode == "recent"){
  update_recent(id)
  cat("  From R: ",id," Total_OI ~~ Completed\n")
}else if(mode=="history"){
  history_data(id)
  update_recent(id)
  cat("  From R: ",id," Total_OI ~~ Completed\n")
}

# update_recent()
# history_data("MTX")


## End




