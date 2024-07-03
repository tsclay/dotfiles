return {
  workspace_folder = os.getenv 'HOME' .. '/.eclipse/',
  JAR = vim.fn.glob(os.getenv 'HOME' .. '/.local/share/nvim/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_*.jar'),
  JDK_PATH = '/usr/lib/jvm/java-11-amazon-corretto/bin/java',
  JDT_CONFIG = os.getenv 'HOME' .. '/.local/share/nvim/eclipse.jdt.ls/config_linux',
  bundles = {
    vim.fn.glob(os.getenv 'HOME' .. '/.local/share/nvim/com.microsoft.java.debug.plugin-*.jar'),
    vim.fn.glob(os.getenv 'HOME' .. '/.local/share/nvim/com.microsoft.jdtls.ext.core-*.jar'),
    vim.fn.glob(os.getenv 'HOME' .. '/.local/share/nvim/pde/*.jar'),
  },
  runtimes = {
    {
      name = 'JavaSE-11',
      path = '/usr/lib/jvm/java-11-amazon-corretto/bin/java',
    },
    {
      name = 'JavaSE-17',
      path = '/usr/lib/jvm/java-17-amazon-corretto/bin/java',
    },
  },
}
