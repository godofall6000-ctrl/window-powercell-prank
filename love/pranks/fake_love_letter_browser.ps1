Add-Type -AssemblyName System.Windows.Forms

[System.Windows.Forms.MessageBox]::Show("Your girlfriend sent you a love letter! Opening in browser...", "Love Letter", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

# Open the fake love letter in default browser
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$htmlPath = Join-Path $scriptDir "fake_love_letter.html"
Start-Process $htmlPath

Start-Sleep 2

[System.Windows.Forms.MessageBox]::Show("Hope you enjoyed the letter! Remember to reply!", "Letter Opened", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)