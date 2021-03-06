#OktaAWSCLI
if [[ -f "$HOME/.okta/bash_functions" ]]; then
    . "$HOME/.okta/bash_functions"
fi
if [[ -d "$HOME/.okta/bin" && ":$PATH:" != *":$HOME/.okta/bin:"* ]]; then
    PATH="$HOME/.okta/bin:$PATH"
fi

# Set JAVA_HOME to JDK10 for now
#export JAVA_HOME=$(/usr/libexec/java_home)
export JAVA_HOME=/Library/Java/Home_Java11

# If you come from bash you might have to change your $PATH.

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="ys"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  docker
  aws
  brew
  mvn
  tig
  vi-mode
  tmux
  rust
  history
)

source $ZSH/oh-my-zsh.sh

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

export MYVIMRC="~/.config/nvim/init.vim"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

if [[ $(uname) = 'Linux' ]]; then
    export VIMRUNTIME=~/neovim/runtime
fi

### Aliases
alias ls=~/.cargo/bin/lsd
alias brewup="brew upgrade; brew outdated --cask --greedy | cut -d ' ' -f 1 | xargs brew reinstall --cask"
alias _ssh="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
alias open_failed="rg -e 'status.*failed' -e 'status.*error' target/cucumber_results_html/*/report.js --files-with-matches |awk -F/ '{print \$3}' |xargs -I {} open target/cucumber_results_html/{}/index.html"
alias ldd="otool -L"


# SK
alias skb=" sk -b 'ctrl-o:execute(open {}),ctrl-v:execute(nvim {})' "

# Search for command in history and execute
alias he="history |cut -c 8- | sk | zsh -x"

# For StudyBlue db migrate
alias sbmigrate_prod="migrate --env=prod"

# Update entries (for Boostnote and vim-wiki)
alias update_entries="git add .; git commit -m \"Updating entries\"; git push"

# Print out all robot test scenarios.  Assume in a directory that has robot files
alias robot_tests="l |rg -v ^d|awk \"{print $11}\"| xargs cat | rg \"^[a-zA-Z]\" |rg -i -v -e \"Library\" -e \"Resource\" -e \"Test_Teardown\" -e \"Documentation\" -e \"Test Teardown\" -e \"Set up\""

# Clear DNS cache
alias dns_clear="sudo dscacheutil -flushcache"

# Automate Okta-AWS login
alias okta-docker-login="okta-aws chegg-aws-shared-nonprod ecr get-login-password | docker login --username AWS --password-stdin 342484191705.dkr.ecr.us-west-2.amazonaws.com"
alias okta-robot-login="okta-aws default sts get-caller-identity"
alias okta-login="okta-robot-login; okta-docker-login"

# git pull all subdirectories
alias git_pull_all="ls -l|awk '{print \$11}' | xargs -I {} sh -c \"echo {}; cd {}; git pull; cd ..\" "

## Prod Proxy
# Pre-reqs: 
# https://chegg.atlassian.net/wiki/spaces/DevOps/pages/1331580/Okta+ASA+Start+Here
# https://chegg.atlassian.net/wiki/spaces/~jandrade@chegg.com/pages/298649559/How+to+Set+Up+a+SOCKS5+SSH+Tunnel+for+Production+Access
alias prodproxy="kill \$(lsof -i :9080 | awk 'NR>1 {print \$2}' | uniq); kill \$(lsof -i :9081 | awk 'NR>1 {print \$2}' | uniq); ssh -fqN -D 9080 jump01.core2.cloud.cheggnet.com -o ExitOnForwardFailure=yes && hpts -s localhost:9080 -p 9081 > /dev/null 2>&1 &"

## Docker aliases
# Start container for growth-enablement-tests
alias docker_start_gce="docker run -v /Users/paul/.aws/:/root/.aws -v /Users/paul/Chegg/robot-for-chegg-com:/root/robot/tmp/robot-for-chegg-com -v /Users/paul/Chegg/gne/growth-enablement-robot-tests:/mnt/tests --name urf --entrypoint bash -p 5910:5910 -d 342484191705.dkr.ecr.us-west-2.amazonaws.com/robot-for-chegg-com:latest /root/robot/robot/helpers/vnc-start.sh"

# bring all running docker containers down
alias docker_all_down="docker ps -a |rg -v CONTAINER |awk '{print \$1}' |xargs docker rm -f"

# Clean up any "orphaned" docker images 
alias docker_cleanup_images="docker rmi \$(docker images -qa -f \"dangling=true\"); docker images|rg none|awk '{print $3}'|xargs docker rmi 2> /dev/null"


# For https://github.com/euank/pazi
if command -v pazi &>/dev/null; then
  eval "$(pazi init zsh)"
  alias js='z --pipe="sk"'
  alias j='z'
fi

# pipenv issue - https://github.com/pypa/pipenv/issues/538 
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Neovim as default editor
export EDITOR='nvim'

# Ignore dups when scrolling through shell history
export HISTCONTROL=ignoredups

# Help with compiling Nim on MacOS
export CPATH=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include
export LIBRARY_PATH=$LIBRARY_PATH:/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/lib

export PATH=.:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:/usr/local/opt/llvm/bin:$JAVA_HOME/bin:/usr/local/bin:~/.cargo/bin:~/.nimble/bin:~/.vmodules/bin:~/.local/bin:/bin:$PATH
