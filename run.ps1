$ROOT = "$HOME/.pj"

if (!(test-path "$ROOT")) {
    New-Item -Path "$ROOT" -Type "dir"
}

Add-Type -AssemblyName System.Net.Http;(New-Object System.Net.Http.HttpClient).GetStringAsync('https://raw.githubusercontent.com/purplejay-io/bootstrap_windows/main/Microsoft.PowerShell_profile.ps1').GetAwaiter().GetResult() | New-Item -Path "$ROOT/Microsoft.PowerShell_profile.ps1" -Force -Type "file"

if (!(test-path "C:\ProgramData\chocolatey\choco.exe")) {
    
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

RefreshEnv

choco upgrade chocolatey
choco upgrade all -y

if (!(Test-Path "$PROFILE")) {
    New-Item -Path "$PROFILE" -ItemType "file" -Force
}

Copy-Item -Force -Path "$ROOT/Microsoft.Powershell_profile.ps1" -Destination "$PROFILE"

$chocoPackages = @(
    "git",
    "vscode", 
    "python", 
    "dotnet-sdk", 
    "nvm", 
    "nodejs", 
    "docker-desktop"
)

foreach ($pkg in $chocoPackages) {
    if ((choco list --local | Where-Object { $_.Split(" ")[0] -eq "$pkg" }).Count -eq 0) {
        choco install -y "$pkg"
    }
}

RefreshEnv

if (!(Test-Path "$ROOT/bootstrap_windows")) 
{
    try 
    {
        git clone "https://github.com/purplejay-io/bootstrap_windows.git" "$ROOT"
    }
    catch 
    {
        start-process -FilePath "C:\Program Files\Git\cmd\git.exe" -ArgumentList "clone", "https://github.com/purplejay-io/bootstrap_windows.git", "$ROOT"
    }
}
else 
{
    $cwd = $(pwd)
    Set-Location "$ROOT/bootstrap_windows"
    git pull
    SET-Location "$cwd"
}


$vscodeExtensions = @(
    "ms-python.python", 
    "DotJoshJohnson.xml",
    "ms-azuretools.vscode-docker", 
    "redhat.vscode-yaml", 
    "ms-dotnettools.csharp", 
    "VisualStudioExptTeam.vscodeintellicode", 
    "christian-kohler.path-intellisense", 
    "2gua.rainbow-brackets", 
    "mechatroner.rainbow-csv",
    "ms-toolsai.jupyter",
    "streetsidesoftware.code-spell-checker",
    "ExecutableBookProject.myst-highlight",
    "yzhang.markdown-all-in-one"
)

foreach ($ext in $vscodeExtensions) 
{
    try 
    {
        if ((code --list-extensions | Where-Object { $_ -eq "$ext" }).Count -eq 0) 
        {
            code --install-extension "$ext"
        }
    }
    catch
    {
        Write-Output "Please reopen powershell and run script again"
        Write-Ouput "Script is found here: $ROOT/run.ps1"
    }
    
}
