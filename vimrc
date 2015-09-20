" put this line first in ~/.vimrc
set nocompatible | filetype indent plugin on | syn on

fun! SetupVAM()
  let c = get(g:, 'vim_addon_manager', {})
  let g:vim_addon_manager = c
  let c.plugin_root_dir = expand('$HOME', 1) . '/.vim/vim-addons'

  " Force your ~/.vim/after directory to be last in &rtp always:
  " let g:vim_addon_manager.rtp_list_hook = 'vam#ForceUsersAfterDirectoriesToBeLast'

  " most used options you may want to use:
  " let c.log_to_buf = 1
  " let c.auto_install = 0
  let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'
  if !isdirectory(c.plugin_root_dir.'/vim-addon-manager/autoload')
    execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '
        \       shellescape(c.plugin_root_dir.'/vim-addon-manager', 1)
  endif

  " This provides the VAMActivate command, you could be passing plugin names, too
  call vam#ActivateAddons([], {})
endfun
call SetupVAM()

" ACTIVATING PLUGINS

" OPTION 1, use VAMActivate
"VAMActivate PLUGIN_NAME PLUGIN_NAME ..

" OPTION 2: use call vam#ActivateAddons
" call vam#ActivateAddons(['yaml', 'Syntastic', 'jdaddy', 'spellcheck'], {})
" use <c-x><c-p> to complete plugin names

" OPTION 3: Create a file ~/.vim-srcipts putting a PLUGIN_NAME into each line
" See lazy loading plugins section in README.md for details
"call vam#Scripts('~/.vim-scripts', {'tag_regex': '.*'})


set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4
set autoindent
set noic
syntax on

set background=dark
set showmatch
set smartcase
set ai
set si
set lbr
set sw=4
set backspace=indent,eol,start
set undolevels=1000
set title
set foldenable
set foldnestmax=10
set foldlevelstart=0
set foldmethod=indent
"set foldmethod=syntax
autocmd BufWinEnter * normal zR
noremap <space> za
noremap - zm
noremap = zr
noremap _ zM
noremap + zR
:imap jj <Esc>

hi MatchParen cterm=bold ctermbg=none ctermfg=magenta
hi MatchParen cterm=underline ctermbg=none ctermfg=none
"#ctermbg=green ctermfg=blue

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
    %s/\s\+$//ge
      exe "normal `z"
endfunc

autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite * :call DeleteTrailingWS()
autocmd BufWrite *.yaml :call DeleteTrailingWS()
autocmd BufWrite *.json :call DeleteTrailingWS()
autocmd BufWrite *.c :call DeleteTrailingWS()
autocmd BufWrite *.h :call DeleteTrailingWS()
autocmd BufWrite *.cpp :call DeleteTrailingWS()
autocmd BufWrite *.hpp :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()


set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_check_on_w = 0
let g:syntastic_python_checkers = []
" ['pep8', 'pylint', 'flake8']

