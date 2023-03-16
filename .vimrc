set encoding=utf-8
set nobackup
set nowritebackup
set signcolumn=yes

set number
set updatetime=300

call plug#begin()

Plug 'tpope/vim-sensible'

Plug 'https://github.com/sheerun/vim-polyglot'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'dracula/vim', { 'as': 'dracula' }

Plug 'vim-scripts/The-NERD-tree'

Plug 'airblade/vim-gitgutter'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'tpope/vim-fugitive'

call plug#end()

colorscheme dracula

let g:gitgutter_log=1

command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument

nnoremap <C-p> :Files<CR>
nnoremap <C-f> :Rg<CR>
nnoremap <C-b> :NERDTreeToggle %<CR>
nnoremap <leader>b :NERDTreeToggle<CR>
nnoremap <C-l> :CocDiagnostics<CR>
nnoremap <silent> K :call CocActionAsync('doHover')<CR>

inoremap <silent> <leader>p :CocActionSync('showSignatureHelp')<CR>

set encoding=utf-8
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
