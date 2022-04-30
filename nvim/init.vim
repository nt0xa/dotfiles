scriptencoding utf-8

" Plugins {{{

" Auto-install vim-plug
if empty(glob('$XDG_DATA_HOME/nvim/site/autoload/plug.vim'))
    !git clone 'https://github.com/junegunn/vim-plug' $XDG_DATA_HOME/nvim/site/autoload
endif

call plug#begin('$XDG_DATA_HOME/nvim/site/plugged')

" Interface
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Navigation
Plug 'tpope/vim-rsi'

" Editor
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'junegunn/vim-easy-align'
Plug 'ntpeters/vim-better-whitespace'
Plug 'AndrewRadev/sideways.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'SirVer/ultisnips'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'

" Syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Formatting
Plug 'mhartington/formatter.nvim'

call plug#end()

" }}} Plugins

" Options {{{

" File encodings
set fileencodings=utf-8,cp1251

" Show line numbers
set number

" Always show status line
set laststatus=2

" Always show sign column
set signcolumn=yes

" Hide status line at the bottom
set noshowmode

" Allow switching buffers without saving
set hidden

" Enable mouse
set mouse=a

" This will cause all yank/delete/paste operations to use the system register *
set clipboard=unnamed,unnamedplus

" Wildignore
set wildignore=.git,node_modules,dist,build,venv,vendor*.o,*.a,*.pyc,*.class

" Enable syntax highlighting
syntax enable

" Enables 24-bit RGB color in the |TUI|
set termguicolors

" Colorscheme
set background=dark
try
    colorscheme xcode
catch /^Vim\%((\a\+)\)\=:E185/
    " Fallback colorscheme
    colorscheme desert
endtry

" Count of spaces per tab when editing
set softtabstop=2

" Number of visual spaces per tab
set tabstop=2

" <<, >> spaces
set shiftwidth=2

" Use spaces for indent
set expandtab

" Display tabs and trailing spaces visually
set list listchars=tab:➝\ ,eol:¬

" Mouse and backspace
set backspace=indent,eol,start

" Don't wrap lines
set nowrap

" Count of remembered commands
set history=1000

" Count of undo
set undolevels=1000

" Disable swap & backup files
set nobackup
set nowritebackup
set noswapfile

" Case insensitive search
set ignorecase
set smartcase

" Highlight matches
set hlsearch

" Seach while typing
set incsearch

" Detect filetypes
filetype plugin on

" Load filetype-specific indent files
filetype indent on

" Enable folding
set foldenable

" Set fold method
set foldmethod=marker

" Interactive replace
set inccommand=nosplit

" Suppress the annoying 'match x of y', 'The only match' and 'Pattern not found' messages
set shortmess+=c

" This will show the popup menu even if there's only one match (menuone),
" prevent automatic selection (noselect) and prevent automatic text injection
" into the current line (noinsert).
set completeopt=noinsert,menuone,noselect

" Faster CursorHold
set updatetime=500

" }}} Options

" Key mappings {{{

" Set leader
let g:mapleader = ' '

" Set localleader
let g:maplocalleader = ','

" Reload config
nnoremap <leader>r :source $MYVIMRC<CR>

" Write file
nnoremap <Leader>w :w!<CR>

" Quit
nnoremap <Leader>q :q<CR>

" Only
nnoremap <Leader>o :only<CR>

" Select pasted text
noremap gV `[v`]

" Paste in insert mode
inoremap <C-y> <C-o>p

" Quickfix
nnoremap <Leader>n :cnext<CR>
nnoremap <Leader>p :cprev<CR>

" Clear last search highlighting
map <Leader><Leader> :noh<cr>

" Show syntax element
map gs :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" }}} Key mappings

" Indent {{{

" Default indent settings for different filetypes.
augroup augroup_ident
    autocmd!
    autocmd Filetype go setlocal noexpandtab
augroup END


" }}} Indent

" Filemanager {{{

let g:lf_path = 'lf'

function! OpenLF(path)
    let l:path = expand(a:path)
    let l:tmpfile = tempname()
    let l:curfile = expand('%:p')
    let l:callback = {
    \ 'name': 'lf',
    \ 'tmpfile': l:tmpfile,
    \ 'curfile': l:curfile,
    \ 'curfile_existed': filereadable(l:curfile),
    \ 'curbufnr': bufnr('%'),
    \ }

    function! l:callback.on_exit(id, code, event)
        bdelete!

        if l:self.curfile_existed &&
        \ !filereadable(l:self.curfile)
            exec 'bdelete ' . l:self.curbufnr
        endif

        set hidden

        " Open selected files
        if filereadable(l:self.tmpfile)
            for l:fpath in readfile(l:self.tmpfile)
                exec 'edit '. l:fpath
            endfor
            call delete(l:self.tmpfile)
        endif
    endfunction

    write
    set nohidden
    enew

    let l:command = g:lf_path .
    \ ' -selection-path ' . shellescape(l:tmpfile) .
    \ ' ' . shellescape(l:path)

    call termopen(l:command, l:callback)
    startinsert
endfunction

" Start LF in current buffer directory (d - directory)
nnoremap <Leader>d :call OpenLF('%:p')<CR>

augroup augroup_terminal
    autocmd!
    autocmd TermOpen * setlocal nolist
augroup END

" }}} Filemanager
"
" Statusline {{{

hi StatusLine guifg=#DFDFE0 guibg=#2F3238 gui=none
hi StatusLinePercent guifg=#DFDFE0 guibg=#2F3238 gui=none
hi StatusLinePosition guifg=#DFDFE0 guibg=#7f8c98 gui=bold

set statusline=

" File path, modified, readonly, helpfile, preview
set statusline+=%#StatusLineFile#
set statusline+=\ %f\ %m\ %r\ %w

" Right side
set statusline+=%=

" Percent
set statusline+=%#StatusLinePercent#
set statusline+=\ %3p%%
set statusline+=\ 

" Line:Column
set statusline+=%#StatusLinePosition#
set statusline+=\ %l:%c
set statusline+=\ 


" }}} Statusline

" Plugin: Telescope {{{

" Find files using Telescope command-line sugar.
nnoremap <Leader>f <cmd>Telescope find_files<cr>

" }}} Plugin: Telescope

" Plugin: Sideways {{{

nnoremap gh :SidewaysLeft<CR>
nnoremap gl :SidewaysRight<CR>

" }}} Sideways
"
" Plugin: Compe {{{

let g:compe = {}

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true

" }}} Compe

" Plugin: UltiSnips {{{ "

let g:UltiSnipsExpandTrigger = '<Tab>'
let g:UltiSnipsJumpForwardTrigger = '<Tab>'
let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'

" }}} Plugin: UltiSnips "

" Lua {{{

lua << EOF
require('config')
EOF

" }}} Lua

