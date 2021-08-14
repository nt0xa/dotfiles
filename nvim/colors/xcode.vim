" Init {{{ "

set background=dark

hi clear

if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'xcode'

" }}} Init "

" Highlight function {{{ "

" Arguments: group, guifg, guibg, gui, guisp
function! s:hl(group, fg, ...)

  " foreground
  let fg = a:fg

  " background
  if a:0 >= 1
    let bg = a:1
  else
    let bg = 'NONE'
  endif

  " emphasis
  if a:0 >= 2 && strlen(a:2)
    let emstr = a:2
  else
    let emstr = 'NONE,'
  endif

  " special fallback
  if a:0 >= 3
    if g:gruvbox_guisp_fallback != 'NONE'
      let fg = a:3
    endif

    " bg fallback mode should invert higlighting
    if g:gruvbox_guisp_fallback == 'bg'
      let emstr .= 'inverse,'
    endif
  endif

  let histring = [ 'hi', a:group,
        \ 'guifg=' . fg, 'ctermfg=NONE',
        \ 'guibg=' . bg, 'ctermbg=NONE',
        \ 'gui=' . emstr[:-2], 'cterm=NONE'
        \ ]

  " special
  if a:0 >= 3
    call add(histring, 'guisp=' . a:3[0])
  endif

  execute join(histring, ' ')
endfunction

" }}} Highlight function "

" Colors {{{ "

let s:none = 'NONE,'
let s:bold = 'bold,'
let s:italic = 'italic,'


let s:black = '#393b44'
let s:red = '#ff8170'
let s:green = '#78c2b3'
let s:yellow = '#d9c97c'
let s:blue = '#4eb0cc'
let s:magenta = '#ff7ab2'
let s:cyan = '#b281eb'
let s:white = '#dfdfe0'
let s:bright_black = '#7f8c98'
let s:bright_red = '#ff8170'
let s:bright_green = '#acf2e4'
let s:bright_yellow = '#ffa14f'
let s:bright_blue = '#6bdfff'
let s:bright_magenta = '#ff7ab2'
let s:bright_cyan = '#dabaff'
let s:bright_white = '#dfdfe0'


let s:background = '#292A2F'
let s:background2 = '#393B44'
let s:foreground = '#DFDFE0'
let s:gutter = '#747478'
let s:selection = '#636F83'
let s:line_highlight = '#2F3238'

let s:comments = '#7F8C98'
let s:keywords = '#EE83B1'
let s:strings = '#EF8775'
let s:numbers = '#D3C584'
let s:builtins = '#D4BDFA'
let s:funcdef = '#67AFC9'
let s:funcuse = '#88C0B4'
let s:typedef = '#88DDFB'
let s:typeuse = '#BAF0E4'

call s:hl('XCKeywords', s:keywords, s:none, s:bold)
call s:hl('XCStrings', s:strings)
call s:hl('XCNumbers', s:numbers)
call s:hl('XCBuiltins', s:builtins)
call s:hl('XCFuncdef', s:funcdef)
call s:hl('XCFuncuse', s:funcuse)
call s:hl('XCTypedef', s:typedef)
call s:hl('XCTypeuse', s:typeuse)

" }}} Colors "

" UI {{{"

call s:hl('Normal', s:foreground)
call s:hl('LineNr', s:gutter)
call s:hl('Comment', s:comments)
call s:hl('CommentBold', s:comments, s:none, s:bold)
call s:hl('NonText', s:gutter)
call s:hl('SignColumn', s:none, s:background)
call s:hl('Visual', s:none, s:selection)
call s:hl('Folded', s:comments, s:line_highlight)
call s:hl('Pmenu', s:foreground, s:background2)
call s:hl('PmenuSel', s:foreground, s:blue, s:bold)
call s:hl('MatchParen', s:none, s:selection)



" }}} UI "

" General {{{ "

hi! link Special XCBuiltins

" sizeof, "+", "*", etc.
hi! link Operator Normal

" Variable name
hi! link Identifier Normal

hi! link Delimiter Normal

" }}} General "

" Keywords {{{"

" Generic keyword
hi! link Keyword XCKeywords

" Generic statement
hi! link Statement XCKeywords

" if, then, else, endif, swicth, etc.
hi! link Conditional XCKeywords

" for, do, while, etc.
hi! link Repeat XCKeywords

" case, default, etc.
hi! link Label XCKeywords

" try, catch, throw
hi! link Exception XCKeywords

" static, register, volatile, etc
hi! link StorageClass XCKeywords

" struct, union, enum, etc.
hi! link Structure XCKeywords

" typedef
hi! link Typedef XCKeywords

" Generic preprocessor
hi! link PreProc XCKeywords

" }}} Keywords "

" Constants {{{ "

" strings
hi! link String XCStrings

" numbers
hi! link Number XCNumbers
hi! link Float XCNumbers

" boolean
hi! link Boolean XCKeywords

" }}} Constants "

" Builtins {{{ "

" Generic type
hi! link Type XCBuiltins

" Constant
hi! link Constant XCBuiltins

" }}} Builtins "

" Custom functions {{{ "

" Function name
hi! link Function XCFuncuse

" }}} Custom functions "

" Custom types {{{"

hi! link StorageClass XCTypedef

" }}} Custom types "

" PHP {{{ "

hi! link phpType XCKeywords
hi! link phpStorageClass XCKeywords

hi! link phpFunction XCFuncdef
hi! link phpClass XCTypedef
hi! link phpMethod XCFuncuse
hi! link phpClasses XCBuiltins

hi! link phpRegion Normal
hi! link phpUseNamespaceSeparator Normal
hi! link phpParent Normal

" }}} PHP "

" Vim {{{ "

hi! link vimOption XCBuiltins
hi! link vimMapMod XCBuiltins
hi! link vimMapModKey XCBuiltins
hi! link vimFunction XCFuncdef
hi! link vimEnvVar Normal
hi! link vimParenSep Normal

call s:hl('vimCommentTitle', s:comments, s:none, s:bold)

" }}} Vim "

" Python {{{ "

hi! link pythonBuiltin XCBuiltins
hi! link pythonOperator XCKeywords

" }}} Python "

" JS {{{ "

hi! link jsStorageClass XCKeywords
hi! link jsThis XCKeywords
hi! link jsOperatorKeyword XCKeywords
hi! link jsClassMethodType XCKeywords
hi! link jsSuper XCKeywords
hi! link jsClassFuncName XCFuncdef
hi! link jsClassDefinition XCTypedef

" }}} JS "

" YAML {{{ "

hi! link yamlBlockMappingKey XCKeywords
hi! link yamlKeyValueDelimiter Normal

" }}} YAML "

" HTML & Markdown {{{ "

hi! link htmlH1 XCKeywords

hi! link mkdLink XCFuncdef
hi! link mdkURL XCStrings


" }}} HTML & Markdown "

" XML {{{ "

hi! link xmlEndTag XCFuncuse

" }}} XML "

" Typescript {{{"

hi! link typescriptStorageClass XCKeywords
hi! link typescriptExceptions XCKeywords
hi! link typescriptIdentifier XCKeywords
hi! link typescriptOperator XCKeywords
hi! link typescriptNull XCKeywords
hi! link typescriptEndColons Normal
hi! link typescriptBraces Normal
hi! link typescriptParens Normal
hi! link typescriptDocTags CommentBold
hi! link typescriptDocParam Comment

" }}} Typescript "

