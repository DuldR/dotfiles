call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

Plug 'vim-test/vim-test'
Plug 'takac/vim-hardtime'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'morhetz/gruvbox'

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

let g:hardtime_default_on = 1
let g:hardtime_maxcount = 5
let g:hardtime_motion_with_count_resets = 1 

nmap <C-P> :Files<CR>
nmap <C-Q> :Rg<CR>
nmap <C-\> :Files ..<CR>
nmap cp :let @" = expand("%:p")<cr>
nmap <silent> <leader>e :Explore<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>m :History<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
map q <Nop>
nnoremap Q <Nop>
map <Leader>sra :%s///g<Left><Left>
map <Leader>src :%s///gc<Left><Left><Left>

if maparg('<C-L>', 'n') ==# ''
	  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

let g:fzf_layout = { 'down': '~40%' }
let g:fzf_files_options =
  \ '--preview "bat {} 2> /dev/null | head -'.&lines.'"'

set noerrorbells
set background=dark
set tw=80
set number
set tabstop=2
set shiftwidth=2
set dir=~/vim-swap
set ignorecase
set incsearch
set smartcase
set hlsearch
set showmatch
set noswapfile
set relativenumber
set cursorline

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --hidden --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)
