# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

let
  telaIcons = pkgs.stdenvNoCC.mkDerivation {
    pname = "tela-icons-local";
    version = "1";
    src = ./icons/tela;
    installPhase = ''
      mkdir -p $out/share/icons
      cp -r $src/* $out/share/icons/
    '';
  };
  cqrlog = pkgs.stdenvNoCC.mkDerivation {
    pname = "cqrlog-bin";
    version = "2.5.2";
    src = pkgs.fetchurl {
      url = "https://github.com/ok2cqr/cqrlog/releases/download/v2.5.2/cqrlog_2.5.2_amd64.tar.gz";
      sha256 = "1xa4d8csyfdlmb1k5rb0xaxvdldqhhz9wq6s415y5rl36myjzf0b";
    };
    nativeBuildInputs = [
      pkgs.autoPatchelfHook
    ];
    buildInputs = [
      pkgs.gtk2
      pkgs.glib
      pkgs.gdk-pixbuf
      pkgs.pango
      pkgs.cairo
      pkgs.atk
      pkgs.xorg.libX11
      pkgs.xorg.libXext
      pkgs.xorg.libXrender
      pkgs.xorg.libXcursor
      pkgs.xorg.libXrandr
      pkgs.xorg.libXi
      pkgs.xorg.libSM
      pkgs.xorg.libICE
      pkgs.mariadb-connector-c
      pkgs.openssl
      pkgs.zlib
    ];
    unpackPhase = "tar -xzf $src";
    installPhase = ''
      mkdir -p $out
      cp -r cqrlog-2.5.2/usr/* $out/
    '';
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "extd";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.markw = {
    isNormalUser = true;
    description = "mark welland";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Enable TeamViewer daemon for incoming connections
  services.teamviewer.enable = true;

  # CQRLOG database
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  # Containers
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # Flatpak
  services.flatpak.enable = true;

  # Ollama + Open-WebUI
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    host = "127.0.0.1";
    port = 11434;
  };

  services.open-webui = {
    enable = true;
    host = "127.0.0.1";
    port = 8080;
    environment = {
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes and nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    google-chrome
    claude-code
    git
    teamviewer
    rpi-imager
    caligula
    telaIcons
    cqrlog
    hamlib
    trustedqsl
    podman-desktop
    ffmpeg-full
    # KDE applications
    kdePackages.dolphin
    kdePackages.konsole
    kdePackages.kate
    kdePackages.okular
    kdePackages.gwenview
    kdePackages.ark
    kdePackages.spectacle
    kdePackages.filelight
    kdePackages.kcalc
    kdePackages.kcharselect
    kdePackages.kdeconnect-kde
    kdePackages.kcron
    kdePackages.ksystemlog
    kdePackages.kio-extras
    kdePackages.kamera
    kdePackages.kdegraphics-thumbnailers
    # KDE multimedia / creative
    pkgs.krita
    # KDE PIM
    kdePackages.kmail
    kdePackages.korganizer
    kdePackages.kaddressbook
    kdePackages.kontact
    # KDE games
    kdePackages.kpat
    kdePackages.kmahjongg
    kdePackages.ksudoku
    kdePackages.kmines
    kdePackages.kblocks
    kdePackages.palapeli
    kdePackages.katomic
    kdePackages.lskat
    kdePackages.granatier
    kdePackages.kolf
    kdePackages.konquest
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
