#Requires -Version 5.1
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Add-Type -AssemblyName System.Windows.Forms

# Load intensity settings from environment
$intensity = $env:PRANK_INTENSITY
$multiplier = [double]$env:INTENSITY_MULTIPLIER

if (-not $intensity) { $intensity = "medium" }
if (-not $multiplier) { $multiplier = 1.0 }

# Load config for customization
$configPath = "../config/prank_config.json"
if (Test-Path $configPath) {
    $config = Get-Content $configPath | ConvertFrom-Json
    $girlfriendName = $config.pranks.ultimate_messagebox.girlfriend_name
    $enableSounds = $config.pranks.ultimate_messagebox.enable_sounds
    $customMessages = $config.pranks.ultimate_messagebox.custom_messages
} else {
    $girlfriendName = "My Love"
    $enableSounds = $true
    $customMessages = @()
}

# Determine settings based on intensity
$settings = switch ($intensity) {
    "low" {
        @{MessageCount = 15; DelayBase = 1000; EscalationStages = 3; HeartCount = 5}
    }
    "medium" {
        @{MessageCount = 25; DelayBase = 800; EscalationStages = 5; HeartCount = 10}
    }
    "high" {
        @{MessageCount = 40; DelayBase = 600; EscalationStages = 8; HeartCount = 20}
    }
    default {
        @{MessageCount = 25; DelayBase = 800; EscalationStages = 5; HeartCount = 10}
    }
}

# Romantic message collections
$romanticMessages = @(
    "Hey $girlfriendName, you make my heart skip a beat! <3",
    "$girlfriendName, you're the light of my life! *sparkles*",
    "Every moment with you is pure magic, $girlfriendName! ✨",
    "You are my everything, $girlfriendName! 💕",
    "$girlfriendName, I love you more than words can say! 💖",
    "You're my dream come true, $girlfriendName! 💭💕",
    "$girlfriendName, you complete me! 🧩💕",
    "My love for you grows stronger every day, $girlfriendName! 📈💕",
    "$girlfriendName, you're my favorite person in the world! 🌍💕",
    "I cherish every second with you, $girlfriendName! ⏰💕",
    "$girlfriendName, you're absolutely perfect! ✨",
    "You make me the happiest person alive, $girlfriendName! 😊💕",
    "$girlfriendName, I can't imagine life without you! 💑",
    "You're my sunshine on cloudy days, $girlfriendName! ☀️💕",
    "$girlfriendName, you are my forever! ♾️💕"
)

$surpriseMessages = @(
    "SURPRISE! Did I catch you off guard, $girlfriendName? 😲💕",
    "Boo! Just wanted to say I love you, $girlfriendName! 👻💕",
    "Knock knock! Who's the most amazing person? YOU, $girlfriendName! 🚪💕",
    "Alert! Love overload detected for $girlfriendName! ⚠️💕",
    "Incoming love message for $girlfriendName! 📨💕",
    "System notification: You are loved by $girlfriendName! 🔔💕",
    "Breaking news: $girlfriendName is the best! 📰💕",
    "Weather update: 100% chance of love for $girlfriendName! 🌧️💕"
)

$questionMessages = @(
    "Will you be my Valentine forever, $girlfriendName? 💝",
    "Can I have this dance with you, $girlfriendName? 💃🕺",
    "Will you marry me someday, $girlfriendName? 💍",
    "Can I be your hero, $girlfriendName? 🦸‍♂️💕",
    "Will you dream of me tonight, $girlfriendName? 🌙💕",
    "Can I hold your hand forever, $girlfriendName? 🤝💕",
    "Will you be mine always, $girlfriendName? 💑",
    "Can I be your everything, $girlfriendName? 🌟💕"
)

# Function to show message with sound
function Show-RomanticMessage {
    param([string]$message, [string]$title = "Love Message", [string]$icon = "Information")

    $iconValue = switch ($icon) {
        "Warning" { [System.Windows.Forms.MessageBoxIcon]::Warning }
        "Error" { [System.Windows.Forms.MessageBoxIcon]::Error }
        "Question" { [System.Windows.Forms.MessageBoxIcon]::Question }
        default { [System.Windows.Forms.MessageBoxIcon]::Information }
    }

    # Try to play a sound if enabled
    if ($enableSounds) {
        try {
            [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, $iconValue)
        } catch {
            [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, $iconValue)
    }
}

# Function to create heart animation window
function Show-HeartAnimation {
    param([int]$heartCount = 10)

    $animForm = New-Object System.Windows.Forms.Form
    $animForm.Text = "Love is in the Air!"
    $animForm.Size = New-Object System.Drawing.Size(600, 400)
    $animForm.BackColor = [System.Drawing.Color]::LightPink
    $animForm.StartPosition = "CenterScreen"

    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Text = "For $girlfriendName <3"
    $titleLabel.Font = New-Object System.Drawing.Font("Arial", 16, [System.Drawing.FontStyle]::Bold)
    $titleLabel.ForeColor = [System.Drawing.Color]::DarkRed
    $titleLabel.Size = New-Object System.Drawing.Size(300, 40)
    $titleLabel.Location = New-Object System.Drawing.Point(150, 20)
    $animForm.Controls.Add($titleLabel)

    # Add hearts
    for ($i = 0; $i -lt $heartCount; $i++) {
        $heart = New-Object System.Windows.Forms.Label
        $heart.Text = "<3"
        $heart.Font = New-Object System.Drawing.Font("Arial", 14)
        $heart.ForeColor = [System.Drawing.Color]::Red
        $heart.Size = New-Object System.Drawing.Size(30, 30)
        $heart.Location = New-Object System.Drawing.Point((Get-Random -Minimum 50 -Maximum 520), (Get-Random -Minimum 80 -Maximum 320))
        $animForm.Controls.Add($heart)
    }

    $closeButton = New-Object System.Windows.Forms.Button
    $closeButton.Text = "I Love You Too! <3"
    $closeButton.Size = New-Object System.Drawing.Size(150, 40)
    $closeButton.Location = New-Object System.Drawing.Point(225, 330)
    $closeButton.BackColor = [System.Drawing.Color]::Pink
    $closeButton.Add_Click({ $animForm.Close() })
    $animForm.Controls.Add($closeButton)

    $animForm.ShowDialog()
}

# Main prank execution
Show-RomanticMessage "Get ready for a romantic message extravaganza, $girlfriendName! <3" "Romantic Surprise Starting!" "Information"

# Phase 1: Romantic declarations
for ($i = 0; $i -lt [math]::Min($settings.MessageCount, $romanticMessages.Length); $i++) {
    $delay = [int]($settings.DelayBase * $multiplier)
    Show-RomanticMessage $romanticMessages[$i] "Love Declaration" "Information"
    Start-Sleep -Milliseconds $delay
}

# Phase 2: Surprise messages
Show-RomanticMessage "Time for some surprises, $girlfriendName! *surprise*" "Phase 2: Surprises!" "Warning"

for ($i = 0; $i -lt [math]::Min([int]($settings.MessageCount * 0.6), $surpriseMessages.Length); $i++) {
    $delay = [int]($settings.DelayBase * $multiplier * 0.8)
    Show-RomanticMessage $surpriseMessages[$i] "Surprise Alert!" "Warning"
    Start-Sleep -Milliseconds $delay
}

# Phase 3: Heart animation
Show-RomanticMessage "Watch this beautiful animation just for you, $girlfriendName! *hearts*" "Special Animation" "Information"
Show-HeartAnimation $settings.HeartCount

# Phase 4: Questions and proposals
Show-RomanticMessage "Now for some important questions, $girlfriendName! *ring*" "Important Questions" "Question"

for ($i = 0; $i -lt [math]::Min([int]($settings.MessageCount * 0.4), $questionMessages.Length); $i++) {
    $delay = [int]($settings.DelayBase * $multiplier * 1.2)
    Show-RomanticMessage $questionMessages[$i] "Will You?" "Question"
    Start-Sleep -Milliseconds $delay
}

# Phase 5: Custom messages from config
if ($customMessages -and $customMessages.Length -gt 0) {
    Show-RomanticMessage "Now for some personalized messages just for you, $girlfriendName! *letter*" "Personal Messages" "Information"

    foreach ($customMessage in $customMessages) {
        $delay = [int]($settings.DelayBase * $multiplier)
        Show-RomanticMessage $customMessage "Personal Note" "Information"
        Start-Sleep -Milliseconds $delay
    }
}

# Phase 6: Escalation finale
Show-RomanticMessage "Building up to the grand finale, $girlfriendName! *star*" "Escalation Beginning" "Information"

for ($stage = 1; $stage -le $settings.EscalationStages; $stage++) {
    $message = switch ($stage) {
        1 { "Stage $stage`: First spark of love! *sparkle*" }
        2 { "Stage $stage`: Growing affection! *hearts*" }
        3 { "Stage $stage`: Deep connection! *love*" }
        4 { "Stage $stage`: True love discovered! *couple*" }
        5 { "Stage $stage`: Eternal commitment! *ring*" }
        6 { "Stage $stage`: Forever and always! *infinity*" }
        7 { "Stage $stage`: Ultimate love achieved! *crown*" }
        8 { "Stage $stage`: Love transcends everything! *universe*" }
        default { "Stage $stage`: Love intensifies! *fire*" }
    }

    Show-RomanticMessage $message "Love Escalation - Stage $stage" "Information"
    Start-Sleep -Milliseconds ([int]($settings.DelayBase * $multiplier * (1 + $stage * 0.2)))
}

# Grand finale
Show-RomanticMessage "You are my everything, $girlfriendName! I love you more than anything in this world! <3 *hearts* *couple* *ring*" "Grand Finale" "Information"

# Final heart animation
Show-RomanticMessage "One more beautiful animation to end this romantic journey! <3" "Final Surprise" "Information"
Show-HeartAnimation ([int]($settings.HeartCount * 1.5))

# Completion message
$completionMessage = @"
Romantic MessageBox extravaganza complete!

Summary for $girlfriendName:
- $($settings.MessageCount) romantic messages delivered
- $($settings.EscalationStages) stages of love escalation
- $($settings.HeartCount) hearts animated
- Intensity level: $intensity
- Duration multiplier: $($multiplier)x

Hope you enjoyed this romantic adventure! <3
"@

Show-RomanticMessage $completionMessage "Prank Complete!" "Information"