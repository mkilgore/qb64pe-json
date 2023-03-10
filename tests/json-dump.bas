Option _Explicit
$Console:Only

ChDir _StartDir$

ON ERROR GOTO errorhand

'$include:'../src/json.bi'

Dim ret As Long, json As String
Dim j As json
JsonInit j

json = ReadFile$(COMMAND$(1))

ret = JsonParse&(j, json)

Print "Parse result: ";
If ret = JSON_ERR_Success Then
    Print "Success"; ret

    Print
    PrintTokens j, j.RootToken, 0

    Dim fmt As JsonFormat
    fmt.Indented = -1

    Print
    Print JsonRenderFormatted$(j, fmt)
Else
    Print "Failure "; ret
    Print "JsonHadError: "; JsonHadError; ", Error: "; JsonError
End If


JsonClear j
System

errorhand:
Print "Error: "; ERR
System

'$include:'../src/json.bm'

Sub PrintTokens(j As Json, tok As Long, lvl As Long)
    Dim fmt As JsonFormat
    fmt.Indented = 0

    Print Space$(lvl * 2); "type: "; ___JsonTokenTypeString$(JsonTokenGetType&(j, tok));

    If JsonTokenGetType&(j, tok) = JSONTOK_TYPE_VALUE Or JsonTokenGetType&(j, tok) = JSONTOK_TYPE_KEY Then
        Print ", value: "; AddQuotes$(JsonTokenGetValueStr$(j, tok))
    Else
        Print
    End If

    Dim i As Long
    For i = 0 To JsonTokenTotalChildren&(j, tok) - 1
        PrintTokens j, JsonTokenGetChild&(j, tok, i), lvl + 1
    Next
End Sub

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

Function AddQuotes$ (s As String)
    AddQuotes$ = Chr$(34) + s + Chr$(34)
End Function
