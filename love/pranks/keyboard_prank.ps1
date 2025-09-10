Add-Type -AssemblyName System.Windows.Forms

[System.Windows.Forms.MessageBox]::Show("Keyboard prank activated! Notepad will open and type random text.", "Keyboard Prank", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)

Start-Process notepad.exe
Start-Sleep 2

$randomText = "This is a prank! Your keyboard is possessed! " * 10

foreach ($char in $randomText.ToCharArray()) {
    [System.Windows.Forms.SendKeys]::SendWait($char)
    Start-Sleep -Milliseconds 100
}

[System.Windows.Forms.MessageBox]::Show("Keyboard prank ended.", "Prank Over", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)