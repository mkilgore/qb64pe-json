qb64pe-json
-----------

`qb64pe-json` is a JSON parsing and creation library for QB64-PE. Given a
string containing JSON, it can convert it into a Json object which can then be
queried to retrieve the values in the JSON. Additionally it contains a variety
of `JsonTokenCreate*` functions which can be used to build up a Json object, which
can then be rendered into a String version of that JSON.

Please see [src/json.bi](json.bi) for more indepth documentation around the
API. Additionally see the [examples](examples folder) for code samples of the
API in use.

To use the API, download a
[https://github.com/mkilgore/qb64pe-json/releases](release version) and place
the `json.bi` and `json.bm` files into your project. Then reference the two
files via `'$include:`.
