
Dim Shared JsonError As String, JsonHadError As Long

Const JSONTOK_TYPE_FREE = 0
Const JSONTOK_TYPE_OBJECT = 1
Const JSONTOK_TYPE_ARRAY = 2
Const JSONTOK_TYPE_VALUE = 3
Const JSONTOK_TYPE_KEY = 4

Const JSONTOK_PRIM_STRING = 1
Const JSONTOK_PRIM_NUMBER = 2
Const JSONTOK_PRIM_BOOL = 3

' 256 tokens per block
Const JSON_BLOCK_SHIFT = 8

Type jsontok
    typ As _Byte
    primType As _Byte

    ' Value can either be embedded in the 'value' field, or indexes into the
    ' original string
    value As _Mem

    startIdx As Long ' Index into original json string
    endIdx As Long

    ' Index of parent token.
    ' If token is FREE, then this is the index next free token
    ParentIdx As Long
    ChildrenIdxs As _Mem ' Array of Long's for indexes
End Type

Type JsonTokenBlock
    m As _Mem
End Type

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

' Parses a JSON string into an array of tokens holding its structure
'
' Index 1 in the array will hold the root object token
'
' Array should be ReDim, as it will be resized if necessary
Declare Function ParseJson& (json As String, j As Json)

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

Declare Function GetStrValue$(j As json, t As jsontok)


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

DECLARE Sub PrintTokens (json As String, tokens() As jsontok, index As Long, indent As Long)
