return {
  settings = {
    powershell = {
      codeFormatting = {
        -- addWhitespaceAroundPipe = true,
        -- alignPropertyValuePairs = true,
        -- autoCorrectAliases = false,
        -- avoidSemicolonsAsLineTerminators = true,
        ignoreOneLineBlock = true,
        newLineAfterCloseBrace = false,
        newLineAfterOpenBrace = false,
        openBraceOnSameLine = true,
        -- pipelineIndentationStyle = 'NoIndentation',
        preset = 'Custom',
        -- trimWhitespaceAroundPipe = false,
        -- useConstantStrings = false,
        -- useCorrectCasing = false,
        -- whitespaceAfterSeparator = true,
        -- whitespaceAroundOperator = true,
        -- whitespaceAroundPipe = true,
        whitespaceBeforeOpenBrace = true,
        whitespaceBeforeOpenParen = true,
        -- whitespaceBetweenParameters = false,
        whitespaceInsideBrace = true,
      },
      scriptAnalysis = { 
        -- settingsPath = require('tclay.utils').get_home() .. '/AppData/Local/nvim/PSScriptAnalyzerSettings.psd1',
        settingsPath = 'PSScriptAnalyzerSettings.psd1',
      },
    },
  },
  filetype = { 'ps1', 'psd1', 'psm1' },
}
