
##############################################################
# Tea Tokyo Night — One Line Edition (Unified Version)
# Combines:
#  - p10k-tea-one-line.zsh
#  - p10k-tea-tokyonight.zsh
# Optimized for:
#  - Node.js Development (console.log heavy)
#  - Readability
#  - Thai-safe rendering
#  - Minimal one-line prompt with Tokyo Night colors
##############################################################

# Instant prompt (must be first)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

##############################################################
# ONE-LINE LAYOUT
##############################################################
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=
typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '

##############################################################
# PROMPT ELEMENTS (Minimal for Node.js development)
##############################################################
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  dir        # Directory
  vcs        # Git
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status
  command_execution_time
  time
)

##############################################################
# NERD FONT ENABLED
##############################################################
typeset -g POWERLEVEL9K_MODE='nerdfont-complete'

##############################################################
# TOKYO NIGHT PALETTE (Carefully unified)
##############################################################

### Directory colors ###
typeset -g POWERLEVEL9K_DIR_FOREGROUND=110   # Bright blue
typeset -g POWERLEVEL9K_DIR_BACKGROUND=236
typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
typeset -g POWERLEVEL9K_SHORTEN_DELIMITER='…'

### Git section ###
typeset -g POWERLEVEL9K_VCS_FOREGROUND=141   # Purple
typeset -g POWERLEVEL9K_VCS_BACKGROUND=238
typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=false
typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1

### Status (red when error) ###
typeset -g POWERLEVEL9K_STATUS_OK=false
typeset -g POWERLEVEL9K_STATUS_ERROR=true
typeset -g POWERLEVEL9K_STATUS_FOREGROUND=15
typeset -g POWERLEVEL9K_STATUS_BACKGROUND=161

### Execution Time ###
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=1200
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=178
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=237
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=2

### Time Display ###
typeset -g POWERLEVEL9K_TIME_FOREGROUND=117
typeset -g POWERLEVEL9K_TIME_BACKGROUND=238
typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'

### Prompt symbol (Tokyo Night blue) ###
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS='❯'
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS='❯'
typeset -g POWERLEVEL9K_PROMPT_CHAR_FOREGROUND=81

##############################################################
# THAI-SAFE SETTINGS (prevent spacing issues)
##############################################################
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
typeset -g POWERLEVEL9K_ICON_PADDING=1

##############################################################
# LOAD ENGINE
##############################################################
[[ -n "$POWERLEVEL9K_MODULES_DIR" ]] || return
source "$POWERLEVEL9K_MODULES_DIR/powerlevel9k.zsh-theme"
