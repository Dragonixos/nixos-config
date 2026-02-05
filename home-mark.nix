{ config, pkgs, ... }:

{
  imports = [
    ./home-common.nix
  ];

  home.username = "mark";
  home.homeDirectory = "/home/mark";
  home.stateVersion = "25.11";

  # Additional packages for Hyprland rice
  home.packages = with pkgs; [
    # Hyprland essentials
    waybar
    hyprpaper
    hyprlock
    hypridle
    swaynotificationcenter
    wofi
    grim
    slurp
    wl-clipboard
    pavucontrol
    networkmanagerapplet
    
    # Additional utilities
    brightnessctl
    playerctl
    wlogout
    cliphist
    
    # Fonts
    font-awesome
    noto-fonts-color-emoji
    
    # File manager
    nemo
  ];

  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    settings = {
      # Monitor configuration
      monitor = ",preferred,auto,1";

      # Startup applications
      exec-once = [
        "waybar"
        "hyprpaper"
        "hypridle"
        "swaync"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "nm-applet --indicator"
      ];

      # Environment variables
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "QT_QPA_PLATFORM,wayland"
        "QT_QPA_PLATFORMTHEME,qt6ct"
      ];

      # Input configuration
      input = {
        kb_layout = "gb";
        kb_variant = "extd";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
        };
      };

      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(cba6f7ee) rgba(89b4faee) 45deg";
        "col.inactive_border" = "rgba(585b70aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      # Decoration
      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 0.95;
        
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      # Animations
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # Layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      # Misc settings
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      # Keybindings
      "$mod" = "SUPER";

      bind = [
        # Applications
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, nemo"
        "$mod, V, togglefloating,"
        "$mod, D, exec, wofi --show drun"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        "$mod, F, fullscreen,"
        "$mod, L, exec, hyprlock"
        
        # Screenshots
        "$mod, S, exec, grim -g \"$(slurp)\" - | wl-copy"
        "$mod SHIFT, S, exec, grim - | wl-copy"
        
        # Notifications
        "$mod, N, exec, swaync-client -t -sw"
        
        # Clipboard history
        "$mod, C, exec, cliphist list | wofi -dmenu | cliphist decode | wl-copy"

        # Move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Switch workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move window to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Special workspace (scratchpad)
        "$mod, grave, togglespecialworkspace, magic"
        "$mod SHIFT, grave, movetoworkspace, special:magic"

        # Scroll through workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Media keys
      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];

      bindle = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 10%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
      ];

      # Window rules
      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "float, class:^(pavucontrol)$"
        "float, class:^(nm-connection-editor)$"
        "float, title:^(Volume Control)$"
        "size 800 600, title:^(Volume Control)$"
      ];
    };
  };

  # Waybar configuration
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        spacing = 4;

        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" "tray" ];

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "󰈹";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            default = "";
          };
          persistent-workspaces = {
            "*" = 5;
          };
        };

        "hyprland/window" = {
          format = "{}";
          max-length = 50;
          separate-outputs = true;
        };

        clock = {
          format = "{:%H:%M  %a %d %b}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#f5c2e7'><b>{}</b></span>";
              days = "<span color='#cdd6f4'><b>{}</b></span>";
              weeks = "<span color='#89b4fa'><b>W{}</b></span>";
              weekdays = "<span color='#f9e2af'><b>{}</b></span>";
              today = "<span color='#f38ba8'><b><u>{}</u></b></span>";
            };
          };
        };

        cpu = {
          format = "  {usage}%";
          tooltip = false;
        };

        memory = {
          format = "  {}%";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = "󰂄  {capacity}%";
          format-plugged = "  {capacity}%";
          format-icons = [ "" "" "" "" "" ];
        };

        network = {
          format-wifi = "  {essid}";
          format-ethernet = "󰈀  Connected";
          format-disconnected = "󰖪  Disconnected";
          tooltip-format = "{ifname}: {ipaddr}";
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "󰝟  Muted";
          format-icons = {
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };

        tray = {
          spacing = 10;
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrains Mono", "Font Awesome 6 Free";
        font-size: 13px;
        font-weight: bold;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background: rgba(30, 30, 46, 0.8);
        color: #cdd6f4;
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      #workspaces button {
        padding: 0 10px;
        color: #cdd6f4;
        background: transparent;
        border-radius: 10px;
        margin: 5px 3px;
      }

      #workspaces button.active {
        background: rgba(203, 166, 247, 0.3);
        color: #cba6f7;
      }

      #workspaces button:hover {
        background: rgba(137, 180, 250, 0.2);
        color: #89b4fa;
      }

      #window {
        margin: 5px 10px;
        padding: 0 10px;
        color: #89b4fa;
      }

      #clock {
        padding: 0 15px;
        margin: 5px;
        background: rgba(203, 166, 247, 0.3);
        color: #cba6f7;
        border-radius: 10px;
      }

      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 10px;
        margin: 5px 3px;
        background: rgba(88, 91, 112, 0.3);
        border-radius: 10px;
      }

      #battery.charging {
        background: rgba(166, 227, 161, 0.3);
        color: #a6e3a1;
      }

      #battery.warning:not(.charging) {
        background: rgba(249, 226, 175, 0.3);
        color: #f9e2af;
      }

      #battery.critical:not(.charging) {
        background: rgba(243, 139, 168, 0.3);
        color: #f38ba8;
        animation: blink 0.5s linear infinite alternate;
      }

      @keyframes blink {
        to {
          background-color: rgba(243, 139, 168, 0.5);
        }
      }

      #pulseaudio.muted {
        color: #f38ba8;
      }

      #network.disconnected {
        color: #f38ba8;
      }
    '';
  };

  # Hyprpaper configuration
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "~/Pictures/wallpaper.jpg"
      ];
      wallpaper = [
        ",~/Pictures/wallpaper.jpg"
      ];
      splash = false;
    };
  };

  # Hyprlock configuration
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        grace = 0;
        no_fade_in = false;
      };

      background = [{
        path = "~/Pictures/wallpaper.jpg";
        blur_passes = 3;
        blur_size = 7;
        noise = 0.0117;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      }];

      input-field = [{
        size = "300, 50";
        position = "0, -80";
        monitor = "";
        dots_center = true;
        fade_on_empty = false;
        font_color = "rgb(205, 214, 244)";
        inner_color = "rgb(30, 30, 46)";
        outer_color = "rgb(203, 166, 247)";
        outline_thickness = 2;
        placeholder_text = "<i>Enter Password...</i>";
        shadow_passes = 2;
      }];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"<b><big>$(date +%H:%M)</big></b>\"";
          color = "rgb(205, 214, 244)";
          font_size = 64;
          font_family = "JetBrains Mono";
          position = "0, 16";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:18000000] echo \"<b>$(date +'%A, %-d %B %Y')</b>\"";
          color = "rgb(205, 214, 244)";
          font_size = 24;
          font_family = "JetBrains Mono";
          position = "0, -50";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "Hi, $USER";
          color = "rgb(203, 166, 247)";
          font_size = 20;
          font_family = "JetBrains Mono";
          position = "0, -150";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # Hypridle configuration
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  # Wofi configuration
  programs.wofi = {
    enable = true;
    settings = {
      width = 600;
      height = 400;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 40;
      gtk_dark = true;
    };

    style = ''
      window {
        margin: 0px;
        border: 2px solid #cba6f7;
        background-color: rgba(30, 30, 46, 0.9);
        border-radius: 10px;
      }

      #input {
        padding: 10px;
        margin: 10px;
        border: none;
        color: #cdd6f4;
        background-color: rgba(49, 50, 68, 0.8);
        border-radius: 10px;
      }

      #inner-box {
        margin: 10px;
        border: none;
        background-color: transparent;
      }

      #outer-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
        color: #cdd6f4;
      }

      #entry {
        padding: 8px;
        border-radius: 8px;
      }

      #entry:selected {
        background-color: rgba(203, 166, 247, 0.3);
      }

      #text:selected {
        color: #cba6f7;
      }
    '';
  };

  # SwayNC (notification center) configuration
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      control-center-margin-left = 0;
      notification-2fa-action = true;
      notification-inline-replies = false;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      fit-to-screen = true;
      control-center-width = 500;
      control-center-height = 600;
      notification-window-width = 500;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;
    };

    style = ''
      * {
        font-family: "JetBrains Mono";
        font-weight: bold;
      }

      .notification-row {
        outline: none;
      }

      .notification {
        background: rgba(30, 30, 46, 0.9);
        border: 2px solid #cba6f7;
        border-radius: 10px;
        margin: 6px;
        padding: 0;
      }

      .notification-content {
        background: transparent;
        padding: 10px;
        border-radius: 10px;
      }

      .notification-default-action {
        margin: 0;
        padding: 0;
        border-radius: 10px;
      }

      .close-button {
        background: #f38ba8;
        color: #1e1e2e;
        border-radius: 50%;
        margin: 5px;
      }

      .close-button:hover {
        background: #eba0ac;
      }

      .notification-action {
        background: rgba(203, 166, 247, 0.3);
        color: #cdd6f4;
        border-radius: 8px;
        margin: 4px;
      }

      .notification-action:hover {
        background: rgba(137, 180, 250, 0.3);
      }

      .control-center {
        background: rgba(30, 30, 46, 0.9);
        border: 2px solid #cba6f7;
        border-radius: 10px;
      }

      .control-center-list {
        background: transparent;
      }

      .widget-title {
        color: #cdd6f4;
        font-size: 18px;
        margin: 10px;
      }

      .widget-dnd {
        background: rgba(203, 166, 247, 0.3);
        border-radius: 8px;
        margin: 10px;
        padding: 8px;
      }

      .widget-label {
        color: #cdd6f4;
      }
    '';
  };

  # GTK theme for better integration
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "standard";
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
  };

  # Qt theming
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };
}
