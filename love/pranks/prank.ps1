Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.MessageBox]::Show("Windows has detected a virus!", "Windows Security Alert", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)

$result = [System.Windows.Forms.MessageBox]::Show("Do you want to fix it now?", "Fix Virus", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
if ($result -eq [System.Windows.Forms.DialogResult]::No) { exit }

[System.Windows.Forms.MessageBox]::Show("Attempting to fix...", "Fixing", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
Start-Sleep 2

[System.Windows.Forms.MessageBox]::Show("Unable to fix the virus.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)

[System.Windows.Forms.MessageBox]::Show("Click OK to scan computer now.", "Scan", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

$form = New-Object System.Windows.Forms.Form
$form.Text = "Scanning Computer"
$form.Size = New-Object System.Drawing.Size(300, 100)
$form.StartPosition = "CenterScreen"
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Minimum = 0
$progressBar.Maximum = 100
$progressBar.Value = 0
$progressBar.Size = New-Object System.Drawing.Size(250, 20)
$progressBar.Location = New-Object System.Drawing.Point(20, 20)
$form.Controls.Add($progressBar)
$form.Show()
for ($i = 1; $i -le 100; $i++) {
    $progressBar.Value = $i
    Start-Sleep -Milliseconds 100
}
$form.Close()

[System.Windows.Forms.MessageBox]::Show("ALERT: VIRUS DETECTED!", "Virus Alert", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)

$result = [System.Windows.Forms.MessageBox]::Show("Do you want to delete the virus?", "Delete Virus", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
if ($result -eq [System.Windows.Forms.DialogResult]::No) {
    [System.Windows.Forms.MessageBox]::Show("You chose no. Virus remains.", "No Action", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    exit
}

[System.Windows.Forms.MessageBox]::Show("Attempting to delete virus...", "Deleting", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
Start-Sleep 2

[System.Windows.Forms.MessageBox]::Show("Unable to delete virus.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)

[System.Windows.Forms.MessageBox]::Show("VIRUS ACTIVATED: Deleting system32...", "Virus Activated", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
Start-Sleep 3

$form = New-Object System.Windows.Forms.Form
$form.Text = "File Transfer"
$form.Size = New-Object System.Drawing.Size(300, 100)
$form.StartPosition = "CenterScreen"
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Minimum = 0
$progressBar.Maximum = 5
$progressBar.Value = 0
$progressBar.Size = New-Object System.Drawing.Size(250, 20)
$progressBar.Location = New-Object System.Drawing.Point(20, 20)
$form.Controls.Add($progressBar)
$form.Show()
for ($i = 1; $i -le 5; $i++) {
    $progressBar.Value = $i
    Start-Sleep 1
}
$form.Close()

[System.Windows.Forms.MessageBox]::Show("File transfer complete.", "Transfer Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

[System.Windows.Forms.MessageBox]::Show("To avoid this kind of virus, kindly send love to me.", "Advice", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
Start-Sleep 2

[System.Windows.Forms.MessageBox]::Show("I love you", "Prank", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

# Additional advanced pranks
[System.Windows.Forms.MessageBox]::Show("System will shut down in 10 seconds due to critical error.", "Critical Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
Start-Sleep 5

[System.Windows.Forms.MessageBox]::Show("Shutdown initiated. Saving data...", "Shutdown", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
Start-Sleep 3

[System.Windows.Forms.MessageBox]::Show("Data saved. Shutting down now.", "Shutdown Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

# Fake BSOD simulation
$form = New-Object System.Windows.Forms.Form
$form.Text = "Blue Screen of Death"
$form.Size = New-Object System.Drawing.Size(800, 600)
$form.BackColor = [System.Drawing.Color]::Blue
$form.StartPosition = "CenterScreen"
$label = New-Object System.Windows.Forms.Label
$label.Text = "A problem has been detected and Windows has been shut down to prevent damage to your computer.`n`nIRQL_NOT_LESS_OR_EQUAL`n`nIf this is the first time you've seen this error screen, restart your computer. If this screen appears again, follow these steps:`n`nCheck to make sure any new hardware or software is properly installed.`nIf this is a new installation, ask your hardware or software manufacturer for any Windows updates you might need.`n`nIf problems continue, disable or remove any newly installed hardware or software. Disable BIOS memory options such as caching or shadowing.`nIf you need to use Safe Mode to remove or disable components, restart your computer, press F8 to select Advanced Startup Options, and then select Safe Mode.`n`nTechnical information:`n*** STOP: 0x0000000A (0x00000000, 0x00000000, 0x00000000, 0x00000000)`n`nCollecting data for crash dump...`nInitializing disk for crash dump...`nBeginning dump of physical memory.`nDumping physical memory to disk: 100"
$label.Font = New-Object System.Drawing.Font("Lucida Console", 10)
$label.ForeColor = [System.Drawing.Color]::White
$label.Size = New-Object System.Drawing.Size(780, 550)
$label.Location = New-Object System.Drawing.Point(10, 10)
$form.Controls.Add($label)
$form.ShowDialog()

# Heart using positioned message box-like forms
$heartPositions = @(
    [PSCustomObject]@{X=5; Y=0},
    [PSCustomObject]@{X=4; Y=1},
    [PSCustomObject]@{X=5; Y=1},
    [PSCustomObject]@{X=6; Y=1},
    [PSCustomObject]@{X=3; Y=2},
    [PSCustomObject]@{X=7; Y=2},
    [PSCustomObject]@{X=3; Y=3},
    [PSCustomObject]@{X=4; Y=3},
    [PSCustomObject]@{X=6; Y=3},
    [PSCustomObject]@{X=7; Y=3},
    [PSCustomObject]@{X=4; Y=4},
    [PSCustomObject]@{X=5; Y=4},
    [PSCustomObject]@{X=6; Y=4},
    [PSCustomObject]@{X=5; Y=5}
)
foreach ($pos in $heartPositions) {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Heart"
    $form.Size = New-Object System.Drawing.Size(150, 100)
    $form.StartPosition = "Manual"
    $form.Location = New-Object System.Drawing.Point((100 + $pos.X * 50), (100 + $pos.Y * 50))
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "♥"
    $label.Font = New-Object System.Drawing.Font("Arial", 20)
    $label.Size = New-Object System.Drawing.Size(30, 30)
    $label.Location = New-Object System.Drawing.Point(10, 10)
    $form.Controls.Add($label)
    $button = New-Object System.Windows.Forms.Button
    $button.Text = "OK"
    $button.Size = New-Object System.Drawing.Size(50, 30)
    $button.Location = New-Object System.Drawing.Point(50, 50)
    $button.Add_Click({ $form.Close() })
    $form.Controls.Add($button)
    $form.Show()
}