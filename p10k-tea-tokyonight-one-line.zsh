
##############################################################
# Tea Tokyo Night — One Line Edition V3 (No Icons)
# Combines:
#  - p10k-tea-one-line.zsh
#  - p10k-tea-tokyonight.zsh
#  - Enhanced with DevOps tools (nvm, python, k8s, aws, gcloud)
# Optimized for:
#  - Node.js Development (console.log heavy)
#  - Backend & DevOps (Python, K8s, Cloud)
#  - Readability
#  - Thai-safe rendering
#  - Minimal one-line prompt with Tokyo Night colors
#  - NO ICONS (text-only for cleaner look)
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
# PROMPT ELEMENTS (Minimal but powerful for DevOps)
##############################################################
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  dir        # Directory
  vcs        # Git
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status                  # Exit code
  command_execution_time  # Duration
  background_jobs         # Background jobs indicator
  nvm                     # Node.js version (from nvm)
  virtualenv              # Python virtual environment
  kubecontext             # Kubernetes context
  aws                     # AWS profile
  gcloud                  # Google Cloud project
  time                    # Current time
)

##############################################################
# ICON SETTINGS (ปิด icons ทั้งหมด)
##############################################################
# ใช้ 'compatible' mode = ไม่มี icons
typeset -g POWERLEVEL9K_MODE='compatible'

# หรือถ้าต้องการใช้ nerdfont แต่ปิด icon เฉพาะ segment:
# typeset -g POWERLEVEL9K_MODE='nerdfont-complete'
# typeset -g POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION=''
# typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=''

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

### Background Jobs ###
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=220
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=237

### NVM (Node.js) ###
typeset -g POWERLEVEL9K_NVM_FOREGROUND=114   # Green
typeset -g POWERLEVEL9K_NVM_BACKGROUND=238
typeset -g POWERLEVEL9K_NVM_SHOW_ON_UPGLOB=false

### Python Virtualenv ###
typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=220   # Yellow
typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND=238
typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false

### Kubernetes ###
typeset -g POWERLEVEL9K_KUBECONTEXT_FOREGROUND=81   # Cyan
typeset -g POWERLEVEL9K_KUBECONTEXT_BACKGROUND=237
typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_DEFAULT_NAMESPACE=true

### AWS ###
typeset -g POWERLEVEL9K_AWS_FOREGROUND=208   # Orange
typeset -g POWERLEVEL9K_AWS_BACKGROUND=237

### Google Cloud ###
typeset -g POWERLEVEL9K_GCLOUD_FOREGROUND=75   # Light blue
typeset -g POWERLEVEL9K_GCLOUD_BACKGROUND=237

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
# INSTANT PROMPT MODE
##############################################################
typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

##############################################################
# SEGMENT VISIBILITY (Show only when relevant)
##############################################################
# NVM: Show only when package.json exists
typeset -g POWERLEVEL9K_NVM_SHOW_ON_UPGLOB='package.json'

# Virtualenv: Show only when inside virtualenv
typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=false

# Kubernetes: Hide default context to reduce noise
typeset -g POWERLEVEL9K_KUBECONTEXT_CLASSES=(
  '*'         KUBECONTEXT
)

# AWS: Show only when AWS_PROFILE is set
# Google Cloud: Show only when gcloud config is active

##############################################################
# LOAD ENGINE
##############################################################
[[ -n "$POWERLEVEL9K_MODULES_DIR" ]] || return
source "$POWERLEVEL9K_MODULES_DIR/powerlevel9k.zsh-theme"
