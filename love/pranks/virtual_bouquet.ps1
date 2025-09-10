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

# Determine bouquet settings based on intensity
$settings = switch ($intensity) {
    "low" {
        @{FlowerCount = 8; FlowerTypes = 3; AnimationDuration = 10}
    }
    "medium" {
        @{FlowerCount = 15; FlowerTypes = 5; AnimationDuration = 15}
    }
    "high" {
        @{FlowerCount = 25; FlowerTypes = 7; AnimationDuration = 20}
    }
    default {
        @{FlowerCount = 15; FlowerTypes = 5; AnimationDuration = 15}
    }
}

# Flower types with colors
$flowerTypes = @(
    @{Symbol = "🌹"; Name = "Rose"; Color = [System.Drawing.Color]::Red},
    @{Symbol = "🌷"; Name = "Tulip"; Color = [System.Drawing.Color]::Pink},
    @{Symbol = "🌺"; Name = "Hibiscus"; Color = [System.Drawing.Color]::HotPink},
    @{Symbol = "🌸"; Name = "Cherry Blossom"; Color = [System.Drawing.Color]::LightPink},
    @{Symbol = "🌼"; Name = "Daisy"; Color = [System.Drawing.Color]::Yellow},
    @{Symbol = "🌻"; Name = "Sunflower"; Color = [System.Drawing.Color]::Gold},
    @{Symbol = "🌿"; Name = "Greenery"; Color = [System.Drawing.Color]::Green}
)

# Create the bouquet window
$form = New-Object System.Windows.Forms.Form
$form.Text = "Virtual Bouquet for $targetName"
$form.Size = New-Object System.Drawing.Size(700, 600)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::LightPink
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$form.MaximizeBox = $false

# Title
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "💐 Virtual Bouquet for $targetName 💐"
$titleLabel.Font = New-Object System.Drawing.Font("Arial", 18, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::DarkRed
$titleLabel.Size = New-Object System.Drawing.Size(500, 50)
$titleLabel.Location = New-Object System.Drawing.Point(100, 20)
$titleLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($titleLabel)

# Message
$messageLabel = New-Object System.Windows.Forms.Label
$messageLabel.Text = "These flowers represent my love for you! Each one blooms with affection. 🌸"
$messageLabel.Font = New-Object System.Drawing.Font("Arial", 12)
$messageLabel.ForeColor = [System.Drawing.Color]::Red
$messageLabel.Size = New-Object System.Drawing.Size(500, 30)
$messageLabel.Location = New-Object System.Drawing.Point(100, 70)
$messageLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($messageLabel)

# Vase
$vaseLabel = New-Object System.Windows.Forms.Label
$vaseLabel.Text = "🏺"
$vaseLabel.Font = New-Object System.Drawing.Font("Arial", 40)
$vaseLabel.Size = New-Object System.Drawing.Size(80, 80)
$vaseLabel.Location = New-Object System.Drawing.Point(310, 450)
$form.Controls.Add($vaseLabel)

# Create flowers
$flowers = @()
$usedTypes = @()

for ($i = 0; $i -lt $settings.FlowerCount; $i++) {
    # Select flower type (ensuring variety based on intensity)
    $typeIndex = Get-Random -Minimum 0 -Maximum ([math]::Min($settings.FlowerTypes, $flowerTypes.Length))
    $flowerType = $flowerTypes[$typeIndex]

    $flower = New-Object System.Windows.Forms.Label
    $flower.Text = $flowerType.Symbol
    $flower.Font = New-Object System.Drawing.Font("Arial", 24)
    $flower.ForeColor = $flowerType.Color
    $flower.Size = New-Object System.Drawing.Size(40, 40)

    # Position flowers in a bouquet arrangement
    $angle = ($i / $settings.FlowerCount) * 2 * [math]::PI
    $radius = 80 + (Get-Random -Minimum -20 -Maximum 20)
    $centerX = 330
    $centerY = 420

    $x = $centerX + $radius * [math]::Cos($angle) + (Get-Random -Minimum -30 -Maximum 30)
    $y = $centerY + $radius * [math]::Sin($angle) + (Get-Random -Minimum -30 -Maximum 30)

    $flower.Location = New-Object System.Drawing.Point($x, $y)
    $flower.Tag = @{OriginalY = $y; FloatOffset = 0; FloatDirection = 1}

    $form.Controls.Add($flower)
    $flowers += $flower
}

# Flower information panel
$infoPanel = New-Object System.Windows.Forms.GroupBox
$infoPanel.Text = "Bouquet Details"
$infoPanel.Size = New-Object System.Drawing.Size(200, 150)
$infoPanel.Location = New-Object System.Drawing.Point(480, 120)
$form.Controls.Add($infoPanel)

$infoLabel = New-Object System.Windows.Forms.Label
$infoLabel.Text = "Flowers: $($settings.FlowerCount)`nTypes: $($settings.FlowerTypes)`nDuration: $($settings.AnimationDuration)s`n`nEach flower represents`na moment of love! 💕"
$infoLabel.Font = New-Object System.Drawing.Font("Arial", 10)
$infoLabel.Size = New-Object System.Drawing.Size(180, 120)
$infoLabel.Location = New-Object System.Drawing.Point(10, 20)
$infoPanel.Controls.Add($infoLabel)

# Animation controls
$startButton = New-Object System.Windows.Forms.Button
$startButton.Text = "Start Blooming! 🌸"
$startButton.Size = New-Object System.Drawing.Size(120, 40)
$startButton.Location = New-Object System.Drawing.Point(50, 520)
$startButton.BackColor = [System.Drawing.Color]::LightGreen
$form.Controls.Add($startButton)

$stopButton = New-Object System.Windows.Forms.Button
$stopButton.Text = "Thank You! 💕"
$stopButton.Size = New-Object System.Drawing.Size(120, 40)
$stopButton.Location = New-Object System.Drawing.Point(200, 520)
$stopButton.BackColor = [System.Drawing.Color]::LightCoral
$stopButton.Add_Click({ $form.Close() })
$form.Controls.Add($stopButton)

# Animation timer
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 100

$animationStep = 0
$maxSteps = $settings.AnimationDuration * 10

$timer.Add_Tick({
    $script:animationStep++

    # Gentle floating animation for flowers
    foreach ($flower in $flowers) {
        $originalY = $flower.Tag.OriginalY
        $offset = $flower.Tag.FloatOffset
        $direction = $flower.Tag.FloatDirection

        $offset += $direction * 0.5

        if ([math]::Abs($offset) -gt 5) {
            $flower.Tag.FloatDirection = -$direction
        }

        $flower.Tag.FloatOffset = $offset
        $flower.Location = New-Object System.Drawing.Point($flower.Location.X, $originalY + $offset)
    }

    # End animation
    if ($script:animationStep -ge $maxSteps) {
        $timer.Stop()
        [System.Windows.Forms.MessageBox]::Show("The bouquet has fully bloomed! Each flower represents my love for you, $targetName! 💐💕", "Bouquet Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
})

# Start animation when button is clicked
$startButton.Add_Click({
    $timer.Start()
    $startButton.Enabled = $false
    $startButton.Text = "Blooming... 🌸"
})

$form.ShowDialog()

# Cleanup
$timer.Dispose()