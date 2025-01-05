const completion: Fig.Spec = {
  name: "yazi",
  description: "",
  options: [
    {
      name: "--cwd-file",
      description: "Write the cwd on exit to this file",
      isRepeatable: true,
      args: {
        name: "cwd_file",
        isOptional: true,
        template: "filepaths",
      },
    },
    {
      name: "--chooser-file",
      description: "Write the selected files to this file on open fired",
      isRepeatable: true,
      args: {
        name: "chooser_file",
        isOptional: true,
        template: "filepaths",
      },
    },
    {
      name: "--client-id",
      description: "Use the specified client ID, must be a globally unique number",
      isRepeatable: true,
      args: {
        name: "client_id",
        isOptional: true,
      },
    },
    {
      name: "--local-events",
      description: "Report the specified local events to stdout",
      isRepeatable: true,
      args: {
        name: "local_events",
        isOptional: true,
      },
    },
    {
      name: "--remote-events",
      description: "Report the specified remote events to stdout",
      isRepeatable: true,
      args: {
        name: "remote_events",
        isOptional: true,
      },
    },
    {
      name: "--clear-cache",
      description: "Clear the cache directory",
    },
    {
      name: "--debug",
      description: "Print debug information",
    },
    {
      name: ["-V", "--version"],
      description: "Print version",
    },
    {
      name: ["-h", "--help"],
      description: "Print help",
    },
  ],
  args: {
    name: "entries",
    isVariadic: true,
    isOptional: true,
    template: "filepaths",
  },
};

export default completion;
