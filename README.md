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














