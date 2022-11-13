call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

Plug 'vim-test/vim-test'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'morhetz/gruvbox'

Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'

Plug 'elixir-editors/vim-elixir'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
call plug#end()

syntax on
filetype plugin indent on

autocmd vimenter * ++nested colorscheme gruvbox

let g:gruvbox_contrast_dark="hard"

" remove the filetype part
let g:airline_section_x=''
let g:airline_section_y=''
let g:airline_section_z = "%p%% : \ue0a1:%l/%L: Col:%c"
" remove separators for empty sections
let g:airline_skip_empty_sections = 1
" better file location
let g:airline#extensions#tabline#formatter = 'unique_tail'

nmap <C-P> :FZF<CR>
nmap <C-O> :Rg<CR>
nmap <C-[> :FZF ..<CR>
nmap cp :let @" = expand("%:p")<cr>
nmap <silent> <leader>t :TestFile<CR>
nmap <silent> <leader>m :History<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nnoremap ; :

set noerrorbells
set background=dark
set tw=80
set number
set tabstop=2
set shiftwidth=2
set dir=~/vim-swap
set ignorecase
set smartcase
set hlsearch
set showmatch
set noswapfile

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)
