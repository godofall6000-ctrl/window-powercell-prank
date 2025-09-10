#Requires -Version 5.1
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Add-Type -AssemblyName System.Windows.Forms

# Load config
$configPath = "../config/prank_config.json"
if (Test-Path $configPath) {
    $config = Get-Content $configPath | ConvertFrom-Json
    $messages = $config.pranks.ghost_typing.messages
} else {
    $messages = @(
        "I love you more than code!",
        "Your computer is blushing... 💕",
        "Will you be my Valentine? Or at least my debugging partner?",
        "This is a ghost typing prank! Boo! 👻"
    )
}

[System.Windows.Forms.MessageBox]::Show("Ghost typing activated! Messages will appear in your text editors.", "Ghost Typing", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

Start-Sleep 3

foreach ($message in $messages) {
    [System.Windows.Forms.SendKeys]::SendWait($message)
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
    Start-Sleep 2
}

[System.Windows.Forms.MessageBox]::Show("Ghost typing complete! Hope you enjoyed the messages.", "Prank Over", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)