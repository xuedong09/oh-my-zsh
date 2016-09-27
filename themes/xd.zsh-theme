# the idea of this theme is to contain a lot of info in a small string, by
# compressing some parts and colorcoding, which bring useful visual cues,
# while limiting the amount of colors and such to keep it easy on the eyes.
# When a command exited >0, the timestamp will be in red and the exit code
# will be on the right edge.
# The exit code visual cues will only display once.
# (i.e. they will be reset, even if you hit enter a few times on empty command prompts)

# modified by xd

typeset -A host_repr

# translate hostnames into shortened, colorcoded strings
host_repr=('dieter-ws-a7n8x-arch' "%{$fg_bold[green]%}ws" 'dieter-p4sci-arch' "%{$fg_bold[blue]%}p4")

# user part, color coded by privileges
local user="%(!.%{$fg[green]%}.%{$fg[red]%})%n%{$reset_color%}"

# Hostname part.  compressed and colorcoded per host_repr array
# if not found, regular hostname in default color
local host="@${host_repr[$HOST]:-$HOST}%{$reset_color%}"

# author: xd move from smt
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[blue]%}✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[magenta]%}➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[yellow]%}═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[cyan]%}✭"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$fg_bold[brown]%}:%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""

#change by xd: use absolute path
local pwd="%{$terminfo[bold]$fg[green]%} %~%{$reset_color%}"
PROMPT='
${user}${pwd}$(git_prompt_short_sha)$(git_prompt_info)$(git_prompt_status)%{$reset_color%}
> '


# elaborate exitcode on the right when >0
return_code_enabled="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
return_code_disabled=
return_code=$return_code_enabled

RPS1='${return_code}'

function accept-line-or-clear-warning () {
	if [[ -z $BUFFER ]]; then
		time=$time_disabled
		return_code=$return_code_disabled
	else
		time=$time_enabled
		return_code=$return_code_enabled
	fi
	zle accept-line
}
zle -N accept-line-or-clear-warning
bindkey '^M' accept-line-or-clear-warning
