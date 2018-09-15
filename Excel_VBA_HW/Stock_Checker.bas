Attribute VB_Name = "Stock_Checker"
Sub Stock_Checker()

Dim ws As Worksheet


For Each ws In Worksheets

Dim YC As Double
Dim YCH As Double
Dim PC As Double
Dim i As Long
Dim RowCountz As Long
Dim RB As Integer
Dim j As Long
Dim GPI As Double
Dim GPD As Double
Dim GTV As Double
Dim YO As Double


RowCountz = ws.Cells(Rows.Count, 1).End(xlUp).Row + 1
ws.Cells(1, 9).Value = "Ticker"
ws.Cells(1, 10).Value = "Yearly Change"
ws.Cells(1, 11).Value = "Percent Change"
ws.Cells(1, 12).Value = "Total Volume"
ws.Cells(1, 16).Value = "Ticker"
ws.Cells(1, 17).Value = "Value"
ws.Cells(2, 15).Value = "Greatest % Increase"
ws.Cells(3, 15).Value = "Greatest % Decrease"
ws.Cells(4, 15).Value = "Greatest Total Volume"

TV = 0
RB = 2
YO = ws.Cells(2, 3).Value
GPI = 0
GPD = 0
GTV = 0

For i = 2 To RowCountz
    
    If ws.Cells(i, 1).Value = ws.Cells(i + 1, 1).Value Then
    TV = TV + ws.Cells(i, 7).Value
    
    Else
    TV = TV + ws.Cells(i, 7).Value
    ws.Cells(RB, 9).Value = ws.Cells(i, 1).Value
    ws.Cells(RB, 12).Value = TV
    YC = ws.Cells(i, 6).Value
    YCH = YC - YO
    PC = YCH / YO
        
    ws.Cells(RB, 11).Value = PC
    ws.Cells(RB, 10).Value = YCH
    ws.Cells(RB, 11).NumberFormat = ".00%"
    
        
        If ws.Cells(RB, 10).Value < 0 Then
        ws.Cells(RB, 10).Interior.ColorIndex = 3
        ElseIf ws.Cells(RB, 10).Value > 0 Then
        ws.Cells(RB, 10).Interior.ColorIndex = 4
        End If
        
    YO = ws.Cells(i + 1, 3).Value
    TV = 0
    RB = RB + 1
    End If
    
Next i

For j = 2 To RowCountz
    If ws.Cells(j, 11).Value > GPI Then
    GPI = ws.Cells(j, 11).Value
    ws.Cells(2, 17).Value = GPI
    ws.Cells(2, 16).Value = ws.Cells(j, 9).Value
    
    ElseIf ws.Cells(j, 11).Value < GPD Then
    GPD = ws.Cells(j, 11).Value
    ws.Cells(3, 17).Value = GPD
    ws.Cells(3, 16).Value = ws.Cells(j, 9).Value
    End If
    
    If ws.Cells(j, 12).Value > GTV Then
    GTV = ws.Cells(j, 12).Value
    ws.Cells(4, 17).Value = GTV
    ws.Cells(4, 16).Value = ws.Cells(j, 9).Value
    End If
Next j

ws.Cells(2, 17).NumberFormat = ".00%"
ws.Cells(3, 17).NumberFormat = ".00%"

Next ws

End Sub


