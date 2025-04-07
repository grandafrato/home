{
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
