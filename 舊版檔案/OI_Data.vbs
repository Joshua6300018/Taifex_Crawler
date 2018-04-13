' OI_Data.vbs
' 使用VBScript抓取期貨三大法人未平倉資料，並輸出成CSV可以餵給MultiCharts
' Author ：iInfo資訊交流 Amin
' Date   ： 2016/12/09
' Version：V1.00
'
' 1.使用AJAX抓取期交所盤後三大法人資料
' 2.抓出從當日往前推3年的外資與陸資未平倉歷史資料
' 3.輸出可以餵給MultiCharts使用的CSV
'
' History：
'	2016/12/09 V1.00 First Edit.

Const xlUp = -4162
Const xlToLeft = -4159
Const xlDataField = 4
Const xlDatabase = 1
Const xlCaptionEquals = 15
Const xlCSV = 6

'Command輸入判別
if Wscript.Arguments.Count = 2 then	
	Select Case Wscript.Arguments.Item(1)
		Case "1"
			conditional = "外資及陸資"
			fName = Wscript.Arguments.Item(0) & "_Foreign.csv"			
		Case "2"
			conditional = "自營商"
			fName = Wscript.Arguments.Item(0) & "_Dealer.csv"
		Case "3"
			conditional = "投信"
			fName = Wscript.Arguments.Item(0) & "_InvestmentTrust.csv"
		Case Else
			conditional = ""
			Msgbox "參數輸入錯誤，請重新輸入!!", vbCritical, "錯誤"
	end Select
	
	if conditional <> "" then
		'指定路徑與名稱			
		FolderName = "C:\期貨下載資料\"
		FileName = FolderName & "期貨資料.csv"
		
		'取得桌面路徑
		currentpath = Createobject("Scripting.FileSystemObject").GetFile(Wscript.ScriptFullName).ParentFolder.Path
		
		'組成輸出CSV檔檔名
		outputFile = currentpath & "\current_data\" & fName
		
		'建立檔案下載目錄
		createFolder(FolderName)	
		
		'下載三大法人檔案檔案
		downloadFile(Wscript.Arguments.Item(0))
		
		'篩選資料
		Fdata = filterData(conditional)
		
		'確保有正確資料
		if UBound(Fdata) <> 0 then
			'輸出CSV檔		
			OutputCSV Fdata, outputFile
		else
			Msgbox "檔案下載有問題，請確認相關程式或參數!!", vbCritical, "錯誤"
		end if
	end if
else
	Usage
end if

Sub Usage
	Dim strMsg
	strMsg = UCase( WScript.ScriptName ) _
		& vbCrLf & vbCrLf _
		& "抓取期貨三大法人未平倉量，輸出MultiCharts可讀檔案,  Version 1.00" _
		& vbCrLf & vbCrLf _
		& "Usage:  " & UCase( WScript.ScriptName ) & "  [command]"  _
		& vbCrLf _
		& "		     [command]" _
		& vbCrLf _
		& "		     1  ""外資及陸資"" "   _
		& vbCrLf _
		& "		     2  ""外自營商"" "   _
		& vbCrLf _
		& "		     3  ""投信"" "   _
		& vbCrLf _
		& "		     執行後輸出OIData.csv" _
		& vbCrLf & vbCrLf _
		& "iInfo資訊交流 http://white5168.blogspot.tw/"
		Msgbox strMsg, vbInformation, "操作方法"
end sub

Sub outputCSV(Fdata, outputFile)
        '建立Excel物件
        Set objExcel = CreateObject("Excel.Application")
        
        '建立工作簿
	Set objWB = objExcel.Workbooks.Add         
	
	with objExcel
		'不顯示 Excel Alerts
		.DisplayAlerts = False
		
		'不顯示Excel畫面
		.Visible = False
		
	        for i = 1 to UBound(Fdata, 1)-1
	            .Cells(i,1).Value = Fdata(i, 1)
	            '指定日期格式
	            .Cells(i,1).NumberFormatLocal = "yyyy/mm/dd"
	            .Cells(i,2).Value = Fdata(i, 2)
	        next
	end with
	
	'指定儲存為CSV格式
        objWB.SaveAs outputFile, xlCSV
        
        '離開Excel
        objExcel.Quit
        
        '釋放資源
        Set objWB = Nothing
	Set objExcel = Nothing        
End Sub

Function filterData(conditional)
	'建立Excel物件
	Set objExcel = CreateObject("Excel.Application")
	
	'開啟指定檔案
	Set objWB = objExcel.Workbooks.Open(FileName) 	

	'不顯示 Excel Alerts
	objExcel.DisplayAlerts = False
	
	'不顯示Excel畫面
	ObjExcel.Visible = False
	
	'新增工作表
	objWB.sheets.Add
	
	'指定樞紐分析表的位置
	StartPvt = objWB.Sheets(1).Name & "!R1C1"
		
	Set WSD = objWB.Sheets("期貨資料")
	
	'抓出資料的範圍	
	FinalRow = WSD.Cells(WSD.Rows.Count, 1).End(xlUp).Row
        FinalCol = WSD.Cells(1, WSD.Columns.Count).End(xlToLeft).Column
        
        '指定資料範圍
        Set PRange = WSD.Cells(1, 1).Resize(FinalRow, FinalCol)
        
        '建立樞紐分析表快取
        Set PTCache = objExcel.ActiveWorkbook.PivotCaches.Create(1, PRange)
        
        '建立樞紐分析表
        Set PT = PTCache.CreatePivotTable(StartPvt, "PivotTable1")
        
        '操作樞紐分析表
        with PT
        	'指定Row欄位
	        .AddFields Array("日期", "身份別")
	        
	        '指定資料
	        .PivotFields("多空未平倉口數淨額")
	        .PivotFields("多空未平倉口數淨額").Orientation = xlDataField       
		
		'挑選前幾名的資料
	        '.PivotFields("身份別").PivotFilters.Add xlDatabase, .PivotFields("加總 - 多空未平倉口數淨額"), 1
	        
	        '篩選 "外資及陸資"、"自營商"、"投信"
	        .PivotFields("身份別").PivotFilters.Add xlCaptionEquals, , conditional
	        
	        '摺疊項目
	        .PivotFields("日期").ShowDetail = False
	        
	        '移除"總計"
	        .ColumnGrand = False         
	        
	        '選取內容
	        filterData = .TableRange2.Offset(1, 0)
	        
	        '資料欄位
	        '.DataBodyRange
	end with
	
	'關閉檔案
        objWB.Close 0
        
        '離開Excel
	objExcel.Quit
	
	'釋放資源
	Set objWB = Nothing
	Set objExcel = Nothing
End Function

Function checkFileText()
	'建立Excel物件
	Set objExcel = CreateObject("Excel.Application")
	
	'開啟指定檔案
	Set objWB = objExcel.Workbooks.Open(FileName) 	

	'不顯示 Excel Alerts
	objExcel.DisplayAlerts = False
	
	'不顯示Excel畫面
	ObjExcel.Visible = False
        
        CheckFileText = False
        
	'防止下載錯誤內容
	if Instr(1, objWB.Sheets(1).cells(1,1), "<!DOCTYPE") <> 0 then
           CheckFileText = True
	end if
        
	'關閉檔案
        objWB.Close 0
        
        '離開Excel
	objExcel.Quit
	
	'釋放資源
	Set objWB = Nothing
	Set objExcel = Nothing 
End Function

Function downloadFile(CommodityCode) 
        SYear = Year(now) - 3
        SMonth = Month(now)
        SDay = Day(now) + 1
        EYear = Year(now)
        EMonth = Month(now) 
		
	'當時間大於當日下午15:20後，日期改以當天日期為主
        'if DateDiff("n", DateAdd("n", 920, Date), now) < 0 then
	'	EDay = Day(now) - 1
        'else
        '	EDay = Day(now)
	'end if
        i = 0
        do
                while Weekday(DateAdd("d", (-1) * i, Date), 2) = 7 or Weekday(DateAdd("d", (-1) * i, Date), 2) = 6
                        i = i + 1
                wend
                
                EDay = Day(now) - i
                
                '組成期交所三大法人盤後資料的URL
                para = "?syear=" & SYear &"&smonth=" & SMonth & "&sday=" & SDay & "&eyear=" & EYear & "&emonth=" & EMonth & "&eday=" & EDay & "&COMMODITY_ID=" & CommodityCode
                URL = "http://www.taifex.com.tw/chinese/3/7_12_8dl.asp" & para

                XMLHTTP URL

                i = i + 1                
        Loop while checkFileText      
End Function

Sub XMLHTTP(URL)
	'建立XMLHTTP物件
	Set objXMLHTTP = CreateObject("Microsoft.XMLHTTP")
	
	'建立ADODB.stream物件
	Set objStream = CreateObject("ADODB.stream")
    
    	with objXMLHTTP
    		'使用同步傳送方式
		.Open "GET", URL, False
		
		'執行AJAX		
		.send 

                'Server成功回傳資料
		If .Status = 200 Then
			with objStream
				'開啟數據流通道
				.Open
				
				'指定通道類型
				.Type = 1
				
				'導入數據				
				.Write objXMLHTTP.ResponseBody
				
				'確認檔案是否存在
				If checkFileExist(FileName) <> "" Then deleteFile FileName			
				
				'存檔
				.SaveToFile FileName
				
				'關閉數據流通道
				.Close
			end with
		End if	
	end with
	
	'釋放資源
	Set objXMLHTTP = Nothing
	Set objStream = Nothing
End Sub

Function createFolder(FolderName)
	Dim objFSO	
	'建立檔案物件
	Set objFSO = CreateObject("Scripting.FileSystemObject") 
	
	'初始化
	createFolder = False
	
	'確認目錄存在與否
	If Not objFSO.FolderExists(FolderName) Then
		'建立目錄
		objFSO.CreateFolder(FolderName)		
		createFolder = True
	End If
	
	'釋放資源
	Set objFSO = Nothing
End Function

Function checkFileExist(FilePath)
	Dim objFSO	
	'建立檔案物件
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	 
	'初始化 
	checkFileExist = True
	If not objFSO.FileExists(FilePath) Then checkFileExist = False 
	
	'釋放資源
	Set objFSO = Nothing
End Function

Function deleteFile(FilePath)
	Dim objFSO
	'建立檔案物件
	Set objFSO = CreateObject("Scripting.FileSystemObject") 
	
	If objFSO.FileExists(FilePath) Then objFSO.DeleteFile FilePath
	
	'釋放資源
	Set objFSO = Nothing
End Function