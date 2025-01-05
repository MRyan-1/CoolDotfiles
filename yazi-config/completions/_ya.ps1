
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName 'ya' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'ya'
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
        'ya' {
            [CompletionResult]::new('-V', '-V ', [CompletionResultType]::ParameterName, 'Print version')
            [CompletionResult]::new('--version', '--version', [CompletionResultType]::ParameterName, 'Print version')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('emit', 'emit', [CompletionResultType]::ParameterValue, 'Emit a command to be executed by the current instance')
            [CompletionResult]::new('emit-to', 'emit-to', [CompletionResultType]::ParameterValue, 'Emit a command to be executed by the specified instance')
            [CompletionResult]::new('pack', 'pack', [CompletionResultType]::ParameterValue, 'Manage packages')
            [CompletionResult]::new('pub', 'pub', [CompletionResultType]::ParameterValue, 'Publish a message to the current instance')
            [CompletionResult]::new('pub-to', 'pub-to', [CompletionResultType]::ParameterValue, 'Publish a message to the specified instance')
            [CompletionResult]::new('sub', 'sub', [CompletionResultType]::ParameterValue, 'Subscribe to messages from all remote instances')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'ya;emit' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'ya;emit-to' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'ya;pack' {
            [CompletionResult]::new('-a', '-a', [CompletionResultType]::ParameterName, 'Add a package')
            [CompletionResult]::new('--add', '--add', [CompletionResultType]::ParameterName, 'Add a package')
            [CompletionResult]::new('-i', '-i', [CompletionResultType]::ParameterName, 'Install all packages')
            [CompletionResult]::new('--install', '--install', [CompletionResultType]::ParameterName, 'Install all packages')
            [CompletionResult]::new('-l', '-l', [CompletionResultType]::ParameterName, 'List all packages')
            [CompletionResult]::new('--list', '--list', [CompletionResultType]::ParameterName, 'List all packages')
            [CompletionResult]::new('-u', '-u', [CompletionResultType]::ParameterName, 'Upgrade all packages')
            [CompletionResult]::new('--upgrade', '--upgrade', [CompletionResultType]::ParameterName, 'Upgrade all packages')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'ya;pub' {
            [CompletionResult]::new('--str', '--str', [CompletionResultType]::ParameterName, 'Send the message with a string body')
            [CompletionResult]::new('--json', '--json', [CompletionResultType]::ParameterName, 'Send the message with a JSON body')
            [CompletionResult]::new('--list', '--list', [CompletionResultType]::ParameterName, 'Send the message as string of list')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'ya;pub-to' {
            [CompletionResult]::new('--str', '--str', [CompletionResultType]::ParameterName, 'Send the message with a string body')
            [CompletionResult]::new('--json', '--json', [CompletionResultType]::ParameterName, 'Send the message with a JSON body')
            [CompletionResult]::new('--list', '--list', [CompletionResultType]::ParameterName, 'Send the message as string of list')
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'ya;sub' {
            [CompletionResult]::new('-h', '-h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', '--help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'ya;help' {
            [CompletionResult]::new('emit', 'emit', [CompletionResultType]::ParameterValue, 'Emit a command to be executed by the current instance')
            [CompletionResult]::new('emit-to', 'emit-to', [CompletionResultType]::ParameterValue, 'Emit a command to be executed by the specified instance')
            [CompletionResult]::new('pack', 'pack', [CompletionResultType]::ParameterValue, 'Manage packages')
            [CompletionResult]::new('pub', 'pub', [CompletionResultType]::ParameterValue, 'Publish a message to the current instance')
            [CompletionResult]::new('pub-to', 'pub-to', [CompletionResultType]::ParameterValue, 'Publish a message to the specified instance')
            [CompletionResult]::new('sub', 'sub', [CompletionResultType]::ParameterValue, 'Subscribe to messages from all remote instances')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'ya;help;emit' {
            break
        }
        'ya;help;emit-to' {
            break
        }
        'ya;help;pack' {
            break
        }
        'ya;help;pub' {
            break
        }
        'ya;help;pub-to' {
            break
        }
        'ya;help;sub' {
            break
        }
        'ya;help;help' {
            break
        }
    })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
        Sort-Object -Property ListItemText
}
