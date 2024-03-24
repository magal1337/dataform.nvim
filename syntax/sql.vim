" BigQuery SQL syntax highlighting

" Keywords
syn keyword sqlKeyword if else end loop continue while for case when then
syn keyword sqlKeyword union all limit order by group by on join left right outer inner cross
syn keyword sqlKeyword select from where as with using having distinct cast is null not and or in like
syn keyword sqlKeyword create table view function procedure materialized external schema database
syn keyword sqlKeyword drop grant revoke alter rename set into from replace by desc asc values
syn keyword sqlKeyword integer int float string bool boolean timestamp date datetime array
syn keyword sqlKeyword true false null

" Functions
syn keyword sqlFunction avg count sum min max approx_count_distinct
syn keyword sqlFunction date_add date_sub extract current_date current_time current_timestamp
syn keyword sqlFunction date_diff date_trunc format_datetime parse_datetime
syn keyword sqlFunction array_agg array_concat array_contains array_length
syn keyword sqlFunction array_reverse array_to_string array_concat_agg

" Operators
syn match sqlOperator /\+\|-\|\*\|\/\|%\|\=\|<\|>\|<=\|>=\|!=\|!<\|!>/\|&\||/

" Numbers
syn match sqlNumber /\v\d+(\.\d+)?/

" Strings
syn region sqlString start=+"+ end=+"+ keepend contains=@sqlStringGroup
syn region sqlString start=+'+ end=+'+ keepend contains=@sqlStringGroup

" Comments
syn match sqlComment "--.*" contains=@Spell

" Highlighting
hi def link sqlKeyword Keyword
hi def link sqlFunction Function
hi def link sqlOperator Operator
hi def link sqlNumber Number
hi def link sqlString String
hi def link sqlComment Comment

