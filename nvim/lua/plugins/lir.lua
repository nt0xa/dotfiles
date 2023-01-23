return {
  "tamago324/lir.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local actions = require'lir.actions'
    local mark_actions = require 'lir.mark.actions'
    local clipboard_actions = require'lir.clipboard.actions'

    require'lir'.setup {
      show_hidden_files = false,
      mappings = {
        ['l']     = actions.edit,
        ['<CR>']  = actions.edit,

        ['h']     = actions.up,
        ['q']     = actions.quit,

        ['N']     = actions.mkdir,
        ['n']     = actions.newfile,
        ['r']     = actions.rename,
        ['Y']     = actions.yank_path,
        ['.']     = actions.toggle_show_hidden,
        ['D']     = actions.delete,

        ['<space>'] = function()
          mark_actions.toggle_mark()
          vim.cmd("normal! j")
        end,
        ['y'] = clipboard_actions.copy,
        ['d'] = clipboard_actions.cut,
        ['p'] = clipboard_actions.paste,
      },
      hide_cursor = true
    }

    vim.keymap.set("n", "<leader>d", require'lir.float'.toggle, {})

    -- Mark multiple item using visual mode
    vim.api.nvim_create_autocmd({'FileType'}, {
      pattern = {"lir"},
      callback = function()
        -- use visual mode
        vim.api.nvim_buf_set_keymap(
          0,
          "x",
          "<space>",
          ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
          { noremap = true, silent = true }
        )

        -- Show current directory
        vim.api.nvim_echo({ { vim.fn.expand("%:p"), "Normal" } }, false, {})
      end
    })
  end
}

