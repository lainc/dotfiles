"Basic Settings ----------------------------------- {{{
if &compatible
    set nocompatible
endif
set exrc
set secure
syntax on
" filetype plugin indent on
runtime macros/matchit.vim
set wrap
set history=200
set pythonthreedll=python37.dll
set hidden confirm
set incsearch
if !&hlsearch
  set hlsearch
endif
" set sw=4 ts=4 sts=4 noet
set shiftwidth=4 softtabstop=4 expandtab
setlocal shiftwidth=2 softtabstop=2 expandtab
set splitbelow splitright
set foldlevelstart=0
let mapleader = " "
let maplocalleader = "\\"
nnoremap j gj
nnoremap k gk

set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "scrollbar

"if (has("nvim"))
"  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
"  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
"endif
""For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
""Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
"" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif
set background=dark
set t_Co=256
set cursorline

if has("gui_running")
  colorscheme hybrid_material
else
  colorscheme onedark
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
nnoremap <C-s> :w<CR>
inoremap <C-s> <esc>:w<CR>i
nnoremap <silent> <leader>w :<C-u>w<CR>
nnoremap Y y$
" inoremap jk <esc>
" inoremap <esc> <nop>
nnoremap <silent> <CR> :<C-u>nohlsearch<CR>
nnoremap <leader>ev :vertical botright split $MYVIMRC<CR>
nnoremap <leader>el :vertical botright split E:\wk\vimstuff\lvimtips.txt<CR>
nnoremap <leader>sv :<C-u>source $MYVIMRC<CR>
nnoremap <F5> :<C-u>call CompileAndExecute()<CR>
nnoremap <F9> :SCCompile<cr>
nnoremap <F10> :SCCompileRun<cr>
nnoremap <leader>hm :call SurroundWithHeadingAndMarkers(input("Heading? "))<CR>
nnoremap <leader>hc :let @*= '(>^.^<)'<CR>
nnoremap <leader>N :setlocal number!<CR>
nnoremap <C-p> :<C-u>FZF<CR>
" 1 less key for window navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <leader>bd <Plug>Kwbd
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

function! Preserve(command)
  " Preparation: save window state
  let l:saved_winview = winsaveview()
  " Run the command:
  execute a:command
  " Clean up: restore previous window position
  call winrestview(l:saved_winview)
endfunction

function! CompileAndExecute()
  echo @%
  let fdir = expand("%:p:h")
  let fname = expand("%:t")
  let tname = expand("%:t:r") . ".exe"
  let bufs = term_list()
  let buf = empty(bufs) ? term_start("cmd", {"term_rows":10}) : bufs[0]
  call term_sendkeys(buf, "cd " . fdir . "\<CR>")
  let sendexpr = "gcc " . fname . " -o " . tname .
        \ " -Wall -Wextra 2>errors.err && " .
        \ tname . "\<CR>"
  call term_sendkeys(buf, sendexpr)
  execute bufwinnr(buf) 'wincmd w'
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
" autocmd filetype lisp,scheme,art setlocal equalprg=scmindent.rkt

augroup Markdown
  autocmd!
  autocmd FileType markdown onoremap ih :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr>
  autocmd FileType markdown onoremap ah :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rg_vk0"<cr>
augroup END

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
  call minpac#add('marijnh/tern_for_vim')
  call minpac#add('vim-scripts/paredit.vim')
  call minpac#add('jpalardy/vim-slime')
  call minpac#add('wlangstroth/vim-racket')
  call minpac#add('xuhdev/SingleCompile')
  call minpac#add('gokcehan/vim-opex') " Opex is a simple plugin that defines two custom operators to execute text objects
  " call minpac#add('sjl/tslime.vim')
  " call minpac#add('christoomey/vim-tmux-navigator')
  " call minpac#add('kana/vim-fakeclip') "clipboard on WSL
  call minpac#add('amdt/vim-niji') "Rainbow parethesis
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
  call minpac#add('sheerun/vim-polyglot')
  call minpac#add('terryma/vim-smooth-scroll')
  call minpac#add('nelstrom/vim-visual-star-search')
  call minpac#add('haya14busa/incsearch.vim')
  call minpac#add('sunaku/vim-shortcut')
  " COLORS
  call minpac#add('veloce/vim-aldmeris')                         " Aldmeris
  call minpac#add('Badacadabra/vim-archery')                     " Archery
  call minpac#add('rafi/awesome-vim-colorschemes')               " Awesome Color Schemes
  call minpac#add('ayu-theme/ayu-vim')                           " Ayu
  call minpac#add('sjl/badwolf')                                 " Badwolf
  call minpac#add('atelierbram/Base2Tone-vim')                   " Base 2 Tone
  call minpac#add('chriskempson/base16-vim')                     " Base 16
  call minpac#add('metalelf0/base16-black-metal-scheme')         " Base 16 black metal vased
  call minpac#add('xero/blaquemagick.vim')                       " Blaquemagick
  call minpac#add('hauleth/blame.vim')                           " Blame
  call minpac#add('Lokaltog/vim-distinguished')                  " Distinguished
  call minpac#add('dracula/vim', {'name': 'dracula'})            " Dracula
  call minpac#add('clinstid/eink.vim')                           " Eink
  call minpac#add('morhetz/gruvbox')                             " Gruvbox
  call minpac#add('noahfrederick/vim-hemisu')                    " Hemisu
  call minpac#add('kristijanhusak/vim-hybrid-material')          " Hybrid Material
  call minpac#add('ciaranm/inkpot')                              " Inkpot
  call minpac#add('nanotech/jellybeans.vim')                     " Jellybeans
  call minpac#add('zeis/vim-kolor')                              " Kolor
  call minpac#add('jonathanfilip/vim-lucius')                    " Lucius
  call minpac#add('dikiaap/minimalist')                          " Minimalist
  call minpac#add('tomasr/molokai')                              " Molokai
  call minpac#add('fxn/vim-monochrome')                          " Monochrome
  call minpac#add('sickill/vim-monokai')                         " Monokai
  call minpac#add('robertmeta/nofrils')                          " No frills
  call minpac#add('arcticicestudio/nord-vim')                    " Nord
  call minpac#add('mhartington/oceanic-next')                    " Oceanic
  call minpac#add('rakr/vim-one')                                " One
  call minpac#add('joshdick/onedark.vim')                        " Onedark
  " call minpac#add('sonph/onehalf')                               " Onehalf Light
  call minpac#add('drewtempelmeyer/palenight.vim')               " Palenight
  call minpac#add('NLKNguyen/papercolor-theme')                  " Papercolor
  call minpac#add('owickstrom/vim-colors-paramount')             " Paramount
  call minpac#add('jpo/vim-railscasts-theme')                    " Railscasts
  call minpac#add('junegunn/seoul256.vim')                       " Seoul256
  call minpac#add('hukl/Smyck-Color-Scheme')                     " Smyck
  call minpac#add('altercation/vim-colors-solarized')            " Solarized
  call minpac#add('jacoborus/tender.vim')                        " Tender
  call minpac#add('gosukiwi/vim-atom-dark')                      " Vim-Atom-Dark
  call minpac#add('tpope/vim-vividchalk')                        " Vividchalk
  call minpac#add('zaki/zazen')                                  " Zazen
  call minpac#add('jnurmine/Zenburn')                            " Zenburn
  "'flazz/vim-colorschemes' " A Lot of Colorscheme
endfunction
" }}}
" Shortcuts ---------------------------------------- {{{
"-----------------------------------------------------------------------------
" NEXT AND PREVIOUS                               *unimpaired-next*
"-----------------------------------------------------------------------------

Shortcut! [a       (unimpaired) go to previous argument
Shortcut! ]a       (unimpaired) go to next     argument
Shortcut! [A       (unimpaired) go to first    argument
Shortcut! ]A       (unimpaired) go to last     argument
Shortcut! [b       (unimpaired) go to previous buffer
Shortcut! ]b       (unimpaired) go to next     buffer
Shortcut! [B       (unimpaired) go to first    buffer
Shortcut! ]B       (unimpaired) go to last     buffer
Shortcut! [l       (unimpaired) go to previous location
Shortcut! ]l       (unimpaired) go to next     location
Shortcut! [L       (unimpaired) go to first    location
Shortcut! ]L       (unimpaired) go to last     location
Shortcut! [<C-L>   (unimpaired) go to previous file with locations
Shortcut! ]<C-L>   (unimpaired) go to next     file with locations
Shortcut! [q       (unimpaired) go to previous quickfix
Shortcut! ]q       (unimpaired) go to next     quickfix
Shortcut! [Q       (unimpaired) go to first    quickfix
Shortcut! ]Q       (unimpaired) go to last     quickfix
Shortcut! [<C-Q>   (unimpaired) go to previous file with quickfixes
Shortcut! ]<C-Q>   (unimpaired) go to next     file with quickfixes
Shortcut! [t       (unimpaired) go to previous ctag
Shortcut! ]t       (unimpaired) go to next     ctag
Shortcut! [T       (unimpaired) go to first    ctag
Shortcut! ]T       (unimpaired) go to last     ctag

Shortcut! [f       (unimpaired) go to previous file in current file's directory
Shortcut! ]f       (unimpaired) go to next     file in current file's directory

Shortcut! [n       (unimpaired) go to previous conflict marker or diff/patch hunk
Shortcut! ]n       (unimpaired) go to next     conflict marker or diff/patch hunk

"-----------------------------------------------------------------------------
" LINE OPERATIONS                                 *unimpaired-lines*
"-----------------------------------------------------------------------------

Shortcut! [<Space> (unimpaired) Add [count] blank lines above the cursor.
Shortcut! ]<Space> (unimpaired) Add [count] blank lines below the cursor.

Shortcut! [e       (unimpaired) Exchange current line with [count] lines above it.
Shortcut! ]e       (unimpaired) Exchange current line with [count] lines below it.

"-----------------------------------------------------------------------------
" OPTION TOGGLING                                 *unimpaired-toggling*
"-----------------------------------------------------------------------------

function! s:describe_option_shortcuts(key, description) abort
  execute 'Shortcut! [o'. a:key .' (unimpaired) enable '.  a:description
  execute 'Shortcut! ]o'. a:key .' (unimpaired) disable '. a:description
  execute 'Shortcut! co'. a:key .' (unimpaired) toggle '.  a:description
endfunction

call s:describe_option_shortcuts('b', "assuming light background")
call s:describe_option_shortcuts('c', "highlighting cursor's line")
call s:describe_option_shortcuts('d', "diffing with current buffer")
call s:describe_option_shortcuts('h', "highlighting search results")
call s:describe_option_shortcuts('i', "ignoring case sensitivity")
call s:describe_option_shortcuts('l', "listing nonprintable characters")
call s:describe_option_shortcuts('n', "absolute line numbering")
call s:describe_option_shortcuts('r', "relative line numbering")
call s:describe_option_shortcuts('s', "checking for misspelled words")
call s:describe_option_shortcuts('u', "highlighting cursor's column")
call s:describe_option_shortcuts('v', "constraining cursor to line")
call s:describe_option_shortcuts('w', "wrapping very long lines")
call s:describe_option_shortcuts('x', "highlighting cursor's position")

"-----------------------------------------------------------------------------
" PASTING                                         *unimpaired-pasting*
"-----------------------------------------------------------------------------

Shortcut! >p       (unimpaired) Paste after  cursor, linewise, increasing indent.
Shortcut! >P       (unimpaired) Paste before cursor, linewise, increasing indent.
Shortcut! <p       (unimpaired) Paste after  cursor, linewise, decreasing indent.
Shortcut! <P       (unimpaired) Paste before cursor, linewise, decreasing indent.
Shortcut! =p       (unimpaired) Paste after  cursor, linewise, reindenting.
Shortcut! =P       (unimpaired) Paste before cursor, linewise, reindenting.

Shortcut! [p       (unimpaired) Paste after  cursor, linewise.
Shortcut! ]p       (unimpaired) Paste before cursor, linewise.

Shortcut! yo       (unimpaired) Paste after  cursor, linewise, using set 'paste'.
Shortcut! yO       (unimpaired) Paste before cursor, linewise, using set 'paste'.

"-----------------------------------------------------------------------------
" ENCODING AND DECODING                           *unimpaired-encoding*
"-----------------------------------------------------------------------------

Shortcut! [x       (unimpaired) XML escape.
Shortcut! ]x       (unimpaired) XML unescape.
Shortcut! [xx      (unimpaired) XML escape current line.
Shortcut! ]xx      (unimpaired) XML unescape current line.

Shortcut! [u       (unimpaired) URL escape.
Shortcut! ]u       (unimpaired) URL unescape.
Shortcut! [uu      (unimpaired) URL escape current line.
Shortcut! ]uu      (unimpaired) URL unescape current line.

Shortcut! [y       (unimpaired) String escape.
Shortcut! ]y       (unimpaired) String unescape.
Shortcut! [yy      (unimpaired) String escape current line.
Shortcut! ]yy (unimpaired) String unescape current line.
" }}}
" Plugin configs ----------------------------------- {{{
" Ale
let g:ale_linters = {
\   'javascript': ['eslint'],
\ }
nmap <silent> [W <Plug>(ale_first)
nmap <silent> [w <Plug>(ale_previous)
nmap <silent> ]w <Plug>(ale_next)
nmap <silent> ]W <Plug>(ale_last)
" incsearch
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
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
" vim-niji
" let g:niji_dark_colours = [
"     \ [ '81', '#5fd7ff'],
"     \ [ '99', '#875fff'],
"     \ [ '1',  '#dc322f'],
"     \ [ '76', '#5fd700'],
"     \ [ '3',  '#b58900'],
"     \ [ '2',  '#859900'],
"     \ [ '6',  '#2aa198'],
"     \ [ '4',  '#268bd2'],
"     \ ]
" Tslime
" let g:tslime_ensure_trailing_newlines = 1
" let g:tslime_normal_mapping = '<localleader>t'
" let g:tslime_visual_mapping = '<localleader>t'
" let g:tslime_vars_mapping = '<localleader>T'
" paredit
let g:paredit_electric_return = 0
" Slime
let g:slime_target = "vimterminal"
let g:slime_no_mappings = 1
xmap <localleader>r <Plug>SlimeRegionSend
nmap <localleader>r <Plug>SlimeParagraphSend
" nmap <leader>ss <Plug>SlimeLineSend
" Vim-shortcut
Shortcut show shortcut menu and run chosen shortcut
      \ noremap <silent> <Leader><Leader> :Shortcuts<Return>

Shortcut fallback to shortcut menu on partial entry
      \ noremap <silent> <Leader> :Shortcuts<Return>


command! PackUpdate call PackInit() | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus call PackInit() | call minpac#status()
" }}}
