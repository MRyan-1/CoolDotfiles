module completions {

  # Yazi command-line interface
  export extern ya [
    --version(-V)             # Print version
    --help(-h)                # Print help
  ]

  # Emit a command to be executed by the current instance
  export extern "ya emit" [
    name: string              # The name of the command
    ...args: string           # The arguments of the command
    --help(-h)                # Print help
  ]

  # Emit a command to be executed by the specified instance
  export extern "ya emit-to" [
    receiver: string          # The receiver ID
    name: string              # The name of the command
    ...args: string           # The arguments of the command
    --help(-h)                # Print help
  ]

  # Manage packages
  export extern "ya pack" [
    --add(-a): string         # Add a package
    --install(-i)             # Install all packages
    --list(-l)                # List all packages
    --upgrade(-u)             # Upgrade all packages
    --help(-h)                # Print help
  ]

  # Publish a message to the current instance
  export extern "ya pub" [
    kind: string              # The kind of message
    --str: string             # Send the message with a string body
    --json: string            # Send the message with a JSON body
    --list: string            # Send the message as string of list
    --help(-h)                # Print help
  ]

  # Publish a message to the specified instance
  export extern "ya pub-to" [
    receiver: string          # The receiver ID
    kind: string              # The kind of message
    --str: string             # Send the message with a string body
    --json: string            # Send the message with a JSON body
    --list: string            # Send the message as string of list
    --help(-h)                # Print help
  ]

  # Subscribe to messages from all remote instances
  export extern "ya sub" [
    kinds: string             # The kind of messages to subscribe to, separated by commas if multiple
    --help(-h)                # Print help
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ya help" [
  ]

  # Emit a command to be executed by the current instance
  export extern "ya help emit" [
  ]

  # Emit a command to be executed by the specified instance
  export extern "ya help emit-to" [
  ]

  # Manage packages
  export extern "ya help pack" [
  ]

  # Publish a message to the current instance
  export extern "ya help pub" [
  ]

  # Publish a message to the specified instance
  export extern "ya help pub-to" [
  ]

  # Subscribe to messages from all remote instances
  export extern "ya help sub" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ya help help" [
  ]

}

export use completions *
