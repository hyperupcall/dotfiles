# Installation (Windows)

## Bootstrapping

Download and execute `bootstrap.ps1` to begin the bootstrap process:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

New-Item -type Directory -Force ~/.bootstrap >$null
Invoke-WebRequest -UseBasicParsing -Uri 'https://raw.githubusercontent.com/hyperupcall/dotfiles/main/os/windows/dotmgr/bootstrap.ps1' -OutFile ~/.bootstrap/bootstrap.ps1
~/.bootstrap/bootstrap.ps1
```

The `bootstrap.ps1` script performs the following steps:

- Installs [Scoop](https://scoop.sh)
- Installs sudo, Git, and Neovim
- Installs Cargo and Rust
- Clones `hyperupcall/dotfiles` to `~/.dotfiles`
- Clones `hyperupcall/dotmgr` to `~/.dotfiles/.data/dotmgr-src`
- Creates a `~/.bootstrap/bootstrap-out.sh`; sourcing it does the following:
  - Sets `NAME`, `EMAIL`, `EDITOR`, `VISUAL`
- Appends `$HOME/.dotfiles/.data/bin` to `PATH`

Then, run the following:

```sh
. ~/.bootstrap/bootstrap-out.ps1

# Now, continue with dotmgr
dotmgr action run bootstrap
dotmgr action run idempotent
```
