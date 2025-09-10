#Requires -Version 5.1
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Add-Type -AssemblyName System.Windows.Forms

[System.Windows.Forms.MessageBox]::Show("Listen to some romantic sounds! *music*<3", "Romantic Sounds", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

# Try to play system sounds (these are built-in Windows sounds)
try {
    # Play different system sounds with romantic messages
    $messages = @(
        "That's the sound of my heart beating for you! <3",
        "Beep beep! That's me saying I love you! *heart*",
        "An exclamation of my love for you! :D",
        "Stop! You're too amazing! *kiss*",
        "Will you be mine forever? *hearts*"
    )

    # Use simpler sound approach - just show messages with sound descriptions
    foreach ($message in $messages) {
        [System.Windows.Forms.MessageBox]::Show($message, "Romantic Sound", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        Start-Sleep 1
    }
} catch {
    [System.Windows.Forms.MessageBox]::Show("Couldn't play sounds, but I still love you! *hug*", "Sound Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
}

[System.Windows.Forms.MessageBox]::Show("Hope the sounds made you smile! :) <3", "Romantic Sounds Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)