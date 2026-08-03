-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- vim.api.nvim_create_autocmd({ 'VimEnter', 'TabNew' }, {
vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  desc = 'Run terminal', -- for programming files.",
  -- pattern = { '*.h', '*.c', '*.cpp', '*.py', '*.sh' },
  nested = true,
  callback = function()
    local height = vim.api.nvim_win_get_height(0)
    height = math.floor((height * 0.25) + 0.5)
    vim.cmd 'split term://zsh'
    vim.cmd('resize ' .. height)
    vim.cmd 'wincmd k'
  end,
})

-- vim.api.nvim_create_autocmd({ 'VimEnter', 'TabNew' }, {
vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  desc = 'Run Neotree filesystem at startup.',
  -- command = "Neotree action=show",
  callback = function()
    local width = vim.api.nvim_win_get_width(0)
    width = math.floor((width * 0.15) + 0.5)
    vim.cmd 'Neotree action=show'
    vim.cmd 'wincmd h'
    vim.cmd('vertical resize ' .. width)
    vim.cmd 'wincmd l'
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*' },
  callback = function(args)
    -- require('conform').format { async = false, lsp_format = 'fallback', range = range }
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Resize CodeCompanion buffers',
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local buf_name = vim.fn.bufname(buf)
    if buf_name:match 'CodeCompanion' then
      -- Only resize if this is the first time entering the buffer
      if not vim.b[buf].codecompanion_resized then
        local width = vim.api.nvim_win_get_width(0)
        width = math.floor((width * 0.60) + 0.5)
        vim.cmd('vertical resize ' .. width)
        vim.b[buf].codecompanion_resized = true
      end
    end
  end,
})

vim.api.nvim_create_autocmd('BufUnload', {
  desc = 'Reset CodeCompanion buffer resize flag',
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local buf_name = vim.fn.bufname(buf)
    if buf_name:match 'CodeCompanion' then
      vim.b[buf].codecompanion_resized = false
    end
  end,
})

vim.api.nvim_create_user_command('DapuiToggle', function()
  local current_tabpage = vim.api.nvim_get_current_tabpage()
  local dapui_id = tonumber(vim.env.dapui_tabpage_id)

  if current_tabpage == dapui_id then
    -- Go to previous tabpage from dap-ui.
    vim.api.nvim_set_current_tabpage(tonumber(vim.env.dapui_prev_tabpage_id))
  else
    -- Save current tabpage and go to dap-ui tabpage.
    vim.g.dapui_prev_tabpage_id = current_tabpage

    if vim.api.nvim_tabpage_is_valid(dapui_id) then
      vim.api.nvim_set_current_tabpage(dapui_id)
    else
      vim.env.dapui_tabpage_id = vim.api.nvim_open_tabpage(0, true, {})
      require('dapui').open()
    end
  end
end, {})

-- [[
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	desc = "Run lsp autoformat after each write for certain files.",
-- 	pattern = {
-- 		"*.c",
-- 		"*.cpp",
-- 		"*.h",
-- 		"*.py",
-- 		"*.sh",
-- 		"*.bash",
-- 		"CMakeLists.txt",
-- 		"*.cmake",
-- 		"*.yml",
-- 		"*.yaml",
-- 		"*.json",
-- 	},
-- 	callback = function()
-- 		vim.lsp.buf.format({ async = false })
-- 	end,
-- })
-- ]]

-- vim.api.nvim_create_autocmd('VimEnter', {
--   desc = 'Run Neotree buffer at startup.',
--   command = 'Neotree action=show source=buffers position=right',
-- })

--[[vim.api.nvim_create_autocmd('VimEnter', {
desc = 'Load terminal debugger on startup'
})]]
