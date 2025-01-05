
use builtin;
use str;

set edit:completion:arg-completer[yazi] = {|@words|
    fn spaces {|n|
        builtin:repeat $n ' ' | str:join ''
    }
    fn cand {|text desc|
        edit:complex-candidate $text &display=$text' '(spaces (- 14 (wcswidth $text)))$desc
    }
    var command = 'yazi'
    for word $words[1..-1] {
        if (str:has-prefix $word '-') {
            break
        }
        set command = $command';'$word
    }
    var completions = [
        &'yazi'= {
            cand --cwd-file 'Write the cwd on exit to this file'
            cand --chooser-file 'Write the selected files to this file on open fired'
            cand --client-id 'Use the specified client ID, must be a globally unique number'
            cand --local-events 'Report the specified local events to stdout'
            cand --remote-events 'Report the specified remote events to stdout'
            cand --clear-cache 'Clear the cache directory'
            cand --debug 'Print debug information'
            cand -V 'Print version'
            cand --version 'Print version'
            cand -h 'Print help'
            cand --help 'Print help'
        }
    ]
    $completions[$command]
}
