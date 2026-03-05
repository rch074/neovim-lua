-- 1. 基本設定（リーダーキーを最優先）
vim.g.mapleader = " "

-- 2. lazy.nvim の本体インストール
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 3. プラグインのセットアップ
require("lazy").setup({
  "nvim-treesitter/nvim-treesitter",
  "neovim/nvim-lspconfig",
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.11.6', -- 安定版を指定
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      -- カレントディレクトリから検索
      vim.keymap.set('n', '<leader>ff', function()
          builtin.find_files({ hidden = true, no_ignore = true })
      end, {})
      -- Cドライブ直下から検索
      vim.keymap.set('n', '<leader>fr', function()
          builtin.find_files({ search_dirs = {"C:/"}, hidden = true, no_ignore = true })
      end, {})
      -- 文字列検索
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      -- Space + fn (config) で、Neovimの設定フォルダ内を検索
      vim.keymap.set('n', '<leader>fn', function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "Search Neovim config files" })
    end
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("nvim-tree").setup({
        -- ディレクトリ同期の設定
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },
        -- トレンドマイクロの監視を除外
        filesystem_watchers = {
          ignore_dirs = {
            "C:/Program Files/Trend Micro",
          },
        },
      })
      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true })
      -- カレントディレクトリを同期
      vim.keymap.set('n', '<leader>cd', ':cd %:p:h<CR>:pwd<CR>')
    end
  },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers", -- バッファをタブとして表示
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "left",
              separator = true
            }
          }
        }
      })
      -- 操作用キーバインド（Alt + 数字 で切り替えなど）
      vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { silent = true })
      vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { silent = true })
    end
  },
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      require'alpha'.setup(require'alpha.themes.startify'.config)
    end
  },
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 12, -- ターミナルの高さ
        open_mapping = [[<C-\>]], -- Ctrl + \ でターミナルを開閉
        direction = 'horizontal', -- 画面下に横長で開く
        -- Neovimのカレントディレクトリで開く設定
        dir = function()
            return vim.fn.getcwd()
        end,
        persist_directory = false, -- 前回のディレクトリを記録しない
        persist_mode = false, -- 前回の入力モードを記録しない
      })
    end
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- oxocarbon は背景色（dark/light）を明示的に指定するのが推奨されています
      vim.opt.background = "dark" 
      vim.cmd([[colorscheme oxocarbon]])
      
      -- すべての背景を「なし」にする関数
      -- 併せて、cmd側でも背景の透明度を90%くらいにしておくとよい
      local function remove_bg()
        local hl_groups = {
          "Normal", "NormalNC", "NormalFloat", "FloatBorder",
          "Terminal", "EndOfBuffer", "LineNr", "CursorLine", "CursorLineNr",
          "SignColumn", "Folded", "FoldColumn", "WindowSeparator",
          "StatusLine", "StatusLineNC", "Pmenu", "PmenuSel", "NvimTreeNormal"
        }
        for _, group in ipairs(hl_groups) do
          vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
        end
      end

      -- 実行
      remove_bg()
      
      -- 斜体回避
      local groups = {
        "Comment", "Keyword", "Statement", "Conditional", "Repeat", 
        "Label", "Operator", "Exception", "Type", "StorageClass", 
        "Structure", "Typedef", "Identifier", "Function"
      }
      for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { italic = false })
      end
    end,
  },
})

-- 4. 見た目・挙動の設定
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autochdir = false 
vim.opt.laststatus = 2
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

-- 起動時にカレントディレクトリをCドライブに変更
-- vim.opt ではなく vim.api.nvim_set_current_dir を使います
vim.api.nvim_set_current_dir("C:/")
