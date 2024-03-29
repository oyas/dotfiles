"
" deoplete is required python3 and `pip3 install neovim`
"
"

" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if !&compatible
	set nocompatible
endif

" dein settings {{{
" dein自体の自動インストール
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
	echo "installing dein.vim"
	call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
" プラグイン読み込み＆キャッシュ作成
let s:toml_file = (empty($XDG_CONFIG_HOME) ? expand('~/.config') : $XDG_CONFIG_HOME).'/nvim/dein.toml'
if dein#load_state(s:dein_dir)
	call dein#begin(s:dein_dir)
	call dein#load_toml(s:toml_file)

	" for nvim plugin
	if !has('nvim')
		" check if neovim is installed
		echo system('python3 -c "import neovim" 2>&1')
		call dein#add('roxma/nvim-yarp')
		call dein#add('roxma/vim-hug-neovim-rpc')  " required `pip install neovim`
	endif

	call dein#end()
	call dein#save_state()
endif
" 不足プラグインの自動インストール
if has('vim_starting') && dein#check_install()
	call dein#install()
endif
" }}}


"
" プラグイン以外の設定
"

" ファイルタイプ別のプラグイン/インデントを有効にする
filetype plugin indent on

" 行番号
set number
" タブ、インデント系
set expandtab	" タブの代わりにスペースを挿入
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
" スワップ,バックアップ無効
set noswapfile
set nobackup
" 入力中のコマンドをステータスに表示する
set showcmd
" インクリメンタルサーチを行う
set incsearch
" 大文字小文字を無視して検索(大文字を含む場合は普通の検索)
set smartcase
" 検索結果をハイライト表示
set hlsearch
" vert newするときに、右側に新しい画面を作る
set splitright
" tagsジャンプの時に複数ある時は一覧表示
nnoremap <C-]> g<C-]>
" backspace でいろいろ消す
set backspace=indent,eol,start


"
" ハイライト
"
" シンタックスハイライト
syntax on
" 背景色に合わせて文字色を変える
set background=dark

" コメントを暗く
highlight Comment ctermfg=darkcyan

" カーソル行ハイライト
set cursorline
highlight clear CursorLine
" 行番号
highlight CursorLineNr term=bold   cterm=NONE ctermfg=111 ctermbg=NONE
highlight LineNr ctermfg=darkgray

" スペース表示
set list  " 不可視文字を表示する
set listchars=tab:\>\ ,trail:_,extends:»,precedes:«,nbsp:%  " タブを >   行末半角スペースを _ で表示する
highlight SpecialKey cterm=NONE ctermfg=darkgray guifg=darkgray

" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermbg=red guibg=#666666
au BufWinEnter * let w:m3 = matchadd("ZenkakuSpace", '　')
au WinEnter * let w:m3 = matchadd("ZenkakuSpace", '　')


"
" Key map
"
" TABにて対応ペアにジャンプ
nnoremap <Tab> %
vnoremap <Tab> %
" 見た目どおりに移動
noremap j gj
noremap k gk
" 行頭、行末へ移動
nnoremap <C-a> ^
vnoremap <C-a> ^
nnoremap <C-e> $
vnoremap <C-e> $
" タブ移動
nnoremap t gt
nnoremap T gT
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" caw.vim
nmap gc <Plug>(caw:hatpos:toggle)
vmap gc <Plug>(caw:hatpos:toggle)
vmap / <Plug>(caw:hatpos:toggle)

" <Leader>を変更
let mapleader = "\<Space>"
"nnoremap <silent> <Leader>i :<C-u>Denite<Space>file_rec<CR>
nnoremap <silent> <Leader>f :<C-u>Vaffle<CR>
nnoremap <silent> <Leader>/ :<C-u>Denite<Space>grep -mode=normal<CR>
nnoremap <silent> <Leader>b :<C-u>Denite<Space>buffer<CR>
nnoremap <silent> <Leader>n :<C-u>tabnew<CR>:<C-u>Vaffle<CR>
nnoremap <silent> <Leader>p :<C-u>Denite<Space>-mode=normal<Space>neoyank<CR>
"nnoremap <silent> <Leader>j :<C-u>tab stj <C-R>=expand('<cword>')<CR><CR>
"nnoremap <silent> <Leader>t :<C-u>TagbarToggle<CR>
nnoremap <silent> <Leader>df :DiffOrig<CR>
nnoremap <silent> <Leader>do <C-w><C-w>:q<CR>:diffoff<CR>
"nnoremap <silent> <Leader>s :call<Space>NewTerminal()<CR>
nnoremap <silent> <Leader>s :tabnew<CR>:terminal ++curwin<CR>


"
" Custom commands
"

" DiffOrig コマンド
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
				\ | wincmd p | diffthis
endif

" Terminal emulator
""set termkey=<C-L>  " terminal keymap
"function! NewTerminal()
"	tabnew
"	1sp		" 高さ1のバッファを作成
"	file [term]   " バッファの名前
"	call setline(1, " [Terminal] <C-w><C-w> to escape terminal. i or a enter terminal.")
"	setlocal nonumber
"	setlocal buftype=nowrite	" 保存しなくて良い設定
"	map <buffer> i <C-w><C-w>
"	map <buffer> a <C-w><C-w>
"	map <buffer> o <C-w><C-w> map <buffer> p <C-w><C-w><C-l>:call feedkeys( getreg('"') )<CR>
"	map <buffer> j <C-w><C-w><C-l>Nj
"	map <buffer> k <C-w><C-w><C-l>Nk
"	map <buffer> h <C-w><C-w><C-l>Nh
"	map <buffer> l <C-w><C-w><C-l>Nl
"	wincmd w	" ウィンドウ移動
"	"terminal ++close ++curwin	" Terminalを起動
"	terminal ++close ++curwin env TERM=xterm-256color bash
"	"setlocal nonumber
"	nnoremap <buffer> <Esc> i<C-l><C-w>
"	autocmd BufDelete <buffer> wincmd w | q		" Terminalバッファを閉じるときもうひとつのバッファも終了する
"endfunction

" auto ctags
" https://tanshio.net/use-ctags-for-vim
"function! GitCtags()
"	if exists('b:git_dir')
"		let ctags_script_path = b:git_dir.'/hooks/ctags'
"		" write .git/hooks/ctags
"		if empty(glob(ctags_script_path))
"			echo 'write .git/hooks/ctags'
"			call system('mkdir -p '.b:git_dir.'/hooks/')
"			execute 'redir > ' . ctags_script_path
"				silent echo '#!/bin/bash'
"				silent echo 'set -e'
"				silent echo 'PATH="$HOME/local/bin:$HOME/.local/bin:/usr/local/bin:$PATH"'
"				silent echo 'cd "$(dirname "${BASH_SOURCE:-$0}")"; cd ../../'
"				silent echo 'trap "rm -f .git/tags.$$" EXIT'
"				silent echo 'ctags --tag-relative=yes -R -f .git/tags.$$ --exclude=.git'
"				silent echo 'mv .git/tags.$$ .git/tags'
"			redir END
"		endif
"		" execute .git/hooks/ctags
"		"echo '"bash '.ctags_script_path.'" &'
"		call system('bash '.ctags_script_path.' &')
"	endif
"endfunction
"augroup vimrc
"	" 保存時に自動でctags実行
"	autocmd! BufWritePost * call GitCtags()
"augroup END


"
" coc default settings
"
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
" inoremap <silent><expr> <TAB>
"			\ pumvisible() ? "\<C-n>" :
"			\ <SID>check_back_space() ? "\<TAB>" :
"			\ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:check_back_space() abort
" 	let col = col('.') - 1
" 	return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" Use <c-space> to trigger completion.
" inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
" nmap <silent> [c <Plug>(coc-diagnostic-prev)
" nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
" nnoremap <silent> K :call <SID>show_documentation()<CR>
"
" function! s:show_documentation()
" 	if (index(['vim','help'], &filetype) >= 0)
" 		execute 'h '.expand('<cword>')
" 	else
" 		call CocAction('doHover')
" 	endif
" endfunction

" Highlight symbol under cursor on CursorHold
" autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
" nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
"xmap <leader>f <Plug>(coc-format-selected)
"nmap <leader>f <Plug>(coc-format-selected)

" augroup mygroup
" 	autocmd!
" 	" Setup formatexpr specified filetype(s).
" 	autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
" 	" Update signature help on jump placeholder
" 	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end
"
" " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
" xmap <leader>a <Plug>(coc-codeaction-selected)
" nmap <leader>a <Plug>(coc-codeaction-selected)
"
" " Remap for do codeAction of current line
" nmap <leader>ac <Plug>(coc-codeaction)
" " Fix autofix problem of current line
" nmap <leader>qf <Plug>(coc-fix-current)
"
" " Use `:Format` to format current buffer
" command! -nargs=0 Format :call CocAction('format')
"
" " Use `:Fold` to fold current buffer
" command! -nargs=? Fold :call CocAction('fold', <f-args>)
"

" Add diagnostic info for https://github.com/itchyny/lightline.vim
let g:lightline = {
			\ 'colorscheme': 'wombat',
			\ 'active': {
			\   'left': [ [ 'mode', 'paste' ],
			\ [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
			\ },
			\ 'component_function': {
			\ 'cocstatus': 'coc#status'
			\ },
			\ }



" " Using CocList
" " Show all diagnostics
" nnoremap <silent> <space>a :<C-u>CocList diagnostics<cr>
" " Manage extensions
" nnoremap <silent> <space>e :<C-u>CocList extensions<cr>
" " Show commands
" nnoremap <silent> <space>c :<C-u>CocList commands<cr>
" " Find symbol of current document
" nnoremap <silent> <space>o :<C-u>CocList outline<cr>
" " Search workspace symbols
" nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
" " Do default action for next item.
" nnoremap <silent> <space>j :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent> <space>k :<C-u>CocPrev<CR>
" " Resume latest coc list
" nnoremap <silent> <space>p :<C-u>CocListResume<CR>
