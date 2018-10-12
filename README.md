# Taifex_Crawler
Crawl the OI information of Taifex with R and Python


# 說明
這是一個可以將台灣期貨交易所公佈的資訊取出
並且合併在歷史資料檔中
對於所想要取得的資料
維護一個完整的csv檔
為了防止沒抓到資料
每日更新的時間點為16:00
(期交所有時候公佈時間會慢)

# 架構
![alt text](https://github.com/Joshua6300018/Taifex_Crawler/blob/master/structure.png "Structure Plot")


# 目前進度
目前只完成R版本的三大法人未平倉&五個契約的交易資訊
接下來持續改寫程Python版並預計加入Imply Var與選擇權的籌碼資料

And control them by batch script.

You can use Linux Crontab or Windows Task Scheduler to run OI_Crawler.bat everyday after 16:00 p.m. 

# 預計新增項目
1. PC-ratio
2. 三大法人-選擇權未平倉
3. 大額交易人
   (1) 交易人  <br />
   (2) 特定法人  <br />
   (3) PutCall/買賣 + 特法PC ratio <br />
   (4) 特法市場佔比 <br />

4. 波動度(Imply Var)
5. 選擇權各序列分開OI(全市場) <br />
   *把OI依照各序列的Delta分成五組:  <br />
      (1) DeepITM 深價內 : Delta 大於 0.9   <br />
      (2) ITM     價內  : 0.9 > Delta > 0.5  <br />
      (3) ATM     價平  : 最接近 0.5   <br />
      (4) OTM     價外  : 0.5 > Delta > 0.1   <br />
      (5) DeepOTM 深價外 : Delta 小於 0.1   <br />
      
 


















