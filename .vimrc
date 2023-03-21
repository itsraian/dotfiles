set nobackup
set nowritebackup
set signcolumn=yes
set number
set updatetime=300
set hlsearch
set fileformat=unix
set encoding=utf-8
set fileencoding=utf-8
set autoindent
set smartindent
set nocompatible
set completeopt+=longest
filetype plugin on
filetype indent on

call plug#begin()

Plug 'tpope/vim-sensible'

Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'dense-analysis/ale'

Plug 'dracula/vim', { 'as': 'dracula' }

Plug 'preservim/nerdtree'

Plug 'airblade/vim-gitgutter'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'tpope/vim-fugitive'

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

Plug 'ryanoasis/vim-devicons'
Plug 'Yggdroot/indentLine'

"Plug 'jiangmiao/auto-pairs'

call plug#end()

colorscheme dracula

nmap <Tab> >>
nmap <S-Tab> <<

inoremap <C-Space> <C-x><C-o>
imap <C-@> <C-Space>

""" ===============
""" NERDTree
""" ===============
let NERDTreeQuitOnOpen=1
let NERDTreeDirArrows=1
let NERDTreeMinimalUI=1
let NERDTreeShowHidden=1
nnoremap <C-b> :NERDTreeFind<CR>
nnoremap <leader>b :NERDTreeClose<CR>

""" ===============
""" vim-go
""" ===============
"let g:go_fmt_autosave=1
"let g:go_fmt_autosave=1
"let g:go_metalinter_autosave=1
"let g:go_highlight_functions=1

"autocmd FileType go nmap <silent> gd <Plug>(go-def)
"autocmd FileType go nmap <silent> gy <Plug>(go-def-type)
"autocmd FileType go nmap <silent> gi <Plug>(go-implements)

""" ===========
""" FZF
""" ===========
nnoremap <C-p> :Files<CR>
nnoremap <C-f> :Rg<CR>

""" =========================
""" COC
""" =========================

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go nnoremap <C-l> :CocList diagnostics<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go nnoremap <silent> K :call CocActionAsync('doHover')<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go inoremap <silent> <leader>p :CocActionSync('showSignatureHelp')<CR>

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go nmap <silent> gd <Plug>(coc-definition)
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go nmap <silent> gy <Plug>(coc-type-definition)
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go nmap <silent> gi <Plug>(coc-implementation)
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go nmap <silent> gr <Plug>(coc-references)
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go nmap <silent> [g <Plug>(coc-diagnostic-prev)
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go nmap <silent> ]g <Plug>(coc-diagnostic-next)

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go imap <silent><expr> <c-space> coc#refresh()

autocmd BufWritePre *.js,*.ts,*.tsx,*.jsx,*.go :call CocAction('runCommand', 'editor.action.organizeImport')
autocmd BufWritePre *.js,*.ts,*.tsx,*.jsx,*.go :call CocAction('runCommand', 'editor.action.formatDocument')

autocmd CursorHold * silent call CocActionAsync('highlight')

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

""" ==================
""" ALE Configuration
""" ==================

"autocmd FileType javascript,typescript,javascriptreact,typescriptreact set omnifunc=ale#completion#OmniFunc
"autocmd FileType javascript,typescript,javascriptreact,typescriptreact nmap <silent> K :ALEHover<CR>
"autocmd FileType javascript,typescript,javascriptreact,typescriptreact nmap <silent> gd :ALEGoToDefinition<CR>
"autocmd FileType javascript,typescript,javascriptreact,typescriptreact nmap <silent> gy :ALEGoToTypeDefinition<CR>
"autocmd FileType javascript,typescript,javascriptreact,typescriptreact nmap <silent> gi :ALEGoToImplementation<CR>
"autocmd FileType javascript,typescript,javascriptreact,typescriptreact nmap <silent> gr :ALEFindReferences
"autocmd FileType javascript,typescript,javascriptreact,typescriptreact nmap <silent> <C-/> :ALEImport<CR>
"
"let g:ale_floating_preview=1
"let g:ale_sign_column_always=1
"let g:ale_fix_on_save=1
"let g:ale_fixers = {
"                       \   '*': ['remove_trailing_lines', 'trim_whitespace'],
"                       \   'javascript': ['prettier','eslint'],
"                       \   'typescript': ['prettier','eslint'],
"                       \   'javascriptreact': ['prettier','eslint'],
"                       \   'typescriptreact': ['prettier','eslint'],
"                       \}
