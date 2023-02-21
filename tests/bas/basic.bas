' Option _Explicit
$Console:Only

'$include:'../../src/json.bi'

Dim j As Json

JsonInit j


' For i = 1 to 1024
'     Print "Idx:"; i; ", free: "; JsonGetEmptyToken&(j)
' Next
' 
' For i = 400 To 800 Step 4
'     'Print "Mark: "; i; i + 3
'     JsonMarkEmptyToken j, i
'     JsonMarkEmptyToken j, i + 3
' Next
' 
' For i = 800 To 400 Step -4
'     'Print "Mark: "; i + 1; i + 2
'     JsonMarkEmptyToken j, i + 1
'     JsonMarkEmptyToken j, i + 2
' Next
' 
' count = 0
' For i = 400 To 803
'     res = JsonGetEmptyToken&(j)
'     ' Print "free: "; res;
'     if res < 805 Then count = count + 1
' Next
' 
' Print
' Print "Count:"; count
' Print "next: "; JsonGetEmptyToken&(j)
' Print "next: "; JsonGetEmptyToken&(j)
' Print "next: "; JsonGetEmptyToken&(j)

JsonClear j

' Dim ret As Long, json As String
' ReDim tokens(1000) As jsontok

JsonInit j

Dim json As String
json = "{" + AddQuotes$("key1") + ":true, " + AddQuotes$("key2") + ": 20       , " + AddQuotes$("foo") + ": [ 20, 30, 40 ]}"

ret = JsonParse&(json, j)

Print "Original json: "; json
Print "Return: "; ret
Print "Error:"; JsonHadError; ", str: "; JsonError
Print

PrintTokens j, 0, 0

JsonClear j

JsonInit j

s& = JsonTokenCreateString&(j, "This is a string!")
b& = JsonTokenCreateBoolean&(j, -1)
flo& = JsonTokenCreateInteger(j, 5000100)

arr& = JsonTokenCreateArray&(j)

JsonTokenArrayAdd j, arr&, s&
JsonTokenArrayAdd j, arr&, b&
JsonTokenArrayAdd j, arr&, flo&

k& = JsonTokenCreateKey&(j, "key1", arr&)

s& = JsonTokenCreateString&(j, "another string")

k2& = JsonTokenCreateKey&(j, "key2", s&)

obj& = JsonTokenCreateObject&(j)

JsonTokenObjectAdd j, obj&, k&
JsonTokenObjectAdd j, obj&, k2&

JsonSetRootToken j, obj&

Print "Created JSON: "; JsonRender$(j)

JsonClear j

' Print "Generated JSON: "; JsonRender$(json, tokens())

System

Sub foo(a)

End Sub

'$include:'../../src/json.bm'
'
Function AddQuotes$ (s As String)
    AddQuotes$ = Chr$(34) + s + Chr$(34)
End Function
