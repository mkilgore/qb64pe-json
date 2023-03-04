Option _Explicit
$Console:Only

'$include:'../../src/json.bi'

Dim j As Json, res As Long, obj As Long
JsonInit j

obj = JsonTokenCreateObject&(j)

JsonTokenObjectAdd j, obj, JsonTokenCreateKey&(j, "bool_true", JsonTokenCreateBool&(j, -1))
JsonTokenObjectAdd j, obj, JsonTokenCreateKey&(j, "bool_false", JsonTokenCreateBool&(j, 0))

JsonTokenObjectAdd j, obj, JsonTokenCreateKey&(j, "null", JsonTokenCreateNull&(j))

JsonTokenObjectAdd j, obj, JsonTokenCreateKey&(j, "string_empty", JsonTokenCreateString&(j, ""))
JsonTokenObjectAdd j, obj, JsonTokenCreateKey&(j, "string_foobar", JsonTokenCreateString&(j, "foobar"))

JsonTokenObjectAdd j, obj, JsonTokenCreateKey&(j, "number_integer", JsonTokenCreateInteger&(j, 100000))
JsonTokenObjectAdd j, obj, JsonTokenCreateKey&(j, "number_integer_neg", JsonTokenCreateInteger&(j, -100000))
JsonTokenObjectAdd j, obj, JsonTokenCreateKey&(j, "number_decimal", JsonTokenCreateDouble&(j, 1.75)) ' 1.75 was choosen because it suffers no rounding issue.

JsonSetRootToken j, obj

'Tests
Dim fmt As JsonFormat
fmt.Indented = -1

Print "Resulting Json:"
Print JsonRenderFormatted$(j, fmt)

Dim i As _Integer64, s As String, b As Long, d As Double
Dim tok As Long

' We verify both the native type version, such as from ValueBool&(), and also
' the string version given via ValueStr$(). They should all be identical to the
' values given above.

tok = JsonQuery&(j, "bool_true")
If JsonTokenGetValueBool&(j, tok) = -1 Then Print "bool_true: PASS!" Else Print "bool_true: FAIL! Real value: "; JsonTokenGetValueBool&(j, tok)
If JsonTokenGetValueStr$(j, tok)  = "true" Then Print "bool_true str: PASS!" Else Print "bool_true str: FAIL! Real value: "; JsonTokenGetValueStr$(j, tok)

tok = JsonQuery&(j, "bool_false")
If JsonTokenGetValueBool&(j, tok) = 0 Then Print "bool_true: PASS!" Else Print "bool_true: FAIL! Real value: "; JsonTokenGetValueBool&(j, tok)
If JsonTokenGetValueStr$(j, tok)  = "false" Then Print "bool_false str: PASS!" Else Print "bool_false str: FAIL! Real value: "; JsonTokenGetValueStr$(j, tok)

tok = JsonQuery&(j, "null")
If JsonTokenGetType&(j, tok) = JSONTOK_TYPE_VALUE And JsonTokenGetPrimType&(j, tok) = JSONTOK_PRIM_NULL Then
    Print "null: PASS!"
Else
    Print "null: FAIL! Real types: "; JsonTokenGetType&(j, tok); JsonTokenGetPrimType&(j, tok)
End If
If JsonTokenGetValueStr$(j, tok) = "null" Then Print "null str: PASS!" Else Print "null str: FAIL! Real value: "; JsonTokenGetValueStr$(j, tok)

tok = JsonQuery&(j, "string_empty")
If JsonTokenGetValueStr$(j, tok) = "" Then Print "string_empty: PASS!" Else Print "string_empty: FAIL! Real value: "; JsonTokenGetValueStr$(j, tok)

tok = JsonQuery&(j, "string_foobar")
If JsonTokenGetValueStr$(j, tok) = "foobar" Then Print "string_foobar: PASS!" Else Print "string_foobar: FAIL! Real value: "; JsonTokenGetValueStr$(j, tok)

tok = JsonQuery&(j, "string_foobar")

tok = JsonQuery&(j, "number_integer")
If JsonTokenGetValueInteger&&(j, tok) = 100000 Then Print "number_integer: PASS!" Else Print "number_integer: FAIL! Real value: "; JsonTokenGetValueInteger&&(j, tok)
If JsonTokenGetValueStr$(j, tok) = "100000" Then Print "number_integer str: PASS!" Else Print "number_integer str: FAIL! Real value: "; JsonTokenGetValueStr$(j, tok)

tok = JsonQuery&(j, "number_integer_neg")
If JsonTokenGetValueInteger&&(j, tok) = -100000 Then Print "number_integer_neg: PASS!" Else Print "number_integer_neg: FAIL! Real value: "; JsonTokenGetValueInteger&&(j, tok)
If JsonTokenGetValueStr$(j, tok) = "-100000" Then Print "number_integer_neg str: PASS!" Else Print "number_integer_neg str: FAIL! Real value: "; JsonTokenGetValueStr$(j, tok)

tok = JsonQuery&(j, "number_decimal")
If JsonTokenGetValueDouble(j, tok) = 1.75 Then Print "number_decimal: PASS!" Else Print "number_decimal: FAIL! Real value: "; JsonTokenGetValueDouble(j, tok)
If JsonTokenGetValueStr$(j, tok) = "1.75" Then Print "number_decimal str: PASS!" Else Print "number_decimal str: FAIL! Real value: "; JsonTokenGetValueStr$(j, tok)

JsonClear j
System

'$include:'../../src/json.bm'
