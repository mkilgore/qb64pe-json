
Const JSONTOK_TYPE_OBJECT = 1
Const JSONTOK_TYPE_ARRAY = 2
Const JSONTOK_TYPE_VALUE = 3
Const JSONTOK_TYPE_KEY = 4

Const JSONTOK_PRIM_STRING = 1
Const JSONTOK_PRIM_NUMBER = 2
Const JSONTOK_PRIM_BOOL = 3

Dim Shared JsonError As String, JsonHadError As Long

Type jsontok
    typ As _Byte
    primType As _Byte
    startIdx As Long ' Index into original json string
    endIdx As Long

    ParentIdx As Long ' Index into tokens array
    ChildrenIdxs As String ' MKL$() list of indexes of children tokens
End Type

' Parses a JSON string into an array of tokens holding its structure
'
' Index 1 in the array will hold the root object token
'
' Array should be ReDim, as it will be resized if necessary
DECLARE Function ParseJson& (json As String, tokens() As jsontok)

DECLARE Function ChildCount& (tokens() As jsontok, idx As Long)
DECLARE Function GetChild& (tokens() As jsontok, idx As Long, childIdx As Long)
DECLARE Function GetStrValue$ (json As String, tokens() As jsontok, idx As Long)

' Takes a JSON query string and finds the JSON tokent that it refers too.
'
' You can either recieve the value directly with `Value$`, or recieve the token index via `Token&`
'
' If there was an error with the query, the result is in 'er'
DECLARE Function JsonQueryToken& (json As String, tokens() As jsontok, query As String, er As String)
DECLARE Function JsonQueryValue$ (json As String, tokens() As jsontok, query As String, er As String)

' Takes a JSON query string and finds the JSON tokent that it refers too.
' This does not start at the root token, but instead starts at token 'startToken'
'
' You can either recieve the value directly with `Value$`, or recieve the token index via `Token&`
DECLARE Function JsonQueryFromToken& (json As String, tokens() As jsontok, startToken As Long, query As String, er As String)
DECLARE Function JsonQueryFromValue$ (json As String, tokens() As jsontok, startToken As Long, query As String, er As String)

DECLARE Function TokenTypeString$ (typ As _Byte)

DECLARE Sub PrintTokens (json As String, tokens() As jsontok, index As Long, indent As Long)
