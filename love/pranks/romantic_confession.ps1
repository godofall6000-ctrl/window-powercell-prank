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
        @{Timeout = [int](10 * $multiplier); HeartCount = 5; MessageVariations = 3}
    }
    "medium" {
        @{Timeout = [int](15 * $multiplier); HeartCount = 10; MessageVariations = 5}
    }
    "high" {
        @{Timeout = [int](20 * $multiplier); HeartCount = 20; MessageVariations = 8}
    }
    default {
        @{Timeout = [int](15 * $multiplier); HeartCount = 10; MessageVariations = 5}
    }
}

# Dynamic message generation based on intensity
$romanticMessages = @(
    "Will you go out with me, $targetName? My heart beats only for you! <3",
    "$targetName, you're the love of my life! Will you be mine forever?",
    "Every moment with you is magical, $targetName! Will you be my date?",
    "$targetName, you make my world complete! Will you go out with me?",
    "My love for you grows stronger each day, $targetName! Will you be my partner?",
    "$targetName, you're my dream come true! Will you make it reality?",
    "I can't imagine life without you, $targetName! Will you be my everything?",
    "$targetName, you're absolutely perfect! Will you be mine?"
)

$message = if ($config -and $config.pranks.romantic_confession.message) {
    $config.pranks.romantic_confession.message
} else {
    $romanticMessages[(Get-Random -Minimum 0 -Maximum ([math]::Min($settings.MessageVariations, $romanticMessages.Length)))]
}

# Create enhanced romantic form
$form = New-Object System.Windows.Forms.Form
$form.Text = "A Message from Your Secret Admirer"
$form.Size = New-Object System.Drawing.Size(500, 300)
$form.StartPosition = "CenterScreen"
$form.TopMost = $true
$form.BackColor = [System.Drawing.Color]::LightPink
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false

# Romantic background with hearts
for ($i = 0; $i -lt $settings.HeartCount; $i++) {
    $heart = New-Object System.Windows.Forms.Label
    $heart.Text = "<3"
    $heart.Font = New-Object System.Drawing.Font("Arial", 12)
    $heart.ForeColor = [System.Drawing.Color]::FromArgb((Get-Random -Minimum 150 -Maximum 255), (Get-Random -Minimum 50 -Maximum 150), (Get-Random -Minimum 50 -Maximum 150))
    $heart.Size = New-Object System.Drawing.Size(20, 20)
    $heart.Location = New-Object System.Drawing.Point((Get-Random -Minimum 0 -Maximum 480), (Get-Random -Minimum 0 -Maximum 280))
    $form.Controls.Add($heart)
}

# Main message label
$messageLabel = New-Object System.Windows.Forms.Label
$messageLabel.Text = $message
$messageLabel.Font = New-Object System.Drawing.Font("Arial", 14, [System.Drawing.FontStyle]::Bold)
$messageLabel.ForeColor = [System.Drawing.Color]::DarkRed
$messageLabel.Size = New-Object System.Drawing.Size(450, 60)
$messageLabel.Location = New-Object System.Drawing.Point(25, 30)
$messageLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($messageLabel)

# Countdown timer
$timeLeft = $settings.Timeout
$timerLabel = New-Object System.Windows.Forms.Label
$timerLabel.Text = "Time to decide: $timeLeft seconds"
$timerLabel.Font = New-Object System.Drawing.Font("Arial", 10)
$timerLabel.ForeColor = [System.Drawing.Color]::Red
$timerLabel.Size = New-Object System.Drawing.Size(200, 20)
$timerLabel.Location = New-Object System.Drawing.Point(150, 100)
$form.Controls.Add($timerLabel)

# Yes button with romantic styling
$yesButton = New-Object System.Windows.Forms.Button
$yesButton.Text = "Yes, Absolutely! <3"
$yesButton.Size = New-Object System.Drawing.Size(120, 40)
$yesButton.Location = New-Object System.Drawing.Point(80, 140)
$yesButton.BackColor = [System.Drawing.Color]::LightGreen
$yesButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$yesButton.Add_Click({
    # Play romantic acceptance sequence
    [System.Windows.Forms.MessageBox]::Show("YES! My heart is bursting with joy! <3", "Love Accepted!", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

    # Show celebration animation
    $celebrateForm = New-Object System.Windows.Forms.Form
    $celebrateForm.Text = "Celebration!"
    $celebrateForm.Size = New-Object System.Drawing.Size(300, 200)
    $celebrateForm.StartPosition = "CenterScreen"
    $celebrateForm.BackColor = [System.Drawing.Color]::Pink

    $celebrateLabel = New-Object System.Windows.Forms.Label
    $celebrateLabel.Text = "Love Wins!`n`n$targetName said YES!`n`n<3<3<3"
    $celebrateLabel.Font = New-Object System.Drawing.Font("Arial", 14, [System.Drawing.FontStyle]::Bold)
    $celebrateLabel.ForeColor = [System.Drawing.Color]::Red
    $celebrateLabel.Size = New-Object System.Drawing.Size(280, 120)
    $celebrateLabel.Location = New-Object System.Drawing.Point(10, 20)
    $celebrateLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $celebrateForm.Controls.Add($celebrateLabel)

    $celebrateForm.ShowDialog()

    $form.Close()
})
$form.Controls.Add($yesButton)

# No button with gentle styling
$noButton = New-Object System.Windows.Forms.Button
$noButton.Text = "Maybe Later..."
$noButton.Size = New-Object System.Drawing.Size(120, 40)
$noButton.Location = New-Object System.Drawing.Point(220, 140)
$noButton.BackColor = [System.Drawing.Color]::LightCoral
$noButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$noButton.Add_Click({
    $reasonForm = New-Object System.Windows.Forms.Form
    $reasonForm.Text = "Tell me why?"
    $reasonForm.Size = New-Object System.Drawing.Size(350, 200)
    $reasonForm.StartPosition = "CenterScreen"
    $reasonForm.BackColor = [System.Drawing.Color]::LightBlue

    $reasonLabel = New-Object System.Windows.Forms.Label
    $reasonLabel.Text = "Why not? Please tell me:`n(I promise not to be sad... much)"
    $reasonLabel.Font = New-Object System.Drawing.Font("Arial", 10)
    $reasonLabel.Size = New-Object System.Drawing.Size(320, 40)
    $reasonLabel.Location = New-Object System.Drawing.Point(15, 20)
    $reasonForm.Controls.Add($reasonLabel)

    $reasonText = New-Object System.Windows.Forms.TextBox
    $reasonText.Multiline = $true
    $reasonText.Size = New-Object System.Drawing.Size(320, 60)
    $reasonText.Location = New-Object System.Drawing.Point(15, 70)
    $reasonText.Text = "Type your reason here..."
    $reasonForm.Controls.Add($reasonText)

    $submitReason = New-Object System.Windows.Forms.Button
    $submitReason.Text = "Submit Reason"
    $submitReason.Size = New-Object System.Drawing.Size(100, 30)
    $submitReason.Location = New-Object System.Drawing.Point(125, 140)
    $submitReason.Add_Click({
        $reason = $reasonText.Text
        if ($reason -and $reason -ne "Type your reason here...") {
            [System.Windows.Forms.MessageBox]::Show("Thank you for being honest. I'll respect your decision.`n`nBut remember, my love for you is eternal! <3`n`nReason: $reason", "Understood", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        } else {
            [System.Windows.Forms.MessageBox]::Show("It's okay if you don't want to share. My feelings remain the same! <3", "No Reason Given", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
        $reasonForm.Close()
        $form.Close()
    })
    $reasonForm.Controls.Add($submitReason)

    $reasonForm.ShowDialog()
})
$form.Controls.Add($noButton)

# Maybe button for uncertainty
$maybeButton = New-Object System.Windows.Forms.Button
$maybeButton.Text = "I'm Not Sure..."
$maybeButton.Size = New-Object System.Drawing.Size(120, 40)
$maybeButton.Location = New-Object System.Drawing.Point(360, 140)
$maybeButton.BackColor = [System.Drawing.Color]::LightYellow
$maybeButton.Font = New-Object System.Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)
$maybeButton.Add_Click({
    [System.Windows.Forms.MessageBox]::Show("Take your time, $targetName! Love is worth waiting for.`n`nI'll be here when you're ready! <3", "Taking Time", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    $form.Close()
})
$form.Controls.Add($maybeButton)

# Progress bar for countdown
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Size = New-Object System.Drawing.Size(400, 20)
$progressBar.Location = New-Object System.Drawing.Point(50, 200)
$progressBar.Minimum = 0
$progressBar.Maximum = $settings.Timeout
$progressBar.Value = $settings.Timeout
$form.Controls.Add($progressBar)

# Countdown timer
$countdownTimer = New-Object System.Windows.Forms.Timer
$countdownTimer.Interval = 1000
$countdownTimer.Add_Tick({
    $script:timeLeft--
    $timerLabel.Text = "Time to decide: $script:timeLeft seconds"
    $progressBar.Value = $script:timeLeft

    if ($script:timeLeft -le 0) {
        $countdownTimer.Stop()
        [System.Windows.Forms.MessageBox]::Show("Time's up! But remember, my love for you never runs out! <3`n`nTake all the time you need to think about it.", "Time's Up", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        $form.Close()
    }
})

# Start the countdown
$form.Add_Shown({ $countdownTimer.Start() })

# Show the form
$form.ShowDialog()

# Cleanup
$countdownTimer.Dispose()