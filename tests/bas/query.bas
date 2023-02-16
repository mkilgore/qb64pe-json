$Console:Only

'$include:'../../src/json.bi'

Type QueryTestCase
    Query As String
    Result As Long
End Type

Dim j As Json

JsonInit j

innerValue1& = JsonTokenCreateInteger&(j, 50)
innerKey1& = JsonTokenCreateKey&(j, "key1", innerValue1&)

innerValue2& = JsonTokenCreateInteger&(j, 100)
innerKey2& = JsonTokenCreateKey&(j, "key2", innerValue1&)

innerValue3& = JsonTokenCreateInteger&(j, 150)
innerKey3& = JsonTokenCreateKey&(j, "key3", innerValue1&)

innerInnerObj& = JsonTokenCreateObject&(j)
JsonTokenObjectAdd j, innerInnerObj&, innerKey1&
JsonTokenObjectAdd j, innerInnerObj&, innerKey2&
JsonTokenObjectAdd j, innerInnerObj&, innerKey3&

innerKey1& = JsonTokenCreateKey(j, "inKey1", innerInnerObj&)

arr1& = JsonTokenCreateArray&(j)

arr1v1& = JsonTokenCreateInteger&(j, 20)
arr1v2& = JsonTokenCreateString&(j, "foobar")
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

Print "Done creating json!"

Dim queryTests(8) As QueryTestCase

queryTests(1).Query = "key1"
queryTests(1).Result = value1&

queryTests(2).Query = "key2"
queryTests(2).Result = value2&

queryTests(3).Query = "inKey1"
queryTests(3).Result = innerObj&

queryTests(4).Query = "inKey1:inKey2"
queryTests(4).Result = arr1&

queryTests(5).Query = "inKey1:inKey2:[0]"
queryTests(5).Result = arr1v1&

queryTests(6).Query = "inKey1:inKey2:[1]"
queryTests(6).Result = arr1v2&

queryTests(7).Query = "inKey1:inKey1"
queryTests(7).Result = innerInnerObj&

queryTests(8).Query = "inKey1:inKey1:key2"
queryTests(8).Result = innerValue1&

Print
Print "Rendered Json: "; JsonRender$(j)
Print

For i = 1 To UBOUND(queryTests)
    res& = JsonQueryToken&(j, queryTests(i).Query)
    Print "Query Test"; i;

    If res& = queryTests(i).Result Then
        Print "PASS!"
    Else
        Print "FAIL, result: "; res&; ", error: "; JsonError
    End If
Next

System

'$include:'../../src/json.bm'
