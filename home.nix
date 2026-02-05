{ config, pkgs, ... }:

{
  imports = [
    ./home-common.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "markw";
  home.homeDirectory = "/home/markw";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    # macOS-like themes and customization (KDE)
    kdePackages.plasma-browser-integration
    whitesur-kde
    whitesur-icon-theme
    whitesur-gtk-theme
    bibata-cursors
    libsForQt5.qtstyleplugin-kvantum
  ];

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

  # Link WhiteSur KDE themes to local share for KDE to find them
  xdg.dataFile = {
    "plasma/desktoptheme/WhiteSur-dark" = {
      source = "${pkgs.whitesur-kde}/share/plasma/desktoptheme/WhiteSur-dark";
    };
    "plasma/look-and-feel/com.github.vinceliuice.WhiteSur-dark" = {
      source = "${pkgs.whitesur-kde}/share/plasma/look-and-feel/com.github.vinceliuice.WhiteSur-dark";
    };
    "color-schemes/WhiteSurDark.colors" = {
      source = "${pkgs.whitesur-kde}/share/color-schemes/WhiteSurDark.colors";
    };
  };

  # KDE Plasma configuration via plasma-manager
  programs.plasma = {
    enable = true;

    # Workspace settings
    workspace = {
      theme = "WhiteSur-dark";
      colorScheme = "WhiteSurDark";
      cursor.theme = "Bibata-Modern-Ice";
      iconTheme = "WhiteSur-dark";
      lookAndFeel = "com.github.vinceliuice.WhiteSur-dark";
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
