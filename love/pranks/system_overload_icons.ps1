Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.MessageBox]::Show("SYSTEM OVERLOAD DETECTED! Icons are going crazy!", "System Overload", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)

$form = New-Object System.Windows.Forms.Form
$form.Text = "Desktop Icons Overload"
$form.Size = New-Object System.Drawing.Size(600, 400)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::Black

$label = New-Object System.Windows.Forms.Label
$label.Text = "Icons are dancing!"
$label.Font = New-Object System.Drawing.Font("Arial", 20)
$label.ForeColor = [System.Drawing.Color]::White
$label.Size = New-Object System.Drawing.Size(300, 50)
$label.Location = New-Object System.Drawing.Point(150, 50)
$form.Controls.Add($label)

# Create fake icons (labels) that move around
$icons = @()
for ($i = 0; $i -lt 10; $i++) {
    $icon = New-Object System.Windows.Forms.Label
    $icon.Text = "[FILE]"
    $icon.Font = New-Object System.Drawing.Font("Arial", 30)
    $icon.Size = New-Object System.Drawing.Size(50, 50)
    $icon.Location = New-Object System.Drawing.Point((Get-Random -Minimum 0 -Maximum 550), (Get-Random -Minimum 100 -Maximum 350))
    $form.Controls.Add($icon)
    $icons += $icon
}

$form.Show()

# Animate icons
for ($j = 0; $j -lt 50; $j++) {
    foreach ($icon in $icons) {
        $newX = $icon.Location.X + (Get-Random -Minimum -20 -Maximum 20)
        $newY = $icon.Location.Y + (Get-Random -Minimum -20 -Maximum 20)
        if ($newX -lt 0) { $newX = 0 }
        if ($newX -gt 550) { $newX = 550 }
        if ($newY -lt 100) { $newY = 100 }
        if ($newY -gt 350) { $newY = 350 }
        $icon.Location = New-Object System.Drawing.Point($newX, $newY)
    }
    Start-Sleep -Milliseconds 100
}

$form.Close()

[System.Windows.Forms.MessageBox]::Show("System overload resolved! Icons are back to normal.", "Overload Fixed", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)