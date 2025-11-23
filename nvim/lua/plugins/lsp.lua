return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.servers = opts.servers or {}

    opts.servers.clangd = {
      cmd = { "clangd", "--background-index", "--clang-tidy" },
      mason = false,
    }
  end,
}
