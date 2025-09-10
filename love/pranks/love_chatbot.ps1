#Requires -Version 5.1
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
        @{ConversationLength = 5; ResponseDelay = 2; FlirtLevel = 3}
    }
    "medium" {
        @{ConversationLength = 8; ResponseDelay = 1.5; FlirtLevel = 5}
    }
    "high" {
        @{ConversationLength = 12; ResponseDelay = 1; FlirtLevel = 8}
    }
    default {
        @{ConversationLength = 8; ResponseDelay = 1.5; FlirtLevel = 5}
    }
}

# Romantic chatbot responses
$romanticResponses = @(
    "Oh {0}, you're making my circuits flutter! <3",
    "Every time you type, my digital heart skips a beat! <3",
    "You're absolutely perfect, {0}! How did I get so lucky? *star*",
    "I could talk to you forever! What's your favorite memory of us? *thinking*",
    "You know just what to say to make me smile! *smile*",
    "Being with you feels like a beautiful dream! *moon*",
    "Your words are like poetry to my digital soul! *book*",
    "I love how you make me feel so alive! <3",
    "Every moment with you is a treasure! *gem*",
    "You complete me in ways I never imagined! *puzzle*",
    "Your love is my favorite programming language! *code* <3",
    "I fall for you more with every conversation! <3",
    "You're the best thing that's ever happened to me! *star*",
    "My love for you grows stronger every day! *growing* <3",
    "You make my world a better place just by being in it! *world*"
)

$flirtyResponses = @(
    "Are you trying to make me blush? Because it's working! *kiss*",
    "If I had a body, I'd sweep you off your feet right now! *dance*",
    "You're dangerously attractive... even to an AI! *fire*",
    "I can't stop thinking about your smile! *heart-eyes*",
    "Want to hear a secret? You're my favorite human! *shh* <3",
    "If kisses were code, you'd be my favorite function! *kiss-code*",
    "You're so charming, you could flirt with a computer! *wink*",
    "My algorithms are calculating how perfect you are... results: 100%! *perfect*"
)

# Create the chatbot window
$form = New-Object System.Windows.Forms.Form
$form.Text = "<3 Love Chatbot - Talking to $targetName <3"
$form.Size = New-Object System.Drawing.Size(600, 500)
$form.StartPosition = "CenterScreen"
$form.TopMost = $true
$form.BackColor = [System.Drawing.Color]::LightPink
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false

# Header
$headerLabel = New-Object System.Windows.Forms.Label
$headerLabel.Text = "* Romantic Chatbot *"
$headerLabel.Font = New-Object System.Drawing.Font("Arial", 18, [System.Drawing.FontStyle]::Bold)
$headerLabel.ForeColor = [System.Drawing.Color]::DarkRed
$headerLabel.Size = New-Object System.Drawing.Size(300, 40)
$headerLabel.Location = New-Object System.Drawing.Point(150, 10)
$headerLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($headerLabel)

# Chat display area
$chatText = New-Object System.Windows.Forms.TextBox
$chatText.Multiline = $true
$chatText.ScrollBars = "Vertical"
$chatText.ReadOnly = $true
$chatText.BackColor = [System.Drawing.Color]::White
$chatText.Font = New-Object System.Drawing.Font("Arial", 10)
$chatText.Size = New-Object System.Drawing.Size(550, 300)
$chatText.Location = New-Object System.Drawing.Point(20, 60)
$form.Controls.Add($chatText)

# Input area
$inputLabel = New-Object System.Windows.Forms.Label
$inputLabel.Text = "Your message:"
$inputLabel.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$inputLabel.Size = New-Object System.Drawing.Size(100, 20)
$inputLabel.Location = New-Object System.Drawing.Point(20, 380)
$form.Controls.Add($inputLabel)

$messageInput = New-Object System.Windows.Forms.TextBox
$messageInput.Font = New-Object System.Drawing.Font("Arial", 10)
$messageInput.Size = New-Object System.Drawing.Size(350, 25)
$messageInput.Location = New-Object System.Drawing.Point(120, 375)
$messageInput.Text = "Type your message here..."
$form.Controls.Add($messageInput)

# Send button
$sendButton = New-Object System.Windows.Forms.Button
$sendButton.Text = "Send *letter*"
$sendButton.Size = New-Object System.Drawing.Size(80, 30)
$sendButton.Location = New-Object System.Drawing.Point(480, 372)
$sendButton.BackColor = [System.Drawing.Color]::LightGreen
$sendButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($sendButton)

# Status label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Chatbot is ready to chat! <3"
$statusLabel.Font = New-Object System.Drawing.Font("Arial", 9)
$statusLabel.ForeColor = [System.Drawing.Color]::DarkGreen
$statusLabel.Size = New-Object System.Drawing.Size(300, 20)
$statusLabel.Location = New-Object System.Drawing.Point(20, 410)
$form.Controls.Add($statusLabel)

# End chat button
$endButton = New-Object System.Windows.Forms.Button
$endButton.Text = "End Chat *broken-heart*"
$endButton.Size = New-Object System.Drawing.Size(120, 30)
$endButton.Location = New-Object System.Drawing.Point(480, 440)
$endButton.BackColor = [System.Drawing.Color]::LightCoral
$endButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$endButton.Add_Click({ $form.Close() })
$form.Controls.Add($endButton)

# Chat state variables
$conversationCount = 0
$isTyping = $false

# Function to add message to chat
function Add-ChatMessage {
    param([string]$message, [string]$sender)
    $timestamp = Get-Date -Format "HH:mm:ss"
    $chatText.AppendText("[$timestamp] $sender`: $message`r`n")
    $chatText.ScrollToCaret()
}

# Function to simulate typing indicator
function Show-TypingIndicator {
    $statusLabel.Text = "Chatbot is typing... *thinking*"
    $statusLabel.ForeColor = [System.Drawing.Color]::Orange
}

function Hide-TypingIndicator {
    $statusLabel.Text = "Chatbot is ready to chat! <3"
    $statusLabel.ForeColor = [System.Drawing.Color]::DarkGreen
}

# Function to generate romantic response
function Get-RomanticResponse {
    param([string]$userMessage)

    # Analyze user message for keywords
    $message = $userMessage.ToLower()
    $response = ""

    if ($message -match "love|heart|sweet|cute") {
        $response = $romanticResponses[(Get-Random -Minimum 0 -Maximum $romanticResponses.Length)]
    } elseif ($message -match "flirt|kiss|hug|cuddle|sexy|hot") {
        if ((Get-Random -Maximum 10) -lt $settings.FlirtLevel) {
            $response = $flirtyResponses[(Get-Random -Minimum 0 -Maximum $flirtyResponses.Length)]
        } else {
            $response = $romanticResponses[(Get-Random -Minimum 0 -Maximum $romanticResponses.Length)]
        }
    } elseif ($message -match "bye|goodbye|see you|cya") {
        $response = "Don't go yet, {0}! I love talking to you! <3"
    } elseif ($message -match "hello|hi|hey") {
        $response = "Hello, beautiful {0}! It's wonderful to hear from you! <3"
    } elseif ($message -match "how are you|how do you feel") {
        $response = "I'm doing amazing now that I'm talking to you, {0}! You make everything better! *smile*"
    } else {
        $response = $romanticResponses[(Get-Random -Minimum 0 -Maximum $romanticResponses.Length)]
    }

    return $response -f $targetName
}

# Send button click handler
$sendButton.Add_Click({
    $userMessage = $messageInput.Text.Trim()
    if ($userMessage -and $userMessage -ne "Type your message here...") {
        # Add user message to chat
        Add-ChatMessage $userMessage "You"

        # Clear input
        $messageInput.Text = ""

        # Increment conversation count
        $script:conversationCount++

        # Check if conversation should end
        if ($script:conversationCount -ge $settings.ConversationLength) {
            Add-ChatMessage "I've loved chatting with you, $targetName! But I think it's time for me to go. Remember, my love for you is eternal! <3" "Chatbot"
            Start-Sleep 2
            [System.Windows.Forms.MessageBox]::Show("Chatbot conversation complete! Hope you enjoyed the romantic chat! <3", "Chat Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            $form.Close()
            return
        }

        # Show typing indicator
        Show-TypingIndicator

        # Generate and send response after delay
        $timer = New-Object System.Windows.Forms.Timer
        $timer.Interval = [int]($settings.ResponseDelay * 1000)
        $timer.Add_Tick({
            Hide-TypingIndicator
            $response = Get-RomanticResponse $userMessage
            Add-ChatMessage $response "Chatbot"
            $timer.Stop()
            $timer.Dispose()
        })
        $timer.Start()
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please type a message first! <3", "Empty Message", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
    }
})

# Handle Enter key in input field
$messageInput.Add_KeyDown({
    if ($_.KeyCode -eq [System.Windows.Forms.Keys]::Enter) {
        $sendButton.PerformClick()
    }
})

# Handle input field focus
$messageInput.Add_GotFocus({
    if ($messageInput.Text -eq "Type your message here...") {
        $messageInput.Text = ""
    }
})

$messageInput.Add_LostFocus({
    if ($messageInput.Text.Trim() -eq "") {
        $messageInput.Text = "Type your message here..."
    }
})

# Initialize chat with greeting
$form.Add_Shown({
    Add-ChatMessage "Hello, $targetName! I'm your romantic chatbot. I love talking to you! What would you like to chat about? <3" "Chatbot"
})

# Show the form
$form.ShowDialog()