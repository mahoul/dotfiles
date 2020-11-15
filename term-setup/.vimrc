set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

colorscheme gruvbox
syntax on
set backspace=indent,eol,start
set cursorline
set cursorcolumn
set modeline
set bg=dark

