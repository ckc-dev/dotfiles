require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  ignore_install = { "kdl" },
  sync_install = true,
  auto_install = true,
  highlight = { enable = true },
}
