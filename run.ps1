if (!(test-path "C:\ProgramData\chocolatey\choco.exe")) {
    
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

RefreshEnv

choco upgrade chocolatey
choco upgrade all -y

if (!(Test-Path "$PROFILE")) {
    New-Item -Path "$PROFILE" -ItemType "file" -Force
}

Copy-Item -Force -Path "$PSScriptRoot/Microsoft.Powershell_profile.ps1" -Destination "$PROFILE"

$chocoPackages = @(
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

foreach ($ext in $vscodeExtensions) {
    if ((code --list-extensions | Where-Object { $_ -eq "$ext" }).Count -eq 0) {
        code --install-extension "$ext"
    }
}
