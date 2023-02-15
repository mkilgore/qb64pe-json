
' If a Json procedure has an error, the error code will be stored in
' JsonHadError and a text version of the error will be in JsonError.
'
' On success JsonHadError will be zero
Dim Shared JsonError As String, JsonHadError As Long

Const JSON_ERR_SUCCESS = 0

Const JSONTOK_TYPE_OBJECT = 1
Const JSONTOK_TYPE_ARRAY = 2
Const JSONTOK_TYPE_VALUE = 3
Const JSONTOK_TYPE_KEY = 4

Const JSONTOK_PRIM_STRING = 1
Const JSONTOK_PRIM_NUMBER = 2
Const JSONTOK_PRIM_BOOL = 3

Type Json
    origStr As String
    RootToken As Long
    TotalTokens As Long
    TotalBlocks As Long

    NextFree As Long

    ' Array of JsonTokenBlocks
    TokenBlocks As _Mem

    IsInitialized As Long
End Type

Declare Sub JsonInit(json As Json)
Declare Sub JsonClear(json As Json)

Declare Sub JsonTokenBlockInit(b As JsonTokenBlock)
Declare Sub JsonTokenBlockClear(b As JsonTokenBlock)

Declare Function JsonGetEmptyToken&(j As Json)
Declare Sub JsonMarkEmptyToken(j As Json, idx As Long)

' Parses a JSON string into a json object. The json object should already be initialized.
'
' Return value indicates whether the parse was a success. JsonHadError can also be checked
Declare Function JsonParse&(j As Json, json As String)

' String contents should be UTF-8. Contents will be escaped automatically as necessary.
Declare Function JsonTokenCreateString&(j As Json, s As String)
Declare Function JsonTokenCreateBoolean&(j As Json, b As _Byte)
Declare Function JsonTokenCreateInteger&(j As Json, i As _Integer64)
Declare Function JsonTokenCreateSingle&(j As Json, s As Double)

Declare Function JsonTokenCreateKey&(j As Json, k As String, inner As Long)

Declare Function JsonTokenCreateArray&(j As Json)
Declare Sub      JsonTokenArrayAdd(j As Json, idx As Long)

Declare Function JsonTokenCreateObject&(j As Json)
Declare Sub      JsonTokenObjectAdd(j As Json, idx As Long)

Declare Sub      JsonSetRootToken(j As json, idx As Long)


Declare Function JsonRender$(j As json)
Declare Function JsonRenderIndex$(j As json, idx As Long)

' Returns the token's value in string form:
'
'    Key:    Key name
'    Value:  String version of the value itself. Bools are "true" or "false". Strings are UTF-8
'    Array:  Error
'    Object: Error
'
' To convert a token into a JSON string, use JsonRender$()
Declare Function JsonTokenGetStr$(j As json, idx As Long)
Declare Function JsonTokenTotalChildren&(j As json, idx As Long)
Declare Function JsonTokenGetChild&(j As json, idx As Long, childIdx As Long) ' Children are numbered from zero

' Returns a JSONTOK_TYPE_* value
Declare Function JsonTokenGetType&(j As Json, idx As Long)

' Only works if the token is a JSONTOK_TYPE_VALUE. Returns a JSONTOK_PRIM_* value
Declare Function JsonTokenGetPrimType&(j As Json, idx As Long)

Declare Function JsonQueryToken&(j As Json, query As String)
Declare Function JsonQueryFromToken&(j As Json, query As String, startToken As Long)

Declare Function JsonQueryValue$(j As Json, query As String)
Declare Function JsonQueryFromValue$(j As Json, query As String, startToken As Long)

' DECLARE Function ChildCount& (tokens() As jsontok, idx As Long)
' DECLARE Function GetChild& (tokens() As jsontok, idx As Long, childIdx As Long)
' DECLARE Function GetStrValue$ (json As String, tokens() As jsontok, idx As Long)

' Takes a JSON query string and finds the JSON tokent that it refers too.
'
' You can either recieve the value directly with `Value$`, or recieve the token index via `Token&`
'
' If there was an error with the query, the result is in 'er'
' DECLARE Function JsonQueryToken& (json As String, tokens() As jsontok, query As String, er As String)
' DECLARE Function JsonQueryValue$ (json As String, tokens() As jsontok, query As String, er As String)
' 
' ' Takes a JSON query string and finds the JSON tokent that it refers too.
' ' This does not start at the root token, but instead starts at token 'startToken'
' '
' ' You can either recieve the value directly with `Value$`, or recieve the token index via `Token&`
' DECLARE Function JsonQueryFromToken& (json As String, tokens() As jsontok, startToken As Long, query As String, er As String)
' DECLARE Function JsonQueryFromValue$ (json As String, tokens() As jsontok, startToken As Long, query As String, er As String)
' 
' DECLARE Function TokenTypeString$ (typ As _Byte)
