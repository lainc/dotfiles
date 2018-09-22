" Basic Settings ----------------------------------- {{{
if &compatible
    set nocompatible
endif
syntax on
" filetype plugin indent on
runtime macros/matchit.vim
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

if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

set undofile
if !has('nvim')
  set undodir=~/.vim/undo
endif
augroup vimrc
  autocmd!
  autocmd BufWritePre /tmp/* setlocal noundofile 
augroup END
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
nnoremap <C-p> :<C-u>FZF<CR>
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
" Plugins ------------------------------------------ {{{
function! PackInit() abort
  packadd minpac

  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})
  call minpac#add('mhinz/vim-grepper')
  " call minpac#add('weynhamz/vim-plugin-minibufexpl')
  " call minpac#add('janko-m/vim-test')
  " call minpac#add('sgur/vim-editorconfig')
  " call minpac#add('tpope/vim-dispatch')
  call minpac#add('junegunn/fzf')
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('tpope/vim-obsession')
  call minpac#add('tpope/vim-projectionist', {'type': 'opt'})
  call minpac#add('xolox/vim-colorscheme-switcher', {'type': 'opt'})
  call minpac#add('w0rp/ale')
  call minpac#add('tpope/vim-commentary')
  call minpac#add('tpope/vim-eunuch')
  call minpac#add('tpope/vim-repeat')
  call minpac#add('vim-scripts/ScrollColors')
  call minpac#add('tpope/vim-surround')
  call minpac#add('tpope/vim-unimpaired')
  call minpac#add('tpope/vim-abolish')
  call minpac#add('tpope/vim-rsi')
  call minpac#add('tpope/vim-sensible')
  call minpac#add('terryma/vim-smooth-scroll')
  call minpac#add('nelstrom/vim-visual-star-search')
  " COLORS
  call minpac#add('veloce/vim-aldmeris')                         " Aldmeris
  call minpac#add('rafi/awesome-vim-colorschemes')               " Awesome Color Schemes
  
  call minpac#add('ayu-theme/ayu-vim')                           " Ayu
  call minpac#add('sjl/badwolf')                                 " Badwolf
  call minpac#add('chriskempson/base16-vim')                     " Base 16
  call minpac#add('Lokaltog/vim-distinguished')                  " Distinguished
  call minpac#add('dracula/vim', {'name': 'dracula'})              " Dracula
  call minpac#add('morhetz/gruvbox')                             " Gruvbox
  call minpac#add('kristijanhusak/vim-hybrid-material')          " Hybrid Material
  call minpac#add('ciaranm/inkpot')                              " Inkpot
  call minpac#add('nanotech/jellybeans.vim')                     " Jellybeans
  call minpac#add('zeis/vim-kolor')                              " Kolor
  call minpac#add('jonathanfilip/vim-lucius')                    " Lucius
  call minpac#add('dikiaap/minimalist')                          " Minimalist
  call minpac#add('tomasr/molokai')                              " Molokai
  call minpac#add('sickill/vim-monokai')                         " Monokai
  call minpac#add('arcticicestudio/nord-vim')                    " Nord
  call minpac#add('mhartington/oceanic-next')                    " Oceanic
  call minpac#add('rakr/vim-one')                                " One
  call minpac#add('joshdick/onedark.vim')                        " Onedark
  call minpac#add('sonph/onehalf')                               " Onehalf Light
  call minpac#add('drewtempelmeyer/palenight.vim')               " Palenight
  call minpac#add('NLKNguyen/papercolor-theme')                  " Papercolor
  call minpac#add('jpo/vim-railscasts-theme')                    " Railscasts
  call minpac#add('junegunn/seoul256.vim')                       " Seoul256
  call minpac#add('hukl/Smyck-Color-Scheme')                     " Smyck
  call minpac#add('altercation/vim-colors-solarized')            " Solarized
  call minpac#add('jacoborus/tender.vim')                        " Tender
  call minpac#add('gosukiwi/vim-atom-dark')                      " Vim-Atom-Dark
  call minpac#add('tpope/vim-vividchalk')                        " Vividchalk
  call minpac#add('jnurmine/Zenburn')                            " Zenburn
  "'flazz/vim-colorschemes' " A Lot of Colorscheme
endfunction

" Plugin configs 
" Ale
let g:ale_linters = {
\   'javascript': ['eslint'],
\ }
nmap <silent> [W <Plug>(ale_first)
nmap <silent> [w <Plug>(ale_previous)
nmap <silent> ]w <Plug>(ale_next)
nmap <silent> ]W <Plug>(ale_last)
"Grepper
let g:grepper       = {}
let g:grepper.tools = ['grep', 'git', 'rg']
" Search for the current word
nnoremap <Leader>* :Grepper -cword -noprompt<CR>
" Search for the current selection
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)
nnoremap <Leader>g :Grepper -tool rg<CR>
nnoremap <Leader>G :Grepper -tool git<CR>

command! PackUpdate call PackInit() | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus call PackInit() | call minpac#status()
" }}}
