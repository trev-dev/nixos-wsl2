{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  nixos-wsl = import ./nixos-wsl;
in
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"

    nixos-wsl.nixosModules.wsl
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Vancouver";


  environment = {
    systemPackages = with pkgs; [ neovim pinentry ];
    pathsToLink = ["/share/bash-completion"];
  };

  users.users.trev = {
    isNormalUser = true;
    home = "/home/trev";
    description = "Trevor Richards";
    extraGroups = [ "docker" "wheel" ];
  };

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "trev";
    startMenuLaunchers = true;
    interop.includePath = true;

    # Enable native Docker support
    docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;

  };

  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  system.stateVersion = "22.05";
}
