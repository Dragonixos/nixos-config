{ config, pkgs, ... }:

{
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

    # AI & Cloud CLIs
    codex  # OpenAI Codex terminal coding agent
    google-cloud-sdk  # gcloud CLI
    gemini-cli  # Google Gemini AI terminal agent

    # Terminal & Editors
    terminator  # Terminal emulator with tiling
    neovim  # Modern Vim fork

    # Windows compatibility
    wine  # Run Windows applications

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
    grc  # Colorize command output (for Fish grc plugin)

    # Communication
    thunderbird
    discord
    telegram-desktop

    # Browsers
    chromium
    brave
    tor-browser

    # IDE
    antigravity-fhs  # FHS-wrapped version for better extension support
    android-studio  # Android development IDE
    android-tools  # adb/fastboot
    fvm  # Flutter SDK manager
    temurin-bin  # JDK for Java/Android tooling
    # Ham radio - HF digital
    wsjtx
    fldigi
    js8call

    # Office
    libreoffice  # Office productivity suite

    # Other useful tools
    unzip
    zip
    zip
    mcp-nixos  # MCP server for Claude Code
    openclaw-gateway  # AI Agent CLI

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

  # Podman registries config (for rootless containers)
  xdg.configFile."containers/registries.conf".text = ''
    [registries.search]
    registries = ['docker.io', 'quay.io', 'ghcr.io']
  '';

  # Podman policy.json (allows pulling from any registry)
  xdg.configFile."containers/policy.json".text = builtins.toJSON {
    default = [{ type = "insecureAcceptAnything"; }];
  };

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

  # VS Code configuration
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      ms-python.python
      ms-toolsai.jupyter
      rust-lang.rust-analyzer
      ms-vscode.cpptools
      redhat.vscode-yaml
      dart-code.dart-code
      dart-code.flutter
      redhat.java
      catppuccin.catppuccin-vsc
      golang.go
      eamodio.gitlens
      ms-vscode-remote.remote-ssh
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint
      pkief.material-icon-theme
    ];
    profiles.default.userSettings = {
      "editor.fontFamily" = "JetBrains Mono, Fira Code, monospace";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 14;
      "editor.lineHeight" = 22;
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;
      "editor.bracketPairColorization.enabled" = true;
      "editor.guides.bracketPairs" = true;
      "editor.renderWhitespace" = "selection";
      "editor.minimap.enabled" = false;
      "workbench.colorTheme" = "Catppuccin Mocha";
      "files.autoSave" = "onFocusChange";
      "terminal.integrated.fontFamily" = "JetBrains Mono";
      "terminal.integrated.fontSize" = 13;
      "python.analysis.typeCheckingMode" = "basic";
      "python.analysis.autoImportCompletions" = true;
      "python.defaultInterpreterPath" = "${pkgs.python3}/bin/python3";
      "rust-analyzer.checkOnSave.command" = "clippy";
      "C_Cpp.intelliSenseEngine" = "Default";
      "yaml.validate" = true;
      "dart.flutterSdkPath" = "${config.home.homeDirectory}/.fvm/versions/stable";
      "java.jdt.ls.java.home" = "${pkgs.temurin-bin}/lib/openjdk";
    };
  };

  # Bash configuration
  programs.bash = {
    enable = true;
    shellAliases = {
      # NixOS specific
      update = "sudo nixos-rebuild switch --flake /home/markw#nixos";
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

  # Fish shell configuration
  programs.fish = {
    enable = true;
    
    # Shell aliases (same as bash)
    shellAliases = {
      # NixOS specific
      update = "sudo nixos-rebuild switch --flake /home/markw#nixos";
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
      reload = "source ~/.config/fish/config.fish";

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

      # Docker
      d = "docker";
      dc = "docker-compose";
      dps = "docker ps";
      dpsa = "docker ps -a";

      # Quick edits
      v = "vim";
      code = "code .";
    };

    # Fish shell initialization
    interactiveShellInit = ''
      # Better history settings
      set -g fish_history_size 10000

      # Disable greeting
      set -g fish_greeting

      # fzf keybindings
      fzf --fish | source

      # Welcome message with fastfetch (only once per session)
      if not set -q FASTFETCH_SHOWN
        set -gx FASTFETCH_SHOWN 1
        fastfetch
      end
    '';

    # Fish plugins for enhanced tab completion
    plugins = [
      # autopair - auto-close brackets, quotes, etc.
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      # done - notifications when long commands finish
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      # fzf-fish - fzf integration for history, files, git
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      # grc - colorize command output
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
    ];
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
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

  # Additional fonts for development
  fonts.fontconfig.enable = true;

  # Kitty terminal configuration
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono";
      size = 13;
    };
    settings = {
      # Mouse copy/paste support
      copy_on_select = "yes";  # Automatically copy when selecting with mouse
      
      # Enable clicking URLs
      mouse_map = "left click ungrabbed mouse_handle_click selection link prompt";
      
      # Appearance
      background_opacity = "0.95";
      cursor_shape = "beam";
      cursor_blink_interval = 0;
      
      # Scrollback
      scrollback_lines = 10000;
      
      # Window
      window_padding_width = 8;
      remember_window_size = "yes";
      
      # Tab bar
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      
      # Colors (Catppuccin Mocha theme)
      foreground = "#CDD6F4";
      background = "#1E1E2E";
      selection_foreground = "#1E1E2E";
      selection_background = "#F5E0DC";
      
      # Cursor colors
      cursor = "#F5E0DC";
      cursor_text_color = "#1E1E2E";
      
      # URL colors
      url_color = "#F5E0DC";
    };
    keybindings = {
      # Paste shortcuts
      "ctrl+shift+v" = "paste_from_clipboard";
      "shift+insert" = "paste_from_clipboard";
      
      # Copy shortcuts
      "ctrl+shift+c" = "copy_to_clipboard";
      
      # Tab management
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
    };
  };

  # Foot terminal configuration
  programs.foot = {
    enable = true;
    server.enable = true; # Enable foot server for faster startups with 'footclient'
    settings = {
      main = {
        term = "xterm-256color";
        # Use the correct Nerd Font family name found via fc-list
        font = "JetBrainsMono Nerd Font:size=11";
        pad = "8x8";
        selection-target = "clipboard"; # Copy to clipboard on selection
        dpi-aware = "yes"; # Ensure proper scaling
      };
      
      mouse = {
        hide-when-typing = "yes";
      };

      key-bindings = {
        clipboard-copy = "Control+Shift+c XF86Copy";
        clipboard-paste = "Control+Shift+v XF86Paste";
      };

      colors = {
        alpha = 0.95;
        background = "1e1e2e";
        foreground = "cdd6f4";
        
        ## Normal/regular colors (Catppuccin Mocha)
        regular0 = "45475a";  # black
        regular1 = "f38ba8";  # red
        regular2 = "a6e3a1";  # green
        regular3 = "f9e2af";  # yellow
        regular4 = "89b4fa";  # blue
        regular5 = "f5c2e7";  # magenta
        regular6 = "94e2d5";  # cyan
        regular7 = "bac2de";  # white
        
        ## Bright colors
        bright0 = "585b70";   # bright black
        bright1 = "f38ba8";   # bright red
        bright2 = "a6e3a1";   # bright green
        bright3 = "f9e2af";   # bright yellow
        bright4 = "89b4fa";   # bright blue
        bright5 = "f5c2e7";   # bright magenta
        bright6 = "94e2d5";   # bright cyan
        bright7 = "a6adc8";   # bright white
      };
    };
  };

  # Desktop shortcuts
  xdg.desktopEntries = {
    openclaw = {
      name = "OpenClaw";
      genericName = "AI Agent";
      exec = "bash -lc \"xdg-open http://localhost:18789/?token=\\$(openclaw config get gateway.auth.token)\"";
      terminal = false;
      categories = [ "Utility" "Network" ];
      icon = "utilities-terminal"; # Fallback icon since we don't have a custom one yet
      comment = "OpenClaw AI Bot Web UI";
    };
  };

  # OpenClaw Gateway Service (Native Flake - Manual Definition)
  systemd.user.services.openclaw-gateway = {
    Unit = {
      Description = "OpenClaw Gateway";
      After = [ "network.target" ];
    };

    Service = {
      ExecStart = "${pkgs.openclaw-gateway}/bin/openclaw gateway";
      Restart = "always";
      RestartSec = "5s";
      
      # Workaround for Issue #35: Fix gateway configuration
      ExecStartPre = let
        openclaw = "${pkgs.openclaw-gateway}/bin/openclaw";
        setupScript = pkgs.writeShellScript "openclaw-gateway-setup" ''
          ${openclaw} config set gateway.mode local 2>/dev/null || true
          ${openclaw} config set gateway.bind loopback 2>/dev/null || true

          CURRENT_TOKEN=$(${openclaw} config get gateway.auth.token 2>/dev/null || echo "")
          if [ -z "$CURRENT_TOKEN" ] || [ "$CURRENT_TOKEN" = "null" ]; then
            NEW_TOKEN=$(cat /proc/sys/kernel/random/uuid | tr -d '-')
            ${openclaw} config set gateway.auth.token "$NEW_TOKEN" 2>/dev/null || true
          fi
        '';
      in "${setupScript}";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

}
