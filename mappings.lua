-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
function get_git_branch()
    local branch = vim.fn.system('git rev-parse --abbrev-ref HEAD 2>/dev/null')
    return string.gsub(branch, '\n', '')  -- Remove newline character
end
return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map

    -- navigate buffer tabs with `H` and `L`
    -- L = {
    --   function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
    --   desc = "Next buffer",
    -- },
    -- H = {
    --   function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
    --   desc = "Previous buffer",
    -- },

    -- mappings seen under group name "Buffer"
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(
          function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
        )
      end,
      desc = "Pick to close",
    },
    ["<leader>fw"] = {
      function()
        require("telescope").extensions.live_grep_args.live_grep_args()
      end
    },
    ["<leader>gH"] = {
      function()
        local current_buffer = vim.api.nvim_get_current_buf()
        local file_path = vim.api.nvim_buf_get_name(current_buffer)
        local current_directory = vim.fn.getcwd()
        local project_root = vim.fn.finddir('.git', current_directory .. ';')
        local relative_path = vim.fn.fnamemodify(file_path, ":~:" .. project_root)
        local line_number = vim.fn.line('.')
        local branch = get_git_branch()
        os.execute("open https://github.com/krispai/kr-api/blob/" .. branch .. "/" .. relative_path .. "#L" .. line_number)
      end,
      desc = "Open file in github"
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },
    -- quick save
    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
}
