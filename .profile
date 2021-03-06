source ~/.git-completion.bash

# aliases
alias ls='ls -GFh'
alias igrep='grep -Ir --exclude="*.svn\*"'
alias delpyc='find . -name "*.pyc" -exec rm -fv {} \;'
alias pgstart='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pgstop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
alias cpwd='pwd|xargs echo -n|pbcopy'
alias lock='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
alias git='hub'
alias runsnake='arch -i386 pythonw /usr/local/bin/raw_runsnake'

# shell variables
export EDITOR='mvim -f -c "au VimLeave * !open -a Terminal"'
export TERM="xterm-color"

# virtualenv
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
export PIP_RESPECT_VIRTUALENV=true

# rabbitmq
export PATH=$PATH:/usr/local/sbin

#### PS1 customization ####
NONE="\[\033[0m\]"    # unsets color to term fg color

# regular colors
K="\[\033[0;30m\]"    # black
R="\[\033[0;31m\]"    # red
G="\[\033[0;32m\]"    # green
Y="\[\033[0;33m\]"    # yellow
B="\[\033[0;34m\]"    # blue
M="\[\033[0;35m\]"    # magenta
C="\[\033[0;36m\]"    # cyan
W="\[\033[0;37m\]"    # white

# emphasized (bolded) colors
EMK="\[\033[1;30m\]"
EMR="\[\033[1;31m\]"
EMG="\[\033[1;32m\]"
EMY="\[\033[1;33m\]"
EMB="\[\033[1;34m\]"
EMM="\[\033[1;35m\]"
EMC="\[\033[1;36m\]"
EMW="\[\033[1;37m\]"

# background colors
BGK="\[\033[40m\]"
BGR="\[\033[41m\]"
BGG="\[\033[42m\]"
BGY="\[\033[43m\]"
BGB="\[\033[44m\]"
BGM="\[\033[45m\]"
BGC="\[\033[46m\]"
BGW="\[\033[47m\]"


# displays only the last 25 characters of pwd
set_new_pwd() {
    # How many characters of the $PWD should be kept
    local pwdmaxlen=25
    # Indicate that there has been dir truncation
    local trunc_symbol=".."
    local dir=${PWD##*/}
    pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
    NEW_PWD=${PWD/#$HOME/\~}
    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
    if [ ${pwdoffset} -gt "0" ]
    then
        NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
        NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
    fi
}

# the name of the git branch in the current directory
set_git_branch() {
    unset GIT_BRANCH
    local branch=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /'`;
    
    if test $branch
        then
            GIT_BRANCH="${EMG}git:${NONE}$branch"
    fi
}

# revision of the svn repo in the current directory
set_svn_rev() {
    unset SVN_REV
    local rev=`svn info 2> /dev/null | grep "Revision" | sed 's/Revision: \(.*\)/r\1 /'`;
    
    if test $rev
        then
            SVN_REV="${EMG}svn:${NONE}$rev"
    fi
}

# the name of the activated virtual env
set_virtual_env_base() {
    unset VIRTUAL_ENV_BASE
    local venv=`basename "$VIRTUAL_ENV"`
    
    if test $venv
        then
            VIRTUAL_ENV_BASE="${EMG}env:${NONE}$venv "
    fi
}

update_prompt() {
    set_new_pwd
    set_git_branch
    set_svn_rev
    set_virtual_env_base
    
    PS1="${EMB}[${NONE}${NEW_PWD}${EMB}] ${GIT_BRANCH}${SVN_REV}${VIRTUAL_ENV_BASE}${B}\$ ${NONE}"
}

PROMPT_COMMAND=update_prompt

# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end
export YOURMOM=fat
export PIP_RESPECT_VIRTUALENV=true
