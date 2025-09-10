#Requires -Version 5.1
[Console]::OutputEncoding = [System.TextEncoding]::UTF8
Add-Type -AssemblyName System.Windows.Forms

# Load intensity settings
$intensity = $env:PRANK_INTENSITY
$multiplier = [double]$env:INTENSITY_MULTIPLIER
$targetName = $env:TARGET_NAME

if (-not $intensity) { $intensity = "medium" }
if (-not $multiplier) { $multiplier = 1.0 }
if (-not $targetName) { $targetName = "My Love" }

# Quiz questions based on intensity
$quizQuestions = @(
    @{
        Question = "What's $targetName's favorite color?"
        Options = @("Red (like my love)", "Blue (like the sky)", "Pink (like romance)", "Green (like nature)")
        Answer = 0
        Romantic = "Red is the color of passion and love! <3"
    },
    @{
        Question = "How many times does $targetName make my heart skip a beat?"
        Options = @("Every second", "Every minute", "Every hour", "Every day")
        Answer = 0
        Romantic = "Every single second I'm with you! *heart eyes*"
    },
    @{
        Question = "What's the most romantic thing $targetName could do?"
        Options = @("Send me flowers", "Write me a poem", "Surprise me with love", "Just be themselves")
        Answer = 3
        Romantic = "Being yourself is the most romantic thing ever! 💕"
    },
    @{
        Question = "How much do I love $targetName?"
        Options = @("A little", "A lot", "Very much", "To the moon and back!")
        Answer = 3
        Romantic = "To infinity and beyond! 🚀💕"
    },
    @{
        Question = "What's $targetName's best feature?"
        Options = @("Smile", "Eyes", "Personality", "Everything!")
        Answer = 3
        Romantic = "Everything about you is perfect! ✨"
    }
)

# Determine number of questions based on intensity
$questionCount = switch ($intensity) {
    "low" { 2 }
    "medium" { 3 }
    "high" { 5 }
    default { 3 }
}

$score = 0
$romanticResponses = @()

for ($i = 0; $i -lt $questionCount; $i++) {
    $question = $quizQuestions[$i]

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Love Quiz for $targetName - Question $($i + 1)"
    $form.Size = New-Object System.Drawing.Size(500, 350)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [System.Drawing.Color]::LightPink

    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Text = "💕 Love Quiz 💕"
    $titleLabel.Font = New-Object System.Drawing.Font("Arial", 16, [System.Drawing.FontStyle]::Bold)
    $titleLabel.ForeColor = [System.Drawing.Color]::DarkRed
    $titleLabel.Size = New-Object System.Drawing.Size(300, 40)
    $titleLabel.Location = New-Object System.Drawing.Point(100, 20)
    $form.Controls.Add($titleLabel)

    $questionLabel = New-Object System.Windows.Forms.Label
    $questionLabel.Text = $question.Question
    $questionLabel.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
    $questionLabel.Size = New-Object System.Drawing.Size(450, 40)
    $questionLabel.Location = New-Object System.Drawing.Point(25, 80)
    $questionLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $form.Controls.Add($questionLabel)

    $optionButtons = @()
    $selectedAnswer = -1

    for ($j = 0; $j -lt $question.Options.Length; $j++) {
        $optionButton = New-Object System.Windows.Forms.RadioButton
        $optionButton.Text = $question.Options[$j]
        $optionButton.Font = New-Object System.Drawing.Font("Arial", 10)
        $optionButton.Size = New-Object System.Drawing.Size(400, 30)
        $optionButton.Location = New-Object System.Drawing.Point(50, 130 + ($j * 35))
        $optionButton.Tag = $j
        $optionButton.Add_CheckedChanged({
            param($sender, $e)
            if ($sender.Checked) {
                $script:selectedAnswer = $sender.Tag
            }
        })
        $form.Controls.Add($optionButton)
        $optionButtons += $optionButton
    }

    $submitButton = New-Object System.Windows.Forms.Button
    $submitButton.Text = "Submit Answer <3"
    $submitButton.Size = New-Object System.Drawing.Size(120, 40)
    $submitButton.Location = New-Object System.Drawing.Point(190, 280)
    $submitButton.BackColor = [System.Drawing.Color]::Pink
    $submitButton.Add_Click({
        if ($script:selectedAnswer -eq $question.Answer) {
            $script:score++
            [System.Windows.Forms.MessageBox]::Show("Correct! " + $question.Romantic, "Love Quiz", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        } else {
            [System.Windows.Forms.MessageBox]::Show("That's sweet, but the romantic answer is: " + $question.Options[$question.Answer] + "`n" + $question.Romantic, "Love Quiz", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
        $script:romanticResponses += $question.Romantic
        $form.Close()
    })
    $form.Controls.Add($submitButton)

    $form.ShowDialog()
}

# Final results
$percentage = [math]::Round(($score / $questionCount) * 100)
$romanticLevel = switch {
    ($percentage -ge 80) { "Ultimate Romantic! 💕💕💕" }
    ($percentage -ge 60) { "Very Romantic! 💕💕" }
    ($percentage -ge 40) { "Sweet Romantic! 💕" }
    default { "Learning to be Romantic! 💕" }
}

$resultMessage = @"
Love Quiz Complete!

Results for $targetName:
- Questions Answered: $questionCount
- Correct Answers: $score
- Romantic Score: $percentage%
- Romantic Level: $romanticLevel

Romantic Highlights:
$($romanticResponses -join "`n")

You got $($score)/$($questionCount) romantic questions right!
Keep spreading the love! 💕
"@

[System.Windows.Forms.MessageBox]::Show($resultMessage, "Love Quiz Results", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)