# Love Gift Customization Script
# Allows personalization of the chatbot before giving it as a gift

Write-Host "<3 Love Gift Chatbot Customization <3" -ForegroundColor Magenta
Write-Host "=====================================" -ForegroundColor Cyan

# Get customization inputs
Write-Host "`n* Who is this loving gift for?" -ForegroundColor Yellow
$recipientName = Read-Host "Enter recipient's name"

Write-Host "`n*letter* What loving message should appear when they start?" -ForegroundColor Yellow
$customGreeting = Read-Host "Enter custom greeting (or press Enter for default)"

if (-not $customGreeting) {
    $customGreeting = "Hello, my dearest $recipientName! I'm your personal love chatbot, created just for you."
}

Write-Host "`n*music* Should romantic music play automatically? (Y/N)" -ForegroundColor Yellow
$musicChoice = Read-Host
$enableMusic = ($musicChoice -eq "Y" -or $musicChoice -eq "y")

Write-Host "`n*camera* Should love photos be available? (Y/N)" -ForegroundColor Yellow
$photoChoice = Read-Host
$enablePhotos = ($photoChoice -eq "Y" -or $photoChoice -eq "y")

Write-Host "`n*speech* How many messages before the conversation ends? (default: 20)" -ForegroundColor Yellow
$conversationLength = Read-Host
if (-not $conversationLength -or -not [int]::TryParse($conversationLength, [ref]$null)) {
    $conversationLength = 20
}

Write-Host "`n*palette* Choose a theme: 1) Hearts & Roses  2) Valentine's Day  3) Anniversary" -ForegroundColor Yellow
$themeChoice = Read-Host
switch ($themeChoice) {
    "2" { $theme = "valentines" }
    "3" { $theme = "anniversary" }
    default { $theme = "hearts" }
}

# Create customized version
Write-Host "`n*tools* Creating customized Love Gift Chatbot..." -ForegroundColor Green

$originalScript = Get-Content "love_gift_chatbot.ps1" -Raw

# Replace customization variables
$customizedScript = $originalScript
$customizedScript = $customizedScript -replace '\$targetName = "My Love"', "`$targetName = `"$recipientName`""
$customizedScript = $customizedScript -replace '\$enableMusic = \$true', "`$enableMusic = `$$enableMusic"
$customizedScript = $customizedScript -replace '\$enablePhotos = \$true', "`$enablePhotos = `$$enablePhotos"
$customizedScript = $customizedScript -replace '\$conversationLength = 20', "`$conversationLength = $conversationLength"
$customizedScript = $customizedScript -replace '\$theme = "hearts"', "`$theme = `"$theme`""

# Replace the greeting
$greetingPattern = 'Add-ChatMessage "Hello, my dearest \$targetName! I''m your personal love chatbot, created just for you. Every word I say comes from a place of pure affection and care. What would you like to talk about today\? <3" "Love Chatbot"'
$customGreetingEscaped = $customGreeting -replace '"', '""'
$customizedScript = $customizedScript -replace $greetingPattern, "Add-ChatMessage `"$customGreetingEscaped <3`" `"Love Chatbot`""

# Set the boolean values
if ($enableMusic) {
    $customizedScript = $customizedScript -replace '\$enableMusic = \$true', '$enableMusic = $true'
} else {
    $customizedScript = $customizedScript -replace '\$enableMusic = \$true', '$enableMusic = $false'
}

if ($enablePhotos) {
    $customizedScript = $customizedScript -replace '\$enablePhotos = \$true', '$enablePhotos = $true'
} else {
    $customizedScript = $customizedScript -replace '\$enablePhotos = \$true', '$enablePhotos = $false'
}

# Save customized script
$customizedScript | Out-File -FilePath "love_gift_chatbot_custom.ps1" -Encoding UTF8

Write-Host "`n*check* Customization complete!" -ForegroundColor Green
Write-Host "*folder* Customized script saved as: love_gift_chatbot_custom.ps1" -ForegroundColor Cyan

# Update README with recipient name
$readmeContent = Get-Content "README_LoveGift.txt" -Raw
$readmeContent = $readmeContent -replace "\[Girlfriend's Name\]", $recipientName
$readmeContent = $readmeContent -replace "\[Your Name\]", "Your Loving Partner"
$readmeContent | Out-File -FilePath "README_LoveGift_Personal.txt" -Encoding UTF8

Write-Host "*memo* Personalized README created: README_LoveGift_Personal.txt" -ForegroundColor Cyan

Write-Host "`n*gift* Your Love Gift is ready!" -ForegroundColor Magenta
Write-Host "Files created:" -ForegroundColor Yellow
Write-Host "  * love_gift_chatbot_custom.ps1 (customized chatbot)" -ForegroundColor White
Write-Host "  * README_LoveGift_Personal.txt (personalized instructions)" -ForegroundColor White
Write-Host "  * Run_Love_Chatbot.bat (easy launcher)" -ForegroundColor White
Write-Host "  * heart_image.txt (love photo)" -ForegroundColor White

Write-Host "`n<3 To compile to executable, run: .\compile_to_exe.ps1" -ForegroundColor Green
Write-Host "<3 Then give the .exe file and README to your loved one! <3" -ForegroundColor Green

Write-Host "`n*clipboard* Summary of customizations:" -ForegroundColor Cyan
Write-Host "  Recipient: $recipientName" -ForegroundColor White
Write-Host "  Music: $(if ($enableMusic) { 'Enabled' } else { 'Disabled' })" -ForegroundColor White
Write-Host "  Photos: $(if ($enablePhotos) { 'Enabled' } else { 'Disabled' })" -ForegroundColor White
Write-Host "  Conversation Length: $conversationLength messages" -ForegroundColor White
Write-Host "  Theme: $theme" -ForegroundColor White