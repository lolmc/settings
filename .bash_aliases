# config file editing and source aliases
alias sbal='source ~/.bash_aliases'
alias ebal='nvim ~/.bash_aliases'
alias sbrc='source ~/.bashrc'
alias ebrc='nvim ~/.bashrc'
alias ei3='nvim ~/.config/i3/config'
alias econk='nvim ~/.config/conky/conkyrc'
alias ealac='nvim /home/mcbridl/.config/alacritty/alacritty.toml'
alias etmux='nvim /home/mcbridl/.config/tmux/tmux.local.conf'
alias eneo='nvim ~/.config/nvim/init.lua'

# my SSH aliases
alias ssha='(eval$ssh-agent) && ssh-add'
alias shkat='ssh mcbridl@192.168.7.51'
alias shcal='ssh mcbridl@192.168.7.57'
alias shnc='ssh mcbridl@192.168.7.60'
alias shpi='ssh mcbridl@192.168.7.50'
alias nems='ssh adm_mcbridl@192.168.7.109'
alias shc3='ssh -p 2112 mcbridl@192.168.7.63'

# Directory navigation
alias ..='cd ..'
alias .2='cd ../../'

# File management with prompts
alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'
alias ln='ln -i'
alias mkdir='mkdir -pv'

# command aliases
alias ktmux='tmux kill-server'
alias tmux='tmux -f /home/mcbridl/.config/oh-my-tmux/.tmux.conf.local'
#alias cd='z'
alias za='zoxide add'
alias ze='zoxide edit'
alias zi='zoxide import'
alias zq='zoxide query'
alias zr='zoxide remove'
alias upmod="ollama list | awk 'NR>1 {print \$1}' | xargs -I {} sh -c 'echo
\"Updating model: {}\"; ollama pull {}; echo \"--\"' && echo \"All models updated.\""

#git aliases
alias config='/usr/bin/git --git-dir=/home/mcbridl/.cfg/ --work-tree=/home/mcbridl'

# zellij aliases
alias zrust='zellij -c /home/mcbridl/.config/zellij/config.kdl -l /home/mcbridl/.config/zellij/layouts/rust.kdl'
alias zrust2='zellij -c /home/mcbridl/.config/zellij/config.kdl -l /home/mcbridl/.config/zellij/layouts/rust2.kdl'
alias zellij='zellij -c /home/mcbridl/.config/zellij/newconf.kdl -l /home/mcbridl/.config/zellij/layouts/multi.kdl'
alias rust-dev='zellij -c /home/mcbridl/.config/zellij/config.kdl -l /home/mcbridl/.config/zellij/layouts/rust-dev.kdl'
alias myz="zellij -c /home/mcbridl/.config/zellij/config.kdl -l /home/mcbridl/.config/zellij/layouts/my.kdl"

# nvim aliases
alias nvim="nvim -u /home/mcbridl/.config/nvim/init.lua"
alias lazy="nvim -u /home/mcbridl/.config/nvim/init.lua"

# topgrade alias
alias topgrade='/home/mcbridl/.cargo/bin/topgrade --skip-notify -y'

# micok8s
alias kubectl='microk8s kubectl'

# admin aliases
alias please='sudo'
alias pls='sudo'
alias plz='sudo'
alias du='ncdu'
alias df='pydf'
alias myip='curl http://ipecho.net/plain; echo'
alias path='echo -e ${PATH//:/\\n} | less'

# ls exa aliases
alias exa='exa -alF --octal-permissions'
alias l='exa -alF --octal-permissions'
alias ll='exa -alF --octal-permissions'
alias ls='exa -alF --octal-permissions'

# other aliases
alias h='history'
alias j="jobs -l"
alias pu="pushd"
alias po="popd"

# emacs
alias rustemacs='emacs -q --load ./emacs-rust-config/standalone.el'
alias doom='~/.emacs.d/bin/doom'

# Some useful aliases.
alias texclean='rm -f *.toc *.aux *.log *.cp *.fn *.tp *.vr *.pg *.ky'
alias clean='echo -n "Really clean this directory?";
	read yorn;
	if test "$yorn" = "y"; then
	   rm -f \#* *~ .*~ *.bak .*.bak  *.tmp .*.tmp core a.out;
	   echo "Cleaned.";
	else
	   echo "Not cleaned.";
	fi'

#
# Csh compatibility:
#
alias unsetenv=unset
function setenv() {
	export $1="$2"
}

# Function which adds an alias to the current shell and to
# the ~/.bash_aliases file.
add-alias() {
	local name=$1 value="$2"
	echo alias $name=\'$value\' >>~/.bash_aliases
	eval alias $name=\'$value\'
	alias $name
}

# "repeat" command.  Like:
#
#	repeat 10 echo foo
repeat() {
	local count="$1" i
	shift
	for i in $(_seq 1 "$count"); do
		eval "$@"
	done
}

# Subfunction needed by `repeat'.
_seq() {
	local lower upper output
	lower=$1 upper=$2

	if [ $lower -ge $upper ]; then return; fi
	while [ $lower -lt $upper ]; do
		echo -n "$lower "
		lower=$(($lower + 1))
	done
	echo "$lower"
}
