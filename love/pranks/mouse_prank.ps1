Add-Type -AssemblyName System.Windows.Forms
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Mouse {
    [DllImport("user32.dll")]
    public static extern bool SetCursorPos(int X, int Y);
    [DllImport("user32.dll")]
    public static extern bool GetCursorPos(out POINT lpPoint);
    [StructLayout(LayoutKind.Sequential)]
    public struct POINT {
        public int X;
        public int Y;
    }
}
"@

[System.Windows.Forms.MessageBox]::Show("Mouse control prank activated! Your mouse will move randomly for 30 seconds.", "Mouse Prank", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)

$duration = 30  # seconds
$endTime = (Get-Date).AddSeconds($duration)

while ((Get-Date) -lt $endTime) {
    $point = New-Object Mouse+POINT
    [Mouse]::GetCursorPos([ref]$point)
    $newX = $point.X + (Get-Random -Minimum -50 -Maximum 50)
    $newY = $point.Y + (Get-Random -Minimum -50 -Maximum 50)
    [Mouse]::SetCursorPos($newX, $newY)
    Start-Sleep -Milliseconds 500
}

[System.Windows.Forms.MessageBox]::Show("Mouse prank ended.", "Prank Over", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)