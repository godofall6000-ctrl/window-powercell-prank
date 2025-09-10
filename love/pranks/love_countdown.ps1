#Requires -Version 5.1
[Console]::OutputEncoding = [System.TextEncoding]::UTF8
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Load intensity settings and config
$intensity = $env:PRANK_INTENSITY
$multiplier = [double]$env:INTENSITY_MULTIPLIER
$targetName = $env:TARGET_NAME

if (-not $intensity) { $intensity = "medium" }
if (-not $multiplier) { $multiplier = 1.0 }
if (-not $targetName) { $targetName = "My Love" }

# Load config with enhanced error handling
$configPath = "../config/prank_config.json"
$config = $null
try {
    if (Test-Path $configPath) {
        $config = Get-Content $configPath -Encoding UTF8 | ConvertFrom-Json
    }
} catch {
    Write-Host "Warning: Could not load config file. Using defaults."
}

# Enhanced settings based on intensity
$settings = switch ($intensity) {
    "low" {
        @{CountdownTime = [int](30 * $multiplier); SurpriseFrequency = 5; MessageCount = 3}
    }
    "medium" {
        @{CountdownTime = [int](60 * $multiplier); SurpriseFrequency = 3; MessageCount = 5}
    }
    "high" {
        @{CountdownTime = [int](90 * $multiplier); SurpriseFrequency = 2; MessageCount = 8}
    }
    default {
        @{CountdownTime = [int](60 * $multiplier); SurpriseFrequency = 3; MessageCount = 5}
    }
}

# Romantic countdown messages
$romanticMessages = @(
    "Only {0} seconds until I can tell you how much I love you! 💕",
    "{0} seconds left... My heart is racing just thinking about you! 💓",
    "Counting down to the moment I get to say: I love you, {1}! 💖",
    "{0} more seconds until our love story continues... 📖💕",
    "The wait is almost over, {1}! Only {0} seconds to go! ⏰💕",
    "{0} seconds... Each one bringing me closer to you! 📏💕",
    "Almost there, {1}! {0} seconds until I sweep you off your feet! 💃🕺",
    "The anticipation is building! {0} seconds left, {1}! 🎉💕"
)

$surpriseMessages = @(
    "💕 SURPRISE! You're amazing! 💕",
    "🎉 BOO! I love you! 🎉",
    "💖 POP! You're my favorite! 💖",
    "🌟 SPARKLE! You're a star! 🌟",
    "💫 MAGIC! You're magical! 💫",
    "🎈 BALLOON! You're uplifting! 🎈",
    "🎊 PARTY! You're the life of my party! 🎊",
    "🎁 GIFT! You're a precious gift! 🎁"
)

# Create the countdown window
$form = New-Object System.Windows.Forms.Form
$form.Text = "⏰ Romantic Countdown for $targetName ⏰"
$form.Size = New-Object System.Drawing.Size(600, 500)
$form.StartPosition = "CenterScreen"
$form.TopMost = $true
$form.BackColor = [System.Drawing.Color]::LightPink
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false

# Header
$headerLabel = New-Object System.Windows.Forms.Label
$headerLabel.Text = "⏰ Love Countdown ⏰"
$headerLabel.Font = New-Object System.Drawing.Font("Arial", 20, [System.Drawing.FontStyle]::Bold)
$headerLabel.ForeColor = [System.Drawing.Color]::DarkRed
$headerLabel.Size = New-Object System.Drawing.Size(300, 50)
$headerLabel.Location = New-Object System.Drawing.Point(150, 20)
$headerLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($headerLabel)

# Main countdown display
$countdownLabel = New-Object System.Windows.Forms.Label
$countdownLabel.Text = $settings.CountdownTime.ToString()
$countdownLabel.Font = New-Object System.Drawing.Font("Arial", 48, [System.Drawing.FontStyle]::Bold)
$countdownLabel.ForeColor = [System.Drawing.Color]::Red
$countdownLabel.Size = New-Object System.Drawing.Size(200, 80)
$countdownLabel.Location = New-Object System.Drawing.Point(200, 80)
$countdownLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($countdownLabel)

# Subtitle
$subtitleLabel = New-Object System.Windows.Forms.Label
$subtitleLabel.Text = "seconds until..."
$subtitleLabel.Font = New-Object System.Drawing.Font("Arial", 14)
$subtitleLabel.ForeColor = [System.Drawing.Color]::DarkRed
$subtitleLabel.Size = New-Object System.Drawing.Size(200, 30)
$subtitleLabel.Location = New-Object System.Drawing.Point(200, 160)
$subtitleLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($subtitleLabel)

# Romantic message display
$messageLabel = New-Object System.Windows.Forms.Label
$messageLabel.Text = "Something amazing happens!"
$messageLabel.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Italic)
$messageLabel.ForeColor = [System.Drawing.Color]::DarkRed
$messageLabel.Size = New-Object System.Drawing.Size(500, 40)
$messageLabel.Location = New-Object System.Drawing.Point(50, 200)
$messageLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($messageLabel)

# Progress bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Size = New-Object System.Drawing.Size(500, 20)
$progressBar.Location = New-Object System.Drawing.Point(50, 250)
$progressBar.Minimum = 0
$progressBar.Maximum = $settings.CountdownTime
$progressBar.Value = $settings.CountdownTime
$progressBar.ForeColor = [System.Drawing.Color]::Pink
$form.Controls.Add($progressBar)

# Status display
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Get ready for a romantic surprise! 💕"
$statusLabel.Font = New-Object System.Drawing.Font("Arial", 10)
$statusLabel.ForeColor = [System.Drawing.Color]::DarkGreen
$statusLabel.Size = New-Object System.Drawing.Size(400, 20)
$statusLabel.Location = New-Object System.Drawing.Point(100, 280)
$form.Controls.Add($statusLabel)

# Control buttons
$pauseButton = New-Object System.Windows.Forms.Button
$pauseButton.Text = "Pause ⏸️"
$pauseButton.Size = New-Object System.Drawing.Size(80, 35)
$pauseButton.Location = New-Object System.Drawing.Point(150, 320)
$pauseButton.BackColor = [System.Drawing.Color]::LightYellow
$pauseButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($pauseButton)

$resumeButton = New-Object System.Windows.Forms.Button
$resumeButton.Text = "Resume ▶️"
$resumeButton.Size = New-Object System.Drawing.Size(80, 35)
$resumeButton.Location = New-Object System.Drawing.Point(240, 320)
$resumeButton.BackColor = [System.Drawing.Color]::LightGreen
$resumeButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($resumeButton)

$skipButton = New-Object System.Windows.Forms.Button
$skipButton.Text = "Skip to End 🎯"
$skipButton.Size = New-Object System.Drawing.Size(100, 35)
$skipButton.Location = New-Object System.Drawing.Point(330, 320)
$skipButton.BackColor = [System.Drawing.Color]::LightBlue
$skipButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($skipButton)

# End countdown button
$endButton = New-Object System.Windows.Forms.Button
$endButton.Text = "End Countdown 💔"
$endButton.Size = New-Object System.Drawing.Size(120, 35)
$endButton.Location = New-Object System.Drawing.Point(240, 370)
$endButton.BackColor = [System.Drawing.Color]::LightCoral
$endButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$endButton.Add_Click({ $form.Close() })
$form.Controls.Add($endButton)

# Countdown state variables
$timeLeft = $settings.CountdownTime
$isPaused = $false
$messageIndex = 0

# Function to update countdown display
function Update-CountdownDisplay {
    $countdownLabel.Text = $script:timeLeft.ToString()

    # Update progress bar
    $progressBar.Value = $script:timeLeft

    # Update message periodically
    if ($script:timeLeft % 10 -eq 0 -and $script:timeLeft -gt 0) {
        $romanticMessage = $romanticMessages[$script:messageIndex % $romanticMessages.Length]
        $messageLabel.Text = $romanticMessage -f $script:timeLeft, $targetName
        $script:messageIndex++
    }

    # Surprise messages
    if ($script:timeLeft % $settings.SurpriseFrequency -eq 0 -and $script:timeLeft -gt 0 -and $script:timeLeft -lt ($settings.CountdownTime - 5)) {
        $surpriseMessage = $surpriseMessages[(Get-Random -Minimum 0 -Maximum $surpriseMessages.Length)]
        $statusLabel.Text = $surpriseMessage
        $statusLabel.ForeColor = [System.Drawing.Color]::Purple

        # Flash effect
        $originalColor = $form.BackColor
        $form.BackColor = [System.Drawing.Color]::Yellow
        Start-Sleep -Milliseconds 200
        $form.BackColor = $originalColor
    } else {
        $statusLabel.Text = "Counting down to romance! 💕"
        $statusLabel.ForeColor = [System.Drawing.Color]::DarkGreen
    }
}

# Countdown timer
$countdownTimer = New-Object System.Windows.Forms.Timer
$countdownTimer.Interval = 1000
$countdownTimer.Add_Tick({
    if (-not $script:isPaused) {
        $script:timeLeft--

        if ($script:timeLeft -le 0) {
            $countdownTimer.Stop()

            # Countdown complete - show romantic finale
            $countdownLabel.Text = "0"
            $messageLabel.Text = "TIME'S UP! Here's your romantic surprise:"
            $statusLabel.Text = "🎉 COUNTDOWN COMPLETE! 🎉"
            $statusLabel.ForeColor = [System.Drawing.Color]::Red

            # Show romantic finale messages
            $finaleMessages = @(
                "I LOVE YOU, $targetName! 💕",
                "You're the most amazing person ever! ✨",
                "My heart belongs to you forever! 💖",
                "You're my everything! 🌟",
                "I can't wait to spend forever with you! 💑"
            )

            for ($i = 0; $i -lt [math]::Min($settings.MessageCount, $finaleMessages.Length); $i++) {
                $messageLabel.Text = $finaleMessages[$i]
                Start-Sleep -Milliseconds 1500
                $form.Refresh()
            }

            Start-Sleep 2
            [System.Windows.Forms.MessageBox]::Show("Countdown complete! Hope you enjoyed the romantic journey, $targetName! 💕", "Romantic Countdown Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            $form.Close()
        } else {
            Update-CountdownDisplay
        }
    }
})

# Button event handlers
$pauseButton.Add_Click({
    $script:isPaused = $true
    $statusLabel.Text = "Countdown paused... 💭"
    $statusLabel.ForeColor = [System.Drawing.Color]::Orange
})

$resumeButton.Add_Click({
    $script:isPaused = $false
    $statusLabel.Text = "Countdown resumed! 💕"
    $statusLabel.ForeColor = [System.Drawing.Color]::DarkGreen
})

$skipButton.Add_Click({
    $script:timeLeft = 1  # Will trigger completion on next tick
    $statusLabel.Text = "Skipping to the good part! 🎯"
    $statusLabel.ForeColor = [System.Drawing.Color]::Blue
})

# Initialize display
Update-CountdownDisplay

# Start the countdown
$form.Add_Shown({ $countdownTimer.Start() })

# Show the form
$form.ShowDialog()

# Cleanup
$countdownTimer.Dispose()