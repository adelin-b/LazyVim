return {
  { "nvim-neotest/neotest-plenary" },
  { "nvim-neotest/neotest-jest" },
  { "nvim-neotest/neotest-python" },
  { "rouge8/neotest-rust" },
  {
    "nvim-neotest/neotest",
    opts = { adapters = { "neotest-plenary", "neotest-jest", "neotest-python", "neotest-rust" } },
  },
}
