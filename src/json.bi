
Const JSONTOK_TYPE_OBJECT = 1
Const JSONTOK_TYPE_ARRAY = 2
Const JSONTOK_TYPE_VALUE = 3
Const JSONTOK_TYPE_KEY = 4

Const JSONTOK_PRIM_STRING = 1
Const JSONTOK_PRIM_NUMBER = 2
Const JSONTOK_PRIM_BOOL = 3

Type jsontok
    typ As _Byte
    primType As _Byte
    startIdx As Long ' Index into original json string
    endIdx As Long

    ParentIdx As Long ' Index into tokens array
    ChildrenIdxs As String ' MKL$() list of indexes of children tokens
End Type

