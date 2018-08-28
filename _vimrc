" Plugins ----------------------------------------- {{{
execute pathogen#infect()
" https://github.com/mileszs/ack.vim.git
" https://github.com/w0rp/ale.git
" https://github.com/tpope/vim-commentary.git
" https://github.com/tpope/vim-repeat.git
" https://github.com/vim-scripts/ScrollColors.git
" https://github.com/tpope/vim-surround.git
" https://github.com/tpope/vim-unimpaired.git
" https://github.com/tpope/vim-abolish.git
" https://github.com/tpope/vim-rsi.git
" https://github.com/tpope/vim-sensible.git
" https://github.com/terryma/vim-smooth-scroll.git
" https://github.com/nelstrom/vim-visual-star-search.git

set nocompatible
syntax on
filetype plugin indent on
runtime macros/matchit.vim

" https://github.com/junegunn/vim-plug
call plug#begin('~\vimfiles\plugged')              "        Name
Plug 'veloce/vim-aldmeris'                         " Aldmeris
Plug 'rafi/awesome-vim-colorschemes'               " Awesome Color Schemes
Plug 'ayu-theme/ayu-vim'                           " Ayu
Plug 'sjl/badwolf'                                 " Badwolf
Plug 'chriskempson/base16-vim'                     " Base 16
Plug 'Lokaltog/vim-distinguished'                  " Distinguished
Plug 'dracula/vim', { 'as': 'dracula' }            " Dracula
Plug 'morhetz/gruvbox'                             " Gruvbox
Plug 'kristijanhusak/vim-hybrid-material'          " Hybrid Material
Plug 'ciaranm/inkpot'                              " Inkpot
Plug 'nanotech/jellybeans.vim'                     " Jellybeans
Plug 'zeis/vim-kolor'                              " Kolor
Plug 'jonathanfilip/vim-lucius'                    " Lucius
Plug 'dikiaap/minimalist'                          " Minimalist
Plug 'tomasr/molokai'                              " Molokai
Plug 'sickill/vim-monokai'                         " Monokai
Plug 'arcticicestudio/nord-vim'                    " Nord
Plug 'mhartington/oceanic-next'                    " Oceanic
Plug 'rakr/vim-one'                                " One
Plug 'joshdick/onedark.vim'                        " Onedark
Plug 'sonph/onehalf'                               " Onehalf Light
Plug 'drewtempelmeyer/palenight.vim'               " Palenight
Plug 'NLKNguyen/papercolor-theme'                  " Papercolor
Plug 'jpo/vim-railscasts-theme'                    " Railscasts
Plug 'junegunn/seoul256.vim'                       " Seoul256
Plug 'hukl/Smyck-Color-Scheme'                     " Smyck
Plug 'altercation/vim-colors-solarized'            " Solarized
Plug 'jacoborus/tender.vim'                        " Tender
Plug 'gosukiwi/vim-atom-dark'                      " Vim-Atom-Dark
Plug 'tpope/vim-vividchalk'                        " Vividchalk
Plug 'jnurmine/Zenburn'                            " Zenburn
call plug#end()
" Plug 'flazz/vim-colorschemes'                      " A Lot of Colorschemes
" }}}
" Basic Settings ----------------------------------- {{{
set wrap
set history=200
set pythonthreedll=python37.dll
set hidden confirm
set hlsearch incsearch
set shiftwidth=4 softtabstop=4 expandtab
setlocal shiftwidth=2 softtabstop=2 expandtab
set splitbelow splitright
set foldlevelstart=0
let mapleader = " "
let maplocalleader = "-"
nnoremap j gj
nnoremap k gk

if has("gui_running")
  colorscheme hybrid_material
else
  colorscheme darkblue
endif

" highlight ColorColumn ctermbg=235 guibg=#2c2d27
if exists('&colorcolumn')
  execute "set colorcolumn=" . join(range(81,335), ',')
else
  match ColorColumn /\%>80v.\+/
endif
" }}}
" Statusline --------------------------------------- {{{
set statusline=%f         " Path to the file
set statusline+=%=        " Switch to the right side
set statusline+=%l        " Current line
set statusline+=/         " Separator
set statusline+=%L        " Total lines
" }}}
" Mappings ----------------------------------------- {{{
" To save, ctrl-s.
nnoremap <c-s> :w<CR>
inoremap <c-s> <Esc>:w<CR>i
nnoremap <leader>w :w<CR>
" inoremap jk <esc>
" inoremap <esc> <nop>
nnoremap <silent> <cr> :<C-u>nohlsearch<cr>
nnoremap <leader>ev :vertical botright split $MYVIMRC<cr>
nnoremap <leader>el :vertical botright split E:\wk\vimstuff\lvimtips.txt<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>hm :call SurroundWithHeadingAndMarkers(input("Heading? "))<cr>
nnoremap <leader>hc :let @*= '(>^.^<)'<cr>
nnoremap <leader>N :setlocal number!<cr>
" for adding colorschemes to Plug
nnoremap <leader>ff G/call plug#end()<cr>:let @a = "Plug '" . matchstr(@*, '\/\zs[^/]*\/[^/]*$') . "'"<cr>O<c-r>a<esc>:3,.:sort<cr>
nnoremap <leader>fsp G/call plug#begin<cr>jV/call plug#end<cr>k:sort /[^"]*" /<cr>
" function ComparePlugNames(p1, p2)
"   let pat =  "'\\zs[^']*\\ze'"
"   let p1 = split(matchstr(a:p1, pat), '/')[1]
"   let p2 = split(matchstr(a:p2, pat), '/')[1]
"   return strcmp(p1, p2)
" endfunction
" }}}
" Utility functions ---------------------------- {{{
function! SurroundWithHeadingAndMarkers(heading) range
  let first = a:firstline
  let last = a:lastline
  if last == first
    let first = search('^\s*$', 'bnW') + 1
    let last = search('^\s*$', 'nW') - 1
  endif
  call append(last, '" }'.'}}')
  let dashes = repeat('-', 49 - strlen(a:heading))
  call append(first - 1, '" ' . a:heading . ' ' . dashes . ' {'.'{{')
endfunction

function! SetRangeLines(n)
  let i = 0
  while (i < a:n)
    call setline(line(".") + i, string(i))
    let i += 1
  endwhile
endfunction
" }}}
" LVTHW mappings ----------------------------------- {{{
" nnoremap <leader>fc :call FoldColumnToggle()<cr>
" function! FoldColumnToggle()
"   " setlocal foldcolumn=(&foldcolumn?0:4)
"   if &foldcolumn
"     setlocal foldcolumn=0
"   else
"     setlocal foldcolumn=4
"   endif
" endfunction
" nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cWORD>")) . " ."<cr>:copen<cr>
" nnoremap <leader>d ddi<c-g>u<esc>dd
" nnoremap <leader>oa :execute "rightbelow vsplit " . bufname("#")<cr>
" nnoremap <leader>hh execute @*<cr>
" inorema <c-u> <esc>gUawi
" nnoremap <leader><c-u> gUaw
" vnoremap  <leader>" <esc>`<i"<esc>`>la"<esc> 
" onoremap in@ :<c-u>execute "normal! /[A-Za-z.]\\+@\\w\\+.[A-Za-z.]\\+\rgN"<cr>
" }}}
" Filetype autocomands ------------------------- {{{
autocmd FileType javascript nnoremap <buffer> <localleader>c I//<esc>
autocmd FileType python     nnoremap <buffer> <localleader>c I#<esc>

augroup Markdown
  autocmd!
  autocmd FileType markdown onoremap ih :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr>
  autocmd FileType markdown onoremap ah :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rg_vk0"<cr>
augroup END
" }}}
" Vimscript file settings ------------------------- {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}
" Plugin Ack.vim ---------------------------------- {{{
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
" }}}
