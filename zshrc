#!/bin/zsh

#zmodload zsh/zprof  # uncoment and run zprof for profiling
#SHELL=$(which zsh)

DEFAULT_USER=labianchin

#POWERLEVEL9K_MODE='compatible'
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon load context dir virtualenv vcs)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs rbenv virtualenv history time)

setopt auto_cd              # if a command is issued that can't be executed as a normal command,
                            # and the command is the name of a directory, perform the cd command to that directory
setopt auto_pushd           # make cd push the old directory onto the directory stack.
setopt pushd_ignore_dups    # don't push the same dir twice.
setopt extended_glob        # in order to use #, ~ and ^ for filename generation
                            # grep word *~(*.gz|*.bz|*.bz2|*.zip|*.Z) ->
                            # -> searches for word not in compressed files
                            # don't forget to quote '^', '~' and '#'!
setopt longlistjobs         # display PID when suspending processes as well
setopt notify               # report the status of backgrounds jobs immediately
setopt hash_list_all        # Whenever a command completion is attempted, make sure \
                            # the entire command path is hashed first.
setopt completeinword       # not just at the end
setopt nohup                # and don't kill them, either
setopt nonomatch            # try to avoid the 'zsh: no matches found...'
setopt nobeep               # avoid "beep"ing
setopt noglobdots           # * shouldn't match dotfiles. ever.
setopt noshwordsplit        # use zsh style word splitting

dot_sources=(
  "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  "$HOME/.zplug-setup"
  #".zgen-setup"  # zgen, DEPRECATED
  "$HOME/.myterminalrc"  # custom portable bash/zsh/sh config
  "$HOME/.zshrc.local"  #other portable config
  "/usr/local/opt/fzf/shell/key-bindings.zsh"
  "$HOME/.fzf/shell/key-bindings.zsh"
  )
# if interactive shell: https://stackoverflow.com/questions/31155381/what-does-i-mean-in-bash
[[ $- == *i* ]] && dot_sources+=(
  "/usr/local/opt/fzf/shell/completion.zsh"
  "$HOME/.fzf/shell/completion.zsh"
  "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
)

for dot in $dot_sources; do
  [[ -s "$dot" ]] && source "$dot"
done

_fzf_complete_git() {
    ARGS="$@"
    local branches
    branches=$(git branch --sort=-committerdate -vv)
    if [[ $ARGS == 'git co'* ]] || [[ $ARGS == 'g co'* ]]; then
        _fzf_complete "--reverse --multi" "$@" < <(
            echo $branches
        )
    else
        eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
}

_fzf_complete_git_post() {
    awk '{print $1}'
}
alias _fzf_complete_g=_fzf_complete_git
alias _fzf_complete_g_post=_fzf_complete_git_post

# Setup pyenv and pyenv-virtualenv
#if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
#if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# https://github.com/junegunn/fzf/wiki/Configuring-fuzzy-completion#dedicated-completion-key
export FZF_COMPLETION_TRIGGER=''
bindkey '^T' fzf-completion
bindkey '^I' $fzf_default_completion
