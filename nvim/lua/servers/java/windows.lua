return {
  workspace_folder = os.getenv 'UserProfile' .. 'AppData/Local/Eclipse/',
  bundles = {
    vim.fn.glob(os.getenv 'UserProfile' .. '/AppData/Local/nvim-data/com.microsoft.java.debug.plugin-*.jar'),
    vim.fn.glob(os.getenv 'UserProfile' .. '/AppData/Local/nvim-data/com.microsoft.jdtls.ext.core-*.jar'),
  },
  JDK_PATH = 'C:/Program Files/',
  JAR = vim.fn.glob(os.getenv 'UserProfile' .. '/AppData/Local/nvim-data/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_*.jar'),
  JDT_CONFIG = os.getenv 'UserProfile' .. '/AppData/Local/nvim-data/eclipse.jdt.ls/config_win',
  runtimes = {
    {
      name = 'JavaSE-11',
      path = 'C:/Program Files/Amazon Corretto/jdk11.0.18_10',
    },
  },
}
