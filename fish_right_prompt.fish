# ░█▀▄░█░░░█▀█░█▀▀░█░█░█▀▀
# ░█▀▄░█░░░█░█░█░░░█▀▄░▀▀█
# ░▀▀░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀

# Time stamp block
function _block_time_stamp -d 'Returns time stamp block'
	set block (set_color -b brcyan -o black)' '(date +%H:%M)' '
	echo $block
end
# Command duration block
function _block_cmd_duration -d 'Returns command duration block'
	set -l min_cmd_duration 5000 # 5 seconds
	set -l cmd_duration $CMD_DURATION
	set_color normal
	if test $cmd_duration -ge $min_cmd_duration
		set -l human_duration (math --scale=2 "$cmd_duration / 1000")s
		echo (set_color -b brmagenta -o black)'  '$human_duration' '
	end
end

# Status block
function _block_status -d 'Returns status block'
	if not test $status -eq 0
		set block (set_color -b red yellow)'  '
	else
		set block (set_color -b black green)'  '
	end
	echo $block
end

# Git block
function _block_git -d 'Returns Git block'
	set -l git_prompt (fish_git_prompt)
	if [ "$git_prompt" ]
		set -l ahead_behind (git rev-list --left-right --count '@{upstream}...HEAD' 2>/dev/null)
		set -l behind (echo $ahead_behind | cut -f1)
		set -l ahead (echo $ahead_behind | cut -f2)

		set -l indicators
		if [ $behind -gt 0 ]
			set -a indicators "  $behind"
		end
		if [ $ahead -gt 0 ]
			set -a indicators "  $ahead"
		end

		set git_bg (_fishblocks_git_status)
		set block "$git_prompt$indicators  "
	else
		set git_bg normal
		set block (fish_git_prompt)
	end
	echo (set_color -b $git_bg -o black)' '$block
end

# Override fish_default_mode_prompt and use the theme's custom prompt
function fish_default_mode_prompt -d 'Display the default mode for the prompt'
end

function _block_default_mode -d 'Returns the default mode for the prompt'
	set block
	# Check if in vi mode
	if test "$fish_key_bindings" = 'fish_vi_key_bindings'
		or test "$fish_key_bindings" = 'fish_hybrid_key_bindings'
		switch $fish_bind_mode
			case default
				set block (set_color -b brred -o black)' N '
			case insert
				set block (set_color -b brgreen -o black)' I '
			case replace_one
				set block (set_color -b brgreen -o black)' R '
			case replace
				set block (set_color -b brcyan -o black)' R '
			case visual
				set block (set_color -b brmagenta -o black)' V '
		end
	end
	echo $block
end


# Private mode block
function _block_private -d 'Returns private mode block'
	if  not test -z $fish_private_mode
		set block (set_color -b black white)' 﫸'
	else
		set block
	end
	echo $block
end

# ░█▀▄░▀█▀░█▀▀░█░█░▀█▀░░░░░█░█░█▀█░█▀█░█▀▄░░░█▀█░█▀▄░█▀█░█▄█░█▀█░▀█▀
# ░█▀▄░░█░░█░█░█▀█░░█░░▄▄▄░█▀█░█▀█░█░█░█░█░░░█▀▀░█▀▄░█░█░█░█░█▀▀░░█░
# ░▀░▀░▀▀▀░▀▀▀░▀░▀░░▀░░░░░░▀░▀░▀░▀░▀░▀░▀▀░░░░▀░░░▀░▀░▀▀▀░▀░▀░▀░░░░▀░

# Right-hand prompt
function fish_right_prompt -d 'Right-hand prompt'
	echo -ne (_block_status)(_block_git)(_block_cmd_duration)(_block_time_stamp)(_block_default_mode)(_block_private)(set_color normal)
end
