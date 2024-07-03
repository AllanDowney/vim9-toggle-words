vim9script

# =========================================================
#   Copyright (C) 2023 AllanDowney. All rights reserved.
#
#   File Name       : toggle_words.vim
#   Author          : Allan Downey<allandowney@126.com>
#   Version         : 0.1
#   Create          : 2023-04-13 21:40
#   Last Modified   : 2023-04-13 21:40
#   Describe        : This is a mirror of
#                     https://github.com/vim-scripts/toggle_words.vim.git
#                     and rewrite using vim9script
# =========================================================

# Documentation:
#   The purpose of this plugin is very simple, it can toggle words among
#   'true'=>'false', 'True'=>'False', 'if'=>'elseif'=>'else'=>'endif' etc .
#
#   To use it, move the cursor on some words like 'true', 'False', 'YES', etc,
#   call command
#     :ToggleWord
#
#   It will toggle 'true'=>'false', 'False'=>'True', 'YES'=>'NO' etc. Yes,
#   this script will try to take the case into account when toggling words, so
#   'True' will be toggled to 'False' instead of 'false'. Currently the way to
#   check the case is very simple, but it works well for me.
#
#   You can define a map for 'ToggleWord' comand to make it easier:
#     nmap ,t <Cmd>ToggleWord<CR>
#
#   This script can search the candicate words to toggle based on
#   current filetype, for example, you can put the following configuration
#   into your .vimrc to define some words for python:
#      let g:toggle_words_dict = {'python': [['if', 'elif', 'else']]}

#   There are some default words for toggling predefined in the
#   script(g:_toogle_words_dict) that will work for all filetypes.
#   Any comment, suggestion, bug report are welcomed.

if g:->get('loaded_toggle_words')
	finish
endif

if v:version < 900
	echoerr "[toggle_words] Error: 需要 Vim-9.0 以上版本."
	finish
endif

g:loaded_toggle_words = 1

g:_toggle_words_dict = {		# {{{
	'*': [
		['==', '!='],
		['>', '<'],
		['(', ')'],
		['[', ']'],
		['{', '}'],
		['+', '-'],
		['allow', 'deny'],
		['before', 'after'],
		['block', 'inline', 'none'],
		['define', 'undef'],
		['good', 'bad'],
		['if', 'elseif', 'else', 'endif'],
		['in', 'out'],
		['left', 'right'],
		['min', 'max'],
		['on', 'off'],
		['start', 'stop'],
		['success', 'failure'],
		['true', 'false'],
		['up', 'down'],
		['left', 'right'],
		['yes', 'no'],
		['monday', 'tuesday', 'wednesday', 'thursday', 'friday',
		'saturday', 'sunday'],
		['january', 'february', 'march', 'april', 'may', 'june',
		'july', 'august', 'september', 'october', 'november', 'december'],
		['1', '0'],
		[],
	],
}		# }}}

if exists('g:toggle_words_dict')		# {{{
	for key in keys(g:toggle_words_dict)
		if has_key(g:_toggle_words_dict, key)
			extend(g:_toggle_words_dict[key], g:toggle_words_dict[key])
		else
			g:_toggle_words_dict[key] = g:toggle_words_dict[key]
		endif
	endfor
endif		# }}}

def ToggleWord()		# {{{
	var cur_filetype = &filetype
	var words_candicates_array: list<list<any>>

	if !has_key(g:_toggle_words_dict, cur_filetype)
		words_candicates_array = g:_toggle_words_dict['*']
	else
		words_candicates_array = g:_toggle_words_dict[cur_filetype] + g:_toggle_words_dict['*']
	endif

	var cur_word = expand('<cword>')
	var word_attr = 0 # 0 - lowercase; 1 - Capital; 2 - uppercase

	if toupper(cur_word) ==# cur_word
		word_attr = 2
	elseif cur_word ==# substitute(cur_word, '.*', '\u\0', '')
		word_attr = 1
	else
		word_attr = 0
	endif

	cur_word = tolower(cur_word)

	var new_word: string
	for words_candicates in words_candicates_array
		var index = index(words_candicates, cur_word)
		if index != -1
			var new_word_index = (index + 1) % len(words_candicates)
			new_word = words_candicates[new_word_index]

			if word_attr == 2
				new_word = toupper(new_word)
			elseif word_attr == 1
				new_word = substitute(new_word, '.*', '\u\0', '')
			else
				new_word = tolower(new_word)
			endif

			execute 'normal ciw' .. new_word .. ''
			break
		endif
	endfor

enddef		# }}}

command! -nargs=0 ToggleWord call <SID>ToggleWord()

# vim: ts=4 sw=4 noet fdm=marker
