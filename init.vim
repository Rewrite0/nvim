call plug#begin('~/.config/nvim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'				"状态栏
Plug 'vim-airline/vim-airline-themes'
Plug 'jiangmiao/auto-pairs'					"括号补全
Plug 'tmhedberg/SimpylFold'					"代码折叠
Plug 'preservim/nerdcommenter'				"注释
Plug 'luochen1990/rainbow'					"彩色括号
Plug 'keith/swift.vim'						"swift
call plug#end()

"============================================
"================插件配置====================
"彩色括号
let g:rainbow_active = 1 

"coc
let g:coc_global_extensions = ['coc-json','coc-css','coc-html','coc-snippets','coc-highlight','coc-yaml','coc-xml','coc-tsserver','coc-sourcekit','coc-python','coc-java','coc-vimlsp']

"============================================
"配置
set encoding=utf-8
set t_Co=256                    "256色
set number                      "行号
set tabstop=4                   "Tab键的宽度

" 统一缩进为4
set softtabstop=4
set shiftwidth=4

set noexpandtab                 "不要用空格代替制表符
set smarttab                    "在行和段开始处使用制表符
set wrap                        "自动换行
set linebreak                   "不再单词内部折行
set wrapmargin=2                "折行处与编辑窗口的右边缘之间空出的字符数
set scrolloff=5                 "垂直滚动时，光标距离顶部/底部的位置（单位：行）
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

"=============================================================================
"按键映射

"用;替换:
noremap ; :

"shell
noremap ! :!

" Save & quit
noremap Q :q<CR>
noremap <C-q> :wq<CR>
noremap S :w<CR>

" 映射全选+复制 ctrl+a
map <C-A> ggVGY

" 选中状态下 Ctrl+c 复制
vmap <C-c> "+y

"init.vim
noremap rc :e ~/.config/nvim/init.vim<CR>

"缩进
nnoremap < <<
nnoremap > >>

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
"f5运行程序    
    map <F5> :call CompileRunGcc()<CR>
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
            :!time bash %
        elseif &filetype == 'python'
            exec "!python %"
		elseif &filetype == 'swift'
			exec "!swift %"
        elseif &filetype == 'html'
            exec "!chromium % &"
        elseif &filetype == 'go'
            exec "!go build %<"
            exec "!go run %"
        endif
    endfunc

"================================================================
