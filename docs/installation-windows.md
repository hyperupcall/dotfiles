# Installation (Windows)

## Bootstrapping

First,

- [Active developer mode](https://learn.microsoft.com/en-us/windows/apps/get-started/enable-your-device-for-development#activate-developer-mode)
- Don't enable "enable sudo", this one is buggy
- Launch System Restore, System Properties > System Protection > Configure, set Max Usage to 2GB (each restore takes about ~100MB)
- Launch Local Group Policy Editor, and navigate towards `Computer Configuration > Windows Settings > Security Settings > Local Policies > User Rights Assignment > Create symbolic links`, adding own user

Then, download and execute `bootstrap.ps1` to begin the bootstrap process:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
New-Item -Type Directory -Force ~/.bootstrap >$null
Invoke-WebRequest -UseBasicParsing -Uri 'https://raw.githubusercontent.com/hyperupcall/dotfiles/main/os-windows/bootstrap.ps1' -OutFile ~/.bootstrap/bootstrap.ps1
~/.bootstrap/bootstrap.ps1
```

The `bootstrap.ps1` script performs the following steps:

- Installs [Scoop](https://scoop.sh)
- Installs sudo, Git, and Neovim
- Installs Cargo and Rust
- Clones `hyperupcall/dotfiles` to `~/.dotfiles`
- Creates a `~/.bootstrap/bootstrap-out.ps1`; sourcing it does the following:
  - Sets `NAME`, `EMAIL`, `EDITOR`, `VISUAL`
  - Appends `$HOME/.dotfiles/.data/bin` to `PATH`

## Next Steps

Additional scripts should be executed. They include:

- `. ~/.bootstrap/bootstrap-out.ps1`
- `~/scripts/doctor.ps1`
