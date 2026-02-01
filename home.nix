{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "markw";
  home.homeDirectory = "/home/markw";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "25.11";

  # Packages to install in user profile
  home.packages = with pkgs; [
    # Development tools
    nodejs_22
    python3
    rustc
    cargo
    go

    # Build tools
    gcc
    gnumake
    cmake

    # Version control
    git-lfs
    gh  # GitHub CLI

    # Utilities
    htop
    btop
    neofetch
    fastfetch  # Faster alternative to neofetch
    tree
    ripgrep
    fd
    fzf
    jq
    wget
    curl
    bat  # Better cat with syntax highlighting
    eza  # Better ls

    # Communication
    thunderbird
    discord
    telegram-desktop

    # IDE
    antigravity-fhs  # FHS-wrapped version for better extension support

    # macOS-like themes and customization
    kdePackages.plasma-browser-integration
    whitesur-kde
    whitesur-icon-theme
    whitesur-gtk-theme
    bibata-cursors
    libsForQt5.qtstyleplugin-kvantum

    # Other useful tools
    unzip
    zip
    mcp-nixos  # MCP server for Claude Code

    # Fonts
    fira-code
    fira-code-symbols
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    powerline-fonts
    inter  # Similar to SF Pro
    noto-fonts
    noto-fonts-color-emoji
  ];

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Dragonixos";
        email = "markwelland06@gmail.com";
      };
      credential = {
        helper = "/home/markw/git-credential-gh.sh";
      };
    };
  };

  # Bash configuration
  programs.bash = {
    enable = true;
    shellAliases = {
      # NixOS specific
      update = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      nixconf = "cd /etc/nixos";
      nixedit = "sudo vim /etc/nixos/configuration.nix";
      nixhome = "sudo vim /etc/nixos/home.nix";
      nixgc = "sudo nix-collect-garbage -d";
      nixsearch = "nix search nixpkgs";

      # ls aliases (using eza - modern ls replacement)
      ls = "eza --color=auto --icons";
      ll = "eza -alF --icons --git";
      la = "eza -A --icons";
      l = "eza -F --icons";
      lt = "eza -lT --icons";
      lh = "eza -lh --icons";
      tree = "eza --tree --icons";

      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";

      # Git aliases
      g = "git";
      gs = "git status";
      ga = "git add";
      gaa = "git add .";
      gc = "git commit -m";
      gca = "git commit -am";
      gp = "git push";
      gpl = "git pull";
      gd = "git diff";
      gl = "git log --oneline --graph --decorate";
      gco = "git checkout";
      gb = "git branch";
      gf = "git fetch";

      # Safety aliases
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";

      # Modern replacements
      cat = "bat --style=plain --paging=never";
      grep = "rg";
      find = "fd";

      # Utilities
      h = "history";
      c = "clear";
      e = "exit";
      reload = "source ~/.bashrc";

      # System monitoring
      ports = "sudo netstat -tulanp";
      disk = "df -h";
      mem = "free -h";
      cpu = "htop";

      # Development
      py = "python3";
      ipy = "ipython";
      serve = "python3 -m http.server";
      json = "jq";

      # Docker (if you add it later)
      d = "docker";
      dc = "docker-compose";
      dps = "docker ps";
      dpsa = "docker ps -a";

      # Quick edits
      v = "vim";
      code = "code .";
    };

    # Bash initialization script
    initExtra = ''
      # Better history
      export HISTSIZE=10000
      export HISTFILESIZE=20000
      export HISTCONTROL=ignoredups:erasedups
      shopt -s histappend

      # fzf keybindings
      eval "$(fzf --bash)"

      # Welcome message with fastfetch
      if [ -z "$FASTFETCH_SHOWN" ]; then
        export FASTFETCH_SHOWN=1
        fastfetch
      fi
    '';
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      # Use nerd font symbols
      format = "$all";

      # Faster command timeout
      command_timeout = 1000;

      # Character symbol
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      # Directory settings
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
      };

      # Git branch
      git_branch = {
        symbol = " ";
        style = "bold purple";
      };

      # Git status
      git_status = {
        style = "bold yellow";
        ahead = "⇡\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        behind = "⇣\${count}";
      };

      # Programming language versions
      nodejs = {
        symbol = " ";
        style = "bold green";
      };

      python = {
        symbol = " ";
        style = "bold yellow";
      };

      rust = {
        symbol = " ";
        style = "bold red";
      };

      golang = {
        symbol = " ";
        style = "bold cyan";
      };

      # Battery
      battery = {
        full_symbol = "🔋";
        charging_symbol = "⚡";
        discharging_symbol = "💀";
      };

      # Time
      time = {
        disabled = false;
        style = "bold white";
        format = "[$time]($style) ";
      };

      # Username
      username = {
        show_always = true;
        style_user = "bold green";
        format = "[$user]($style) ";
      };

      # Hostname
      hostname = {
        ssh_only = false;
        style = "bold green";
        format = "[@$hostname]($style) ";
      };
    };
  };

  # VSCode configuration
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Language support
        ms-python.python
        ms-vscode.cpptools
        rust-lang.rust-analyzer
        golang.go

        # Git
        eamodio.gitlens

        # Utilities
        ms-vscode-remote.remote-ssh
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint

        # Themes
        pkief.material-icon-theme
      ];
      userSettings = {
        "editor.fontSize" = 14;
        "editor.fontFamily" = "'Fira Code', 'monospace'";
        "editor.fontLigatures" = true;
        "workbench.colorTheme" = "Default Dark Modern";
        "editor.formatOnSave" = true;
        "files.autoSave" = "afterDelay";
      };
    };
  };

  # Additional fonts for development
  fonts.fontconfig.enable = true;

  # macOS-like GTK theme configuration
  gtk = {
    enable = true;
    theme = {
      name = "WhiteSur-Dark";
      package = pkgs.whitesur-gtk-theme;
    };
    iconTheme = {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
  };

  # Qt/KDE theme configuration
  qt = {
    enable = true;
    platformTheme.name = "kde";
  };

  # KDE Plasma configuration via plasma-manager
  programs.plasma = {
    enable = true;

    # Workspace settings
    workspace = {
      theme = "breeze-dark";
      colorScheme = "BreezeDark";
      cursor.theme = "Bibata-Modern-Ice";
      iconTheme = "WhiteSur-dark";
      wallpaper = null;  # Set a path like "${./wallpaper.jpg}" if desired
    };

    # Hot corners
    hotkeys.commands = { };

    # Panel configuration (taskbar)
    panels = [
      {
        location = "bottom";
        height = 44;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseperator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.showdesktop"
        ];
      }
    ];

    # Keyboard shortcuts
    shortcuts = {
      "kwin" = {
        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";
        "Window Close" = "Meta+Q";
        "Window Maximize" = "Meta+Up";
        "Window Minimize" = "Meta+Down";
      };
      "plasmashell" = {
        "show-on-mouse-pos" = "Meta+V";  # Clipboard popup
      };
    };

    # KWin window manager settings
    kwin = {
      borderlessMaximizedWindows = false;
      titlebarButtons = {
        left = [ "on-all-desktops" "keep-above-windows" ];
        right = [ "minimize" "maximize" "close" ];
      };
    };

    # Spectacle (screenshot) settings
    configFile = {
      "spectaclerc"."General"."clipboardGroup" = "PostScreenshotCopyImage";
    };
  };
}
