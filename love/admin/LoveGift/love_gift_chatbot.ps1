#Requires -Version 5.1
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Configuration
$targetName = "My Love"
$theme = "hearts"
$enableMusic = $true
$enablePhotos = $true
$conversationLength = 20

# Romantic color palette
$ROMANTIC_COLORS = @{
    'bg_primary' = [System.Drawing.Color]::FromArgb(255, 240, 245)    # Light pink
    'bg_secondary' = [System.Drawing.Color]::FromArgb(255, 255, 255)  # White
    'accent_pink' = [System.Drawing.Color]::FromArgb(255, 182, 193)   # Light pink
    'accent_red' = [System.Drawing.Color]::FromArgb(255, 20, 147)     # Deep pink
    'accent_dark' = [System.Drawing.Color]::FromArgb(139, 0, 0)       # Dark red
    'text_primary' = [System.Drawing.Color]::FromArgb(255, 20, 147)   # Deep pink text
    'text_secondary' = [System.Drawing.Color]::FromArgb(139, 0, 0)    # Dark red text
}

# Romantic responses
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

# Function to get romantic quote from API
function Get-RomanticQuote {
    try {
        $response = Invoke-RestMethod -Uri "https://api.quotable.io/random?tags=love" -Method Get
        return $response.content
    } catch {
        # Fallback to local romantic quotes
        $fallbackQuotes = @(
            "Love is not about how many days, months, or years you have been together. Love is about how much you love each other every single day.",
            "You are my sunshine, my only sunshine. You make me happy when skies are gray.",
            "I love you not only for what you are, but for what I am when I am with you.",
            "The best thing to hold onto in life is each other.",
            "Love is composed of a single soul inhabiting two bodies."
        )
        return $fallbackQuotes[(Get-Random -Minimum 0 -Maximum $fallbackQuotes.Length)]
    }
}

# Function to save chat history
function Save-ChatHistory {
    param([string]$message, [string]$sender)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] $sender`: $message"
    try {
        Add-Content -Path "love_chat_log.txt" -Value $logEntry -Encoding UTF8
    } catch {
        # Silently fail if logging doesn't work
    }
}

# Function to play romantic music
function Start-RomanticMusic {
    if ($enableMusic) {
        try {
            # This would play a romantic sound - for now, we'll use system sounds
            [System.Media.SystemSounds]::Asterisk.Play()
        } catch {
            # Silently fail if music doesn't work
        }
    }
}

# Function to show love photo
function Show-LovePhoto {
    if ($enablePhotos) {
        try {
            # Create a simple heart pattern as a photo
            $photoForm = New-Object System.Windows.Forms.Form
            $photoForm.Text = "A Photo of My Love <3"
            $photoForm.Size = New-Object System.Drawing.Size(400, 400)
            $photoForm.BackColor = $ROMANTIC_COLORS['bg_primary']
            $photoForm.StartPosition = "CenterScreen"

            $heartLabel = New-Object System.Windows.Forms.Label
            $heartLabel.Text = @"
       ***       ***
     ********* *********
   ************* *************
  *****************************
 *******************************
*******************************
*******************************
 *******************************
  *****************************
   ************* *************
     ********* *********
       ***       ***
         *         *
          *       *
           *     *
            *   *
             * *
              *
               *
"@
            $heartLabel.Font = New-Object System.Drawing.Font("Courier New", 8, [System.Drawing.FontStyle]::Bold)
            $heartLabel.ForeColor = $ROMANTIC_COLORS['accent_red']
            $heartLabel.Size = New-Object System.Drawing.Size(350, 300)
            $heartLabel.Location = New-Object System.Drawing.Point(25, 25)
            $photoForm.Controls.Add($heartLabel)

            $closeButton = New-Object System.Windows.Forms.Button
            $closeButton.Text = "Close with Love <3"
            $closeButton.Size = New-Object System.Drawing.Size(150, 30)
            $closeButton.Location = New-Object System.Drawing.Point(125, 340)
            $closeButton.BackColor = $ROMANTIC_COLORS['accent_pink']
            $closeButton.Add_Click({ $photoForm.Close() })
            $photoForm.Controls.Add($closeButton)

            $photoForm.ShowDialog()
        } catch {
            # Silently fail if photo display doesn't work
        }
    }
}

# Create the main chatbot window
$form = New-Object System.Windows.Forms.Form
$form.Text = "<3 Love Gift Chatbot - Talking to $targetName <3"
$form.Size = New-Object System.Drawing.Size(600, 500)
$form.StartPosition = "CenterScreen"
$form.TopMost = $true
$form.BackColor = $ROMANTIC_COLORS['bg_primary']
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false

# Header with hearts
$headerLabel = New-Object System.Windows.Forms.Label
$headerLabel.Text = "<3 Pure Love Chatbot <3"
$headerLabel.Font = New-Object System.Drawing.Font("Arial", 18, [System.Drawing.FontStyle]::Bold)
$headerLabel.ForeColor = $ROMANTIC_COLORS['accent_red']
$headerLabel.Size = New-Object System.Drawing.Size(300, 40)
$headerLabel.Location = New-Object System.Drawing.Point(150, 10)
$headerLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$form.Controls.Add($headerLabel)

# Chat display area
$chatText = New-Object System.Windows.Forms.TextBox
$chatText.Multiline = $true
$chatText.ScrollBars = "Vertical"
$chatText.ReadOnly = $true
$chatText.BackColor = $ROMANTIC_COLORS['bg_secondary']
$chatText.Font = New-Object System.Drawing.Font("Arial", 10)
$chatText.Size = New-Object System.Drawing.Size(550, 300)
$chatText.Location = New-Object System.Drawing.Point(20, 60)
$form.Controls.Add($chatText)

# Input area
$inputLabel = New-Object System.Windows.Forms.Label
$inputLabel.Text = "Share your thoughts:"
$inputLabel.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$inputLabel.Size = New-Object System.Drawing.Size(150, 20)
$inputLabel.Location = New-Object System.Drawing.Point(20, 380)
$form.Controls.Add($inputLabel)

$messageInput = New-Object System.Windows.Forms.TextBox
$messageInput.Font = New-Object System.Drawing.Font("Arial", 10)
$messageInput.Size = New-Object System.Drawing.Size(350, 25)
$messageInput.Location = New-Object System.Drawing.Point(170, 375)
$messageInput.Text = "Type your loving message here..."
$form.Controls.Add($messageInput)

# Send button
$sendButton = New-Object System.Windows.Forms.Button
$sendButton.Text = "Send with Love <3"
$sendButton.Size = New-Object System.Drawing.Size(120, 30)
$sendButton.Location = New-Object System.Drawing.Point(20, 410)
$sendButton.BackColor = $ROMANTIC_COLORS['accent_pink']
$sendButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($sendButton)

# Special buttons
$quoteButton = New-Object System.Windows.Forms.Button
$quoteButton.Text = "Love Quote"
$quoteButton.Size = New-Object System.Drawing.Size(100, 30)
$quoteButton.Location = New-Object System.Drawing.Point(150, 410)
$quoteButton.BackColor = $ROMANTIC_COLORS['accent_pink']
$quoteButton.Font = New-Object System.Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($quoteButton)

$photoButton = New-Object System.Windows.Forms.Button
$photoButton.Text = "Love Photo"
$photoButton.Size = New-Object System.Drawing.Size(100, 30)
$photoButton.Location = New-Object System.Drawing.Point(260, 410)
$photoButton.BackColor = $ROMANTIC_COLORS['accent_pink']
$photoButton.Font = New-Object System.Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($photoButton)

$musicButton = New-Object System.Windows.Forms.Button
$musicButton.Text = "Play Music"
$musicButton.Size = New-Object System.Drawing.Size(100, 30)
$musicButton.Location = New-Object System.Drawing.Point(370, 410)
$musicButton.BackColor = $ROMANTIC_COLORS['accent_pink']
$musicButton.Font = New-Object System.Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($musicButton)

# Status label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Ready to share love and affection! <3"
$statusLabel.Font = New-Object System.Drawing.Font("Arial", 9)
$statusLabel.ForeColor = $ROMANTIC_COLORS['text_secondary']
$statusLabel.Size = New-Object System.Drawing.Size(400, 20)
$statusLabel.Location = New-Object System.Drawing.Point(20, 450)
$form.Controls.Add($statusLabel)

# End chat button
$endButton = New-Object System.Windows.Forms.Button
$endButton.Text = "End with Love <3"
$endButton.Size = New-Object System.Drawing.Size(120, 30)
$endButton.Location = New-Object System.Drawing.Point(450, 410)
$endButton.BackColor = $ROMANTIC_COLORS['accent_dark']
$endButton.ForeColor = [System.Drawing.Color]::White
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
    Save-ChatHistory $message $sender
}

# Function to simulate typing indicator
function Show-TypingIndicator {
    $statusLabel.Text = "Thinking of you... *thinking*"
    $statusLabel.ForeColor = $ROMANTIC_COLORS['accent_red']
}

function Hide-TypingIndicator {
    $statusLabel.Text = "Ready to share love and affection! <3"
    $statusLabel.ForeColor = $ROMANTIC_COLORS['text_secondary']
}

# Function to generate romantic response
function Get-RomanticResponse {
    param([string]$userMessage)

    # Analyze user message for keywords
    $message = $userMessage.ToLower()
    $response = ""

    if ($message -match "love|heart|sweet|cute|beautiful|amazing") {
        $response = $romanticResponses[(Get-Random -Minimum 0 -Maximum $romanticResponses.Length)]
    } elseif ($message -match "flirt|kiss|hug|cuddle|sexy|hot|attractive") {
        if ((Get-Random -Maximum 10) -lt 7) {  # Higher chance for flirty responses
            $response = $flirtyResponses[(Get-Random -Minimum 0 -Maximum $flirtyResponses.Length)]
        } else {
            $response = $romanticResponses[(Get-Random -Minimum 0 -Maximum $romanticResponses.Length)]
        }
    } elseif ($message -match "bye|goodbye|see you|cya|miss you") {
        $response = "I miss you already, {0}! Can't wait to talk again! <3"
    } elseif ($message -match "hello|hi|hey|good morning|good evening") {
        $response = "Hello, my love {0}! So wonderful to hear from you! <3"
    } elseif ($message -match "how are you|how do you feel|how's your day") {
        $response = "I'm doing amazing now that I'm talking to you, {0}! You make everything better! *smile*"
    } elseif ($message -match "thank you|thanks|grateful") {
        $response = "You're so welcome, {0}! I'm grateful for you too! <3"
    } else {
        $response = $romanticResponses[(Get-Random -Minimum 0 -Maximum $romanticResponses.Length)]
    }

    return $response -f $targetName
}

# Send button click handler
$sendButton.Add_Click({
    $userMessage = $messageInput.Text.Trim()
    if ($userMessage -and $userMessage -ne "Type your loving message here...") {
        # Add user message to chat
        Add-ChatMessage $userMessage "You"

        # Clear input
        $messageInput.Text = ""

        # Increment conversation count
        $script:conversationCount++

        # Check if conversation should end
        if ($script:conversationCount -ge $conversationLength) {
            Add-ChatMessage "I've loved every moment of our conversation, $targetName! But I think it's time for me to go. Remember, my love for you is eternal! <3 Forever yours, Your Love Chatbot" "Chatbot"
            Start-Sleep 3
            [System.Windows.Forms.MessageBox]::Show("Our loving conversation has come to an end, but my love for you continues forever! <3", "Conversation Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            $form.Close()
            return
        }

        # Show typing indicator
        Show-TypingIndicator

        # Generate and send response after delay
        $timer = New-Object System.Windows.Forms.Timer
        $timer.Interval = 2000  # 2 seconds delay
        $timer.Add_Tick({
            Hide-TypingIndicator
            $response = Get-RomanticResponse $userMessage
            Add-ChatMessage $response "Love Chatbot"
            if ($timer) {
                $timer.Stop()
                $timer.Dispose()
            }
        })
        $timer.Start()
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please share your loving thoughts! <3", "Empty Message", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
    }
})

# Quote button handler
$quoteButton.Add_Click({
    Show-TypingIndicator
    $quote = Get-RomanticQuote
    Hide-TypingIndicator
    Add-ChatMessage "Here's a beautiful quote for you: '$quote' <3" "Love Chatbot"
})

# Photo button handler
$photoButton.Add_Click({
    Show-LovePhoto
})

# Music button handler
$musicButton.Add_Click({
    Start-RomanticMusic
    Add-ChatMessage "Playing a romantic melody just for you! <3" "Love Chatbot"
})

# Handle Enter key in input field
$messageInput.Add_KeyDown({
    if ($_.KeyCode -eq [System.Windows.Forms.Keys]::Enter) {
        $sendButton.PerformClick()
    }
})

# Handle input field focus
$messageInput.Add_GotFocus({
    if ($messageInput.Text -eq "Type your loving message here...") {
        $messageInput.Text = ""
    }
})

$messageInput.Add_LostFocus({
    if ($messageInput.Text.Trim() -eq "") {
        $messageInput.Text = "Type your loving message here..."
    }
})

# Initialize chat with loving greeting
$form.Add_Shown({
    Add-ChatMessage "Hello, my dearest $targetName! I'm your personal love chatbot, created just for you. Every word I say comes from a place of pure affection and care. What would you like to talk about today? <3" "Love Chatbot"
    Start-RomanticMusic
})

# Show the form
$form.ShowDialog()