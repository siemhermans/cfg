call plug#begin()

" Standard plugins

"------------------
" Code Completions
"------------------
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'Raimondi/delimitMate'
" Plug 'ervandew/supertab'
" snippets
" Plug 'garbas/vim-snipmate'
" Plug 'honza/vim-snippets'
"------ snipmate dependencies -------
" Plug 'MarcWeber/vim-addon-mw-utils'
" Plug 'tomtom/tlib_vim'

"-----------------
" Fast navigation
"-----------------
" Plug 'Lokaltog/vim-easymotion'

"--------------
" Fast editing
"--------------
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'
"" Plug 'scrooloose/nerdcommenter'
Plug 'mbbill/undotree'
"" Plug 'godlygeek/tabular'
"" Plug 'nathanaelkane/vim-indent-guides'
"
""--------------
"" IDE features
""--------------
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'jistr/vim-nerdtree-tabs'
""" Plug 'humiaozuzu/TabBar'
Plug 'majutsushi/tagbar'
""" Plug 'mileszs/ack.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/syntastic'
Plug 'nvie/vim-flake8'
"" Plug 'bronson/vim-trailing-whitespace'
"" Plug 'mkitt/tabline.vim'
"" Plug 'airblade/vim-gitgutter'
"
""-------------
"" Other Utils
""-------------
Plug 'tpope/vim-sensible'
" Plug 'humiaozuzu/fcitx-status'
" Plug 'nvie/vim-togglemouse'
" Plug 'christoomey/vim-tmux-navigator'

"--------------
" Color Schemes
"--------------
"Plug 'rickharris/vim-blackboard'
"Plug 'altercation/vim-colors-solarized'
Plug 'dracula/vim'

" Plugin outside ~/.config/nvim/plugged with post-update hook
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

call plug#end()

" encoding dectection
set encoding=utf-8 
set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1

"enable Powerline fonts
let g:airline_powerline_fonts = 1

" Use deoplete.
let g:deoplete#enable_at_startup = 1

" enable filetype dectection and ft specific plugin/indent
filetype plugin indent on

" enable syntax hightlight and completion
let python_highlight_all=1
syntax on

"--------
" Vim UI
"--------
" color scheme
set background=dark
color dracula

" create a soft colorcolumn
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 80)

" highlight current line
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn

" search
set incsearch
"set highlight 	" conflict with highlight current line
set ignorecase
set smartcase

" editor settings
set history=1000
set nocompatible
set nofoldenable                                                  " disable folding"
set confirm                                                       " prompt when existing from an unsaved file
set backspace=indent,eol,start                                    " More powerful backspacing
set t_Co=256                                                      " Explicitly tell vim that the terminal has 256 colors "
set mouse=a                                                       " use mouse in all modes
set report=0                                                      " always report number of lines changed                "
set nowrap                                                        " dont wrap lines
set scrolloff=5                                                   " 5 lines above/below cursor when scrolling
set number                                                        " show line numbers
set showmatch                                                     " show matching bracket (briefly jump)
set showcmd                                                       " show typed command in status bar
set title                                                         " show file in titlebar
set laststatus=2                                                  " use 2 lines for the status bar
set matchtime=2                                                   " show matching bracket for 0.2 seconds
set matchpairs+=<:>                                               " specially for html
set timeoutlen=0                                                  " reduce timeout when switching modes"
set shell=/bin/zsh                                                " set backend shell
set noswapfile                                                    " disable swap file creation
set clipboard=unnamedplus                                         " share the system clipboard with vim
filetype off
filetype plugin indent on
" set relativenumber

" Default Indentation
set autoindent
set smartindent     " indent when
set tabstop=4       " tab width
set softtabstop=4   " backspace
set shiftwidth=4    " indent width
" set textwidth=79
" set smarttab
set expandtab       " expand tab to space

autocmd FileType php setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
autocmd FileType ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120
autocmd FileType coffee,javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120
autocmd FileType html,htmldjango,xhtml,haml setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=0
autocmd FileType sass,scss,css setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120

"-----------------
" Plugin settings
"-----------------

" MultipleCursors
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-m>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" DelimitMate
let delimitMate_excluded_ft = "mail,csv"
let delimitMate_excluded_regions = "Comment"
let delimitMate_nesting_quotes = ['"','`']
au FileType python let b:delimitMate_nesting_quotes = ['"']

"" tabbar
"let g:Tb_MaxSize = 2
"let g:Tb_TabWrap = 1
"
"hi Tb_Normal guifg=white ctermfg=white
"hi Tb_Changed guifg=green ctermfg=green
"hi Tb_VisibleNormal ctermbg=252 ctermfg=235
"hi Tb_VisibleChanged guifg=green ctermbg=252 ctermfg=white
"
"" easy-motion
"let g:EasyMotion_leader_key = '<Leader>'

" Tagbar
let g:tagbar_left=0
let g:tagbar_width=32
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0
let g:tagbar_compact = 1

" NERD Tree
let NERDTreeWinSize=32
let NERDTreeChDirMode=2
let NERDTreeMinimalUI=1
let NERDTreeIgnore=['\~$', '\.pyc$', '\.swp$']
" let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\~$']
let NERDTreeShowBookmarks=1
let NERDTreeWinPos = "left"

" NERDCommenter
"let NERDSpaceDelims=1
"" nmap <D-/> :NERDComToggleComment<cr>
"let NERDCompactSexyComs=1

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_section_b = '%{strftime("%c")}'
let g:airline_section_y = 'BN: %{bufnr("%")}'

" Vim-Flake8
let g:flake8_quickfix_height=10
let g:flake8_show_quickfix=0
let g:flake8_show_in_gutter=1
" Automatically call Flake8 when writing a .py file
autocmd BufWritePost *.py call Flake8()

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['pylint', 'flake8']

" UndoTree
let g:undotree_WindowLayout = 3
let g:undotree_SplitWidth = 32
let g:undotree_DiffpanelHeight = 10

" SuperTab
" let g:SuperTabDefultCompletionType='context'
" let g:SuperTabDefaultCompletionType = '<C-X><C-U>'
" let g:SuperTabRetainCompletionType=2

" ctrlp
set wildignore+=*/tmp/*,*.so,*.o,*.a,*.obj,*.swp,*.zip,*.pyc,*.pyo,*.class,.DS_Store  " MacOSX/Linux
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'

" IndentLine
"let g:indent_guides_auto_colors = 1
"let g:indent_guides_start_level = 2
"let g:indent_guides_guide_size = 1

" Keybindings for plugin toggle
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
nnoremap <F3 :IndentGuidesToggle<CR>
nnoremap <F4> :GundoToggle<CR>
nnoremap <F5> :NERDTreeToggle<CR>
nnoremap <F6> :TagbarToggle<CR>
" <F7> reserved for Flake8 checking
nnoremap <F8> :UndotreeToggle<CR>
nnoremap <leader>a :Ack
nnoremap <leader>v V`]

"------------------
" Useful Functions
"------------------
" Set default split direction
set splitbelow
set splitright

" Split navigation 
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Enable writing to write protected file
cmap w!! w !sudo tee > /dev/null %

"" Quickly edit/reload the vimrc file
"nmap <silent> <leader>ev :e $MYVIMRC<CR>
"nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Fix common typos when saving
nnoremap ; :
:command W w
:command WQ wq
:command Wq wq
:command Q q
:command Qa qa
:command QA qa

" Mode is show in airline
set noshowmode
set noruler

"EOF
