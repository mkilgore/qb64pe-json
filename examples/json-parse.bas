'
' This example displays the basics of parsing a JSON string and extracting the
' values of various entries in the JSON
'
Option _Explicit
'$include:'../src/json.bi'

Dim jsonString As String

ChDir _StartDir$

' Attempt to find json-file.json and read the JSON string inside it
jsonString = ReadFile$("json-file.json")
If Len(jsonString) = 0 Then jsonString = ReadFile$("examples/json-file.json")
If Len(jsonString) = 0 Then Print "Error, unable to find examples/json-file.json!": End

' Declare and initialize our Json object
Dim j As Json
JsonInit j

Dim errorCode As Long
errorCode = JsonParse&(j, jsonString)

' Should print zero for success
Print "JsonParse error code: "; errorCode
Print

' Directly query the string value, and use Value$() version to get the string value directly
Print "stringKey: "; JsonQueryValue$(j, "stringKey")

' Same thing, but using JsonQuery&() to get the token and manually pass it to JsonTokenGetValueStr$()
Print "stringKey: "; JsonTokenGetValueStr$(j, JsonQuery&(j, "stringKey"))

' Same thing, but the target is a number token instead
Print "numberKey: "; JsonTokenGetValueInteger&&(j, JsonQuery&(j, "numberKey"))

' Same thing, but the target is a bool token instead
Print "boolKey: "; JsonTokenGetValueBool&(j, JsonQuery&(j, "boolKey"))

' Perform a query several levels down
Print "objectKey:objectInnerKey:objectInnerKey:innerKey: "; JsonTokenGetValueBool&(j, JsonQuery&(j, "objectKey.objectInnerKey.objectInnerKey.innerKey"))

' We can query for an object or array and then do additional queries starting from that point
Dim objectToken As Long
objectToken = JsonQuery&(j, "objectKey.objectInnerKey")
Print "objectKey:objectInnerKey:objectInnerKey:innerKey: "; JsonTokenGetValueBool&(j, JsonQueryFrom&(j, objectToken, "objectInnerKey.innerKey"))
Print "objectKey:objectInnerKey:objectInnerKey2:innerKey: "; JsonTokenGetValueBool&(j, JsonQueryFrom&(j, objectToken, "objectInnerKey2.innerKey"))



Dim i As Long, arrToken As Long
Print "arrayKey:"

' Iterate over an array and print each individual array index
'
' We query to find the Token for this array, and then use that token for the
' rest of the logic.
arrToken = JsonQuery&(j, "arrayKey")
For i = 0 to JsonTokenTotalChildren&(j, arrToken) - 1
    Dim childToken As Long
    childToken = JsonTokenGetChild&(j, arrToken, i)
    Print "    Child"; i; " ="; JsonTokenGetValueInteger&&(j, childToken)
Next


' Free our Json object. Unnecessary since the program is about to exit anyway,
' but good to remember regardless
JsonClear j
End

'$include:'../src/json.bm'

Function ReadFile$(file As String)
    Dim sourceFileNo As Long, fileLength As Long, buffer As String
    sourceFileNo = FREEFILE
    OPEN file FOR BINARY as #sourceFileNo

    fileLength = LOF(sourceFileNo)

    ' Read the file in one go
    buffer = SPACE$(fileLength)

    GET #sourceFileNo, , buffer

    ReadFile$ = buffer

    CLOSE #sourceFileNo
End Function
