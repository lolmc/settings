# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8
export LANGUAGE=en_GB.UTF-8

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# Fix fo Tilix
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
	source /etc/profile.d/vte*.sh
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi
. "$HOME/.cargo/env"
export PATH=$(python3 -c 'import site; print(site.USER_BASE + "/bin")'):$PATH
export PATH=$PATH:/var/lib/flatpak/exports/bin
export PATH=/home/mcbridl/.cargo/bin:$PATH
export PATH=/home/mcbridl/.local/bin:$PATH
export PATH=/snap/bin/:$PATH
eval "$(starship init bash)"

# =============================================================================
#
# Utility functions for zoxide.
#

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd() {
	\builtin pwd -L
}

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd() {
	# shellcheck disable=SC2164
	\builtin cd -- "$@"
}

# =============================================================================
#
# Hook configuration for zoxide.
#

# Hook to add new entries to the database.
__zoxide_oldpwd="$(__zoxide_pwd)"

function __zoxide_hook() {
	\builtin local -r retval="$?"
	\builtin local pwd_tmp
	pwd_tmp="$(__zoxide_pwd)"
	if [[ ${__zoxide_oldpwd} != "${pwd_tmp}" ]]; then
		__zoxide_oldpwd="${pwd_tmp}"
		\command zoxide add -- "${__zoxide_oldpwd}"
	fi
	return "${retval}"
}

# Initialize hook.
if [[ ${PROMPT_COMMAND:=} != *'__zoxide_hook'* ]]; then
	PROMPT_COMMAND="__zoxide_hook;${PROMPT_COMMAND#;}"
fi

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

__zoxide_z_prefix='z#'

# Jump to a directory using only keywords.
function __zoxide_z() {
	# shellcheck disable=SC2199
	if [[ $# -eq 0 ]]; then
		__zoxide_cd ~
	elif [[ $# -eq 1 && $1 == '-' ]]; then
		__zoxide_cd "${OLDPWD}"
	elif [[ $# -eq 1 && -d $1 ]]; then
		__zoxide_cd "$1"
	elif [[ ${@: -1} == "${__zoxide_z_prefix}"?* ]]; then
		# shellcheck disable=SC2124
		\builtin local result="${@: -1}"
		__zoxide_cd "${result:${#__zoxide_z_prefix}}"
	else
		\builtin local result
		# shellcheck disable=SC2312
		result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")" &&
			__zoxide_cd "${result}"
	fi
}

# Jump to a directory using interactive search.
function __zoxide_zi() {
	\builtin local result
	result="$(\command zoxide query --interactive -- "$@")" && __zoxide_cd "${result}"
}

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

\builtin unalias z &>/dev/null || \builtin true
function z() {
	__zoxide_z "$@"
}

\builtin unalias zi &>/dev/null || \builtin true
function zi() {
	__zoxide_zi "$@"
}

# Load completions.
# - Bash 4.4+ is required to use `@Q`.
# - Completions require line editing. Since Bash supports only two modes of
#   line editing (`vim` and `emacs`), we check if either them is enabled.
# - Completions don't work on `dumb` terminals.
if [[ ${BASH_VERSINFO[0]:-0} -eq 4 && ${BASH_VERSINFO[1]:-0} -ge 4 || ${BASH_VERSINFO[0]:-0} -ge 5 ]] &&
	[[ :"${SHELLOPTS}": =~ :(vi|emacs): && ${TERM} != 'dumb' ]]; then
	# Use `printf '\e[5n'` to redraw line after fzf closes.
	\builtin bind '"\e[0n": redraw-current-line' &>/dev/null

	function __zoxide_z_complete() {
		# Only show completions when the cursor is at the end of the line.
		[[ ${#COMP_WORDS[@]} -eq $((COMP_CWORD + 1)) ]] || return

		# If there is only one argument, use `cd` completions.
		if [[ ${#COMP_WORDS[@]} -eq 2 ]]; then
			\builtin mapfile -t COMPREPLY < <(
				\builtin compgen -A directory -- "${COMP_WORDS[-1]}" || \builtin true
			)
		# If there is a space after the last word, use interactive selection.
		elif [[ -z ${COMP_WORDS[-1]} ]] && [[ ${COMP_WORDS[-2]} != "${__zoxide_z_prefix}"?* ]]; then
			\builtin local result
			# shellcheck disable=SC2312
			result="$(\command zoxide query --exclude "$(__zoxide_pwd)" --interactive -- "${COMP_WORDS[@]:1:${#COMP_WORDS[@]}-2}")" &&
				COMPREPLY=("${__zoxide_z_prefix}${result}/")
			\builtin printf '\e[5n'
		fi
	}

	\builtin complete -F __zoxide_z_complete -o filenames -- z
	\builtin complete -r zi &>/dev/null || \builtin true
fi

# =============================================================================
#
# To initialize zoxide, add this to your configuration (usually ~/.bashrc):
#
# eval "$(zoxide init bash)"
eval "$(zoxide init bash)"

#eval "$(atuin init bash)"
source ~/.bash_completion/alacritty
export EDITOR='nvim-lazy'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/mcbridl/anaconda3/bin/conda' 'shell.bash' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
	eval "$__conda_setup"
else
	if [ -f "/home/mcbridl/anaconda3/etc/profile.d/conda.sh" ]; then
		. "/home/mcbridl/anaconda3/etc/profile.d/conda.sh"
	else
		export PATH="/home/mcbridl/anaconda3/bin:$PATH"
	fi
fi
unset __conda_setup
# <<< conda initialize <<<

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
if [ -f "/home/mcbridl/.config/fabric/fabric-bootstrap.inc" ]; then . "/home/mcbridl/.config/fabric/fabric-bootstrap.inc"; fi
