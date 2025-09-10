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
    $girlfriendName = $config.pranks.romantic_escalation.girlfriend_name
    $enableSounds = $config.pranks.romantic_escalation.enable_sounds
} else {
    $girlfriendName = "Darling"
    $enableSounds = $true
}

# Determine escalation levels based on intensity
$stages = switch ($intensity) {
    "low" { 3 }
    "medium" { 5 }
    "high" { 8 }
    default { 5 }
}

[System.Windows.Forms.MessageBox]::Show("Starting romantic escalation for $girlfriendName! Get ready for a building surprise! 💕", "Romantic Escalation Begins", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

# Stage 1: Simple message
$message1 = "Hey $girlfriendName, I have something special for you..."
[System.Windows.Forms.MessageBox]::Show($message1, "Stage 1: The Beginning", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
Start-Sleep ([int](1000 * $multiplier))

# Stage 2: Sweet message
$message2 = "$girlfriendName, you mean the world to me! <3"
$form2 = New-Object System.Windows.Forms.Form
$form2.Text = "Stage 2: Sweet Thoughts"
$form2.Size = New-Object System.Drawing.Size(300, 150)
$form2.StartPosition = "CenterScreen"
$form2.BackColor = [System.Drawing.Color]::LightPink

$label2 = New-Object System.Windows.Forms.Label
$label2.Text = $message2
$label2.Font = New-Object System.Drawing.Font("Arial", 14)
$label2.Size = New-Object System.Drawing.Size(280, 60)
$label2.Location = New-Object System.Drawing.Point(10, 20)
$form2.Controls.Add($label2)

$form2.Show()
Start-Sleep ([int](2000 * $multiplier))
$form2.Close()

# Stage 3: Romantic declaration
$message3 = "My dearest $girlfriendName, I love you more than anything! 💖"
[System.Windows.Forms.MessageBox]::Show($message3, "Stage 3: True Feelings", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
Start-Sleep ([int](1500 * $multiplier))

# Additional stages for higher intensity
if ($stages -ge 5) {
    # Stage 4: Memory lane
    $message4 = "Remember our first date, $girlfriendName? That was magical! ✨"
    [System.Windows.Forms.MessageBox]::Show($message4, "Stage 4: Precious Memories", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    Start-Sleep ([int](1500 * $multiplier))

    # Stage 5: Future promises
    $message5 = "I promise to love you forever, $girlfriendName! 💍"
    [System.Windows.Forms.MessageBox]::Show($message5, "Stage 5: Forever Promise", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    Start-Sleep ([int](1500 * $multiplier))
}

if ($stages -ge 8) {
    # Stage 6: Heart animation
    $form6 = New-Object System.Windows.Forms.Form
    $form6.Text = "Stage 6: Heart Animation"
    $form6.Size = New-Object System.Drawing.Size(400, 300)
    $form6.StartPosition = "CenterScreen"
    $form6.BackColor = [System.Drawing.Color]::Pink

    for ($i = 0; $i -lt 15; $i++) {
        $heart = New-Object System.Windows.Forms.Label
        $heart.Text = "<3"
        $heart.Font = New-Object System.Drawing.Font("Arial", 16)
        $heart.ForeColor = [System.Drawing.Color]::Red
        $heart.Size = New-Object System.Drawing.Size(30, 30)
        $heart.Location = New-Object System.Drawing.Point((Get-Random -Minimum 10 -Maximum 350), (Get-Random -Minimum 10 -Maximum 250))
        $form6.Controls.Add($heart)
    }

    $form6.Show()
    Start-Sleep ([int](3000 * $multiplier))
    $form6.Close()

    # Stage 7: Love letter
    $message7 = "Dear $girlfriendName,`n`nYou are my sunshine, my moon, and all my stars!`nEvery moment with you is pure magic.`nI love you to infinity and beyond!`n`nYour eternal love 💕"
    [System.Windows.Forms.MessageBox]::Show($message7, "Stage 7: Love Letter", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

    # Stage 8: Grand finale
    $message8 = "$girlfriendName, you are the love of my life! Will you be mine forever? 💑"
    [System.Windows.Forms.MessageBox]::Show($message8, "Stage 8: Grand Finale", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Question)
}

# Final message
$finalMessage = "Romantic escalation complete! Did you feel the love building up, $girlfriendName? 💕"
[System.Windows.Forms.MessageBox]::Show($finalMessage, "Escalation Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)