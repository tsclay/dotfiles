if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config ~/.config/zash.omp.json)"
fi

nvim=~/nvim-macos/bin/nvim
export EDITOR=nvim

# pnpm
export PNPM_HOME="/Users/timclay/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
