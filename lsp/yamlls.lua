return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose" },
  root_markers = { ".git" },
  settings = {
    yaml = {
      keyOrdering = false,
      format = { enable = false }, -- formatting handled by conform/yamlfmt
    },
  },
}
