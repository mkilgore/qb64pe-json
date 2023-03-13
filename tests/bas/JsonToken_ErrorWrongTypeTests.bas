Option _Explicit
$Console:Only

'$include:'../../src/json.bi'

Dim j As Json, res As Long
JsonInit j

Dim As Long arrayToken, objectToken, keyToken, valueToken
valueToken = JsonTokenCreateInteger&(j, 20)
keyToken = JsonTokenCreateKey&(j, "key", valueToken)
objectToken = JsonTokenCreateObject&(j)
arrayToken = JsonTokenCreateArray&(j)

' Wrong type for array token
JsonTokenArrayAdd j, objectToken, valueToken
ExpectJsonError "ArrayAdd: Object", JSON_ERR_TokenWrongType
JsonTokenArrayAdd j, valueToken, valueToken
ExpectJsonError "ArrayAdd: Value", JSON_ERR_TokenWrongType
JsonTokenArrayAdd j, keyToken, valueToken
ExpectJsonError "ArrayAdd: Key", JSON_ERR_TokenWrongType

' Arrays cannot contain key tokens
JsonTokenArrayAdd j, arrayToken, keyToken
ExpectJsonError "ArrayAdd: child Key", JSON_ERR_TokenWrongType

' Wrong type for object token
JsonTokenObjectAdd j, arrayToken, valueToken
ExpectJsonError "ObjectAdd: Array", JSON_ERR_TokenWrongType
JsonTokenObjectAdd j, valueToken, valueToken
ExpectJsonError "ObjectAdd: Value", JSON_ERR_TokenWrongType
JsonTokenObjectAdd j, keyToken, valueToken
ExpectJsonError "ObjectAdd: Key", JSON_ERR_TokenWrongType

' Wrong type for object child token
JsonTokenObjectAdd j, objectToken, arrayToken
ExpectJsonError "ObjectAdd: child Array", JSON_ERR_TokenWrongType
JsonTokenObjectAdd j, objectToken, valueToken
ExpectJsonError "ObjectAdd: child Value", JSON_ERR_TokenWrongType
JsonTokenObjectAdd j, objectToken, objectToken
ExpectJsonError "ObjectAdd: child Object", JSON_ERR_TokenWrongType

' Wrong type for key child token
res = JsonTokenCreateKey&(j, "key", keyToken)
ExpectJsonErrorAndRet "CreateKey: child key", res, JSON_ERR_TokenWrongType

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
