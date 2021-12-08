# my SSH aliases
alias shmon='ssh mcbridl@monster -p 2112'
alias shmall='ssh mcbridl@smallbox'
alias shkat='ssh mcbridl@katana'
alias shpi='ssh pi@pihole'
alias shkul='ssh -p 781 mcbridl@skull.hopto.org'
alias shdel='ssh mcbridl@192.168.7.107'
alias shclo='ssh mcbridl@192.168.7.117'
alias shprox='ssh root@192.168.7.145'
alias sonarr='ssh mcbridl@192.168.7.121'
alias radarr='ssh mcbridl@192.168.7.122'
alias sabnzb='ssh mcbridl@192.168.7.153'


# micok8s
alias kubectl='microk8s kubectl'

# admin aliases
alias aup='sudo apt update && sudo apt dist-upgrade -y && sudo apt autoremove -y'
alias ls='exa -alF'

# emacs
alias rustemacs='emacs -q --load ./emacs-rust-config/standalone.el'
alias doom='~/.emacs.d/bin/doom'

#function apt-updater {
#	sudo apt update &&
#	sudo apt dist-upgrade -Vy &&
#	sudo apt autoremove -y &&
#	sudo apt autoclean &&
#	sudo apt clean &&
#	}

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
alias h='history'
alias j="jobs -l"
alias l="exa -alF "
alias ll="exa -alF"
alias ls="exa -alF"
alias pu="pushd"
alias po="popd"

#
# Csh compatibility:
#
alias unsetenv=unset
function setenv () {
  export $1="$2"
}

# Function which adds an alias to the current shell and to
# the ~/.bash_aliases file.
add-alias ()
{
   local name=$1 value="$2"
   echo alias $name=\'$value\' >>~/.bash_aliases
   eval alias $name=\'$value\'
   alias $name
}

# "repeat" command.  Like:
#
#	repeat 10 echo foo
repeat ()
{ 
    local count="$1" i;
    shift;
    for i in $(_seq 1 "$count");
    do
        eval "$@";
    done
}

# Subfunction needed by `repeat'.
_seq ()
{ 
    local lower upper output;
    lower=$1 upper=$2;

    if [ $lower -ge $upper ]; then return; fi
    while [ $lower -lt $upper ];
    do
	echo -n "$lower "
        lower=$(($lower + 1))
    done
    echo "$lower"
}
