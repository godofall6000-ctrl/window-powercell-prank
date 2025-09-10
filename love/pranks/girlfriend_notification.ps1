#Requires -Version 5.1
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Add-Type -AssemblyName System.Windows.Forms

# Get intensity settings from environment
$intensity = $env:PRANK_INTENSITY
$multiplier = [double]$env:INTENSITY_MULTIPLIER

if (-not $intensity) { $intensity = "medium" }
if (-not $multiplier) { $multiplier = 1.0 }

# Load config for customization
$configPath = "../config/prank_config.json"
if (Test-Path $configPath) {
    $config = Get-Content $configPath | ConvertFrom-Json
    $girlfriendName = $config.pranks.girlfriend_notification.girlfriend_name
    $notificationMessage = $config.pranks.girlfriend_notification.message
} else {
    $girlfriendName = "My Love"
    $notificationMessage = "You have a special message waiting!"
}

# Create system tray notification style popup
$form = New-Object System.Windows.Forms.Form
$form.Text = "Love Notification"
$form.Size = New-Object System.Drawing.Size(350, 150)
$form.StartPosition = "Manual"
$form.Location = New-Object System.Drawing.Point(50, 50)
$form.BackColor = [System.Drawing.Color]::LightPink
$form.TopMost = $true
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

$iconLabel = New-Object System.Windows.Forms.Label
$iconLabel.Text = "💌"
$iconLabel.Font = New-Object System.Drawing.Font("Arial", 24)
$iconLabel.Size = New-Object System.Drawing.Size(50, 50)
$iconLabel.Location = New-Object System.Drawing.Point(20, 20)
$form.Controls.Add($iconLabel)

$messageLabel = New-Object System.Windows.Forms.Label
$messageLabel.Text = "Hey $girlfriendName!`n$notificationMessage"
$messageLabel.Font = New-Object System.Drawing.Font("Arial", 12)
$messageLabel.Size = New-Object System.Drawing.Size(250, 60)
$messageLabel.Location = New-Object System.Drawing.Point(80, 20)
$form.Controls.Add($messageLabel)

$closeButton = New-Object System.Windows.Forms.Button
$closeButton.Text = "Open Message 💕"
$closeButton.Size = New-Object System.Drawing.Size(120, 30)
$closeButton.Location = New-Object System.Drawing.Point(115, 90)
$closeButton.BackColor = [System.Drawing.Color]::Pink
$closeButton.Add_Click({
    [System.Windows.Forms.MessageBox]::Show("Dear $girlfriendName,`n`nYou are my everything! Every day with you is a blessing.`nI cherish every moment we spend together.`nYou make my world brighter!`n`nForever yours,`nYour Loving Partner 💕", "Secret Love Message", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    $form.Close()
})
$form.Controls.Add($closeButton)

# Auto-close based on intensity
$autoCloseTime = [int](5000 * $multiplier)  # Base 5 seconds, scaled by intensity
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = $autoCloseTime
$timer.Add_Tick({
    $form.Close()
    $timer.Stop()
})
$timer.Start()

$form.ShowDialog()

[System.Windows.Forms.MessageBox]::Show("Surprise notification sent to $girlfriendName! Did you see the love message? 💕", "Notification Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)