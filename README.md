# Getting along with Windows

This configuration uses [NixOS-WSL](https://github.com/nix-community/NixOS-WSL)

This will eventually be a flake, but for now this is set up by:

1.  Symlinking configuration.nix to /etc/nixos/configuration.nix
2.  Adding the current nixos stable as a separate channel for my user
3.  Adding and installing home manager
4.  Rebuild system and home

