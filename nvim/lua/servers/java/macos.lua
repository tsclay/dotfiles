return {
  workspace_folder = os.getenv 'HOME' .. '/.eclipse/',
  JAR = vim.fn.glob(os.getenv 'HOME' .. '/.local/share/nvim/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_*.jar'),
  JDK_PATH = '/Library/Java/JavaVirtualMachines/jdk-17.0.2.jdk/Contents/Home/bin/java',
  JDT_CONFIG = os.getenv 'HOME' .. '/.local/share/nvim/eclipse.jdt.ls/config_mac',
  bundles = {
    vim.fn.glob(os.getenv 'HOME' .. '/.local/share/nvim/com.microsoft.java.debug.plugin-*.jar'),
    vim.fn.glob(os.getenv 'HOME' .. '/.local/share/nvim/com.microsoft.jdtls.ext.core-*.jar'),
    vim.fn.glob(os.getenv 'HOME' .. '/.local/share/nvim/pde/*.jar'),
  },
  runtimes = {
    {
      name = 'JavaSE-11',
      path = '/usr/local/opt/openjdk@11/libexec/openjdk.jdk/Contents/Home',
    },
    {
      name = 'JavaSE-21',
      path = '/usr/local/Cellar/openjdk/21.0.1',
    },
  },
}
