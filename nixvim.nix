{pkgs, ...}: let
  tree-sitter-wesl-grammar = pkgs.tree-sitter.buildGrammar {
    language = "wgsl";
    version = "0.0.0+rev=94ee612";
    src = pkgs.fetchFromGitHub {
      owner = "wgsl-tooling-wg";
      repo = "tree-sitter-wesl";
      rev = "94ee6122680ef8ce2173853ca7c99f7aaeeda8ce";
      hash = "sha256-n9yob5tDyWalSAPjH2a3BFcH4Zqd6rwb+V/Qbvaxt7c=";
    };
    meta.homepage = "https://github.com/wgsl-tooling-wg/tree-sitter-wesl";
  };
in {
  enable = true;
  defaultEditor = true;

  globals = {
    mapleader = " ";
    maplocalleader = " ";
    have_nerd_font = true;
  };

  opts = {
    number = true;
    showmode = false;

    clipboard = {
      providers.wl-copy.enable = true;
      register = "unnamedplus";
    };

    breakindent = true;

    ignorecase = true;
    smartcase = true;

    signcolumn = "yes";

    updatetime = 250;
    timeoutlen = 300;

    splitbelow = true;
    splitright = true;

    list = true;
    listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

    inccommand = "split";

    cursorline = true;

    scrolloff = 10;

    hlsearch = true;

    expandtab = true;
    tabstop = 2;
    shiftwidth = 2;
  };

  plugins = {
    web-devicons.enable = true;

    treesitter = {
      enable = true;
      settings = {
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = true;
        };
        indent = {
          enable = true;
          disable = ["ruby"];
        };
      };
      grammarPackages =
        pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars
        ++ [
          tree-sitter-wesl-grammar
        ];
      luaConfig.post = ''
        do
          local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
          -- change the following as needed
          parser_config.wesl = {
            install_info = {
              url = "${tree-sitter-wesl-grammar}", -- local path or git repo
              files = {"src/parser.c", "src/scanner.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
              -- optional entries:
              --  branch = "main", -- default branch in case of git repo if different from master
              -- generate_requires_npm = false, -- if stand-alone parser without npm dependencies
              -- requires_generate_from_grammar = true, -- if folder contains pre-generated src/parser.c
            },
            filetype = "wgsl", -- if filetype does not match the parser name
          }
        end
      '';
    };

    sleuth.enable = true;

    todo-comments = {
      enable = true;
      settings.signs = true;
    };

    gitsigns = {
      enable = true;
      settings.signs = {
        add = {
          text = "+";
        };
        change = {
          text = "~";
        };
        delete = {
          text = "_";
        };
        topdelete = {
          text = "‾";
        };
        changedelete = {
          text = "~";
        };
      };
    };

    luasnip.enable = true;
    cmp_luasnip.enable = true;
    cmp-path.enable = true;

    indent-blankline.enable = true;
  };

  extraPlugins = [tree-sitter-wesl-grammar];
  # More advanced plugins:
  imports = [
    ./nixvim/lsp.nix
    ./nixvim/telescope.nix
    ./nixvim/cmp.nix
    ./nixvim/conform.nix
  ];

  autoGroups = {
    kickstart-highlight-yank.clear = true;
  };
  autoCmd = [
    {
      event = ["TextYankPost"];
      desc = "Highlight when yanking text";
      group = "kickstart-highlight-yank";
      callback.__raw = ''
        function()
          vim.highlight.on_yank()
        end
      '';
    }
  ];

  keymaps = [
    # Clear highlights on search when pressing Esc in normal mode
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
    }

    # Keybinds for split window navigation
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w><C-h>";
      options.desc = "Move focus to left pane.";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w><C-l>";
      options.desc = "Move focus to right pane.";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w><C-k>";
      options.desc = "Move focus to upper pane.";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w><C-j>";
      options.desc = "Move focus to lower pane.";
    }
  ];
}
