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

  environment.systemPackages = with pkgs; [ neovim pinentry ];

  programs.zsh.enable = true;

  users.users.trev = {
    isNormalUser = true;
    home = "/home/trev";
    description = "Trevor Richards";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.zsh;
  };

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "trev";
    startMenuLaunchers = true;

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
