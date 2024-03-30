" Vim syntax file
" Language: SQLX
" Maintainer: Andres Lowrie
" Repository: https://github.com/andres-lowrie/vim-sqlx
" License: VIM
" Credits: https://github.com/pangloss/vim-javascript
"


" Allow $ in identifiers
if (v:version > 704 || v:version == 704 && has('patch1142')) && setting_up_sqlx
  syntax iskeyword @,48-57,_,192-255,$
else
  syntax iskeyword+=$
endif


" Grammar Constructs
" ---------------------
syn match sqlxJsNoise       /[:,;]/
syn match sqlxJsDot         /\./ skipwhite skipempty nextgroup=sqlxJsObjectProp,sqlxJsFuncCall,sqlxJsTaggedTemplate
syn match sqlxJsFuncCall    /\<\K\k*\ze\s*(/
syn match sqlxJsParensError /[(}\]]/


" Types and Builtin
" ---------------------
syn keyword sqlxJsGlobalObjects ArrayBuffer Array BigInt BigInt64Array BigUint64Array Float32Array Float64Array Int16Array Int32Array Int8Array Uint16Array Uint32Array Uint8Array Uint8ClampedArray Boolean Buffer Collator DataView Date DateTimeFormat Function Intl Iterator JSON Map Set WeakMap WeakRef WeakSet Math Number NumberFormat Object ParallelArray Promise Proxy Reflect RegExp String Symbol Uint8ClampedArray WebAssembly console document fetch window
syn keyword sqlxJsExceptions    Error EvalError InternalError RangeError ReferenceError StopIteration SyntaxError TypeError URIError
syn keyword sqlxJsBuiltins      decodeURI decodeURIComponent encodeURI encodeURIComponent eval isFinite isNaN parseFloat parseInt uneval


" Operators
" ---------------------
syn match sqlxJsOperator "[-!|&+<>=%/*~^]" skipwhite skipempty nextgroup=@sqlxJsExpression


" Strings and Templates
" ---------------------
syn region sqlxJsString         start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1+ end=+$+  contains=sqlxJsSpecial extend
syn region sqlxJsTemplateString start=+`+  skip=+\\`+  end=+`+ contains=sqlxJsTemplateExpression,sqlxJsSpecial extend
syn match  sqlxJsTaggedTemplate /\<\K\k*\ze`/ nextgroup=sqlxJsTemplateString


" Numbers
" ---------------------
syn match   sqlxJsNumber /\c\<\%(\d\+\%(e[+-]\=\d\+\)\=\|0b[01]\+\|0o\o\+\|0x\%(\x\|_\)\+\)n\=\>/
syn keyword sqlxJsNumber Infinity
syn match   sqlxJsFloat  /\c\<\%(\d\+\.\d\+\|\d\+\.\|\.\d\+\)\%(e[+-]\=\d\+\)\=\>/


" Regex
" ---------------------
syn match   sqlxJsSpecial            contained "\v\\%(x\x\x|u%(\x{4}|\{\x{4,5}})|c\u|.)"
syn region  sqlxJsTemplateExpression contained matchgroup=sqlxJsTemplateBraces start=+${+ end=+}+ contains=@sqlxJsExpression keepend
syn region  sqlxJsRegexpCharClass    contained start=+\[+ skip=+\\.+ end=+\]+ contains=sqlxJsSpecial extend
syn match   sqlxJsRegexpBoundary     contained "\v\c[$^]|\\b"
syn match   sqlxJsRegexpBackRef      contained "\v\\[1-9]\d*"
syn match   sqlxJsRegexpQuantifier   contained "\v[^\\]%([?*+]|\{\d+%(,\d*)?})\??"lc=1
syn match   sqlxJsRegexpOr           contained "|"
syn match   sqlxJsRegexpMod          contained "\v\(\?[:=!>]"lc=1
syn region  sqlxJsRegexpGroup        contained start="[^\\]("lc=1 skip="\\.\|\[\(\\.\|[^]]\+\)\]" end=")" contains=sqlxJsRegexpCharClass,@sqlxJsRegexpSpecial keepend
syn region  sqlxJsRegexpString                 start=+\%(\%(\<return\|\<typeof\|\_[^)\]'"[:blank:][:alnum:]_$]\)\s*\)\@<=/\ze[^*/]+ skip=+\\.\|\[[^]]\{1,}\]+ end=+/[gimyus]\{,6}+ contains=sqlxJsRegexpCharClass,sqlxJsRegexpGroup,@sqlxJsRegexpSpecial oneline keepend extend
syn cluster sqlxJsRegexpSpecial      contains=sqlxJsSpecial,sqlxJsRegexpBoundary,sqlxJsRegexpBackRef,sqlxJsRegexpQuantifier,sqlxJsRegexpOr,sqlxJsRegexpMod


" Objects
" ---------------------
syn match  sqlxJsObjectProp          contained /\<\K\k*/
syn match  sqlxJsObjectShorthandProp contained /\<\k*\ze\s*/ skipwhite skipempty nextgroup=sqlxJsObjectSeparator
syn match  sqlxJsObjectKey           contained /\<\k*\ze\s*:/ contains=sqlxJsFunctionKey skipwhite skipempty nextgroup=sqlxJsObjectValue
syn region sqlxJsObjectKeyString     contained start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1\|$+  contains=sqlxJsSpecial skipwhite skipempty nextgroup=sqlxJsObjectValue
syn region sqlxJsObjectKeyComputed   contained matchgroup=sqlxJsBrackets start=/\[/ end=/]/ contains=@sqlxJsExpression skipwhite skipempty nextgroup=sqlxJsObjectValue,sqlxJsFuncArgs extend
syn match  sqlxJsObjectSeparator     contained /,/
syn region sqlxJsObjectValue         contained matchgroup=sqlxJsObjectColon start=/:/ end=/[,}]\@=/ contains=@sqlxJsExpression extend
syn match  sqlxJsObjectFuncName      contained /\<\K\k*\ze\_s*(/ skipwhite skipempty nextgroup=sqlxJsFuncArgs
syn match  sqlxJsFunctionKey         contained /\<\K\k*\ze\s*:\s*function\>/
syn match  sqlxJsObjectMethodType    contained /\<[gs]et\ze\s\+\K\k*/ skipwhite skipempty nextgroup=sqlxJsObjectFuncName
syn region sqlxJsObjectStringKey     contained start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1\|$+  contains=sqlxJsSpecial extend skipwhite skipempty nextgroup=sqlxJsFuncArgs,sqlxJsObjectValue


" Classes
" ---------------------
syn keyword sqlxJsClassKeyword           contained class
syn keyword sqlxJsExtendsKeyword         contained extends skipwhite skipempty nextgroup=@sqlxJsExpression
syn match   sqlxJsClassNoise             contained /\./
syn match   sqlxJsClassFuncName          contained /\<\K\k*\ze\s*[(<]/ skipwhite skipempty nextgroup=sqlxJsFuncArgs
syn match   sqlxJsClassMethodType        contained /\<\%([gs]et\|static\)\ze\s\+\K\k*/ skipwhite skipempty nextgroup=sqlxJsAsyncKeyword,sqlxJsClassFuncName,sqlxJsClassProperty
syn region  sqlxJsClassDefinition                  start=/\<class\>/ end=/\(\<extends\>\s\+\)\@<!{\@=/ contains=sqlxJsClassKeyword,sqlxJsExtendsKeyword,sqlxJsClassNoise,@sqlxJsExpression skipwhite skipempty nextgroup=sqlxJsCommentClass,sqlxJsClassBlock
syn match   sqlxJsClassProperty          contained /\<\K\k*\ze\s*[=;]/ skipwhite skipempty nextgroup=sqlxJsClassValue
syn region  sqlxJsClassValue             contained start=/=/ end=/\_[;}]\@=/ contains=@sqlxJsExpression
syn region  sqlxJsClassPropertyComputed  contained matchgroup=sqlxJsBrackets start=/\[/ end=/]/ contains=@sqlxJsExpression skipwhite skipempty nextgroup=sqlxJsFuncArgs,sqlxJsClassValue extend
syn region  sqlxJsClassStringKey         contained start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1\|$+  contains=sqlxJsSpecial extend skipwhite skipempty nextgroup=sqlxJsFuncArgs


" Destructuring
" ---------------------
syn match  sqlxJsDestructuringPropertyValue     contained /\k\+/
syn match  sqlxJsDestructuringProperty          contained /\k\+\ze\s*=/ skipwhite skipempty nextgroup=sqlxJsDestructuringValue
syn match  sqlxJsDestructuringAssignment        contained /\k\+\ze\s*:/ skipwhite skipempty nextgroup=sqlxJsDestructuringValueAssignment
syn region sqlxJsDestructuringValue             contained start=/=/ end=/[,}\]]\@=/ contains=@sqlxJsExpression extend
syn region sqlxJsDestructuringValueAssignment   contained start=/:/ end=/[,}=]\@=/ contains=sqlxJsDestructuringPropertyValue,sqlxJsDestructuringBlock,sqlxJsNoise,sqlxJsDestructuringNoise skipwhite skipempty nextgroup=sqlxJsDestructuringValue extend
syn match  sqlxJsDestructuringNoise             contained /[,[\]]/
syn region sqlxJsDestructuringPropertyComputed  contained matchgroup=sqlxJsDestructuringBraces start=/\[/ end=/]/ contains=@sqlxJsExpression skipwhite skipempty nextgroup=sqlxJsDestructuringValue,sqlxJsDestructuringValueAssignment,sqlxJsDestructuringNoise extend fold


" Comments
" ---------------------
syn region  sqlxJsComment        start=+//+ end=/$/ contains=sqlxTodo,@Spell extend keepend
syn region  sqlxJsComment        start=+/\*+  end=+\*/+ contains=sqlxTodo,@Spell fold extend keepend
syn region  sqlxJsEnvComment     start=/\%^#!/ end=/$/ display


" Specialized Comments - These are special comment regexes that are used in
" odd places that maintain the proper nextgroup functionality. It sucks we
" can't make jsComment a skippable type of group for nextgroup
syn region sqlxJsCommentFunction contained start=+//+ end=/$/    contains=sqlxTodo,@Spell skipwhite skipempty nextgroup=sqlxJsFuncBlock extend keepend
syn region sqlxJsCommentFunction contained start=+/\*+ end=+\*/+ contains=sqlxTodo,@Spell skipwhite skipempty nextgroup=sqlxJsFuncBlock fold extend keepend
syn region sqlxJsCommentClass    contained start=+//+ end=/$/    contains=sqlxTodo,@Spell skipwhite skipempty nextgroup=sqlxJsClassBlock extend keepend
syn region sqlxJsCommentClass    contained start=+/\*+ end=+\*/+ contains=sqlxTodo,@Spell skipwhite skipempty nextgroup=sqlxJsClassBlock fold extend keepend
syn region sqlxJsCommentIfElse   contained start=+//+ end=/$/    contains=sqlxTodo,@Spell skipwhite skipempty nextgroup=sqlxJsIfElseBlock extend keepend
syn region sqlxJsCommentIfElse   contained start=+/\*+ end=+\*/+ contains=sqlxTodo,@Spell skipwhite skipempty nextgroup=sqlxJsIfElseBlock fold extend keepend
syn region sqlxJsCommentRepeat   contained start=+//+ end=/$/    contains=sqlxTodo,@Spell skipwhite skipempty nextgroup=sqlxJsRepeatBlock extend keepend
syn region sqlxJsCommentRepeat   contained start=+/\*+ end=+\*/+ contains=sqlxTodo,@Spell skipwhite skipempty nextgroup=sqlxJsRepeatBlock fold extend keepend


" Decorators
" ---------------------
syn match sqlxJsDecorator                    /^\s*@/ nextgroup=sqlxJsDecoratorFunction
syn match sqlxJsDecoratorFunction  contained /\h[a-zA-Z0-9_.]*/ nextgroup=sqlxJsParenDecorator



" Keywords
" ---------------------
syn keyword sqlxJsStorageClass              const let skipwhite skipempty nextgroup=sqlxJsDestructuringBlock,sqlxJsDestructuringArray,sqlxJsVariableDef
syn keyword sqlxJsStorageClass              const let skipwhite skipempty
syn keyword sqlxJsOperatorKeyword           delete instanceof typeof void new in of skipwhite skipempty nextgroup=@sqlxJsExpression
syn keyword sqlxJsBoolean                   true false
syn keyword sqlxJsNull                      null
syn keyword sqlxJsReturn                    return contained skipwhite nexgroup@sqlxJsExpression
syn keyword sqlxJsUndefined                 undefined
syn keyword sqlxJsNan                       NaN
syn keyword sqlxJsPrototype                 prototype
syn keyword sqlxJsThis                      this
syn keyword sqlxJsSuper                     super
syn keyword sqlxJsException                 throw
syn keyword sqlxJsAsyncKeyword              async await
syn keyword sqlxJsConditional               if skipwhite skipempty nextgroup=sqlxJsParenIfElse
syn keyword sqlxJsConditional               else skipwhite skipempty nextgroup=sqlxJsCommentIfElse,sqlxJsIfElseBlock
syn keyword sqlxJsConditional               switch skipwhite skipempty nextgroup=sqlxJsParenSwitch
syn keyword sqlxJsRepeat                    while for skipwhite skipempty nextgroup=sqlxJsParenRepeat,sqlxJsForAwait
syn region  sqlxJsSwitchCase      contained start=/\<\%(case\|default\)\>/ end=/:\@=/ contains=@sqlxJsExpression skipwhite skipempty nextgroup=sqlxJsSwitchColon keepend
syn keyword sqlxJsTry                       try skipwhite skipempty nextgroup=sqlxJsTryCatchBlock
syn keyword sqlxJsFinally         contained finally skipwhite skipempty nextgroup=sqlxJsFinallyBlock
syn keyword sqlxJsCatch           contained catch skipwhite skipempty nextgroup=sqlxJsParenCatch,sqlxJsTryCatchBlock
syn match   sqlxJsSwitchColon     contained /::\@!/ skipwhite skipempty nextgroup=sqlxJsSwitchBlock


" Code blocks
" ---------------------
syn region sqlxJsBracket                      matchgroup=sqlxJsBrackets            start=/\[/ end=/\]/ contains=@sqlxJsExpression,sqlxJsSpreadExpression extend fold
syn region sqlxJsParen                        matchgroup=sqlxJsParens              start=/(/  end=/)/  contains=@sqlxJsExpression extend fold
syn region sqlxJsParenDecorator     contained matchgroup=sqlxJsParensDecorator     start=/(/  end=/)/  contains=@sqlxJsAll extend fold
syn region sqlxJsParenIfElse        contained matchgroup=sqlxJsParensIfElse        start=/(/  end=/)/  contains=@sqlxJsAll skipwhite skipempty nextgroup=sqlxJsCommentIfElse,sqlxJsIfElseBlock,sqlxJsReturn extend fold
syn region sqlxJsParenRepeat        contained matchgroup=sqlxJsParensRepeat        start=/(/  end=/)/  contains=@sqlxJsAll skipwhite skipempty nextgroup=sqlxJsCommentRepeat,sqlxJsRepeatBlock,sqlxJsReturn extend fold
syn region sqlxJsParenSwitch        contained matchgroup=sqlxJsParensSwitch        start=/(/  end=/)/  contains=@sqlxJsAll skipwhite skipempty nextgroup=sqlxJsSwitchBlock extend fold
syn region sqlxJsParenCatch         contained matchgroup=sqlxJsParensCatch         start=/(/  end=/)/  skipwhite skipempty nextgroup=sqlxJsTryCatchBlock extend fold
syn region sqlxJsFuncArgs           contained matchgroup=sqlxJsFuncParens          start=/(/  end=/)/  contains=sqlxJsFuncArgCommas,sqlxJsComment,sqlxJsFuncArgExpression,sqlxJsDestructuringBlock,sqlxJsDestructuringArray,sqlxJsRestExpression skipwhite skipempty nextgroup=sqlxJsCommentFunction,sqlxJsFuncBlock extend fold
syn region sqlxJsClassBlock         contained matchgroup=sqlxJsClassBraces         start=/{/  end=/}/  contains=sqlxJsClassFuncName,sqlxJsClassMethodType,sqlxJsArrowFunction,sqlxJsArrowFuncArgs,sqlxJsComment,sqlxJsGenerator,sqlxJsDecorator,sqlxJsClassProperty,sqlxJsClassPropertyComputed,sqlxJsClassStringKey,sqlxJsAsyncKeyword,sqlxJsNoise extend fold
syn region sqlxJsFuncBlock          contained matchgroup=sqlxJsFuncBraces          start=/{/  end=/}/  contains=@sqlxJsAll,sqlxJsBlock extend fold
syn region sqlxJsIfElseBlock        contained matchgroup=sqlxJsIfElseBraces        start=/{/  end=/}/  contains=@sqlxJsAll,sqlxJsBlock extend fold
syn region sqlxJsTryCatchBlock      contained matchgroup=sqlxJsTryCatchBraces      start=/{/  end=/}/  contains=@sqlxJsAll,sqlxJsBlock skipwhite skipempty nextgroup=sqlxJsCatch,sqlxJsFinally extend fold
syn region sqlxJsFinallyBlock       contained matchgroup=sqlxJsFinallyBraces       start=/{/  end=/}/  contains=@sqlxJsAll,sqlxJsBlock extend fold
syn region sqlxJsSwitchBlock        contained matchgroup=sqlxJsSwitchBraces        start=/{/  end=/}/  contains=@sqlxJsAll,sqlxJsBlock,sqlxJsSwitchCase extend fold
syn region sqlxJsRepeatBlock        contained matchgroup=sqlxJsRepeatBraces        start=/{/  end=/}/  contains=@sqlxJsAll,sqlxJsBlock extend fold
syn region sqlxJsDestructuringBlock contained matchgroup=sqlxJsDestructuringBraces start=/{/  end=/}/  contains=sqlxJsDestructuringProperty,sqlxJsDestructuringAssignment,sqlxJsDestructuringNoise,sqlxJsDestructuringPropertyComputed,sqlxJsSpreadExpression,sqlxJsComment extend fold
syn region sqlxJsDestructuringArray contained matchgroup=sqlxJsDestructuringBraces start=/\[/ end=/\]/ contains=sqlxJsDestructuringPropertyValue,sqlxJsDestructuringNoise,sqlxJsDestructuringProperty,sqlxJsSpreadExpression,sqlxJsDestructuringBlock,sqlxJsDestructuringArray,sqlxJsComment extend fold
syn region sqlxJsObject             contained matchgroup=sqlxJsObjectBraces        start=/{/  end=/}/  contains=sqlxJsObjectKey,sqlxJsObjectKeyString,sqlxJsObjectKeyComputed,sqlxJsObjectShorthandProp,sqlxJsObjectSeparator,sqlxJsObjectFuncName,sqlxJsObjectMethodType,sqlxJsGenerator,sqlxJsComment,sqlxJsObjectStringKey,sqlxJsSpreadExpression,sqlxJsDecorator,sqlxJsAsyncKeyword,sqlxJsTemplateString extend fold
syn region sqlxJsBlock                        matchgroup=sqlxJsBraces              start=/{/  end=/}/  contains=@sqlxJsAll,sqlxJsSpreadExpression,sqlxJsTemplateString extend fold
syn region sqlxJsSpreadExpression   contained matchgroup=sqlxJsSpreadOperator      start=/\.\.\./ end=/[,}\]]\@=/ contains=@sqlxJsExpression
syn region sqlxJsRestExpression     contained matchgroup=sqlxJsRestOperator        start=/\.\.\./ end=/[,)]\@=/
syn region sqlxJsTernaryIf                    matchgroup=sqlxJsTernaryIfOperator   start=/?:\@!/  end=/\%(:\|}\@=\)/  contains=@sqlxJsExpression extend skipwhite skipempty nextgroup=@sqlxJsExpression


" These must occur here or they will be over written by jsTernaryIf
syn match sqlxJsOperator /?\.\ze\_D/
syn match sqlxJsOperator /??/ skipwhite skipempty nextgroup=@sqlxJsExpression

syn match   sqlxJsGenerator         contained /\*/ skipwhite skipempty nextgroup=sqlxJsFuncName,sqlxJsFuncArgs
syn match   sqlxJsFuncName          contained /\<\K\k*/ skipwhite skipempty nextgroup=sqlxJsFuncArgs
syn region  sqlxJsFuncArgExpression contained matchgroup=sqlxJsFuncArgOperator start=/=/ end=/[,)]\@=/ contains=@sqlxJsExpression extend
syn match   sqlxJsFuncArgCommas     contained ','
syn keyword sqlxJsArguments         contained arguments
syn keyword sqlxJsForAwait          contained await skipwhite skipempty nextgroup=sqlxJsParenRepeat

" Matches a single keyword argument with no parens and the (iffe) arrow
syn match sqlxJsArrowFuncArgs /\<\K\k*\ze\s*=>/ skipwhite contains=sqlxJsFuncArgs skipwhite skipempty nextgroup=sqlxJsArrowFunction extend
syn match sqlxJsArrowFuncArgs /([^()]*)\ze\s*=>/ contains=sqlxJsFuncArgs skipempty skipwhite nextgroup=sqlxJsArrowFunction extend

syn match sqlxJsFunction      /\<function\>/ skipwhite skipempty nextgroup=sqlxJsGenerator,sqlxJsFuncName,sqlxJsFuncArgs skipwhite
syn match sqlxJsArrowFunction /=>/           skipwhite skipempty nextgroup=sqlxJsFuncBlock,sqlxJsCommentFunction
syn match sqlxJsArrowFunction /()\ze\s*=>/   skipwhite skipempty nextgroup=sqlxJsArrowFunction
syn match sqlxJsArrowFunction /_\ze\s*=>/    skipwhite skipempty nextgroup=sqlxJsArrowFunction
  
syn cluster sqlxJsExpression  contains=sqlxJsBracket,sqlxJsParen,sqlxJsObject,sqlxJsTernaryIf,sqlxJsTaggedTemplate,sqlxJsTemplateString,sqlxJsString,sqlxJsRegexpString,sqlxJsNumber,sqlxJsFloat,sqlxJsOperator,sqlxJsOperatorKeyword,sqlxJsBooleanTrue,sqlxJsBooleanFalse,sqlxJsNull,sqlxJsFunction,sqlxJsArrowFunction,sqlxJsGlobalObjects,sqlxJsExceptions,sqlxJsFuncCall,sqlxJsUndefined,sqlxJsNan,sqlxJsPrototype,sqlxJsBuiltins,sqlxJsNoise,sqlxJsClassDefinition,sqlxJsArrowFunction,sqlxJsArrowFuncArgs,sqlxJsParensError,sqlxJsComment,sqlxJsArguments,sqlxJsThis,sqlxJsSuper,sqlxJsForAwait,sqlxJsAsyncKeyword,sqlxJsStatement,sqlxJsDot
syn cluster sqlxJsAll         contains=@sqlxJsExpression,sqlxJsStorageClass,sqlxJsConditional,sqlxJsRepeat,sqlxJsReturn,sqlxJsException,sqlxJsTry,sqlxJsNoise


" Link
" ---------------------
hi def link sqlxJsArguments               Special
hi def link sqlxJsArrowFuncArgs           sqlxJsFuncArgs
hi def link sqlxJsArrowFunction           Type
hi def link sqlxJsAsyncKeyword            Keyword
hi def link sqlxJsBooleanFalse            Boolean
hi def link sqlxJsBooleanTrue             Boolean
hi def link sqlxJsBraces                  Noise
hi def link sqlxJsBrackets                Noise
hi def link sqlxJsBranch                  Conditional
hi def link sqlxJsBuiltins                Constant
hi def link sqlxJsCatch                   Exception
hi def link sqlxJsCharacter               Character
hi def link sqlxJsClassBraces             Noise
hi def link sqlxJsClassDefinition         sqlxJsFuncName
hi def link sqlxJsClassFuncName           sqlxJsFuncName
hi def link sqlxJsClassKeyword            Keyword
hi def link sqlxJsClassMethodType         Type
hi def link sqlxJsClassNoise              Noise
hi def link sqlxJsClassProperty           sqlxJsObjectKey
hi def link sqlxJsClassStringKey          String
hi def link sqlxJsComment                 Comment
hi def link sqlxJsCommentClass            sqlxJsComment
hi def link sqlxJsCommentFunction         sqlxJsComment
hi def link sqlxJsCommentIfElse           sqlxJsComment
hi def link sqlxJsCommentRepeat           sqlxJsComment
hi def link sqlxJsConditional             Conditional
hi def link sqlxJsDecorator               Special
hi def link sqlxJsDecoratorFunction       Function
hi def link sqlxJsDestructuringAssignment sqlxJsObjectKey
hi def link sqlxJsDestructuringBraces     Noise
hi def link sqlxJsDestructuringNoise      Noise
hi def link sqlxJsDestructuringProperty   sqlxJsFuncArgs
hi def link sqlxJsDo                      Repeat
hi def link sqlxJsDot                     Noise
hi def link sqlxJsEnvComment              PreProc
hi def link sqlxJsError                   Error
hi def link sqlxJsException               Exception
hi def link sqlxJsExceptions              Constant
hi def link sqlxJsExportDefault           StorageClass
hi def link sqlxJsExportDefaultGroup      jsExportDefault
hi def link sqlxJsExtendsKeyword          Keyword
hi def link sqlxJsFinally                 Exception
hi def link sqlxJsFinallyBraces           Noise
hi def link sqlxJsFloat                   Float
hi def link sqlxJsForAwait                Keyword
hi def link sqlxJsFuncArgOperator         sqlxJsFuncArgs
hi def link sqlxJsFuncBraces              Noise
hi def link sqlxJsFuncCall                Function
hi def link sqlxJsFuncName                Function
hi def link sqlxJsFuncParens              Noise
hi def link sqlxJsFunction                Type
hi def link sqlxJsGenerator               sqlxJsFunction
hi def link sqlxJsGlobalObjects           Constant
hi def link sqlxJsIfElseBraces            Noise
hi def link sqlxJsNan                     Number
hi def link sqlxJsNoise                   Noise
hi def link sqlxJsNull                    Type
hi def link sqlxJsNumber                  Number
hi def link sqlxJsObjectBraces            Noise
hi def link sqlxJsObjectColon             jsNoise
hi def link sqlxJsObjectFuncName          Function
hi def link sqlxJsObjectKeyString         String
hi def link sqlxJsObjectMethodType        Type
hi def link sqlxJsObjectSeparator         Noise
hi def link sqlxJsObjectShorthandProp     sqlxJsObjectKey
hi def link sqlxJsObjectStringKey         String
hi def link sqlxJsOperator                Operator
hi def link sqlxJsOperatorKeyword         sqlxJsOperator
hi def link sqlxJsParens                  Noise
hi def link sqlxJsParensCatch             sqlxJsParens
hi def link sqlxJsParensDecorator         sqlxJsParens
hi def link sqlxJsParensError             Error
hi def link sqlxJsParensIfElse            sqlxJsParens
hi def link sqlxJsParensRepeat            sqlxJsParens
hi def link sqlxJsParensSwitch            sqlxJsParens
hi def link sqlxJsPrototype               Special
hi def link sqlxJsRegexpBackRef           SpecialChar
hi def link sqlxJsRegexpBoundary          SpecialChar
hi def link sqlxJsRegexpCharClass         Character
hi def link sqlxJsRegexpGroup             sqlxJsRegexpString
hi def link sqlxJsRegexpMod               SpecialChar
hi def link sqlxJsRegexpOr                Conditional
hi def link sqlxJsRegexpQuantifier        SpecialChar
hi def link sqlxJsRegexpString            String
hi def link sqlxJsRepeat                  Repeat
hi def link sqlxJsRepeatBraces            Noise
hi def link sqlxJsRestExpression          sqlxJsFuncArgs
hi def link sqlxJsRestOperator            Operator
hi def link sqlxJsReturn                  Statement
hi def link sqlxJsSpecial                 Special
hi def link sqlxJsSpreadOperator          Operator
hi def link sqlxJsStatement               Statement
hi def link sqlxJsStorageClass            StorageClass
hi def link sqlxJsString                  String
hi def link sqlxJsSuper                   Constant
hi def link sqlxJsSwitchBraces            Noise
hi def link sqlxJsSwitchColon             Noise
hi def link sqlxJsTaggedTemplate          StorageClass
hi def link sqlxJsTemplateBraces          Noise
hi def link sqlxJsTemplateString          String
hi def link sqlxJsTernaryIfOperator       Operator
hi def link sqlxJsThis                    Special
hi def link sqlxJsTry                     Exception
hi def link sqlxJsTryCatchBraces          Noise
hi def link sqlxJsUndefined               Type
