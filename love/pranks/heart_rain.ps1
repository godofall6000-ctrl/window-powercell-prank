#Requires -Version 5.1
[Console]::OutputEncoding = [System.TextEncoding]::UTF8
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Load intensity settings
$intensity = $env:PRANK_INTENSITY
$multiplier = [double]$env:INTENSITY_MULTIPLIER
$targetName = $env:TARGET_NAME

if (-not $intensity) { $intensity = "medium" }
if (-not $multiplier) { $multiplier = 1.0 }
if (-not $targetName) { $targetName = "My Love" }

# Determine animation settings based on intensity
$settings = switch ($intensity) {
    "low" {
        @{HeartCount = 20; Duration = 10; Speed = 50}
    }
    "medium" {
        @{HeartCount = 35; Duration = 15; Speed = 30}
    }
    "high" {
        @{HeartCount = 50; Duration = 20; Speed = 20}
    }
    default {
        @{HeartCount = 35; Duration = 15; Speed = 30}
    }
}

# Create the main animation window
$form = New-Object System.Windows.Forms.Form
$form.Text = "Heart Rain for $targetName"
$form.Size = New-Object System.Drawing.Size(800, 600)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::LightPink
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$form.MaximizeBox = $false

# Title label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "🌧️ Heart Rain for $targetName 🌧️"
$titleLabel.Font = New-Object System.Drawing.Font("Arial", 18, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::DarkRed
$titleLabel.Size = New-Object System.Drawing.Size(400, 50)
$titleLabel.Location = New-Object System.Drawing.Point(200, 20)
$titleLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($titleLabel)

# Subtitle
$subtitleLabel = New-Object System.Windows.Forms.Label
$subtitleLabel.Text = "Watch the hearts fall like my love for you! 💕"
$subtitleLabel.Font = New-Object System.Drawing.Font("Arial", 12)
$subtitleLabel.ForeColor = [System.Drawing.Color]::Red
$subtitleLabel.Size = New-Object System.Drawing.Size(400, 30)
$subtitleLabel.Location = New-Object System.Drawing.Point(200, 70)
$subtitleLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($subtitleLabel)

# Create heart objects
$hearts = @()
$heartSymbols = @("<3", "💕", "💖", "💗", "💓", "💘", "💝", "💞", "💟", "❣️")

for ($i = 0; $i -lt $settings.HeartCount; $i++) {
    $heart = New-Object System.Windows.Forms.Label
    $heart.Text = $heartSymbols[$i % $heartSymbols.Length]
    $heart.Font = New-Object System.Drawing.Font("Arial", 16)
    $heart.ForeColor = [System.Drawing.Color]::FromArgb((Get-Random -Minimum 150 -Maximum 255), (Get-Random -Minimum 50 -Maximum 150), (Get-Random -Minimum 50 -Maximum 150))
    $heart.Size = New-Object System.Drawing.Size(30, 30)
    $heart.Location = New-Object System.Drawing.Point((Get-Random -Minimum 0 -Maximum 750), (Get-Random -Minimum -50 -Maximum 0))
    $heart.Tag = @{Y = $heart.Location.Y; Speed = (Get-Random -Minimum 1 -Maximum 5)}
    $form.Controls.Add($heart)
    $hearts += $heart
}

# Stop button
$stopButton = New-Object System.Windows.Forms.Button
$stopButton.Text = "Stop the Rain 💔"
$stopButton.Size = New-Object System.Drawing.Size(120, 40)
$stopButton.Location = New-Object System.Drawing.Point(340, 520)
$stopButton.BackColor = [System.Drawing.Color]::LightCoral
$stopButton.Add_Click({ $form.Close() })
$form.Controls.Add($stopButton)

# Animation timer
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = $settings.Speed

$animationStep = 0
$maxSteps = [int]($settings.Duration * 1000 / $settings.Speed)

$timer.Add_Tick({
    $script:animationStep++

    foreach ($heart in $hearts) {
        $currentY = $heart.Location.Y
        $speed = $heart.Tag.Speed

        # Move heart down
        $newY = $currentY + $speed

        # Reset heart to top if it goes off screen
        if ($newY -gt 500) {
            $newY = (Get-Random -Minimum -50 -Maximum 0)
            $heart.Location = New-Object System.Drawing.Point((Get-Random -Minimum 0 -Maximum 750), $newY)
            # Change color occasionally
            if ((Get-Random -Maximum 10) -lt 3) {
                $heart.ForeColor = [System.Drawing.Color]::FromArgb((Get-Random -Minimum 150 -Maximum 255), (Get-Random -Minimum 50 -Maximum 150), (Get-Random -Minimum 50 -Maximum 150))
            }
        } else {
            $heart.Location = New-Object System.Drawing.Point($heart.Location.X, $newY)
        }
    }

    # End animation after duration
    if ($script:animationStep -ge $maxSteps) {
        $timer.Stop()
        [System.Windows.Forms.MessageBox]::Show("Heart rain complete! Did it make your heart flutter, $targetName? 💕", "Heart Rain Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        $form.Close()
    }
})

# Show the form and start animation
$form.Add_Shown({ $timer.Start() })
$form.ShowDialog()

# Cleanup
$timer.Dispose()