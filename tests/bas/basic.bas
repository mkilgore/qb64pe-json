Option _Explicit
$Console:Only

'$include:'../src/json.bi'

Dim ret As Long, json As String
ReDim tokens(1000) As jsontok

json = "{" + AddQuotes$("key1") + ":true}"

ret = ParseJson&(json, tokens())

Print "Original json: "; json
Print "Return: "; ret
Print

PrintTokens json, tokens(), 1, 0

System

'$include:'../src/json.bm'
