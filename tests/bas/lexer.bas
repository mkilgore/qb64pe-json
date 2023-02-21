$Console:Only

'$include:'../../src/json.bi'

Dim j As Json

JsonInit j

innerValue1& = JsonTokenCreateInteger&(j, 50)
innerKey1& = JsonTokenCreateKey&(j, "key1", innerValue1&)

innerValue2& = JsonTokenCreateInteger&(j, 100)
innerKey2& = JsonTokenCreateKey&(j, "key2", innerValue2&)

innerValue3& = JsonTokenCreateDouble&(j, -200000.50)
innerKey3& = JsonTokenCreateKey&(j, "key3", innerValue3&)

innerInnerObj& = JsonTokenCreateObject&(j)
JsonTokenObjectAdd j, innerInnerObj&, innerKey1&
JsonTokenObjectAdd j, innerInnerObj&, innerKey2&
JsonTokenObjectAdd j, innerInnerObj&, innerKey3&

innerKey1& = JsonTokenCreateKey(j, "inKey1", innerInnerObj&)

arr1& = JsonTokenCreateArray&(j)

arr1v1& = JsonTokenCreateInteger&(j, 20)
arr1v2& = JsonTokenCreateString&(j, "foobar" + Chr$(34) + Chr$(34))
arr1v3& = JsonTokenCreateInteger&(j, 40)

JsonTokenArrayAdd j, arr1&, arr1v1&
JsonTokenArrayAdd j, arr1&, arr1v2&
JsonTokenArrayAdd j, arr1&, arr1v2&

innerKey2& = JsonTokenCreateKey(j, "inKey2", arr1&)

innerObj& = JsonTokenCreateObject&(j)
JsonTokenObjectAdd j, innerObj&, innerKey1&
JsonTokenObjectAdd j, innerObj&, innerKey2&

inKey& = JsonTokenCreateKey&(j, "inKey1", innerObj&)

value1& = JsonTokenCreateInteger&(j, 5000)
key1& = JsonTokenCreateKey&(j, "key1", value1&)

value2& = JsonTokenCreateInteger&(j, 5000)
key2& = JsonTokenCreateKey&(j, "key2", value2&)

Obj& = JsonTokenCreateObject&(j)
JsonTokenObjectAdd j, Obj&, key1&
JsonTokenObjectAdd j, Obj&, key2&
JsonTokenObjectAdd j, Obj&, inKey&

JsonSetRootToken j, Obj&

jsonStr$ = JsonRender$(j)

Print "JsonString: " + jsonStr$

Test jsonStr$

System

'$include:'../../src/json.bm'

Sub Test(jsonStr$)
    Dim lexer As ___JsonLexer
    lexer.nextIdx = 1
    JsonHadError = 0
    Print "Starting loop..."

    While tok <> ___JSON_LEX_End And Not JsonHadError And count < 100
        count = count + 1
        JsonHadError = 0
        tok = ___JsonLex&(jsonStr$, lexer)

        If JsonHadError Then
            Print "Error: "; JsonError
        Else
            Print "Token: "; lexTokStr$(tok); ", start:"; lexer.startIdx; ", end:"; lexer.endIdx
        End If
    Wend
End Sub
