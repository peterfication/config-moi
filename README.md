# Config files managed with [chezmoi](https://www.chezmoi.io/)

## Nix on macOS

See [Nixcademy: Setting up Nix on macOS](https://nixcademy.com/posts/nix-on-macos/) and [DeterminateSystems/nix-installer](https://github.com/DeterminateSystems/nix-installer).

> NOTE: The Determinate shell installer has to be used with the normal Nix install. (no `--determinate` flag and answering no)

See [Justfile](private_dot_config/nix/Justfile) for useful commands.

## Getting started

```bash
# Install nix with determinate installer but with nix upstream
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# Clone and link the nix folder (amongst others) with a temporary chezmoi bin
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply https://github.com/peterfication/config-moi && rm ~/.local/bin/chezmoi

touch ~/.config/chezmoi/key.txt
vim ~/.config/chezmoi/key.txt

# Run the initial nix-darwin command
sudo nix run "nix-darwin/nix-darwin-25.05#darwin-rebuild" -- --flake ".config/nix#simple" switch

# Run the nix-rebuild alias in a new shell
nix-rebuild

# Install homebrew things
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
cd ~/.config/brew && just brew-install
```

## Just commands

| Command                        | Explanation                                                                                                                                                     |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `just vscode-extensions-apply` | This is needed because VS Code minifies the file, so `chezmoi diff` will a lot of times have a lot of changes. With this command, these changes can be ignored. |
| `just yazi-add-package-toml`   | This is needed because this file is updated via `ya pkg <...>` commands outside of `chezmoi`.                                                                   |
