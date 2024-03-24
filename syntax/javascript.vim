" JavaScript syntax highlighting

" Keywords
syn keyword javaScriptKeyword break case catch class const continue debugger
syn keyword javaScriptKeyword default delete do else export extends finally for
syn keyword javaScriptKeyword function if import in instanceof let new return
syn keyword javaScriptKeyword super switch this throw try typeof var void
syn keyword javaScriptKeyword while with yield async await

" Functions
syn keyword javaScriptFunction console.log setTimeout setInterval alert prompt

" Objects and Methods
syn keyword javaScriptMethod Object String Array Math JSON

" Numbers
syn match javaScriptNumber /\v\d+(\.\d+)?/

" Strings
syn region javaScriptString start=+"+ end=+"+ keepend contains=@javaScriptStringGroup
syn region javaScriptString start=+'+ end=+'+ keepend contains=@javaScriptStringGroup

" Comments
syn match javaScriptComment "//.*" contains=@Spell
syn match javaScriptComment "/\*\_.\{-}\*/" contains=@Spell

" Highlighting
hi def link javaScriptKeyword Keyword
hi def link javaScriptFunction Function
hi def link javaScriptMethod Function
hi def link javaScriptNumber Number
hi def link javaScriptString String
hi def link javaScriptComment Comment

