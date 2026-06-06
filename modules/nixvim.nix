{ config, pkgs, lib, ... }:

{
  programs.nixvim = {
    enable = true;

    # ── System Packages & Dependencies ──────────────────────────────────────
    extraPackages = with pkgs; [
      fd
      ripgrep
      # Formatters & Linters
      stylua
      black
      isort
      ruff
      prettier
      nixpkgs-fmt
    ];

    # ── External Raw Plugins ────────────────────────────────────────────────
    extraPlugins = with pkgs.vimPlugins; [
      alpha-nvim
      git-conflict-nvim  # Inline git merge conflict resolution
      cmp-cmdline        # Command-line completion source for cmp
      cmp-buffer         # Buffer source dependency for command-line search
    ];

    # ── Core options ────────────────────────────────────────────────────────
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      cursorline = true;
      termguicolors = true;
      signcolumn = "yes";
      scrolloff = 8;
      sidescrolloff = 8;
      splitbelow = true;
      splitright = true;
      ignorecase = true;
      smartcase = true;
      hlsearch = true;
      incsearch = true;
      updatetime = 200;
      timeoutlen = 300;
      undofile = true;
      conceallevel = 2;
    };

    # ── Global vars ─────────────────────────────────────────────────────────
    globals = {
      mapleader = " ";
      maplocalleader = "\\";
    };

    # ── Colorscheme ─────────────────────────────────────────────────────────
    colorschemes.tokyonight = {
      enable = true;
      settings = {
        style = "moon";
        transparent = false;
      };
    };

    # ── Keymaps ─────────────────────────────────────────────────────────────
    keymaps = [
      # Better up/down on wrapped lines
      { mode = "n"; key = "j"; action = "v:count == 0 ? 'gj' : 'j'"; options = { expr = true; silent = true; }; }
      { mode = "n"; key = "k"; action = "v:count == 0 ? 'gk' : 'k'"; options = { expr = true; silent = true; }; }

      # Move lines up/down
      { mode = "n"; key = "<A-j>"; action = "<cmd>m .+1<CR>=="; options.desc = "Move down"; }
      { mode = "n"; key = "<A-k>"; action = "<cmd>m .-2<CR>=="; options.desc = "Move up"; }
      { mode = "i"; key = "<A-j>"; action = "<esc><cmd>m .+1<CR>==gi"; options.desc = "Move down"; }
      { mode = "i"; key = "<A-k>"; action = "<esc><cmd>m .-2<CR>==gi"; options.desc = "Move up"; }
      { mode = "v"; key = "<A-j>"; action = ":m '>+1<CR>gv=gv"; options.desc = "Move down"; }
      { mode = "v"; key = "<A-k>"; action = ":m '<-2<CR>gv=gv"; options.desc = "Move up"; }

      # Window navigation
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; options.desc = "Go to left window"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; options.desc = "Go to lower window"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; options.desc = "Go to upper window"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; options.desc = "Go to right window"; }

      # Window resize
      { mode = "n"; key = "<C-Up>";    action = "<cmd>resize +2<CR>"; options.desc = "Increase window height"; }
      { mode = "n"; key = "<C-Down>";  action = "<cmd>resize -2<CR>"; options.desc = "Decrease window height"; }
      { mode = "n"; key = "<C-Left>";  action = "<cmd>vertical resize -2<CR>"; options.desc = "Decrease window width"; }
      { mode = "n"; key = "<C-Right>"; action = "<cmd>vertical resize +2<CR>"; options.desc = "Increase window width"; }

      # Buffer navigation
      { mode = "n"; key = "<S-h>"; action = "<cmd>bprevious<CR>"; options.desc = "Prev buffer"; }
      { mode = "n"; key = "<S-l>"; action = "<cmd>bnext<CR>"; options.desc = "Next buffer"; }
      { mode = "n"; key = "[b";    action = "<cmd>bprevious<CR>"; options.desc = "Prev buffer"; }
      { mode = "n"; key = "]b";    action = "<cmd>bnext<CR>"; options.desc = "Next buffer"; }
      { mode = "n"; key = "<leader>bd"; action = "<cmd>bdelete<CR>"; options.desc = "Delete buffer"; }
      { mode = "n"; key = "<leader>bD"; action = "<cmd>bdelete!<CR>"; options.desc = "Delete buffer (force)"; }

      # Clear search highlight
      { mode = "n"; key = "<Esc>"; action = "<cmd>nohlsearch<CR>"; }

      # Indenting in visual mode stays selected
      { mode = "v"; key = "<"; action = "<gv"; }
      { mode = "v"; key = ">"; action = ">gv"; }

      # Paste without yanking
      { mode = "v"; key = "p"; action = "\"_dP"; }

      # Save & Quit
      { mode = [ "i" "x" "n" "s" ]; key = "<C-s>"; action = "<cmd>w<CR><Esc>"; options.desc = "Save file"; }
      { mode = "n"; key = "<leader>qq"; action = "<cmd>qa<CR>"; options.desc = "Quit all"; }
      { mode = "n"; key = "<leader>fn"; action = "<cmd>enew<CR>"; options.desc = "New file"; }

      # Toggle line numbers
      { mode = "n"; key = "<leader>ul"; action = "<cmd>set nu! rnu!<CR>"; options.desc = "Toggle line numbers"; }

      # Plugin Toggles & Workspaces
      { mode = "n"; key = "<leader>e";  action = "<cmd>Neotree toggle<CR>"; options.desc = "Explorer Neo-tree (root)"; }
      { mode = "n"; key = "<leader>xx"; action = "<cmd>Trouble diagnostics toggle<CR>"; options.desc = "Diagnostics (Trouble)"; }
      { mode = "n"; key = "<leader>xX"; action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>"; options.desc = "Buffer Diagnostics (Trouble)"; }
      { mode = "n"; key = "<leader>xq"; action = "<cmd>Trouble quickfix toggle<CR>"; options.desc = "Quickfix List (Trouble)"; }
      { mode = "n"; key = "<leader>xl"; action = "<cmd>Trouble loclist toggle<CR>"; options.desc = "Location List (Trouble)"; }

      # Keymaps for utilities
      { mode = "n"; key = "<leader>sr"; action = "<cmd>GrugFar<CR>"; options.desc = "Search & Replace (Global)"; }
    ];

    # ── Plugins ─────────────────────────────────────────────────────────────
    plugins = {

      # Status line
      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "tokyonight";
            globalstatus = true;
            disabled_filetypes.statusline = [ "dashboard" "alpha" ];
            component_separators = { left = ""; right = ""; };
            section_separators   = { left = ""; right = ""; };
          };
          sections = {
            lualine_a = [ { __unkeyed-1 = "mode"; } ];
            lualine_b = [
              { __unkeyed-1 = "branch"; icon = ""; }
              { __unkeyed-1 = "diff"; symbols = { added = " "; modified = " "; removed = " "; }; }
              { __unkeyed-1 = "diagnostics"; symbols = { error = " "; warn = " "; info = " "; hint = " "; }; }
            ];
            lualine_c = [
              { __unkeyed-1 = "filename"; path = 1; symbols = { modified = "  "; readonly = ""; unnamed = ""; }; }
            ];
            lualine_x = [
              { __unkeyed-1 = "filetype"; icon_only = true; separator = ""; padding = { left = 1; right = 0; }; }
              { __unkeyed-1 = "filetype"; icon_only = false; }
            ];
            lualine_y = [
              { __unkeyed-1 = "progress"; separator = " "; padding = { left = 1; right = 0; }; }
              { __unkeyed-1 = "location"; padding = { left = 0; right = 1; }; }
            ];
            lualine_z = [
              { __unkeyed-1.__raw = ''
                function()
                  return " " .. os.date("%R")
                end
              ''; }
            ];
          };
        };
      };

      # Bufferline (tab bar)
      bufferline = {
        enable = true;
        settings.options = {
          diagnostics = "nvim_lsp";
          always_show_bufferline = false;
          offsets = [
            {
              filetype   = "neo-tree";
              text       = "Neo-tree";
              highlight  = "Directory";
              text_align = "left";
            }
          ];
        };
      };

      # File tree
      neo-tree = {
        enable = true;
        settings = {
          window.width = 30;
          filesystem.filtered_items = {
            visible = false;
            hide_dotfiles = false;
            hide_gitignored = true;
          };
        };
      };

      # Fuzzy finder
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
          ui-select.enable  = true;
        };
        keymaps = {
          "<leader><space>" = { action = "find_files";               options.desc = "Find files (root)"; };
          "<leader>/"       = { action = "live_grep";                options.desc = "Grep (root)"; };
          "<leader>ff"      = { action = "find_files";               options.desc = "Find files"; };
          "<leader>fg"      = { action = "live_grep";                options.desc = "Live grep"; };
          "<leader>fb"      = { action = "buffers";                  options.desc = "Buffers"; };
          "<leader>fr"      = { action = "oldfiles";                 options.desc = "Recent files"; };
          "<leader>gc"      = { action = "git_commits";              options.desc = "Git commits"; };
          "<leader>gs"      = { action = "git_status";               options.desc = "Git status"; };
          "<leader>sd"      = { action = "diagnostics";              options.desc = "Diagnostics"; };
          "<leader>sk"      = { action = "keymaps";                  options.desc = "Keymaps"; };
          "<leader>ss"      = { action = "lsp_document_symbols";     options.desc = "LSP symbols"; };
        };
      };

      # Which-key labels
      which-key = {
        enable = true;
        settings = {
          notify = false;
          spec = [
            { __unkeyed-1 = "<leader>b"; group = "buffers"; }
            { __unkeyed-1 = "<leader>c"; group = "code"; }
            { __unkeyed-1 = "<leader>f"; group = "file/find"; }
            { __unkeyed-1 = "<leader>g"; group = "git"; }
            { __unkeyed-1 = "<leader>q"; group = "quit/session"; }
            { __unkeyed-1 = "<leader>s"; group = "search"; }
            { __unkeyed-1 = "<leader>u"; group = "ui"; }
            { __unkeyed-1 = "<leader>w"; group = "windows"; }
            { __unkeyed-1 = "<leader>x"; group = "diagnostics/quickfix"; }
          ];
        };
      };

      # Treesitter parsing setup
      treesitter = {
        enable = true;
        package = pkgs.vimPlugins.nvim-treesitter;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          auto_install = false;
          ensure_installed = [
            "bash" "c" "diff" "html" "javascript" "jsdoc" "json"
            "jsonc" "lua" "luadoc" "luap" "markdown" "markdown_inline"
            "nix" "python" "query" "regex" "rust" "toml" "tsx"
            "typescript" "vim" "vimdoc" "xml" "yaml"
          ];
        };
      };

      treesitter-context.enable = true;
      treesitter-textobjects.enable = true;

      # LSP Engine
      lsp = {
        enable = true;
        servers = {
          lua_ls = {
            enable = true;
            settings.Lua.workspace.checkThirdParty = false;
          };
          nixd.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          ts_ls.enable = true;
          pyright.enable = true;
          bashls.enable = true;
          html.enable = true;
          cssls.enable = true;
          jsonls.enable = true;
          yamlls.enable = true;
        };
        keymaps = {
          diagnostic = {
            "<leader>cd" = "open_float";
            "[d" = "goto_prev";
            "]d" = "goto_next";
          };
          lspBuf = {
            "K" = "hover";
            "gd" = "definition";
            "gD" = "declaration";
            "gr" = "references";
            "gI" = "implementation";
            "gy" = "type_definition";
            "<leader>ca" = "code_action";
            "<leader>cr" = "rename";
          };
        };
      };

      # Autocompletion
      cmp = {
        enable = true;
        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          mapping = {
            "<C-n>" = "cmp.mapping.select_next_item()";
            "<C-p>" = "cmp.mapping.select_prev_item()";
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif require('luasnip').expand_or_jumpable() then
                  require('luasnip').expand_or_jump()
                else
                  fallback()
                end
              end, { "i", "s" })
            '';
            "<S-Tab>" = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif require('luasnip').jumpable(-1) then
                  require('luasnip').jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" })
            '';
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "buffer"; }
            { name = "path"; }
          ];
        };
      };

      # Snippets architecture
      luasnip = {
        enable = true;
        settings.history = true;
        settings.delete_check_events = "TextChanged";
      };
      friendly-snippets.enable = true;

      # Formatter Engine (Conform)
      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            timeout_ms = 500;
            lsp_fallback = true;
          };
          formatters_by_ft = {
            lua = [ "stylua" ];
            python = [ "isort" "black" ];
            javascript = [ "prettier" ];
            typescript = [ "prettier" ];
            nix = [ "nixpkgs-fmt" ];
            "_" = [ "trim_whitespace" ];
          };
        };
      };

      # Linting System (Nvim-lint)
      lint = {
        enable = true;
        lintersByFt = {
          python = [ "ruff" ];
        };
      };

      # Git indicators
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add.text = "▎";
            change.text = "▎";
            delete.text = "";
            topdelete.text = "";
            changedelete.text = "▎";
            untracked.text = "▎";
          };
          on_attach = ''
            function(buffer)
              local gs = package.loaded.gitsigns
              local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
              end
              map("n", "]h", gs.next_hunk,          "Next hunk")
              map("n", "[h", gs.prev_hunk,          "Prev hunk")
              map("n", "<leader>ghs", gs.stage_hunk,  "Stage hunk")
              map("n", "<leader>ghr", gs.reset_hunk,  "Reset hunk")
              map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
              map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
              map("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")
              map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame line")
              map("n", "<leader>ghd", gs.diffthis,  "Diff this")
            end
          '';
        };
      };

      # Interactive Visual Find & Replace
      grug-far = {
        enable = true;
        settings.disableSigncolumn = true;
      };

      # Utilities & Enhancements
      nvim-autopairs.enable = true;
      vim-surround.enable = true;
      comment.enable = true;
      flash.enable = true;
      notify.enable = true;
      persistence.enable = true;

      indent-blankline = {
        enable = true;
        settings = {
          indent.char = "│";
          scope.enabled = true;
        };
      };

      # UI Animation suite & Modern icons
      mini = {
        enable = true;
        mockDevIcons = true;
        modules = {
          ai = {};
          icons = {};
          # Smooth scrolling & crisp window layout animations
          animate = {
            scroll = { enable = true; };
            cursor = { enable = false; };
          };
        };
      };

      noice = {
        enable = true;
        settings = {
          lsp.override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
            inc_rename = false;
            lsp_doc_border = false;
          };
        };
      };

      trouble.enable = true;
      todo-comments = {
        enable = true;
        settings.signs = true;
      };
    };

    # ── Miscellaneous Hand-Rolled Lua Strings ───────────────────────────────
    extraConfigLua = ''
      -- Fillchars
      vim.opt.fillchars = { foldopen = "v", foldclose = ">", fold = " ", foldsep = " ", diff = "-", eob = " " }

      -- Dashboard Setup Natively via Lua Hooks
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗  ",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║  ",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║  ",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║  ",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║  ",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝  ",
      }

      dashboard.section.buttons.val = {
        dashboard.button("f",   "  Find file",      "<cmd>Telescope find_files<CR>"),
        dashboard.button("n",   "  New file",        "<cmd>enew<CR>"),
        dashboard.button("r",   "  Recent files",    "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("g",   "  Find word",       "<cmd>Telescope live_grep<CR>"),
        dashboard.button("s",   "  Restore session", "<cmd>lua require('persistence').load()<CR>"),
        dashboard.button("q",   "  Quit",            "<cmd>qa<CR>"),
      }

      local v = vim.version()
      dashboard.section.footer.val = string.format("  Neovim v%d.%d.%d", v.major, v.minor, v.patch)
      dashboard.section.footer.opts.hl = "AlphaFooter"

      alpha.setup(dashboard.opts)

      -- Force start dashboard when no initial file arguments are passed
      if vim.fn.argc() == 0 then
        require("alpha").start(true)
      end

      -- Hide/Show tablines during Alpha life cycles
      vim.api.nvim_create_autocromd = vim.api.nvim_create_autocromd or nil
      vim.api.nvim_create_autocmd("User", {
        pattern  = "AlphaReady",
        callback = function() vim.opt.showtabline = 0 end,
      })
      vim.api.nvim_create_autocmd("BufUnload", {
        buffer   = 0,
        callback = function() vim.opt.showtabline = 2 end,
      })

      -- Automatically open Neo-tree on launch if no specific file is opened
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if vim.fn.argc() == 0 or vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
            vim.cmd("Neotree show left")
          end
        end,
      })

      -- Todo-comments navigation
      vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<CR>", { desc = "Todo (Telescope)" })
      vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end,  { desc = "Next todo comment" })
      vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end,  { desc = "Prev todo comment" })

      -- Persistence (session execution shortcuts)
      vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end,           { desc = "Restore session" })
      vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore last session" })
      vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end,           { desc = "Don't save current session" })

      -- Flash Engine Motions
      vim.keymap.set({ "n", "x", "o" }, "s",  function() require("flash").jump() end,              { desc = "Flash" })
      vim.keymap.set({ "n", "x", "o" }, "S",  function() require("flash").treesitter() end,        { desc = "Flash Treesitter" })
      vim.keymap.set("o",               "r",  function() require("flash").remote() end,            { desc = "Remote Flash" })
      vim.keymap.set({ "x", "o" },      "R",  function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })

      -- Initialize Git Conflict Inline Management Plugin
      require('git-conflict').setup({
        default_mappings = true,
        default_commands = true,
        disable_diagnostics = false,
      })

      -- Command-line autocomplete setup
      local cmp = require('cmp')

      -- Colon (:) command-line completion
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline({
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'c' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { 'c' }),
        }),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
      })

      -- Search (/) and (?) command-line completion
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Diagnostic UI Window Tweaks
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
          },
        },
      })
    '';
  };
}
