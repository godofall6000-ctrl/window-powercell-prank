' Love Gift Chatbot Launcher
' This VBScript runs the PowerShell chatbot

Dim shell
Set shell = CreateObject("WScript.Shell")

' Run the PowerShell script
shell.Run "powershell.exe -ExecutionPolicy Bypass -File ""love_gift_chatbot_custom.ps1""", 0, False

' Clean up
Set shell = Nothing