$Console:Only

'$include:'../../src/json.bi'

Type QueryTestCase
    Query As String
    Result As Long
End Type

Dim j As Json
Dim innerValue(1 To 3) As long, innerKey(1 To 3) As Long

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

Dim queryTests(10) As QueryTestCase

queryTests(1).Query = "key1"
queryTests(1).Result = value1&

queryTests(2).Query = "key2"
queryTests(2).Result = value2&

queryTests(3).Query = "inKey1"
queryTests(3).Result = innerObj&

queryTests(4).Query = "inKey1.inKey2"
queryTests(4).Result = arr1&

queryTests(5).Query = "inKey1.inKey2(0)"
queryTests(5).Result = arr(1)

queryTests(6).Query = "inKey1.inKey2(1)"
queryTests(6).Result = arr(2)

queryTests(7).Query = "inKey1.inKey1"
queryTests(7).Result = innerInnerObj&

queryTests(8).Query = "inKey1.inKey1.key2"
queryTests(8).Result = innerValue(2)

queryTests(9).Query = "inKey1.inKey2(3)(0)"
queryTests(9).Result = arrInner&

queryTests(10).Query = "inKey1.inKey2(3)(1).key10"
queryTests(10).Result = arrInner2Value&

Print
Print "Rendered Json: "; JsonRender$(j)
Print

For i = 1 To UBOUND(queryTests)
    res& = JsonQueryFromToken&(j, j.RootToken, queryTests(i).Query)
    Print "Query Test"; i;

    If res& = queryTests(i).Result Then
        Print "PASS!"
    Else
        Print "FAIL, result: "; res&; ", error: "; JsonError
    End If
Next

System

'$include:'../../src/json.bm'
