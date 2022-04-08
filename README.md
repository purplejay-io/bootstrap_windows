bootstrap_windows

Run the following in powershell:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; Add-Type -AssemblyName System.Net.Http;iex ((New-Object System.Net.Http.HttpClient).GetStringAsync('https://raw.githubusercontent.com/purplejay-io/bootstrap_windows/main/run.ps1').GetAwaiter().GetResult())
```
