Option _Explicit
$Console:Only

'$include:'../../src/json.bi'

Dim j As Json, res As Long

res = JsonTokenCreateBool&(j, -1)
ExpectJsonError "JsonTokenCreateBool", res, JSON_ERR_NotInitialized

res = JsonTokenCreateInteger&(j, 20)
ExpectJsonError "JsonTokenCreateInteger", res, JSON_ERR_NotInitialized

res = JsonTokenCreateDouble&(j, 20.2)
ExpectJsonError "JsonTokenCreateDouble", res, JSON_ERR_NotInitialized

res = JsonTokenCreateNumber&(j, 20, 20, 20)
ExpectJsonError "JsonTokenCreateNumber", res, JSON_ERR_NotInitialized

res = JsonTokenCreateNull&(j)
ExpectJsonError "JsonTokenCreateNull", res, JSON_ERR_NotInitialized

res = JsonTokenCreateArray&(j)
ExpectJsonError "JsonTokenCreateArray", res, JSON_ERR_NotInitialized

res = JsonTokenCreateObject&(j)
ExpectJsonError "JsonTokenCreateObject", res, JSON_ERR_NotInitialized

res = JsonTokenCreateString&(j, "foobar")
ExpectJsonError "JsonTokenCreateString", res, JSON_ERR_NotInitialized

res = JsonTokenCreateKey&(j, "foobar", 2)
ExpectJsonError "JsonTokenCreateKey", res, JSON_ERR_NotInitialized

System

'$include:'../../src/json.bm'

Sub ExpectJsonError(tst As String, ret As Long, expected As Long)
    If ret = expected And JsonHadError = expected Then
        Print tst; ": PASS!"
    Else
        Print tst; ": FAIL! ret="; ret; ", expected="; expected
    End If
End Sub
