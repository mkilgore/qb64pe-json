qb64pe-json
-----------

`qb64pe-json` is a JSON parsing and creation library for QB64-PE. Given a
string containing JSON, it can convert it into a Json object which can then be
queried to retrieve the values in the JSON. Additionally it contains a variety
of `JsonTokenCreate*` functions which can be used to build up a Json object, which
can then be rendered into a String version of that JSON.

Please see [json.bi](src/json.bi) for more indepth documentation around the
API. Additionally see the [examples folder](examples/) for code samples of the
API in use.

To use the API, download a
[release version](https://github.com/mkilgore/qb64pe-json/releases) and place
the `json.bi` and `json.bm` files into your project. Then reference the two
files via `'$include:`.
