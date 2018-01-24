" Set nocmaptible mode
set nocompatible

set mouse=a
"set insertmode
"set hidden

" Searching
set ignorecase
set smartcase
set incsearch
set hlsearch

" Indentation
set autoindent
set smartindent
set expandtab
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" editing
set fenc=utf-8
set backspace=2

" other
" swap soubory ukladame do ~/.swp
set dir=~/.swp
set directory=~/.swp
set backupdir=~/.swp

" Filetype detection and syntax highlighting
filetype plugin indent on
syntax on

" Highlight current line
highlight cursorline cterm=none ctermbg=black gui=none guibg=grey30
highlight Comment ctermfg=green guifg=green
"autocmd InsertLeave * setlocal nocursorline
"autocmd InsertEnter * setlocal cursorline


" Set file encoding automagically (use enca)
function! GetEncoding(f)
    let e = system('enca -Pe -L none "' . a:f . '"')
    let e = substitute(e, '/.*', '', '')
    if e =~ 'unknown'
        return 'utf-8'
    endif
    return e
endfunc

" autocmd BufReadPre * exec "set fileencodings=" . GetEncoding(expand('<afile>'))
" autocmd FileReadPre * exec "set fencs=" . GetEncoding(expand('<afile>'))
autocmd BufReadPre * exec "set fileencodings=utf-8"
autocmd FileReadPre * exec "set fencs=utf-8"

" Tab completion
function! CleverTab(command)
    if strpart(getline('.'), 0, col('.')-1) =~ '^\s*$'
        if a:command == 'next'
            return "\<Tab>"
        elseif a:command == 'prev'
            return "\<BS>"
        endif
    else
        if a:command == 'next'
            return "\<C-N>"
        elseif a:command == 'prev'
            return "\<C-P>"
        endif
    endif
endfunction

inoremap <C-Space> <C-X><C-O>
inoremap <C-N>     <C-R>=CleverTab('next')<CR>
"inoremap <S-Tab>   <C-R>=CleverTab('prev')<CR>

" (Un)comment selection
function! ToggleComment(CommentLeader, CommentTrailer)
    let hls = @/
    if getline(".") =~ a:CommentLeader
        execute ":s/^\\(\\s*\\)" . a:CommentLeader . "/\\1/"
        execute ":s/" . a:CommentTrailer . "$//"
    else
        execute ":s/^\\(\\s*\\)/\\1" . a:CommentLeader . "/"
        execute ":s/$/" . a:CommentTrailer . "/"
    endif
    let @/ = hls
endfunction

vnoremap <C-D>     :call ToggleComment('### ', '')<CR>
autocmd FileType c          vnoremap <C-D> :call ToggleComment('\/\/ ', '')<CR>
autocmd FileType cpp        vnoremap <C-D> :call ToggleComment('\/\/ ', '')<CR>
autocmd FileType php        vnoremap <C-D> :call ToggleComment('\/\/ ', '')<CR>
autocmd FileType javascript vnoremap <C-D> :call ToggleComment('\/\/ ', '')<CR>
autocmd FileType python     vnoremap <C-D> :call ToggleComment('# ', '')<CR>
autocmd FileType sh         vnoremap <C-D> :call ToggleComment('# ', '')<CR>
autocmd FileType html       vnoremap <C-D> :call ToggleComment('<!-- ', ' -->')<CR>

" (Un)indent selection
function! Indenter(IndentChar)
    normal gv
    execute "normal " . a:IndentChar
    normal gv
endfunction

vnoremap <Tab>     :<C-u>call Indenter(">")<CR>
vnoremap <S-Tab>   :<C-u>call Indenter("<")<CR>


behave xterm

" Keybindings (like Windows, Nano, Konqueror, etc.)
"map <F5> :silent !/opt/local/bin/xterm -e /opt/local/bin/python -i % <CR>
inoremap <C-T>     <C-O>:tabnew
nnoremap <C-T>     :tabnew

"inoremap <C-Left>  <C-O>:tabprevious<CR>
"nnoremap <C-Left>  :tabprevious<CR>
"inoremap <C-Right> <C-O>:tabnext<CR>
"nnoremap <C-Right> :tabnext<CR>
"inoremap <C-Down>  <C-O>:tabclose<CR>
"nnoremap <C-Down>  :tabclose<CR>

inoremap <C-h>  <C-O>:tabprevious<CR>
nnoremap <C-h>  :tabprevious<CR>
inoremap <C-l>  <C-O>:tabnext<CR>
nnoremap <C-l>  :tabnext<CR>

inoremap <C-h>  <C-O>:tabprevious<CR>
nnoremap <C-h>  :tabprevious<CR>
inoremap <C-l>  <C-O>:tabnext<CR>
nnoremap <C-l>  :tabnext<CR>

"inoremap <C-S> <C-O>:w<CR>
"nnoremap <C-S> :w<CR>
"inoremap <C-Up>    <C-O><C-W>w
"nnoremap <C-Up>    <C-W>w
"inoremap <C-Down>  <C-O><C-W>W
"nnoremap <C-Down>  <C-W>W
vmap cc :s/^\(\s*\)/\1# /<CR>
vmap cv :s/^\(\s*\)# /\1/<CR>

" Basic UI settings
"colorscheme desert
set history=10000
set confirm
set ruler
set showcmd
set number
set wrapscan
set linebreak
set showbreak=+++
set wildmenu
set wildmode=full
set showmatch
set background=dark
set tabpagemax=50
set nojoinspaces

" syntax check
execute pathogen#infect()
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_style_error_symbol='P8'
let g:syntastic_style_warning_symbol='⚡'
let g:syntastic_python_checkers = ['flake8']
let g:flake8_ignore="E501,W293,E265,E126,E128"

autocmd FileType python map <buffer> <C-p> :call Flake8()<CR>

" automaticly delete whitespaces on the end of line
autocmd BufWritePre *.py :%s/\s\+$//e
" :nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
set t_Co=256
if &term=="xterm" || &term=="xterm-color"
     set t_Co=8
     set t_Sb=^[4%dm
     set t_Sf=^[3%dm
     :imap <Esc>Oq 1
     :imap <Esc>Or 2
     :imap <Esc>Os 3
     :imap <Esc>Ot 4
     :imap <Esc>Ou 5
     :imap <Esc>Ov 6
     :imap <Esc>Ow 7
     :imap <Esc>Ox 8
     :imap <Esc>Oy 9
     :imap <Esc>Op 0
     :imap <Esc>On .
     :imap <Esc>OQ /
     :imap <Esc>OR *
     :imap <Esc>Ol +
     :imap <Esc>OS -

     :vmap <Esc>Oq 1
     :vmap <Esc>Or 2
     :vmap <Esc>Os 3
     :vmap <Esc>Ot 4
     :vmap <Esc>Ou 5
     :vmap <Esc>Ov 6
     :vmap <Esc>Ow 7
     :vmap <Esc>Ox 8
     :vmap <Esc>Oy 9
     :vmap <Esc>Op 0
     :vmap <Esc>On .
     :vmap <Esc>OQ /
     :vmap <Esc>OR *
     :vmap <Esc>Ol +
     :vmap <Esc>OS -

     :cmap <Esc>Oq 1
     :cmap <Esc>Or 2
     :cmap <Esc>Os 3
     :cmap <Esc>Ot 4
     :cmap <Esc>Ou 5
     :cmap <Esc>Ov 6
     :cmap <Esc>Ow 7
     :cmap <Esc>Ox 8
     :cmap <Esc>Oy 9
     :cmap <Esc>Op 0
     :cmap <Esc>On .
     :cmap <Esc>OQ /
     :cmap <Esc>OR *
     :cmap <Esc>Ol +
     :cmap <Esc>OS -

     :nmap <Esc>Oq 1
     :nmap <Esc>Or 2
     :nmap <Esc>Os 3
     :nmap <Esc>Ot 4
     :nmap <Esc>Ou 5
     :nmap <Esc>Ov 6
     :nmap <Esc>Ow 7
     :nmap <Esc>Ox 8
     :nmap <Esc>Oy 9
     :nmap <Esc>Op 0
     :nmap <Esc>On .
     :nmap <Esc>OQ /
     :nmap <Esc>OR *
     :nmap <Esc>Ol +
     :nmap <Esc>OS -
endif

:nmap ! i <CR><Esc>
:command Vb normal <C-v>
:nmap Y y$
" unnamed register communicates with system clipboard
set clipboard=unnamed
set colorcolumn=120
