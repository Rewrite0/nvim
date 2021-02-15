call plug#begin('~/.config/nvim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'				"状态栏
Plug 'vim-airline/vim-airline-themes'
Plug 'tmhedberg/SimpylFold'					"代码折叠
Plug 'preservim/nerdcommenter'			"注释
Plug 'luochen1990/rainbow'					"彩色括号
Plug 'keith/swift.vim'						"swift
Plug 'honza/vim-snippets'					"语法片段(需安装coc-snippets)
Plug 'godlygeek/tabular' "必要插件，安装在vim-markdown前面,提供表格对齐
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}		"md预览
Plug 'preservim/nerdtree'					"文件树菜单
call plug#end()

"============================================

"================插件配置====================
"彩色括号
let g:rainbow_active = 1 

"coc
let g:coc_global_extensions = ['coc-json','coc-css','coc-html','coc-snippets','coc-highlight','coc-yaml','coc-xml','coc-tsserver','coc-python','coc-java','coc-vimlsp','coc-pairs']
set updatetime=100
set shortmess+=c
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
nmap <silent> <LEADER>- <Plug>(coc-diagnostic-prev)
nmap <silent> <LEADER>= <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
nmap <leader>rn <Plug>(coc-rename)


"vim-markdown
" 禁用折叠
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_conceal = 0
let g:tex_conceal = ''
let g:vim_markdown_math = 1
let g:vim_markdown_toml_frontmatter = 1

"NERDTree
" 不显示隐藏文件
let g:NERDTreeHidden=0
" 过滤: 所有指定文件和文件夹不显示
let NERDTreeIgnore = ['\.pyc$', '\.swp', '\.swo', '\.vscode', '__pycache__']  

"====================配置===================
"设置前缀键<leader>为空格
let mapleader="\<space>"

set encoding=utf-8
set t_Co=256                    "256色
set number                      "行号
set relativenumber							"相对行号
set tabstop=2                   "Tab键的宽度

" 统一缩进为4
set softtabstop=2
set shiftwidth=2

set noexpandtab                 "不要用空格代替制表符
set smarttab                    "在行和段开始处使用制表符
set wrap                        "自动换行
set linebreak                   "不再单词内部折行
set wrapmargin=2                "折行处与编辑窗口的右边缘之间空出的字符数
set scrolloff=10                 "垂直滚动时，光标距离顶部/底部的位置（单位：行）
set showmatch                   "高亮对应括号
set incsearch                   "自动跳转搜索到的第一个结果
set ignorecase                  "搜索忽略大小写
set smartcase                   "搜索对首字母大写敏感
set autochdir                   "自动切换工作目录
set nocompatible                "不兼容vi
set clipboard=unnamed           "共享剪切板

"禁止生成临时文件
set nobackup
set noswapfile

filetype on                     "检测文件类型

" 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
set mouse=a
set selection=exclusive
set selectmode=mouse,key

" 自动缩进
set autoindent
set cindent
" 为C程序提供自动缩进
set smartindent

"================================按键映射==================================
" 双击空格跳到'<++>' 
noremap <space><space> <Esc>/<++><CR>:nohlsearch<CR>c4l

"用;替换:
noremap ; :

"shell
noremap ! :!

" Save & quit
noremap <LEADER>q :q<CR>
noremap <C-q> :wq<CR>
noremap <LEADER>s :w<CR>

" 映射全选+复制 ctrl+a
map <C-A> ggVGY

" 选中状态下 Ctrl+c 复制
vmap <C-c> "+y

" 输入状态 Ctrl+v 粘贴
inoremap <C-v> <Esc>p

"init.vim
noremap rc :e ~/.config/nvim/init.vim<CR>

"缩进
nnoremap < <<
nnoremap > >>

"注释切换
nmap ci <LEADER>ci
"注释光标后的内容
nmap ce <LEADER>c$
"最后一行添加注释符号并进入插入模式
nmap cli <LEADER>cA
"单词转为大写
inoremap <C-u> <esc>gUiwea

"光标移到行首
noremap <LEADER>a 0
"光标移到行尾
noremap <LEADER>d $

"分屏操作
"向右分屏
map <LEADER>l :set splitright<CR>:vsplit<CR>
"向左分屏
map <LEADER>h :set nosplitright<CR>:vsplit<CR>
"向上分屏
map <LEADER>k :set nosplitbelow<CR>:split<CR>
"向下分屏
map <LEADER>j :set splitbelow<CR>:split<CR>
"光标移动至左分屏
map sh <C-w>h
"光标移动至右分屏
map sl <C-w>l
"光标移动至下分屏
map sj <C-w>j
"光标移动至上分屏
map sk <C-w>k
"增加纵向分屏大小
map <up> :res +5<CR>
"减少纵向分屏大小
map <down> :res -5<CR>
"减少横向分屏大小
map <left> :vertical resize-5<CR>
"增加横横分屏大小
map <right> :vertical resize+5<CR>
"将分屏设置为横向分屏
map <LEADER>H <C-w>t<C-w>H
"将分屏设置为纵向分屏
map <LEADER>K <C-w>t<C-w>K

"打开目录树
map <F3> :NERDTreeToggle<CR>
"切换光标
noremap <LEADER>w <C-w>w

"标签
"打开新标签
map tn :tabe<CR>
" 跳转至上一个标签
map tj :-tabnext<CR>
" 跳转至下一个标签
map tk :+tabnext<CR>
  " 关闭当前标签
map td :tabclose<CR>

"markdown
"插入超链接
inoremap ;a [](<++>)<++><esc>10hi
"插入<!--more-->
inoremap ;m <!--more--><Esc>o
"插入</br>
inoremap ;br </br>

"=============================================================================
"新建文件，自动插入文件头 
autocmd BufNewFile *.sh,*.py exec ":call SetTitle()" 
""定义函数SetTitle，自动插入文件头 
func SetTitle() 
    "如果文件类型为.sh文件 
    if &filetype == 'sh' 
        call setline(1, "#!/bin/bash")
        call append(line("."), "#########################################################################")
        call append(line(".")+1, "# File Name: ".expand("%")) 
        call append(line(".")+2, "# Created Time: ".strftime("%c")) 
        call append(line(".")+3, "#########################################################################") 
        call append(line(".")+4, "")
    
    "如果文件类型为.py文件
    elseif &filetype == 'python'
        call setline(1, "#!/usr/bin/env python")
        call append(line("."), "#coding:utf-8")
        call append(line(".")+1, "#########################################################################")
        call append(line(".")+2, "# File Name: ".expand("%")) 
        call append(line(".")+3, "# Created Time: ".strftime("%c")) 
        call append(line(".")+4, "#########################################################################") 
        call append(line(".")+5, "")
    endif
    autocmd BufNewFile * normal G
endfunc
"================================================================
"r运行程序    
    map <LEADER>r :call CompileRunGcc()<CR>
    func! CompileRunGcc()
        exec "w"
        if &filetype == 'c'
            exec "!g++ % -o %<"
            exec "!./%<"
        elseif &filetype == 'cpp'
            exec "!g++ % -o %<"
            exec "!./%<"
        elseif &filetype == 'java'
            exec "!javac %"
            exec "!java %<"
        elseif &filetype == 'sh'
            :!bash %
        elseif &filetype == 'python'
            exec "!python %"
		elseif &filetype == 'swift'
			exec "!swift %"
		elseif &filetype == 'markdown'
			exec "MarkdownPreview"
        elseif &filetype == 'html'
            exec "!chromium %"
        elseif &filetype == 'go'
            exec "!go build %<"
            exec "!go run %"
        endif
    endfunc

"================================================================
"输入|自动对齐表格
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>table_auto_align()<CR>a

function! s:table_auto_align()
    let p = '^\s*|\s.*\s|\s*$'
    if exists(':Tabularize') && getline('.') =~# '^\s*|'
                \ && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
        let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
        let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
        Tabularize/|/l1
        normal! 0
        call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
    endif
endfunction
"================================================================
