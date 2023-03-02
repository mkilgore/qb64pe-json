Option _Explicit
$Console:Only

'$include:'../../src/json.bi'

Type queryErrorTest
    query As String
    errCode As Long
    errStr As String
End Type

Dim tests(8) As queryErrorTest

tests(1).query = "foobar"
tests(1).errCode = JSON_ERR_KeyNotFound
tests(1).errStr = "Key " + Chr$(34) + "foobar" + Chr$(34) + " not found!"

tests(2).query = "key1.foobar"
tests(2).errCode = JSON_ERR_KeyNotFound
tests(2).errStr = "Key " + Chr$(34) + "foobar" + Chr$(34) + " not found!"

tests(3).query = "key1(1)"
tests(3).errCode = JSON_ERR_BADQUERY
tests(3).errStr = "Array bounds were used on a non-array token, at position: 8"

tests(4).query = "key1("
tests(4).errCode = JSON_ERR_BADQUERY
tests(4).errStr = "Expected digit at position: 6"

tests(5).query = "key1(2"
tests(5).errCode = JSON_ERR_BADQUERY
tests(5).errStr = "Expected ')' at position: 7"

tests(6).query = "key1(2KKK)"
tests(6).errCode = JSON_ERR_BADQUERY
tests(6).errStr = "Expected ')' at position: 7"

tests(7).query = "key1()"
tests(7).errCode = JSON_ERR_BADQUERY
tests(7).errStr = "Expected digit at position: 6"

tests(8).query = "key1)"
tests(8).errCode = JSON_ERR_KeyNotFound
tests(8).errStr = "Key " + Chr$(34) + "key1)" + Chr$(34) + " not found!"

Dim j As Json
jsonCreateTree j

Dim i As Long
For i = 1 To Ubound(tests)
    Dim res As long

    res = JsonQuery&(j, tests(i).query)

    If res = tests(i).errCode And JsonHadError = tests(i).errCode And JsonError = tests(i).errStr Then
        Print "Test "; i; ": PASS!"
    Else
        Print "Test "; i; ": FAIL! res="; res
        Print "    Expected: code:"; tests(i).errCode; ", str: "; tests(i).errStr
        Print "    Actual  : code:"; JsonHadError; ", str: "; JsonError
    End If
Next

System

'$include:'../../src/json.bm'

Sub jsonCreateTree(j As Json)
    Dim innerValue(1 To 3) As long, innerKey(1 To 3) As Long
    Dim As Long innerInnerObj, innerKey1, arrInner, arrInner2
    Dim As Long arrInner2Value, arrInner2Key, arr1, innerKey2
    Dim As Long innerObj, innKey, value1, key1, value2, key2, Obj

    JsonInit j

    innerValue(1) = JsonTokenCreateInteger&(j, 50)
    innerValue(2) = JsonTokenCreateInteger&(j, 100)
    innerValue(3) = JsonTokenCreateInteger&(j, 150)

    innerKey(1) = JsonTokenCreateKey&(j, "key1", innerValue(1))
    innerKey(2) = JsonTokenCreateKey&(j, "key2", innerValue(2))
    innerKey(3) = JsonTokenCreateKey&(j, "key3", innerValue(3))

    innerInnerObj& = JsonTokenCreateObject&(j)
    JsonTokenObjectAddAll j, innerInnerObj&, innerKey()

    innerKey1& = JsonTokenCreateKey(j, "inKey1", innerInnerObj&)

    Dim arr(1 To 4) As Long

    arr(1) = JsonTokenCreateInteger&(j, 20)
    arr(2) = JsonTokenCreateString&(j, "foobar")
    arr(3) = JsonTokenCreateInteger&(j, 40)
    arr(4) = JsonTokenCreateArray&(j)

    arrInner& = JsonTokenCreateInteger&(j, 2000)
    arrInner2& = JsonTokenCreateObject&(j)

    arrInner2Value& = JsonTokenCreateInteger&(j, 5000)
    arrInner2Key& = JsonTokenCreateKey&(j, "key10", arrInner2Value&)
    JsonTokenObjectAdd j, arrInner2&, arrInner2Key&

    JsonTokenArrayAdd j, arr(4), arrInner&
    JsonTokenArrayAdd j, arr(4), arrInner2&

    arr1& = JsonTokenCreateArray&(j)
    JsonTokenArrayAddAll j, arr1&, arr()

    innerKey2& = JsonTokenCreateKey(j, "inKey2", arr1&)

    innerObj& = JsonTokenCreateObject&(j)
    JsonTokenObjectAdd j, innerObj&, innerKey1&
    JsonTokenObjectAdd j, innerObj&, innerKey2&

    innKey& = JsonTokenCreateKey&(j, "inKey1", innerObj&)

    value1& = JsonTokenCreateInteger&(j, 5000)
    key1& = JsonTokenCreateKey&(j, "key1", value1&)

    value2& = JsonTokenCreateInteger&(j, 5000)
    key2& = JsonTokenCreateKey&(j, "key2", value2&)

    Obj& = JsonTokenCreateObject&(j)
    JsonTokenObjectAdd j, Obj&, key1&
    JsonTokenObjectAdd j, Obj&, key2&
    JsonTokenObjectAdd j, Obj&, innKey&

    JsonSetRootToken j, Obj&
End Sub
