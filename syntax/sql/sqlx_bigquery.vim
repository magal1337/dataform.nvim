" Vim syntax file
" Language: SQLX
" Maintainer: Andres Lowrie
" Repository: https://github.com/magal1337/dataform.nvim
" License: MIT

" BigQuery Syntax
" https://cloud.google.com/bigquery/docs/reference/standard-sql

syn keyword sqlxSqlSpecial false null true
syn keyword sqlxSqlSpecial error

" Keywords
" ---------------------
syn keyword sqlxSqlKeyword as asc
syn keyword sqlxSqlKeyword begin by
syn keyword sqlxSqlKeyword coalesce cross
syn keyword sqlxSqlKeyword desc
syn keyword sqlxSqlKeyword for full function
syn keyword sqlxSqlKeyword if ifnull inner
syn keyword sqlxSqlKeyword join
syn keyword sqlxSqlKeyword left limit
syn keyword sqlxSqlKeyword not null nullable nullif
syn keyword sqlxSqlKeyword of offset order outer
syn keyword sqlxSqlKeyword partition
syn keyword sqlxSqlKeyword safe
syn keyword sqlxSqlKeyword right
syn keyword sqlxSqlKeyword table
syn keyword sqlxSqlKeyword unique unnest using
syn keyword sqlxSqlKeyword values view
syn keyword sqlxSqlKeyword when where with


" Types
" ---------------------
syn keyword sqlxSqlType array
syn keyword sqlxSqlType bool bytes bigdecimal bignumeric
syn keyword sqlxSqlType date datetime decimal
syn keyword sqlxSqlType float64
syn keyword sqlxSqlType geography
syn keyword sqlxSqlType int64
syn keyword sqlxSqlType numeric
syn keyword sqlxSqlType string struct
syn keyword sqlxSqlType time timestamp


" Functions
" ---------------------
syn keyword sqlxSqlFunction abs acos acosh any_value approx_count_distinct approx_quantiles approx_top_count approx_top_sum array_concat_agg array_reverse array_value asin asinh atan atanh atan2 ascii avg
syn keyword sqlxSqlFunction bit_and bit_count bit_or bit_xor byte_length
syn keyword sqlxSqlFunction cast ceil celing count countif cos cosh corr covar_pop covar_samp current_date current_datetime current_timestamp char_length character_length
syn keyword sqlxSqlFunction chr code_points_to_bytes code_points_to_string concat cume_dist
syn keyword sqlxSqlFunction date date_add date_sub date_diff date_trunc date_from_unix_date datetime datetime_add datetime_diff datetime_sub datetime_tunc format_datetime
syn keyword sqlxSqlFunction div dense_rank
syn keyword sqlxSqlFunction ends_with extract external_query exp
syn keyword sqlxSqlFunction farm_fingerprint floor format format_date format_time format_timestamp first_value from_base32 from_base64 from_hex
syn keyword sqlxSqlFunction generate_array generate_date_array generate_timestamp_array generate_uuid greatest
syn keyword sqlxSqlFunction hll_count.init hll_count.merge hll_count.merge_partial hll_count.extract
syn keyword sqlxSqlFunction left length lpad lower ltrim
syn keyword sqlxSqlFunction ieee_divide initcap instr is_inf is_nan
syn keyword sqlxSqlFunction json_extract json_query json_query json_extract_scalar json_value json_extract_array json_extract_string_array json_value_array
syn keyword sqlxSqlFunction lag last_day last_value lead least ln log log10 logical_and logical_or
syn keyword sqlxSqlFunction nth_value net.ip_from_string net.safe_ip_from_string net.ip_to_string net.ip_net_mask net.ip_trunc net.ipv4_from_int64 net.ipv4_to_int64
syn keyword sqlxSqlFunction net.host net.public_suffix net.reg_domain ntile normalize normalize_and_casefold
syn keyword sqlxSqlFunction max md5 min mod
syn keyword sqlxSqlFunction octect_length
syn keyword sqlxSqlFunction parse_date parse_time parse_timestamp percentile_count percentile_disc percent_rank pow power
syn keyword sqlxSqlFunction rand range_bucket rank rollup round row_number regexp_contains regexp_extract regexp_extract_all regexp_instr regexp_replace regexp_substr
syn keyword sqlxSqlFunction replace repeat reverse right rpad rtrim
syn keyword sqlxSqlFunction safe_cast safe_divide safe_multiply safe_negat safe_add safe_substract sha1 sha256 sha512 sign sqrt sin sinh session_user
syn keyword sqlxSqlFunction st_geogpoint st_makeline st_makepolygon st_makepolygonoriented st_geogfromgeojson st_geogfromtext st_geogfromwkb st_geogpointfromgeohash
syn keyword sqlxSqlFunction st_asbinary st_asgeojson st_astext st_geohash st_bounday st_centroid st_centroid_agg st_closestpoint st_convexhull st_difference st_dump
syn keyword sqlxSqlFunction st_intersection st_simplify st_snaptogrid st_union st_union_agg st_dimension st_endpoint st_iscollection is_isempty st_npoint st_numpoints
syn keyword sqlxSqlFunction st_pointn st_startpoint st_x st_y st_contains st_coverdby st_disjoint st_dwithin st_equals st_intersects st_intersectsbox st_touches
syn keyword sqlxSqlFunction st_within st_area st_distance st_length st_maxdistance st_perimeter st_clusterdbscan
syn keyword sqlxSqlFunction safe_convert_bytes_to_string safe_offset safe_ordinal soundex split start_with stddev stddev_pop stddev_samp strpos string string_agg substr sum
syn keyword sqlxSqlFunction tan tanh time time_add time_sub time_diff time_trunc timestamp timestamp_add timestamp_sub timestamp_diff timestamp_trunc timestamp_seconds
syn keyword sqlxSqlFunction timestamp_millis timestamp_micros to_json_string to_base32 to_base64 to_code_points to_hex translate trim trunc
syn keyword sqlxSqlFunction unicode unix_date unix_seconds unix_millis unix_micros upper 
syn keyword sqlxSqlFunction variance var_pop var_samp


" Statements
" ---------------------
syn keyword sqlxSqlStatement case create
syn keyword sqlxSqlStatement declare default delete drop
syn keyword sqlxSqlStatement except
syn keyword sqlxSqlStatement from
syn keyword sqlxSqlStatement group
syn keyword sqlxSqlStatement having
syn keyword sqlxSqlStatement insert
syn keyword sqlxSqlStatement replace
syn keyword sqlxSqlStatement select set
syn keyword sqlxSqlStatement qualify
syn keyword sqlxSqlStatement truncate
syn keyword sqlxSqlStatement update
syn keyword sqlxSqlStatement window
syn keyword sqlxSqlStatement limit


" Operators
" ---------------------
syn keyword sqlxSqlOperator all and any
syn keyword sqlxSqlOperator between
syn keyword sqlxSqlOperator distinct
syn keyword sqlxSqlOperator exists
syn keyword sqlxSqlOperator in intersect is isnull
syn keyword sqlxSqlOperator not
syn keyword sqlxSqlOperator pivot
syn keyword sqlxSqlOperator tamblesample
syn keyword sqlxSqlOperator union unnest unpivot
