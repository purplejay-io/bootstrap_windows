function venv
{
    if (test-path ./venv) {
        Remove-Item -Force -Recurse ./venv
    }
    python -m venv venv --system-site-packages
    ./venv/Scripts/Activate.ps1
    python -m pip install -U pip
    python -m pip install -r requirements.txt
} 

$env:path = "$env:PATH;C:\ProgramData\chocolatey\lib\nodejs"
$env:path = "$env:PATH;C:\ProgramData\chocolatey\lib\nvm"