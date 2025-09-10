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
    $girlfriendName = $config.pranks.girlfriend_surprise.girlfriend_name
    $surpriseMessage = $config.pranks.girlfriend_surprise.message
} else {
    $girlfriendName = "Sweetheart"
    $surpriseMessage = "I have a surprise for you! <3"
}

[System.Windows.Forms.MessageBox]::Show("$surpriseMessage", "Message for $girlfriendName", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

# Create a romantic surprise window
$form = New-Object System.Windows.Forms.Form
$form.Text = "A Special Message for $girlfriendName"
$form.Size = New-Object System.Drawing.Size(500, 400)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::LightPink

$label = New-Object System.Windows.Forms.Label
$label.Text = "Dear $girlfriendName,`n`nYou are the most amazing person I know!`nEvery moment with you is a treasure.`nI love you more than words can express!`n`nWith all my heart,`nYour Secret Admirer 💕"
$label.Font = New-Object System.Drawing.Font("Arial", 14, [System.Drawing.FontStyle]::Bold)
$label.ForeColor = [System.Drawing.Color]::DarkRed
$label.Size = New-Object System.Drawing.Size(450, 200)
$label.Location = New-Object System.Drawing.Point(20, 20)
$label.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($label)

# Add romantic elements based on intensity
$intensityMultiplier = [int]($multiplier * 10)
for ($i = 0; $i -lt $intensityMultiplier; $i++) {
    $heart = New-Object System.Windows.Forms.Label
    $heart.Text = "<3"
    $heart.Font = New-Object System.Drawing.Font("Arial", 20)
    $heart.ForeColor = [System.Drawing.Color]::Red
    $heart.Size = New-Object System.Drawing.Size(30, 30)
    $heart.Location = New-Object System.Drawing.Point((Get-Random -Minimum 20 -Maximum 450), (Get-Random -Minimum 250 -Maximum 350))
    $form.Controls.Add($heart)
}

$button = New-Object System.Windows.Forms.Button
$button.Text = "I Love You Too! 💕"
$button.Size = New-Object System.Drawing.Size(150, 40)
$button.Location = New-Object System.Drawing.Point(175, 320)
$button.BackColor = [System.Drawing.Color]::Pink
$button.Add_Click({ $form.Close() })
$form.Controls.Add($button)

$form.ShowDialog()

[System.Windows.Forms.MessageBox]::Show("Hope you enjoyed the surprise, $girlfriendName! Remember, you're always in my heart! 💖", "Surprise Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)