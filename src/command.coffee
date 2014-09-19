program = require 'commander'

###
* one filter per --where, but the ability to pass in 
  --where multiple times
* --any flag to OR together queries instead of AND
* --query <query.ned> for long queries

(A query file contains `where`, `limit`, `sort` keys etc.
If a query file is an array, the different queries will be
ORed together.)

planet:regex:/ar/,nin:jupiter,'our earth'
planet:
    $regex: /ar/
    $nin:
        [jupiter,our earth]

1. add newlines after colons
2. parse as YAML
3. if , in value then split
4. remove any quotes, parse regex strings, prefix special keys with $
5. feed query into nedb
6. apply additional underscore filters/operations
7. return data

{ planet: { $regex: /ar/, $nin: ['Jupiter', 'Earth'] }
###

program
    # ned options
    .option '-a --any', 
        'Match any criterion, not necessarily than all of them.'
    .option '-w, --where <mapping>', 
        'Match on random truth test (support for basic ones, can pass through to sh cmd)'
    .option '-q --query <file>'
    .option '-s --sort'
    .option '-S --skip'
    .option '-l --limit'
    .option '-p --pick', 
        '(projection)'
    .option '-o --omit', 
        '(projection)'
    # underscore options
    .option '-P --pluck <keys>'
    .option '-g --group <key>'
    .option '-i --index <key>'
    .option '-c --count [key]', 
        'Count, optionally after grouping by a key.'
    # other extensions
    .option '-m --map <mapping>', 
        'Apply a function to a field. [key]:[fn]'
    .option '-A --aggregate <mapping>', 
        # optionally split this out into a separate tool; though 
        # OTOH aggregation is a pretty common querying operation
        'To be used with --group. A mapping of [key]:[average|count|max|min|median|sum]'
    .option '-p --procedures', 
        'Load custom procedures (helper functions) that can be used to aggregate.'
    .option '-H --head', 
        'Alias to limit.'
    .option '-t --tail', 
        'Alias to limit on the reversed dataset.'
    .option '-v, --valid <schema>',
        'Passes JSON schema validation'
    .option '-I, --indent', 
        'Indented JSON.'
    .parse process.argv
