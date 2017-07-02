" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if &compatible
	set nocompatible               " Be iMproved
endif

set encoding=utf-8
scriptencoding utf-8

" 行番号表示
set number
" 256色に対応させる
set t_Co=256
" syntax
syntax on
" タブ、インデント系
"set expandtab	" タブの代わりにスペースを挿入
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
" バックスペースで各種消せるようにする
set backspace=indent,eol,start
" 対応括弧の表示時間を短くする
set matchtime=1
" インデントをshiftwidthの倍数に丸める
set shiftround
" 小文字の検索でも大文字も見つかるようにする
set ignorecase
" ただし大文字も含めた検索の場合はその通りに検索する
set smartcase
" インクリメンタルサーチを行う
set incsearch
" 検索結果をハイライト表示
set hlsearch
" 各種移動できるように
set whichwrap=b,s,[,],<,>
" 背景色に合わせて文字色を変える
set background=dark
" スワップ,バックアップ無効
set noswapfile
set nobackup
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" ステータスライン表示
set laststatus=2
" 入力中のコマンドをステータスに表示する
set showcmd
" ファイル名補完時に無視するファイルパターン
set wildignore=*.o,*.obj,*.bak,*.swp,*.d,*~
" クリップボードにコピー
set clipboard=unnamedplus
" スペース表示
set list  " 不可視文字を表示する
set listchars=tab:\>\ ,trail:_  " タブを >   行末半スペを _ で表示する
highlight SpecialKey cterm=NONE ctermfg=darkgray guifg=darkgray
" 長い行でも表示可能にする
set display=lastline
" 補完メニューの高さ
set pumheight=10
" vert newするときに、右側に新しい画面を作る
set splitright

" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermbg=red guibg=#666666
au BufWinEnter * let w:m3 = matchadd("ZenkakuSpace", '　')
au WinEnter * let w:m3 = matchadd("ZenkakuSpace", '　')

"----------------
"キーバインド

" TABにて対応ペアにジャンプ
nnoremap <Tab> %
vnoremap <Tab> %
" 見た目どおりに移動
noremap j gj
noremap k gk
" H,Lで行頭、行末へ移動
nnoremap <S-h> ^
vnoremap <S-h> ^
nnoremap <S-l> $
vnoremap <S-l> $
" タブ移動
nnoremap t gt
nnoremap T gT
" 自動インデント
noremap =G gg=G''
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>
" Y 行末までのヤンク
nnoremap Y y$
" インクリメント、デクリメント
nnoremap + <C-a>
nnoremap - <C-x>
" tagsジャンプの時に複数ある時は一覧表示
nnoremap <C-]> g<C-]>
" 直近のジャンプポイントへジャンプする
nnoremap go <C-o>


"----------------
" DiffOrig コマンドの定義
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
				\ | wincmd p | diffthis
endif


"----------------
" NeoBundle関係
if has('vim_starting')
	" neobundle をインストールしていない場合は自動インストール
	if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
		echo "install neobundle..."
		" vim からコマンド呼び出しているだけ neobundle.vim のクローン
		:call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
	endif
endif
set runtimepath+=~/.vim/bundle/neobundle.vim/
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

" インストールするプラグイン
NeoBundle 'Shougo/unite.vim'
NeoBundle 'itchyny/lightline.vim'   " ステータスライン
NeoBundleLazy 'Shougo/vimfiler', {
    \   'autoload' : { 'commands' : [ 'VimFiler' ] },
    \ }  " ファイラー
NeoBundle 'Shougo/vimproc.vim', {
    \ 'build' : {
    \     'windows' : 'tools\\update-dll-mingw',
    \     'cygwin' : 'make -f make_cygwin.mak',
    \     'mac' : 'make',
    \     'linux' : 'make',
    \     'unix' : 'gmake',
    \    },
    \ }
NeoBundle 'Shougo/vimshell'  " シェル
NeoBundle 'Shougo/neocomplete.vim'  " コード補完
"NeoBundle 'szw/vim-tags'    " メソッド定義元へのジャンプ
" Git関連
NeoBundle 'tpope/vim-fugitive'  " gitの操作
NeoBundle 'airblade/vim-gitgutter'  " gitの変更行表示
"NeoBundle 'cohama/agit.vim'     " git logの表示
" コメントアウトのトグル
NeoBundle "tyru/caw.vim.git"  " 一発コメントアウト

call neobundle#end()

" ファイルタイプ別のプラグイン/インデントを有効にする
filetype plugin indent on

" unite.vim
nnoremap    [unite]   <Nop>
nmap    <Space> [unite]

nnoremap <silent> [unite]f :<C-u>VimFiler<CR>
nnoremap <silent> [unite]t :<C-u>Unite<Space>tab<CR>
nnoremap <silent> [unite]/ :<C-u>Unite<Space>grep<CR>
nnoremap <silent> [unite]b :<C-u>Unite<Space>buffer<CR>
nnoremap <silent> [unite]z :<C-u>Unite<Space>bookmark<CR>
nnoremap <silent> [unite]a :<C-u>UniteBookmarkAdd<CR>
nnoremap <silent> [unite]n :<C-u>tabnew<CR>:VimFiler<CR>
nnoremap <silent> [unite]s :<C-u>tabnew<CR>:VimShell<CR>
nnoremap <silent> [unite]gl :<C-u>Agit<CR>
nnoremap <silent> [unite]gs :<C-u>Gstatus<CR>
nnoremap <silent> [unite]gd :<C-u>Gdiff<CR>
nnoremap <silent> [unite]gb :<C-u>Gblame<CR>
nnoremap <silent> [unite]j :<C-u>tab stj <C-R>=expand('<cword>')<CR><CR>
nnoremap <silent> [unite]df :DiffOrig<CR>
nnoremap <silent> [unite]do <C-w><C-w>:q<CR>:diffoff<CR>



" lightline.vim
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"RO":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ }
let g:lightline.tab_component_function = {}
let g:lightline.tab_component_function.prefix = 'TalPrefix'
function! TalPrefix(n)
	return lightline#tab#tabnum(a:n) " . TalTabwins(a:n)
endfunction
function! TalTabwins(n)
	return repeat(',', len(tabpagebuflist(a:n)))
endfunction
let g:lightline.tab_component_function.filename = 'TalFilename'
function! TalFilename(n)
	return substitute(lightline#tab#filename(a:n), '.\{16}\zs.\{-}\(\.\w\+\)\?$', '~\1', '')
endfunction
let g:lightline.tabline = {'right': [['rows'], ['cd'], ['tabopts'], ['fugitive']]}
let g:lightline.tab = {'active': ['prefix', 'filename', 'modified']}
let g:lightline.tab.inactive = g:lightline.tab.active


" neocomplete.vim
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1


" caw.vim
nmap gc <Plug>(caw:hatpos:toggle)
vmap gc <Plug>(caw:hatpos:toggle)


" 未インストールのプラグインがないかチェックしてくれる
NeoBundleCheck

