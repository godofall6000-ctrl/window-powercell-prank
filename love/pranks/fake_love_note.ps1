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
        @{AnimationDuration = [int](10 * $multiplier); HeartCount = 8; MessageLength = 50}
    }
    "medium" {
        @{AnimationDuration = [int](15 * $multiplier); HeartCount = 15; MessageLength = 100}
    }
    "high" {
        @{AnimationDuration = [int](25 * $multiplier); HeartCount = 25; MessageLength = 200}
    }
    default {
        @{AnimationDuration = [int](15 * $multiplier); HeartCount = 15; MessageLength = 100}
    }
}

# Dynamic love note generation
$loveNotes = @(
    "I love you more than your computer! Meet me at the coffee shop at 8 PM? xoxo",
    "Every time I see you, my heart skips a beat! You're my everything! <3",
    "You make my world brighter than a thousand screens! Can't wait to see you! 💕",
    "My love for you is like WiFi - invisible but I feel it everywhere! 📶💕",
    "You're the password to my heart! Let's unlock our future together! 🔐💖",
    "I love you more than coffee, and that's saying something! ☕💕",
    "You're my favorite notification! Popping up in my thoughts all day! 📱💕",
    "My love for you is like a computer virus - it spreads everywhere! 🦠💕",
    "You're the Ctrl+S to my unsaved document - you save me every day! 💾💕",
    "I love you more than memes, and that's the highest compliment! 😂💕"
)

$note = if ($config -and $config.pranks.fake_love_note.note) {
    $config.pranks.fake_love_note.note
} else {
    $loveNotes[(Get-Random -Minimum 0 -Maximum $loveNotes.Length)]
}

# Create interactive love note form
$form = New-Object System.Windows.Forms.Form
$form.Text = "💌 Love Note from $targetName 💌"
$form.Size = New-Object System.Drawing.Size(600, 500)
$form.StartPosition = "CenterScreen"
$form.TopMost = $true
$form.BackColor = [System.Drawing.Color]::LightPink
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false

# Romantic background pattern
for ($i = 0; $i -lt 20; $i++) {
    $bgHeart = New-Object System.Windows.Forms.Label
    $bgHeart.Text = "·"
    $bgHeart.Font = New-Object System.Drawing.Font("Arial", 8)
    $bgHeart.ForeColor = [System.Drawing.Color]::FromArgb(200, 150, 150, 150)
    $bgHeart.Size = New-Object System.Drawing.Size(10, 10)
    $bgHeart.Location = New-Object System.Drawing.Point((Get-Random -Minimum 0 -Maximum 580), (Get-Random -Minimum 0 -Maximum 480))
    $form.Controls.Add($bgHeart)
}

# Header
$headerLabel = New-Object System.Windows.Forms.Label
$headerLabel.Text = "💌 A Love Note Just for You 💌"
$headerLabel.Font = New-Object System.Drawing.Font("Arial", 18, [System.Drawing.FontStyle]::Bold)
$headerLabel.ForeColor = [System.Drawing.Color]::DarkRed
$headerLabel.Size = New-Object System.Drawing.Size(400, 40)
$headerLabel.Location = New-Object System.Drawing.Point(100, 20)
$headerLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($headerLabel)

# Love note display
$noteLabel = New-Object System.Windows.Forms.Label
$noteLabel.Text = $note
$noteLabel.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Italic)
$noteLabel.ForeColor = [System.Drawing.Color]::DarkRed
$noteLabel.Size = New-Object System.Drawing.Size(500, 80)
$noteLabel.Location = New-Object System.Drawing.Point(50, 80)
$noteLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($noteLabel)

# Interactive response buttons
$loveButton = New-Object System.Windows.Forms.Button
$loveButton.Text = "I Love You Too! 💕"
$loveButton.Size = New-Object System.Drawing.Size(150, 40)
$loveButton.Location = New-Object System.Drawing.Point(50, 180)
$loveButton.BackColor = [System.Drawing.Color]::LightGreen
$loveButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$loveButton.Add_Click({
    [System.Windows.Forms.MessageBox]::Show("Aww! My heart is melting! 💕`n`nLet's plan something special together!", "Love Returned!", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    $script:userResponse = "Love Returned"
})
$form.Controls.Add($loveButton)

$replyButton = New-Object System.Windows.Forms.Button
$replyButton.Text = "Reply with Message 💌"
$replyButton.Size = New-Object System.Drawing.Size(150, 40)
$replyButton.Location = New-Object System.Drawing.Point(225, 180)
$replyButton.BackColor = [System.Drawing.Color]::LightBlue
$replyButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$replyButton.Add_Click({
    $replyForm = New-Object System.Windows.Forms.Form
    $replyForm.Text = "Reply to Love Note"
    $replyForm.Size = New-Object System.Drawing.Size(400, 250)
    $replyForm.StartPosition = "CenterScreen"
    $replyForm.BackColor = [System.Drawing.Color]::LightPink

    $replyLabel = New-Object System.Windows.Forms.Label
    $replyLabel.Text = "Write your reply:"
    $replyLabel.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
    $replyLabel.Size = New-Object System.Drawing.Size(150, 30)
    $replyLabel.Location = New-Object System.Drawing.Point(20, 20)
    $replyForm.Controls.Add($replyLabel)

    $replyText = New-Object System.Windows.Forms.TextBox
    $replyText.Multiline = $true
    $replyText.Size = New-Object System.Drawing.Size(350, 100)
    $replyText.Location = New-Object System.Drawing.Point(20, 60)
    $replyText.Text = "Type your loving reply here..."
    $replyForm.Controls.Add($replyText)

    $sendReply = New-Object System.Windows.Forms.Button
    $sendReply.Text = "Send Reply 💕"
    $sendReply.Size = New-Object System.Drawing.Size(100, 30)
    $sendReply.Location = New-Object System.Drawing.Point(150, 180)
    $sendReply.Add_Click({
        $reply = $replyText.Text
        if ($reply -and $reply -ne "Type your loving reply here...") {
            [System.Windows.Forms.MessageBox]::Show("Reply sent! '$reply'`n`nYour message has been delivered with lots of love! 💕", "Reply Sent!", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            $script:userResponse = "Reply Sent: $reply"
        } else {
            [System.Windows.Forms.MessageBox]::Show("Please write a loving reply first! 💕", "Empty Reply", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        }
        $replyForm.Close()
    })
    $replyForm.Controls.Add($sendReply)

    $replyForm.ShowDialog()
})
$form.Controls.Add($replyButton)

$surpriseButton = New-Object System.Windows.Forms.Button
$surpriseButton.Text = "Plan a Surprise 🎁"
$surpriseButton.Size = New-Object System.Drawing.Size(150, 40)
$surpriseButton.Location = New-Object System.Drawing.Point(400, 180)
$surpriseButton.BackColor = [System.Drawing.Color]::LightYellow
$surpriseButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$surpriseButton.Add_Click({
    $surpriseIdeas = @(
        "Romantic dinner at your favorite restaurant",
        "Stargazing picnic in the park",
        "Surprise visit with flowers and chocolates",
        "Movie night with all your favorite films",
        "Breakfast in bed with heart-shaped pancakes"
    )
    $randomSurprise = $surpriseIdeas[(Get-Random -Minimum 0 -Maximum $surpriseIdeas.Length)]
    [System.Windows.Forms.MessageBox]::Show("Great idea! How about: $randomSurprise?`n`nLet's make it happen! 💕", "Surprise Planned!", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    $script:userResponse = "Surprise Planned: $randomSurprise"
})
$form.Controls.Add($surpriseButton)

# Enhanced heart animation with multiple hearts
$hearts = @()
$heartSymbols = @("<3", "💕", "💖", "💗", "💓", "💘", "💝", "💞", "💟")

for ($i = 0; $i -lt $settings.HeartCount; $i++) {
    $heart = New-Object System.Windows.Forms.Label
    $heart.Text = $heartSymbols[$i % $heartSymbols.Length]
    $heart.Font = New-Object System.Drawing.Font("Arial", 16)
    $heart.ForeColor = [System.Drawing.Color]::FromArgb((Get-Random -Minimum 150 -Maximum 255), (Get-Random -Minimum 50 -Maximum 150), (Get-Random -Minimum 50 -Maximum 150))
    $heart.Size = New-Object System.Drawing.Size(30, 30)
    $heart.Location = New-Object System.Drawing.Point((Get-Random -Minimum 50 -Maximum 550), (Get-Random -Minimum 250 -Maximum 450))
    $heart.Tag = @{OriginalY = $heart.Location.Y; FloatOffset = 0; FloatDirection = 1; Speed = (Get-Random -Minimum 1 -Maximum 3)}
    $form.Controls.Add($heart)
    $hearts += $heart
}

# Animation controls
$startAnimation = New-Object System.Windows.Forms.Button
$startAnimation.Text = "Start Heart Animation 💖"
$startAnimation.Size = New-Object System.Drawing.Size(180, 35)
$startAnimation.Location = New-Object System.Drawing.Point(210, 240)
$startAnimation.BackColor = [System.Drawing.Color]::Pink
$startAnimation.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($startAnimation)

$stopAnimation = New-Object System.Windows.Forms.Button
$stopAnimation.Text = "Stop & Close 💔"
$stopAnimation.Size = New-Object System.Drawing.Size(120, 35)
$stopAnimation.Location = New-Object System.Drawing.Point(240, 285)
$stopAnimation.BackColor = [System.Drawing.Color]::LightCoral
$stopAnimation.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$stopAnimation.Add_Click({ $form.Close() })
$form.Controls.Add($stopAnimation)

# Animation timer
$animationTimer = New-Object System.Windows.Forms.Timer
$animationTimer.Interval = 100
$animationStep = 0
$maxSteps = $settings.AnimationDuration * 10

$animationTimer.Add_Tick({
    $script:animationStep++

    # Animate hearts with floating motion
    foreach ($heart in $hearts) {
        $originalY = $heart.Tag.OriginalY
        $offset = $heart.Tag.FloatOffset
        $direction = $heart.Tag.FloatDirection
        $speed = $heart.Tag.Speed

        $offset += $direction * $speed * 0.5

        if ([math]::Abs($offset) -gt 10) {
            $heart.Tag.FloatDirection = -$direction
        }

        $heart.Tag.FloatOffset = $offset
        $newY = $originalY + $offset
        $heart.Location = New-Object System.Drawing.Point($heart.Location.X, $newY)

        # Random color change occasionally
        if ((Get-Random -Maximum 50) -lt 1) {
            $heart.ForeColor = [System.Drawing.Color]::FromArgb((Get-Random -Minimum 150 -Maximum 255), (Get-Random -Minimum 50 -Maximum 150), (Get-Random -Minimum 50 -Maximum 150))
        }
    }

    # End animation
    if ($script:animationStep -ge $maxSteps) {
        $animationTimer.Stop()
        [System.Windows.Forms.MessageBox]::Show("Heart animation complete! The love in the air is palpable! 💕`n`nWhat did you think of the love note?", "Animation Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
})

$startAnimation.Add_Click({
    $animationTimer.Start()
    $startAnimation.Enabled = $false
    $startAnimation.Text = "Animation Running... 💖"
})

# Status display
$userResponse = "Waiting for response..."
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Status: $userResponse"
$statusLabel.Font = New-Object System.Drawing.Font("Arial", 10)
$statusLabel.ForeColor = [System.Drawing.Color]::DarkGreen
$statusLabel.Size = New-Object System.Drawing.Size(300, 20)
$statusLabel.Location = New-Object System.Drawing.Point(150, 330)
$form.Controls.Add($statusLabel)

# Update status periodically
$statusTimer = New-Object System.Windows.Forms.Timer
$statusTimer.Interval = 500
$statusTimer.Add_Tick({
    $statusLabel.Text = "Status: $script:userResponse"
})
$statusTimer.Start()

$form.ShowDialog()

# Cleanup
$animationTimer.Dispose()
$statusTimer.Dispose()

# Final message based on user interaction
$finalMessage = switch ($userResponse) {
    {$_ -like "Love Returned*"} { "Perfect! Love is in the air! 💕" }
    {$_ -like "Reply Sent*"} { "Your reply has been sent with extra love! 💌" }
    {$_ -like "Surprise Planned*"} { "Exciting plans ahead! Can't wait! 🎉" }
    default { "Thanks for reading my love note! 💕" }
}

[System.Windows.Forms.MessageBox]::Show($finalMessage, "Love Note Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)