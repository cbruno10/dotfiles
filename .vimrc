set nocompatible              " be iMproved, required
filetype off                  " required

" Show line numbers
set number

" Use 2 spaces instead of tabs and automatically indent
set tabstop=2 shiftwidth=2 expandtab
set smartindent

" Easier newlines
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

" Automatically install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugin management
call plug#begin('~/.vim/plugged')
" Make sure you use single quotes
Plug 'chase/vim-ansible-yaml'
Plug 'fatih/vim-go'
Plug 'hashivim/vim-terraform'
Plug 'lepture/vim-jinja'
Plug 'e-gineer/vim-steampipe'
Plug 'godlygeek/tabular'
Plug 'groenewege/vim-less'
Plug 'kchmck/vim-coffee-script'
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'
Plug 'prettier/vim-prettier'
Plug 'w0rp/ale'
" Initialize plugin system
call plug#end()

filetype plugin indent on    " required

" Enable syntax highlighting
syntax enable

" Highlight the 81st character in a line to signal that it's too long.
" This is a less agressive variant of
" http://blog.ezyang.com/2010/03/vim-textwidth/
augroup vimrc_autocmds
  autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=grey
    autocmd BufEnter * match OverLength /\%81v/
    augroup END

" Disable folding in markdown
let g:vim_markdown_folding_disabled = 1

set backspace=indent,eol,start  " Backspace for dummies
set cursorline                  " Highlight current line
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms

set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

" Use TAB to complete when typing words, else inserts TABs as usual.
" Uses dictionary and source files to find matching words to complete.

" See help completion for source,
" Note: usual completion is on <C-n> but more trouble to press all the time.
" Never type the same word twice and maybe learn a new spellings!
" Use the Linux dictionary when spelling is in doubt.
" Window users can copy the file to their machine.
function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction
:inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
:set dictionary="/usr/dict/words"

" Prettier by default on save
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.json,*.yml,*.yaml PrettierAsync

" Set custom file types
au BufNewFile,BufRead *.ect set filetype=mason
au BufNewFile,BufRead *.cson set filetype=coffee
au BufNewFile,BufRead *.cson.ect set filetype=coffee
au BufNewFile,BufRead *.js.nj set filetype=jinja
au BufNewFile,BufRead *.html.nj set filetype=jinja
au BufNewFile,BufRead *.json.nj set filetype=json
au BufNewFile,BufRead *.coffee.md set filetype=coffee

" The default YAML syntax in vim 7.4 is awfully slow,
" so just use the fast ansible YAML highlighter instead
au BufNewFile,BufRead *.yaml set filetype=ansible
au BufNewFile,BufRead *.yml set filetype=ansible

au BufNewFile,BufRead *.yaml.tj2 set filetype=ansible
au BufNewFile,BufRead *.yml.tj2 set filetype=ansible
au BufNewFile,BufRead *.tf.tj2 set filetype=terraform
