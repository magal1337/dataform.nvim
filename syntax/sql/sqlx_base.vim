" Vim syntax file
" Language: SQLX
" Maintainer: Andres Lowrie
" Repository: https://github.com/andres-lowrie/vim-sqlx
" License: VIM
" Credits: https://github.com/vim/vim/blob/master/runtime/syntax/sqloracle.vim


" The 'Basic' sql keywords.
"
" This list comes from
" https://www.postgresql.org/docs/13/sql-keywords-appendix.html since I have
" no idea how to see the ANSI standard... chances are there are too many words
" here

syn keyword sqlxSqlSpecial false null true


" Keywords
" ---------------------
syn keyword sqlxSqlKeyword allocate are array as asc asensitive asymetric atomic authorization
syn keyword sqlxSqlKeyword begin begin_frame begin_partition blob both by
syn keyword sqlxSqlKeyword call called cardinality cascaded case cast character_length check classifier close cluster collate column commit corresponding cross current current_catalog current_default_transform_group current_path current_row current_transform_group_for_type cursor cycle
syn keyword sqlxSqlKeyword datalink day deallocate dec declare default define deref desc describe deterministic disconnect dlnewcopy dlpreviouscopy dlurlcomplete dlcurlcompleteonly clurlcompletewrite dlurlpath dlurlpathonly dlurlpathwrite dlurlserver dynamic
syn keyword sqlxSqlKeyword each element else empty end end-exec end_frame
syn keyword sqlxSqlKeyword end_partition equals every except exec execute exp
syn keyword sqlxSqlKeyword fetch filter first_value for foreign frame_row free freeze full function fusion
syn keyword sqlxSqlKeyword get global group grouping groups
syn keyword sqlxSqlKeyword having hold
syn keyword sqlxSqlKeyword identity import index indicator initial inner inout insensitive interval into
syn keyword sqlxSqlKeyword join
syn keyword sqlxSqlKeyword lag language large lead leading left local
syn keyword sqlxSqlKeyword materialized measures member merge method modifies module month multiset
syn keyword sqlxSqlKeyword natrual new no none not null nullif
syn keyword sqlxSqlKeyword of offset old on only order outer over overlaps overlay
syn keyword sqlxSqlKeyword parameter partition period primary procedure ptf
syn keyword sqlxSqlKeyword rank reads recursive ref references relase result return returns right
syn keyword sqlxSqlKeyword rollup row rows running
syn keyword sqlxSqlKeyword scope scroll show start
syn keyword sqlxSqlKeyword table then to trigger
syn keyword sqlxSqlKeyword unique unnest using user
syn keyword sqlxSqlKeyword values view
syn keyword sqlxSqlKeyword when whenever where window with


" Types
" ---------------------
syn keyword sqlxSqlType bigint binary bit blob boolean
syn keyword sqlxSqlType char character clob date datetime dec decfloat decimal double
syn keyword sqlxSqlType float
syn keyword sqlxSqlType int integer
syn keyword sqlxSqlType json
syn keyword sqlxSqlType long
syn keyword sqlxSqlType national nchar nclob nullable number numeric
syn keyword sqlxSqlType precision
syn keyword sqlxSqlType real
syn keyword sqlxSqlType smallint
syn keyword sqlxSqlType timestamp
syn keyword sqlxSqlType varchar varray


" Functions
" ---------------------
syn keyword sqlxSqlFunction abs acos array_agg array_max_cardinality asin atan avg
syn keyword sqlxSqlFunction ceil ceiling char_length coalesce collect convert corr cos cosh count covar_pop covar_samp cume_dist current_date current_date current_role current_schema current_time current_timestamp current_user date
syn keyword sqlxSqlFunction dense_rank
syn keyword sqlxSqlFunction floor
syn keyword sqlxSqlFunction json json_array json_arrayagg json_exists json_object json_objectagg json_query json_table json_table_primitive json_value
syn keyword sqlxSqlFunction last_value least like_regex listagg ln localtime localtimestamp log log10 lower
syn keyword sqlxSqlFunction match matches match_number match_recognize max min mod
syn keyword sqlxSqlFunction normalize normalized nth_value ntile
syn keyword sqlxSqlFunction occurrences_regex octet_length one open
syn keyword sqlxSqlFunction percent percentile_cont percentile_desc percent_rank portion position position_regex power precedes
syn keyword sqlxSqlFunction range regr_avgx regr_avgy regr_count regr_intercept regr_r2 regr_slope regr_sxx regr_sxy regr_syy row_count row_number
syn keyword sqlxSqlFunction search seek session_user sin sinh sqrt stddev_pop stddev_samp substring substring_regex sum
syn keyword sqlxSqlFunction tan timezone_hour timezone_minute translate translate_regex treat trim trim_array
syn keyword sqlxSqlFunction var_pop var_samp
syn keyword sqlxSqlFunction xmlagg xmlattributes xmlcast xmlbinary xmlcomment xmlconcat xmldocument xmlelement xmlexists xmlforest xmliterate xmlnamespaces xmlexists xmlforest xmliterate xmlnamespaces xmlparse xmlpi xmlquery xmlserialize xmltable xmltext xmlvalidate


" Statements
" ---------------------
syn keyword sqlxSqlStatement alter
syn keyword sqlxSqlStatement commit create
syn keyword sqlxSqlStatement delete drop
syn keyword sqlxSqlStatement from
syn keyword sqlxSqlStatement grant
syn keyword sqlxSqlStatement insert
syn keyword sqlxSqlStatement revoke rename rollback
syn keyword sqlxSqlStatement savepoint select set
syn keyword sqlxSqlStatement select
syn keyword sqlxSqlStatement truncate
syn keyword sqlxSqlStatement update


" Operators
" ---------------------
syn keyword sqlxSqlOperator all and any
syn keyword sqlxSqlOperator between
syn keyword sqlxSqlOperator distinct
syn keyword sqlxSqlOperator escape exists
syn keyword sqlxSqlOperator in intersect intersection is isnull
syn keyword sqlxSqlOperator like
syn keyword sqlxSqlOperator minus
syn keyword sqlxSqlOperator prior
syn keyword sqlxSqlOperator some sysdate
syn keyword sqlxSqlOperator or out
syn keyword sqlxSqlOperator union
