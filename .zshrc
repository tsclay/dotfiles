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
# export LUA_CPATH="./?.so;/usr/local/lib/lua/5.4/?.so;/usr/local/share/lua/5.4/?.so;./?.dylib"
export LUA_CPATH="$LUA_CPATH;$HOME/.local/share/nvim/lazy/lua-json5/lua/json5.dylib"
export JAVA_HOME="/usr/local/opt/openjdk@11/libexec/openjdk.jdk/Contents/Home"
