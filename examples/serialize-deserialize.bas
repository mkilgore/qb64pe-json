'
' Shows how you can write reusable 'serialize' and 'deserialize' functions for
' transforming Type's to and from Json objects
'
' This paticular example reads the Json from pokemon-party.json and deserializes
' it into 'Pokemon' type objects. It then shows that the Pokemon array got
' filled in correctly, and how you can then use the ItemSerialize&() function
' to build a JSON array of just the heldItem
'
' We then use PokemonSerialize to render the individual Pokemon objects back
' into Json, effectively taking a round trip from pokemon-party.json, to
' Pokemon objects, and back to rendered JSON.
'
Option _Explicit
'$include:'../src/json.bi'

Type PokemonStats
    hp As Long
    attack As Long
    defense As Long
    spAttack As Long
    spDefense As Long
    speed As Long
End Type

Type Move
    nam As String * 12
    pow As Long
End Type

Type Item
    nam As String * 12
End Type

Type Pokemon
    nam As String * 10
    baseStats As PokemonStats

    curStats As PokemonStats

    heldItem As Item

    move1 As Move
    move2 As Move
    move3 As Move
    move4 As move
End Type

Dim jsonString As String

ChDir _StartDir$

' Attempt to find pokemon-party.json and read the JSON string inside it
jsonString = ReadFile$("pokemon-party.json")
If Len(jsonString) = 0 Then jsonString = ReadFile$("examples/pokemon-party.json")
If Len(jsonString) = 0 Then Print "Error, unable to find examples/pokemon-party.json!": End

' Party of Pokemon
Dim p(3) As Pokemon, j As Json
JsonInit j

Dim result As Long
result = JsonParse&(j, jsonString)

Print "Parse result:"; result
Print "error: "; JsonError

PokemonPartyDeserialize j, j.RootToken, p()

' At this point, p() contains all of the informationed listed in the JSON

Dim i As Long
Print "Pokemon in file: ";
For i = 1 To 3
    Print RTrim$(p(i).nam); " ";
Next
Print

' Serialize just the items together into a JSON array and print it
Dim itemj As Json, itemArray As Long
JsonInit itemj

itemArray = JsonTokenCreateArray&(itemj)

For i = 1 To 3
    JsonTokenArrayAdd itemj, itemArray, ItemSerialize&(itemj, p(i).heldItem)
Next

Dim fmt As JsonFormat
fmt.Indented = -1

Print "Items:"
Print JsonRenderTokenFormatted$(itemj, itemArray, fmt)
Sleep

JsonClear itemj

' Serialize and print each pokemon individually
For i = 1 To 3
    Cls
    Print "Serialized Pokemon "; RTrim$(p(i).nam); ":"
    Print

    JsonInit itemj

    itemj.RootToken = PokemonSerialize&(itemj, p(i))
    Print JsonRender$(itemj)

    JsonClear itemj
    Sleep
Next

End

' These serialization functions take an existing object and turn it into a JSON
' structure. The root token of that structure is then returned, allowing you to
' further embed that structure into other structures.

Function PokemonStatsSerialize&(j As Json, stats As PokemonStats)
    Dim rootToken As Long
    rootToken = JsonTokenCreateObject&(j)

    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "hp", JsonTokenCreateInteger&(j, stats.hp))
    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "attack", JsonTokenCreateInteger&(j, stats.attack))
    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "defense", JsonTokenCreateInteger&(j, stats.defense))
    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "spAttack", JsonTokenCreateInteger&(j, stats.spAttack))
    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "spDefense", JsonTokenCreateInteger&(j, stats.spDefense))
    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "speed", JsonTokenCreateInteger&(j, stats.speed))

    PokemonStatsSerialize& = rootToken
End Function

Function MoveSerialize&(j As Json, move As Move)
    Dim rootToken As Long
    rootToken = JsonTokenCreateObject&(j)

    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "name", JsonTokenCreateString&(j, RTrim$(move.nam)))
    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "power", JsonTokenCreateInteger&(j, move.pow))

    MoveSerialize& = rootToken
End Function

Function ItemSerialize&(j As Json, item As Item)
    Dim rootToken As Long
    rootToken = JsonTokenCreateObject&(j)

    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "name", JsonTokenCreateString&(j, RTrim$(item.nam)))

    ItemSerialize& = rootToken
End Function

Function PokemonSerialize&(j As Json, p As Pokemon)
    Dim rootToken As Long, moveArray As Long
    rootToken = JsonTokenCreateObject&(j)

    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "name", JsonTokenCreateString&(j, RTrim$(p.nam)))

    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "baseStats", PokemonStatsSerialize&(j, p.baseStats))
    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "curStats", PokemonStatsSerialize&(j, p.curStats))
    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "heldItem", ItemSerialize&(j, p.heldItem))

    ' Rather then add entries called "move1", "move2", etc. we create a JSON
    ' array and put the moves into that array in order
    moveArray = JsonTokenCreateArray&(j)
    JsonTokenArrayAdd j, moveArray, MoveSerialize&(j, p.move1)
    JsonTokenArrayAdd j, moveArray, MoveSerialize&(j, p.move2)
    JsonTokenArrayAdd j, moveArray, MoveSerialize&(j, p.move3)
    JsonTokenArrayAdd j, moveArray, MoveSerialize&(j, p.move4)

    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "moves", moveArray)

    PokemonSerialize& = rootToken
End Function

'
' These Subs reverse the serialization functions - given a Json token pointing
' to the root of a serialized object, they fill in the provided object with the
' information contained within that JSON structure.
'
Sub PokemonStatsDeserialize(j As Json, token As Long, stats As PokemonStats)
    stats.hp = JsonTokenGetValueInteger&&(j, JsonQueryFrom&(j, token, "hp"))
    stats.attack = JsonTokenGetValueInteger&&(j, JsonQueryFrom&(j, token, "attack"))
    stats.defense = JsonTokenGetValueInteger&&(j, JsonQueryFrom&(j, token, "defense"))
    stats.spAttack = JsonTokenGetValueInteger&&(j, JsonQueryFrom&(j, token, "spAttack"))
    stats.spDefense = JsonTokenGetValueInteger&&(j, JsonQueryFrom&(j, token, "spDefense"))
    stats.speed = JsonTokenGetValueInteger&&(j, JsonQueryFrom&(j, token, "speed"))
End Sub

Sub MoveDeserialize(j As Json, token As Long, move As Move)
    move.nam = JsonQueryFromValue$(j, token, "name")
    move.pow = JsonTokenGetValueInteger&&(j, JsonQueryFrom&(j, token, "pow"))
End Sub

Sub ItemDeserialize(j As Json, token As Long, item As Item)
    item.nam = JsonQueryFromValue$(j, token, "name")
End Sub

Sub PokemonDeserialize(j As Json, token As Long, p As Pokemon)
    p.nam = JsonQueryFromValue$(j, token, "name")

    PokemonStatsDeserialize j, JsonQueryFrom&(j, token, "baseStats"), p.baseStats
    PokemonStatsDeserialize j, JsonQueryFrom&(j, token, "curStats"), p.curStats

    ItemDeserialize j, JsonQueryFrom&(j, token, "heldItem"), p.heldItem

    Dim moveArrayToken As Long
    moveArrayToken = JsonQueryFrom&(j, token, "moves")

    ' Since the moves are in a defined order we can just index the array
    ' directly
    MoveDeserialize j, JsonTokenGetChild&(j, moveArrayToken, 0), p.move1
    MoveDeserialize j, JsonTokenGetChild&(j, moveArrayToken, 1), p.move2
    MoveDeserialize j, JsonTokenGetChild&(j, moveArrayToken, 2), p.move3
    MoveDeserialize j, JsonTokenGetChild&(j, moveArrayToken, 3), p.move4
End Sub

Sub PokemonPartyDeserialize(j As Json, token As Long, p() As Pokemon)
    Dim i As Long, child As Long, count As Long
    count = JsonTokenTotalChildren&(j, token)

    For i = 0 To count - 1
        child = JsonTokenGetChild&(j, token, i)
        PokemonDeserialize j, child, p(i + 1)
    Next
End Sub

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
