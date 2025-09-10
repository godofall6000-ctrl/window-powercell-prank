#Requires -Version 5.1
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.MessageBox]::Show("Get ready for a romantic popup storm! <3", "Romantic Surprise", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

$messages = @(
    "I love you more than chocolate! *chocolate*",
    "You're my favorite person ever! *hearts*",
    "Will you be my Valentine forever? *love*",
    "Your smile lights up my world! :)",
    "I can't imagine life without you! *hug*"
)

foreach ($message in $messages) {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Love Message"
    $form.Size = New-Object System.Drawing.Size(300, 150)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [System.Drawing.Color]::Pink

    $label = New-Object System.Windows.Forms.Label
    $label.Text = $message
    $label.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
    $label.ForeColor = [System.Drawing.Color]::Red
    $label.Size = New-Object System.Drawing.Size(280, 60)
    $label.Location = New-Object System.Drawing.Point(10, 20)
    $label.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $form.Controls.Add($label)

    $button = New-Object System.Windows.Forms.Button
    $button.Text = "Aww! <3"
    $button.Size = New-Object System.Drawing.Size(80, 30)
    $button.Location = New-Object System.Drawing.Point(110, 90)
    $button.Add_Click({ $form.Close() })
    $form.Controls.Add($button)

    $form.ShowDialog()
    Start-Sleep 1
}

[System.Windows.Forms.MessageBox]::Show("Hope you enjoyed the love storm! *kiss*", "Romantic Storm Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)