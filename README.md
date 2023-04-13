This is a mirror of [toggle_words](https://github.com/vim-scripts/toggle_words.vim.git) and rewrite using vim9script.

# Documentation

The purpose of this plugin is very simple, it can toggle words among
'true'=>'false', 'True'=>'False', 'if'=>'elseif'=>'else'=>'endif' etc .

To use it, move the cursor on some words like 'true', 'False', 'YES', etc,
call command
:ToggleWord

It will toggle 'true'=>'false', 'False'=>'True', 'YES'=>'NO' etc. Yes,
this script will try to take the case into account when toggling words, so
'True' will be toggled to 'False' instead of 'false'. Currently the way to
check the case is very simple, but it works well for me.

You can define a map for 'ToggleWord' comand to make it easier:
nmap ,t <Cmd>ToggleWord<CR>

This script can search the candicate words to toggle based on
current filetype, for example, you can put the following configuration
into your .vimrc to define some words for python:
let g:toggle_words_dict = {'python': [['if', 'elif', 'else']]}

There are some default words for toggling predefined in the
script(g:\_toogle_words_dict) that will work for all filetypes.
Any comment, suggestion, bug report are welcomed.
