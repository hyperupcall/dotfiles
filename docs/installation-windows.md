# Installation (Windows)

```powershell
# May be required to...
Set-ExecutionPolicy RemoteSigned -scope CurrentUser

# Method 1
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/hyperupcall/dots/main/windows/bootstrap/pre-bootstrap.sh')

# Method 2
iwr -useb 'https://raw.githubusercontent.com/hyperupcall/dots/main/windows/bootstrap/pre-bootstrap.sh' | iex
```