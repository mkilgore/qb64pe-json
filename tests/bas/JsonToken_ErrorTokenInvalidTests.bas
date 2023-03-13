Option _Explicit
$Console:Only

'$include:'../../src/json.bi'

Dim j As Json, res As Long, strRes As String
JsonInit j

Dim As Long arrayToken, objectToken, keyToken, valueToken
valueToken = JsonTokenCreateInteger&(j, 20)
keyToken = JsonTokenCreateKey&(j, "key", valueToken)
objectToken = JsonTokenCreateObject&(j)
arrayToken = JsonTokenCreateArray&(j)

'
' Invalid tokens are any number less than one, or larger than the current max token
'
' As we've only made a couple tokens, with a block-size of 512 tokens a
' sufficently large value will be invalid
'
'

res = JsonTokenTotalChildren&(j, 0)
ExpectJsonErrorAndRet "TotalChildren: 0", res, JSON_ERR_TokenInvalid

res = JsonTokenTotalChildren&(j, 10000)
ExpectJsonErrorAndRet "TotalChildren: 10000", res, JSON_ERR_TokenInvalid


res = JsonTokenGetChild&(j, 0, 0)
ExpectJsonErrorAndRet "GetChild: 0", res, JSON_ERR_TokenInvalid

res = JsonTokenGetChild&(j, 10000, 0)
ExpectJsonErrorAndRet "GetChild: 10000", res, JSON_ERR_TokenInvalid


res = JsonTokenGetType&(j, 0)
ExpectJsonErrorAndRet "GetType: 0", res, JSON_ERR_TokenInvalid

res = JsonTokenGetType&(j, 10000)
ExpectJsonErrorAndRet "GetType: 10000", res, JSON_ERR_TokenInvalid


res = JsonTokenGetPrimType&(j, 0)
ExpectJsonErrorAndRet "GetPrimType: 0", res, JSON_ERR_TokenInvalid

res = JsonTokenGetPrimType&(j, 10000)
ExpectJsonErrorAndRet "GetPrimType: 10000", res, JSON_ERR_TokenInvalid


JsonTokenFree j, 0
ExpectJsonError "Free: 0", JSON_ERR_TokenInvalid

JsonTokenFree j, 10000
ExpectJsonError "Free: 10000", JSON_ERR_TokenInvalid


JsonTokenFreeShallow j, 0
ExpectJsonError "Free: 0", JSON_ERR_TokenInvalid

JsonTokenFreeShallow j, 10000
ExpectJsonError "Free: 10000", JSON_ERR_TokenInvalid


res = JsonTokenCreateKey&(j, "key", 0)
ExpectJsonErrorAndRet "CreateKey: 0", res, JSON_ERR_TokenInvalid

res = JsonTokenCreateKey&(j, "key", 10000)
ExpectJsonErrorAndRet "CreateKey: 10000", res, JSON_ERR_TokenInvalid


JsonTokenArrayAdd j, 0, valueToken
ExpectJsonErrorAndRet "ArrayAdd: Array 0", res, JSON_ERR_TokenInvalid

JsonTokenArrayAdd j, 10000, valueToken
ExpectJsonErrorAndRet "ArrayAdd: Array 10000", res, JSON_ERR_TokenInvalid

JsonTokenArrayAdd j, arrayToken, 0
ExpectJsonErrorAndRet "ArrayAdd: Child 0", res, JSON_ERR_TokenInvalid

JsonTokenArrayAdd j, arrayToken, 10000
ExpectJsonErrorAndRet "ArrayAdd: Child 10000", res, JSON_ERR_TokenInvalid


JsonTokenObjectAdd j, 0, keyToken
ExpectJsonError "ArrayAdd: Array 0", JSON_ERR_TokenInvalid

JsonTokenObjectAdd j, 10000, keyToken
ExpectJsonError "ArrayAdd: Array 10000", JSON_ERR_TokenInvalid

JsonTokenObjectAdd j, objectToken, 0
ExpectJsonError "ArrayAdd: Child 0", JSON_ERR_TokenInvalid

JsonTokenObjectAdd j, objectToken, 10000
ExpectJsonError "ArrayAdd: Child 10000", JSON_ERR_TokenInvalid


JsonSetRootToken j, 0
ExpectJsonErrorAndRet "SetRootToken: 0", res, JSON_ERR_TokenInvalid

JsonSetRootToken j, 10000
ExpectJsonErrorAndRet "SetRootToken: 10000", res, JSON_ERR_TokenInvalid


strRes = JsonTokenGetValueStr$(j, 0)
ExpectJsonError "GetValueStr: 0", JSON_ERR_TokenInvalid

strRes = JsonTokenGetValueStr$(j, 10000)
ExpectJsonError "GetValueStr: 10000", JSON_ERR_TokenInvalid


res = JsonTokenGetValueBool&(j, 0)
ExpectJsonError "GetValueBool: 0", JSON_ERR_TokenInvalid

res = JsonTokenGetValueBool&(j, 10000)
ExpectJsonError "GetValueBool: 10000", JSON_ERR_TokenInvalid


res = JsonTokenGetValueInteger&&(j, 0)
ExpectJsonError "GetValueInteger: 0", JSON_ERR_TokenInvalid

res = JsonTokenGetValueInteger&&(j, 10000)
ExpectJsonError "GetValueInteger: 10000", JSON_ERR_TokenInvalid


res = JsonTokenGetValueDouble#(j, 0)
ExpectJsonError "GetValueDouble: 0", JSON_ERR_TokenInvalid

res = JsonTokenGetValueDouble#(j, 10000)
ExpectJsonError "GetValueDouble: 10000", JSON_ERR_TokenInvalid


res = JsonQueryFrom&(j, 0, "")
ExpectJsonErrorAndRet "QueryFrom: 0", res, JSON_ERR_TokenInvalid

res = JsonQueryFrom&(j, 10000, "")
ExpectJsonErrorAndRet "QueryFrom: 10000", res, JSON_ERR_TokenInvalid

System

'$include:'../../src/json.bm'

Sub ExpectJsonError(tst As String, expected As Long)
    If JsonHadError = expected Then
        Print tst; ": PASS!"
    Else
        Print tst; ": FAIL! expected="; expected; ", was="; JsonHadError
    End If
End Sub

Sub ExpectJsonErrorAndRet(tst As String, ret As Long, expected As Long)
    If ret = expected And JsonHadError = expected Then
        Print tst; ": PASS!"
    Else
        Print tst; ": FAIL! ret="; ret; ", expected="; expected; ", was="; JsonHadError
    End If
End Sub
