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
set foldlevel=999
set termguicolors
set re=0
set background=dark

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
Plug 'sainnhe/sonokai'
Plug 'preservim/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'ryanoasis/vim-devicons'
Plug 'Yggdroot/indentLine'
Plug 'github/copilot.vim'
Plug 'morhetz/gruvbox'

call plug#end()

" let g:dracula_italic = 0

" packadd! dracula_pro
" let g:dracula_colorterm = 0
let g:gruvbox_italic = 1
let g:gruvbox_italicize_strings = 1
colorscheme gruvbox


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
let g:go_highlight_format_strings=1
let g:go_highlight_generate_tags=1
let g:go_highlight_variable_assignments=1
let g:go_highlight_variable_declarations=1


""" ==============
""" Airline
""" ==============

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'jsformatter'
let g:airline_powerline_fonts = 1
let g:airline_left_sep=' '
let g:airline_right_sep=' '

nnoremap <Right> :echo "No right for you!"<CR>
vnoremap <Right> :<C-u>echo "No right for you!"<CR>
inoremap <Right> <C-o>:echo "No right for you!"<CR>


nnoremap <Down> :echo "No down for you!"<CR>
vnoremap <Down> :<C-u>echo "No down for you!"<CR>
inoremap <Down> <C-o>:echo "No down for you!"<CR>

nnoremap <Up> :echo "No up for you!"<CR>
vnoremap <Up> :<C-u>echo "No up for you!"<CR>
inoremap <Up> <C-o>:echo "No up for you!"<CR>

nnoremap <Left> :echo "No left for you!"<CR>
vnoremap <Left> :<C-u>echo "No left for you!"<CR>
inoremap <Left> <C-o>:echo "No left for you!"<CR>


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

autocmd BufWritePre *.js,*.ts,*.tsx,*.jsx :call CocAction('runCommand', 'editor.action.organizeImport')
autocmd BufWritePre *.js,*.ts,*.tsx,*.jsx,*.zig,*.rs :call CocAction('runCommand', 'editor.action.formatDocument')

autocmd CursorHold * silent call CocActionAsync('highlight')

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
			\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

let g:netrw_winsize=20
let g:netrw_liststyle=3

nnoremap <space>F :Files<CR>
nnoremap <space>f :GFiles<CR>
nnoremap <space>b :Buffers<CR>
nnoremap <space>/ :Rg<CR>
nnoremap <space>E :Explore<CR>

nnoremap <space>1 :e $MYVIMRC<CR>
nnoremap <space>2 :source $MYVIMRC<CR>

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
