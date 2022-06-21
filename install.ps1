# Run with powershell Get-Contents install.ps1 | Invoke-Expression
$LOCALPATH=[Environment]::GetFolderPath('LocalApplicationData') + "\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Copy-Item -Path .\settings.json -Destination $LOCALPATH -Force
echo "Change hide task bar in settings"
echo "Also install font"
