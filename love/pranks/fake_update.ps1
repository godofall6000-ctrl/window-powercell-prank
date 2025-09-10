Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows Update"
$form.Size = New-Object System.Drawing.Size(400, 200)
$form.StartPosition = "CenterScreen"
$form.TopMost = $true

$label = New-Object System.Windows.Forms.Label
$label.Text = "Installing updates... Do not turn off your computer."
$label.Size = New-Object System.Drawing.Size(350, 20)
$label.Location = New-Object System.Drawing.Point(20, 20)
$form.Controls.Add($label)

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Minimum = 0
$progressBar.Maximum = 100
$progressBar.Value = 0
$progressBar.Size = New-Object System.Drawing.Size(350, 20)
$progressBar.Location = New-Object System.Drawing.Point(20, 50)
$form.Controls.Add($progressBar)

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Downloading updates..."
$statusLabel.Size = New-Object System.Drawing.Size(350, 20)
$statusLabel.Location = New-Object System.Drawing.Point(20, 80)
$form.Controls.Add($statusLabel)

$form.Show()

for ($i = 1; $i -le 100; $i++) {
    $progressBar.Value = $i
    if ($i -lt 30) {
        $statusLabel.Text = "Downloading updates... $i%"
    } elseif ($i -lt 70) {
        $statusLabel.Text = "Installing updates... $i%"
    } else {
        $statusLabel.Text = "Finalizing updates... $i%"
    }
    Start-Sleep -Milliseconds 200
}

$form.Close()

[System.Windows.Forms.MessageBox]::Show("Updates installed successfully! Your computer will restart now.", "Update Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)