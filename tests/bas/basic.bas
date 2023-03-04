Option _Explicit
$Console:Only

'$include:'../../src/json.bi'

Dim j As Json

JsonInit j

Dim json As String, ret As Long
json = "{" + AddQuotes$("key1") + ":true, " + AddQuotes$("key2") + ": 20       , " + AddQuotes$("foo") + ": [ 20, 30, 40 ]}"

ret = JsonParse&(j, json)

Print "Original json: "; json
Print "Return: "; ret
Print "Error:"; JsonHadError; ", str: "; JsonError
Print

JsonClear j

JsonInit j

Dim As Long s, b, flo, arr, k, k2, obj

s& = JsonTokenCreateString&(j, "This is a string!")
b& = JsonTokenCreateBool&(j, -1)
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

Dim fmt As JsonFormat
fmt.Indented = -1

Print "Created JSON: "; JsonRenderFormatted$(j, fmt)

JsonClear j

System

Sub foo(a)

End Sub

'$include:'../../src/json.bm'
'
Function AddQuotes$ (s As String)
    AddQuotes$ = Chr$(34) + s + Chr$(34)
End Function
