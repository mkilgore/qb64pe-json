$Console:Only

'$include:'../../src/json.bi'

Type EscapeTestCase
    Orig As String
    Result As String
End Type

Dim escapeTests(13) As EscapeTestCase

escapeTests(1).Orig = ""
escapeTests(1).Result = ""

escapeTests(2).Orig = Chr$(13)
escapeTests(2).Result = "\n"

escapeTests(3).Orig = Chr$(10)
escapeTests(3).Result = "\r"

escapeTests(4).Orig = Chr$(34)
escapeTests(4).Result = "\" + Chr$(34)

escapeTests(5).Orig = "\"
escapeTests(5).Result = "\\"

escapeTests(6).Orig = Chr$(9)
escapeTests(6).Result = "\t"

escapeTests(7).Orig = Chr$(12)
escapeTests(7).Result = "\f"

escapeTests(8).Orig = Chr$(8)
escapeTests(8).Result = "\b"

escapeTests(9).Orig = "This is a test"
escapeTests(9).Result = "This is a test"

escapeTests(10).Orig = "This " + Chr$(13) + "is " + Chr$(13) + "a " + Chr$(9) + "test"
escapeTests(10).Result = "This \nis \na \ttest"

escapeTests(11).Orig = Chr$(13) + Chr$(13) + Chr$(13) + Chr$(13) + Chr$(13) + Chr$(13) + Chr$(13) + Chr$(13) + Chr$(13)
escapeTests(11).Result = "\n\n\n\n\n\n\n\n\n"

escapeTests(12).Orig = "\n\n"
escapeTests(12).Result = "\\n\\n"

escapeTests(13).Orig = "foobar\\foo"
escapeTests(13).Result = "foobar\\\\foo"

For i = 1 To UBOUND(escapeTests)
    res$ = ___JsonEscapeString$(escapeTests(i).Orig)
    Print "Escape   Test"; i;

    If res$ = escapeTests(i).Result Then
        Print "PASS!"
    Else
        Print "FAIL, result: "; res$
    End If

    res$ = ___JsonUnescapeString$(escapeTests(i).Result)
    Print "Unescape Test"; i;

    If res$ = escapeTests(i).Orig Then
        Print "PASS!"
    Else
        Print "FAIL, result: "; res$
    End If
Next

System

'$include:'../../src/json.bm'
