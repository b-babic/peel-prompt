# Prompt symbol
PEEL_PROMPT_SYMBOL="ben do 🙊"

# Colors
PEEL_COLORS_HOST_ME=green
PEEL_COLORS_HOST_AWS_VAULT=yellow
PEEL_COLORS_CURRENT_DIR=blue
PEEL_COLORS_RETURN_STATUS_TRUE=magenta
PEEL_COLORS_RETURN_STATUS_FALSE=yellow
PEEL_COLORS_GIT_STATUS_DEFAULT=green
PEEL_COLORS_GIT_STATUS_STAGED=red
PEEL_COLORS_GIT_STATUS_UNSTAGED=yellow
PEEL_COLORS_GIT_PROMPT_SHA=green
PEEL_COLORS_BG_JOBS=yellow

# Left Prompt
PROMPT='$(host)$(current_dir)$(bg_jobs)$(return_status)'

# Right Prompt
RPROMPT='$(vcs_status) $(git_prompt_info)'

# Enable redrawing of prompt variables
setopt promptsubst

# Prompt with current SHA
# PROMPT='$(host)$(current_dir)$(bg_jobs)$(return_status)'
# RPROMPT='$(vcs_status)$(git_prompt_short_sha)'

# Host
host() {
  if [[ -n $SSH_CONNECTION ]]; then
    me="%n@%m"
  elif [[ $LOGNAME != $USER ]]; then
    me="%n"
  fi
  if [[ -n $me ]]; then
    echo "%{$fg[$PEEL_COLORS_HOST_ME]%}$me%{$reset_color%}:"
  fi
  if [[ $AWS_VAULT ]]; then
    echo "%{$fg[$PEEL_COLORS_HOST_AWS_VAULT]%}$AWS_VAULT%{$reset_color%} "
  fi
}

# Current directory
current_dir() {
  echo -n "%{$fg[$PEEL_COLORS_CURRENT_DIR]%}%c "
}

# Prompt symbol
return_status() {
  echo -n "%(?.%F{$PEEL_COLORS_RETURN_STATUS_TRUE}.%F{$PEEL_COLORS_RETURN_STATUS_FALSE})$PEEL_PROMPT_SYMBOL%f "
}

# Git status
vcs_status() {
    local message=""
    local message_color="%F{$PEEL_COLORS_GIT_STATUS_DEFAULT}"

    # https://git-scm.com/docs/git-status#_short_format
    local staged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU]")
    local unstaged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU? ][MADRCU?]")

    if [[ -n ${staged} ]]; then
        message_color="%F{$PEEL_COLORS_GIT_STATUS_STAGED}"
    elif [[ -n ${unstaged} ]]; then
        message_color="%F{$PEEL_COLORS_GIT_STATUS_UNSTAGED}"
    fi

    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n ${branch} ]]; then
        message+="${message_color}${branch}%f"
    fi

    echo -n "${message}"
}

# Git prompt SHA
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{%F{$PEEL_COLORS_GIT_PROMPT_SHA}%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%} "

# Background Jobs
bg_jobs() {
  bg_status="%{$fg[$PEEL_COLORS_BG_JOBS]%}%(1j.↓%j .)"
  echo -n $bg_status
}
