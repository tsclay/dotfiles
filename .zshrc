if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config ~/.config/zash.omp.json)"
fi

nvim=~/nvim-macos/bin/nvim
export EDITOR=nvim


jdk() {
      version=$1
      unset JAVA_HOME;
      export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
      java -version
}

# pnpm
export PNPM_HOME="/Users/timclay/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
export PATH="/Library/Java/JavaVirtualMachines/jdk-17.0.2.jdk/Contents/Home/bin:$PATH"
