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
set scrolloff=999
set cursorline
set foldmethod=syntax
set foldlevelstart=99
set termguicolors
set re=0

let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

filetype plugin on
filetype indent on
syntax enable

call plug#begin()

Plug 'tpope/vim-sensible'

Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'puremourning/vimspector'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'dense-analysis/ale'

" Plug 'dracula/vim', { 'as': 'dracula' }
" Plug 'arcticicestudio/nord-vim'
" Plug 'morhetz/gruvbox'
Plug 'sainnhe/sonokai'

Plug 'preservim/nerdtree'

Plug 'airblade/vim-gitgutter'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'tpope/vim-fugitive'

" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

Plug 'ryanoasis/vim-devicons'
Plug 'Yggdroot/indentLine'

Plug 'github/copilot.vim'

"Plug 'jiangmiao/auto-pairs'

call plug#end()

" let g:dracula_italic = 0
" let g:airline_theme = 'gruvbox'
let g:sonokai_enable_italic = 1
let g:sonokai_style = 'espresso'
colorscheme sonokai


""" ===============
""" NERDTree
""" ===============
" let NERDTreeQuitOnOpen=1
" let NERDTreeDirArrows=1
" let NERDTreeMinimalUI=1
" let NERDTreeShowHidden=1
" let NERDTreeWinSize=40
" nnoremap <leader>b :NERDTreeFind<CR>
" nnoremap <leader>v :NERDTreeToggle<CR>

""" ===============
""" vim-go
""" ===============
let g:go_fmt_autosave=1
let g:go_metalinter_autosave=1
let g:go_highlight_array_whitespace_error=1
let g:go_highlight_chan_whitespace_error=1
let g:go_highlight_extra_types=1
let g:go_highlight_space_tab_error=1
let g:go_highlight_trailing_whitespace_error=1
let g:go_highlight_operators=1
let g:go_highlight_functions=1
let g:go_highlight_function_parameters=1
let g:go_highlight_function_calls=1
let g:go_highlight_fields=1
let g:go_highlight_types=1
let g:go_highlight_build_constraints=1
let g:go_highlight_string_spellcheck=1
let g:go_highlight_format_strings=0
let g:go_highlight_generate_tags=0
let g:go_highlight_variable_assignments=0
let g:go_highlight_variable_declarations=0


""" ==============
""" Airline
""" ==============

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'jsformatter'
let g:airline_powerline_fonts = 1


""" =========================
""" COC
""" =========================

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust nnoremap <C-l> :CocList diagnostics<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust nnoremap <leader>l :copen<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust nnoremap <silent> K :call CocActionAsync('doHover')<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust inoremap <silent> <leader>p :CocActionSync('showSignatureHelp')<CR>

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust nmap <silent> gd <Plug>(coc-definition)
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust nmap <silent> gy <Plug>(coc-type-definition)
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust nmap <silent> gi <Plug>(coc-implementation)
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust nmap <silent> gr <Plug>(coc-references)
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust nmap <silent> [g <Plug>(coc-diagnostic-prev)
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust nmap <silent> ]g <Plug>(coc-diagnostic-next)

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust imap <silent><expr> <c-space> coc#refresh()

autocmd BufWritePre *.js,*.ts,*.tsx,*.jsx,*.go :call CocAction('runCommand', 'editor.action.organizeImport')
autocmd BufWritePre *.js,*.ts,*.tsx,*.jsx,*.go,*.zig,*.rs :call CocAction('runCommand', 'editor.action.formatDocument')

autocmd CursorHold * silent call CocActionAsync('highlight')

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
			\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nnoremap <leader>fa :Files<CR>
nnoremap <leader>fg :GFiles<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>ff :Rg<CR>

nmap <leader>m <Plug>(coc-codeaction-line)
nnoremap & :call CocAction('runCommand', 'document.toggleInlayHint')<CR>
inoremap <C-Space> <C-x><C-o>
imap <C-@> <C-Space>

nmap <leader>dc <Plug>VimspectorContinue
nmap <leader>dx <Plug>VimspectorStop
nmap <leader>ds <Plug>VimspectorRestart
nmap <leader>dp <Plug>VimspectorPause
nmap <leader>db <Plug>VimspectorToggleBreakpoint
nmap <leader>do <Plug>VimspectorStepOver
nmap <leader>di <Plug>VimspectorStepInto
