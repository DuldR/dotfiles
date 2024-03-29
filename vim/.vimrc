call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

Plug 'vim-test/vim-test'

" Vim Hyperbolic Time Chamber
Plug 'takac/vim-hardtime'

" Fuzzy Finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Vim Theme
Plug 'morhetz/gruvbox'

" Linting
Plug 'dense-analysis/ale'

" Language Support
Plug 'sheerun/vim-polyglot'

" Autocomplete
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'

" Tmux Runner
Plug 'benmills/vimux'

call plug#end()

""" OS Specific Config """
if system('uname -s') == "Darwin\n"
  set clipboard=unnamed "OSX
  let g:ale_fix_on_save = 0
else
  set clipboard=unnamedplus "Linux
  let g:ale_fix_on_save = 1
endif

""" Plugin Config """

" This removes parens highlighting
let loaded_matchparen = 1

" Theme Config
let g:gruvbox_contrast_dark="hard"

" Airline Config
" remove the filetype part
let g:airline_section_x=''
let g:airline_section_y=''
let g:airline_section_z = "%p%% : \ue0a1:%l/%L: Col:%c"
" remove separators for empty sections
let g:airline_skip_empty_sections = 1
" better file location
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#enabled = 0

" Vimux Config
let test#strategy="vimux"
let g:VimuxOrientation = "h"
let g:VimuxCloseOnExit = 1

" Hardtime Config - Remove in the future
" let g:hardtime_default_on = 1
" let g:hardtime_maxcount = 5
" let g:hardtime_motion_with_count_resets = 1

" ALE Config
let g:ale_linters = {
      \   'elixir': ['credo', 'dialyxir', 'elixir-ls'],
      \   'ruby': ['solargraph', 'rubocop'],
      \   'javascript': ['eslint'],
      \}
let g:ale_fixers = {
      \   'elixir': ['mix_format'],
      \   'ruby': ['rubocop'],
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \}
let g:ale_elixir_elixir_ls_release= $HOME . '/Documents/elixir-ls'
" let g:ale_completion_enabled = 1

" deoplete Config - This is slow
let g:deoplete#enable_at_startup = 1

" FZF Config
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_files_options =
  \ '--preview "bat {} 2> /dev/null | head -'.&lines.'"'

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --hidden --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

""" Keybindings """
nmap <C-P> :Files<CR>
nmap <C-Q> :Rg<CR>
nmap <C-\> :Files ..<CR>
nnoremap <C-a> :set relativenumber!<cr>
nmap cp :let @" = expand("%:p")<cr>
nmap <silent> <leader>e :Explore<CR>
nmap <silent> <leader>E :e#<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>N :TestNearest<CR>
nmap <silent> <leader>m :History<CR>
map <silent> <leader>q :VimuxCloseRunner<CR>
nmap <silent> gd :ALEGoToDefinition<CR>
nmap <silent> gi :ALEFindReferences<CR>
nmap <silent> gk :ALEHover<CR>
map q <Nop>
nnoremap Q <Nop>
map <Leader>sra :%s///g<Left><Left>
map <Leader>src :%s///gc<Left><Left><Left>
command! W :w

if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

""" Vim Settings """
set pastetoggle=<F3>
set noerrorbells
set background=dark
set tw=80
set number
set tabstop=2
set shiftwidth=2
set ignorecase
set incsearch
set smartcase
set hlsearch
set showmatch
set noswapfile
set relativenumber
set cursorline
set splitright
set splitbelow
set noshowmode

""" Closes preview window after choosing autocomplete option """
autocmd CompleteDone * pclose

syntax on
filetype plugin indent on

autocmd vimenter * ++nested colorscheme gruvbox
