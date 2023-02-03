{ config, pkgs, lib, ... }:

let
  current = import <nixpkgs-current> {};
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "trev";
  home.homeDirectory = "/home/trev";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

# Packages: {{{

  home.packages = with pkgs; [
    bat
    dbeaver
    gcc
    git
    lazygit
    jdk17
    jp2a
    current.neovim
    google-chrome
    newman
    nodejs
    pandoc
    postman
    python39
    ranger
    ripgrep
    sumneko-lua-language-server
    rnix-lsp
    taskwarrior
    taskwarrior-tui
    timewarrior
    unzip
    wget
    xclip
    zk
    zoxide
  ];
# }}}

  nixpkgs.config.allowUnfree = true;

  programs.fzf.enable = true;
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Shell Config: {{{
  home.sessionVariables = with lib.strings; {
    EDITOR = "nvim";
    SUDO_EDITOR = "nvim";
    ZK_NOTEBOOK_DIR = "/home/trev/Notes";
    SSH_AUTH_SOCK = "$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)";
    WIN_HOME = "/mnt/c/Users/TRERICHA";
    PATH = concatStringsSep ":" [
      "$PATH"
      "$HOME/.local/node/bin"
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
      "$HOME/.nimble/bin"
    ];
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      la = "ls -al";
      ll = "ls -l";
      nv = "nvim";
      r = "ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd \"$LASTDIR\"";
      t = "task";
      lg = "lazygit";
      ti = "timew";
      tui = "taskwarrior-tui";
      tm = "task mod";
      tu = "taskwarrior-tui";
      zke = "zk edit --interactive";
      zkl = "zk list --interactive";
      gd = "git diff";
      gs = "git status";
      gl = "git log --oneline";
      gco = "git checkout";
      ga = "git add";
      gc = "git commit";
      intellij = "nvim";
    };
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
    ];
    initExtra = ''
      bindkey -e
      autoload -Uz vcs_info
      precmd () { vcs_info }
      zstyle ':vcs_info:git:*' formats ' %F{green} %b%f'
      setopt prompt_subst

      envColor=blue
      if [ -n "$IN_NIX_SHELL" ]; then
        envColor=255
      fi

      PS1='%F{white}%3~/$vcs_info_msg_0_ %B%F{$envColor}λ%f%b '
    '';
  };
  # }}}

  programs.git = {
    enable = true;
    userName = "Trevor Richards";
    userEmail = "trev@trevdev.ca";
    signing = {
      key = "0FB7D06B4A2AF07EAD5B1169183B63068AA1D206";
      signByDefault = true;
    };
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      core = {
        excludesFile = "~/.gitignore";
      };
    };
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 60480000;
    defaultCacheTtlSsh = 60480000;
    maxCacheTtl = 60480000;
    sshKeys = ["FF9F589746CBDCE989E5C2D75928BCCDC1E7C015"];
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.resurrect
      tmuxPlugins.sensible
    ];
    shortcut = "a";
    extraConfig = ''
      # vim-like pane resizing
      bind -r C-k resize-pane -U
      bind -r C-j resize-pane -D
      bind -r C-h resize-pane -L
      bind -r C-l resize-pane -R

      # vim-like pane switching
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R

      # and now unbind keys
      unbind Up
      unbind Down
      unbind Left
      unbind Right

      unbind C-Up
      unbind C-Down
      unbind C-Left
      unbind C-Right
    '';
  };

  xdg.enable = true;

  home.file.".npmrc".text = "prefix=/home/trev/.local/node\n";
  home.file.".gitignore".text = ''
    shell.nix
    jsconfig.json
    shims-*.d.ts
  '';
  xdg.configFile."zk".source = config/zk;
}

# vim: foldmethod=marker
