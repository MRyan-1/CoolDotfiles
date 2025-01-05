
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName 'yazi' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'yazi'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-') -or
                $element.Value -eq $wordToComplete) {
                break
        }
        $element.Value
    }) -join ';'

    $completions = @(switch ($command) {
        'yazi' {
            [CompletionResult]::new('--cwd-file', '--cwd-file', [CompletionResultType]::ParameterName, 'Write the cwd on exit to this file')
            [CompletionResult]::new('--chooser-file', '--chooser-file', [CompletionResultType]::ParameterName, 'Write the selected files to this file on open fired')
            [CompletionResult]::new('--client-id', '--client-id', [CompletionResultType]::ParameterName, 'Use the specified client ID, must be a globally unique number')
            [CompletionResult]::new('--local-events', '--local-events', [CompletionResultType]::ParameterName, 'Report the specified local events to stdout')
            [CompletionResult]::new('--remote-events', '--remote-events', [CompletionResultType]::ParameterName, 'Report the specified remote events to stdout')
            [CompletionResult]::new('--clear-cache', '--clear-cache', [CompletionResultType]::ParameterName, 'Clear the cache directory')
            [CompletionResult]::new('--debug', '--debug', [CompletionResultType]::ParameterName, 'Print debug information')
            [CompletionResult]::new('-V', '-V ', [CompletionResultType]::ParameterName, 'Print version')
            [CompletionResult]::new('--version', '--version', [CompletionResultType]::ParameterName, 'Print version')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
    })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
        Sort-Object -Property ListItemText
}
