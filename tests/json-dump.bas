Option _Explicit
$Console:Only

ChDir _StartDir$

ON ERROR GOTO errorhand

'$include:'../src/json.bi'

Dim ret As Long, json As String
ReDim tokens(10000) As jsontok

json = ReadFile$(COMMAND$(1))

' json = "{" + AddQuotes$("key1") + ":true}"

ret = ParseJson&(json, tokens())

Print "Original json: "; json
Print "Parse result: ";
If ret Then
    Print "Success "; ret
Else
    Print "Failure "; ret
End If
Print

PrintTokens json, tokens(), 1, 0

System

errorhand:
Print "Error: "; ERR
System

'$include:'../src/json.bm'

Function ReadFile$(file As String)
    Dim sourceFileNo As Long, fileLength As Long, buffer As String
    sourceFileNo = FREEFILE
    OPEN file FOR BINARY as #sourceFileNo

    fileLength = LOF(sourceFileNo)

    ' Read the file in one go
    buffer = SPACE$(fileLength)

    GET #sourceFileNo, , buffer

    ReadFile$ = buffer

    CLOSE #sourceFileNo
End Function
