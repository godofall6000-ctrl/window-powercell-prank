Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Blue Screen of Death"
$form.Size = New-Object System.Drawing.Size(800, 600)
$form.BackColor = [System.Drawing.Color]::Blue
$form.StartPosition = "CenterScreen"
$form.TopMost = $true
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$form.WindowState = [System.Windows.Forms.FormWindowState]::Maximized

$label = New-Object System.Windows.Forms.Label
$label.Text = "A problem has been detected and Windows has been shut down to prevent damage to your computer.`n`nIRQL_NOT_LESS_OR_EQUAL`n`nIf this is the first time you've seen this error screen, restart your computer. If this screen appears again, follow these steps:`n`nCheck to make sure any new hardware or software is properly installed.`nIf this is a new installation, ask your hardware or software manufacturer for any Windows updates you might need.`n`nIf problems continue, disable or remove any newly installed hardware or software. Disable BIOS memory options such as caching or shadowing.`nIf you need to use Safe Mode to remove or disable components, restart your computer, press F8 to select Advanced Startup Options, and then select Safe Mode.`n`nTechnical information:`n*** STOP: 0x0000000A (0x00000000, 0x00000000, 0x00000000, 0x00000000)`n`nCollecting data for crash dump...`nInitializing disk for crash dump...`nBeginning dump of physical memory.`nDumping physical memory to disk: 100"
$label.Font = New-Object System.Drawing.Font("Lucida Console", 10)
$label.ForeColor = [System.Drawing.Color]::White
$label.Size = New-Object System.Drawing.Size(780, 550)
$label.Location = New-Object System.Drawing.Point(10, 10)
$form.Controls.Add($label)

$button = New-Object System.Windows.Forms.Button
$button.Text = "Close (Prank)"
$button.Size = New-Object System.Drawing.Size(100, 30)
$button.Location = New-Object System.Drawing.Point(350, 500)
$button.Add_Click({ $form.Close() })
$form.Controls.Add($button)

$form.ShowDialog()