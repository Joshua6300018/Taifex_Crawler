' OI_Data.vbs
' �ϥ�VBScript������f�T�j�k�H�����ܸ�ơA�ÿ�X��CSV�i�H����MultiCharts
' Author �GiInfo��T��y Amin
' Date   �G 2016/12/09
' Version�GV1.00
'
' 1.�ϥ�AJAX�������ҽL��T�j�k�H���
' 2.��X�q��驹�e��3�~���~��P���ꥼ���ܾ��v���
' 3.��X�i�H����MultiCharts�ϥΪ�CSV
'
' History�G
'	2016/12/09 V1.00 First Edit.

Const xlUp = -4162
Const xlToLeft = -4159
Const xlDataField = 4
Const xlDatabase = 1
Const xlCaptionEquals = 15
Const xlCSV = 6

'Command��J�P�O
if Wscript.Arguments.Count = 2 then	
	Select Case Wscript.Arguments.Item(1)
		Case "1"
			conditional = "�~��γ���"
			fName = Wscript.Arguments.Item(0) & "_Foreign.csv"			
		Case "2"
			conditional = "�����"
			fName = Wscript.Arguments.Item(0) & "_Dealer.csv"
		Case "3"
			conditional = "��H"
			fName = Wscript.Arguments.Item(0) & "_InvestmentTrust.csv"
		Case Else
			conditional = ""
			Msgbox "�Ѽƿ�J���~�A�Э��s��J!!", vbCritical, "���~"
	end Select
	
	if conditional <> "" then
		'���w���|�P�W��			
		FolderName = "C:\���f�U�����\"
		FileName = FolderName & "���f���.csv"
		
		'���o�ୱ���|
		currentpath = Createobject("Scripting.FileSystemObject").GetFile(Wscript.ScriptFullName).ParentFolder.Path
		
		'�զ���XCSV���ɦW
		outputFile = currentpath & "\current_data\" & fName
		
		'�إ��ɮפU���ؿ�
		createFolder(FolderName)	
		
		'�U���T�j�k�H�ɮ��ɮ�
		downloadFile(Wscript.Arguments.Item(0))
		
		'�z����
		Fdata = filterData(conditional)
		
		'�T�O�����T���
		if UBound(Fdata) <> 0 then
			'��XCSV��		
			OutputCSV Fdata, outputFile
		else
			Msgbox "�ɮפU�������D�A�нT�{�����{���ΰѼ�!!", vbCritical, "���~"
		end if
	end if
else
	Usage
end if

Sub Usage
	Dim strMsg
	strMsg = UCase( WScript.ScriptName ) _
		& vbCrLf & vbCrLf _
		& "������f�T�j�k�H�����ܶq�A��XMultiCharts�iŪ�ɮ�,  Version 1.00" _
		& vbCrLf & vbCrLf _
		& "Usage:  " & UCase( WScript.ScriptName ) & "  [command]"  _
		& vbCrLf _
		& "		     [command]" _
		& vbCrLf _
		& "		     1  ""�~��γ���"" "   _
		& vbCrLf _
		& "		     2  ""�~�����"" "   _
		& vbCrLf _
		& "		     3  ""��H"" "   _
		& vbCrLf _
		& "		     ������XOIData.csv" _
		& vbCrLf & vbCrLf _
		& "iInfo��T��y http://white5168.blogspot.tw/"
		Msgbox strMsg, vbInformation, "�ާ@��k"
end sub

Sub outputCSV(Fdata, outputFile)
        '�إ�Excel����
        Set objExcel = CreateObject("Excel.Application")
        
        '�إߤu�@ï
	Set objWB = objExcel.Workbooks.Add         
	
	with objExcel
		'����� Excel Alerts
		.DisplayAlerts = False
		
		'�����Excel�e��
		.Visible = False
		
	        for i = 1 to UBound(Fdata, 1)-1
	            .Cells(i,1).Value = Fdata(i, 1)
	            '���w����榡
	            .Cells(i,1).NumberFormatLocal = "yyyy/mm/dd"
	            .Cells(i,2).Value = Fdata(i, 2)
	        next
	end with
	
	'���w�x�s��CSV�榡
        objWB.SaveAs outputFile, xlCSV
        
        '���}Excel
        objExcel.Quit
        
        '����귽
        Set objWB = Nothing
	Set objExcel = Nothing        
End Sub

Function filterData(conditional)
	'�إ�Excel����
	Set objExcel = CreateObject("Excel.Application")
	
	'�}�ҫ��w�ɮ�
	Set objWB = objExcel.Workbooks.Open(FileName) 	

	'����� Excel Alerts
	objExcel.DisplayAlerts = False
	
	'�����Excel�e��
	ObjExcel.Visible = False
	
	'�s�W�u�@��
	objWB.sheets.Add
	
	'���w�ϯä��R����m
	StartPvt = objWB.Sheets(1).Name & "!R1C1"
		
	Set WSD = objWB.Sheets("���f���")
	
	'��X��ƪ��d��	
	FinalRow = WSD.Cells(WSD.Rows.Count, 1).End(xlUp).Row
        FinalCol = WSD.Cells(1, WSD.Columns.Count).End(xlToLeft).Column
        
        '���w��ƽd��
        Set PRange = WSD.Cells(1, 1).Resize(FinalRow, FinalCol)
        
        '�إ߼ϯä��R��֨�
        Set PTCache = objExcel.ActiveWorkbook.PivotCaches.Create(1, PRange)
        
        '�إ߼ϯä��R��
        Set PT = PTCache.CreatePivotTable(StartPvt, "PivotTable1")
        
        '�ާ@�ϯä��R��
        with PT
        	'���wRow���
	        .AddFields Array("���", "�����O")
	        
	        '���w���
	        .PivotFields("�h�ť����ܤf�Ʋb�B")
	        .PivotFields("�h�ť����ܤf�Ʋb�B").Orientation = xlDataField       
		
		'�D��e�X�W�����
	        '.PivotFields("�����O").PivotFilters.Add xlDatabase, .PivotFields("�[�` - �h�ť����ܤf�Ʋb�B"), 1
	        
	        '�z�� "�~��γ���"�B"�����"�B"��H"
	        .PivotFields("�����O").PivotFilters.Add xlCaptionEquals, , conditional
	        
	        '�P�|����
	        .PivotFields("���").ShowDetail = False
	        
	        '����"�`�p"
	        .ColumnGrand = False         
	        
	        '������e
	        filterData = .TableRange2.Offset(1, 0)
	        
	        '������
	        '.DataBodyRange
	end with
	
	'�����ɮ�
        objWB.Close 0
        
        '���}Excel
	objExcel.Quit
	
	'����귽
	Set objWB = Nothing
	Set objExcel = Nothing
End Function

Function checkFileText()
	'�إ�Excel����
	Set objExcel = CreateObject("Excel.Application")
	
	'�}�ҫ��w�ɮ�
	Set objWB = objExcel.Workbooks.Open(FileName) 	

	'����� Excel Alerts
	objExcel.DisplayAlerts = False
	
	'�����Excel�e��
	ObjExcel.Visible = False
        
        CheckFileText = False
        
	'����U�����~���e
	if Instr(1, objWB.Sheets(1).cells(1,1), "<!DOCTYPE") <> 0 then
           CheckFileText = True
	end if
        
	'�����ɮ�
        objWB.Close 0
        
        '���}Excel
	objExcel.Quit
	
	'����귽
	Set objWB = Nothing
	Set objExcel = Nothing 
End Function

Function downloadFile(CommodityCode) 
        SYear = Year(now) - 3
        SMonth = Month(now)
        SDay = Day(now) + 1
        EYear = Year(now)
        EMonth = Month(now) 
		
	'��ɶ��j����U��15:20��A�����H��Ѥ�����D
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
                
                '�զ�����ҤT�j�k�H�L���ƪ�URL
                para = "?syear=" & SYear &"&smonth=" & SMonth & "&sday=" & SDay & "&eyear=" & EYear & "&emonth=" & EMonth & "&eday=" & EDay & "&COMMODITY_ID=" & CommodityCode
                URL = "http://www.taifex.com.tw/chinese/3/7_12_8dl.asp" & para

                XMLHTTP URL

                i = i + 1                
        Loop while checkFileText      
End Function

Sub XMLHTTP(URL)
	'�إ�XMLHTTP����
	Set objXMLHTTP = CreateObject("Microsoft.XMLHTTP")
	
	'�إ�ADODB.stream����
	Set objStream = CreateObject("ADODB.stream")
    
    	with objXMLHTTP
    		'�ϥΦP�B�ǰe�覡
		.Open "GET", URL, False
		
		'����AJAX		
		.send 

                'Server���\�^�Ǹ��
		If .Status = 200 Then
			with objStream
				'�}�Ҽƾڬy�q�D
				.Open
				
				'���w�q�D����
				.Type = 1
				
				'�ɤJ�ƾ�				
				.Write objXMLHTTP.ResponseBody
				
				'�T�{�ɮ׬O�_�s�b
				If checkFileExist(FileName) <> "" Then deleteFile FileName			
				
				'�s��
				.SaveToFile FileName
				
				'�����ƾڬy�q�D
				.Close
			end with
		End if	
	end with
	
	'����귽
	Set objXMLHTTP = Nothing
	Set objStream = Nothing
End Sub

Function createFolder(FolderName)
	Dim objFSO	
	'�إ��ɮת���
	Set objFSO = CreateObject("Scripting.FileSystemObject") 
	
	'��l��
	createFolder = False
	
	'�T�{�ؿ��s�b�P�_
	If Not objFSO.FolderExists(FolderName) Then
		'�إߥؿ�
		objFSO.CreateFolder(FolderName)		
		createFolder = True
	End If
	
	'����귽
	Set objFSO = Nothing
End Function

Function checkFileExist(FilePath)
	Dim objFSO	
	'�إ��ɮת���
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	 
	'��l�� 
	checkFileExist = True
	If not objFSO.FileExists(FilePath) Then checkFileExist = False 
	
	'����귽
	Set objFSO = Nothing
End Function

Function deleteFile(FilePath)
	Dim objFSO
	'�إ��ɮת���
	Set objFSO = CreateObject("Scripting.FileSystemObject") 
	
	If objFSO.FileExists(FilePath) Then objFSO.DeleteFile FilePath
	
	'����귽
	Set objFSO = Nothing
End Function