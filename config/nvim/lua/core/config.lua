vim.g.coq_settings = {
  auto_start = "shut-up",
  clients = {
    lsp = {
      enabled = false,
    },
    snippets = {
      enabled = false,
      warn = {},
    },
    tree_sitter = {
      enabled = true,
      weight_adjust = 1.3,
    },
    tags = {
      enabled = true,
      weight_adjust = 1.2,
    },
    paths = {
      enabled = true,
      weight_adjust = 0.9,
    },
    buffers = {
      enabled = true,
      weight_adjust = 1.1,
    },
    tmux = {
      enabled = false,
    },
    third_party = {
      enabled = false,
    },
  }
}
