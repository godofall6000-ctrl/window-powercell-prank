# Script to compile Love Gift Chatbot to executable
# Requires PS2EXE module: Install-Module -Name PS2EXE

param(
    [string]$SourceFile = "love_gift_chatbot.ps1",
    [string]$OutputFile = "LoveGift_Chatbot.exe",
    [string]$Title = "Love Gift Chatbot",
    [string]$Description = "A loving chatbot gift for someone special",
    [string]$Company = "Love & Affection Inc.",
    [string]$Product = "Love Gift Chatbot",
    [string]$Copyright = "Created with love",
    [version]$Version = "1.0.0.0"
)

Write-Host "<3 Compiling Love Gift Chatbot to Executable <3" -ForegroundColor Magenta
Write-Host "================================================" -ForegroundColor Cyan

# Check if PS2EXE is installed
if (-not (Get-Module -ListAvailable -Name PS2EXE)) {
    Write-Host "*cross* PS2EXE module not found!" -ForegroundColor Red
    Write-Host "Please install it using: Install-Module -Name PS2EXE" -ForegroundColor Yellow
    Write-Host "Or visit: https://github.com/MScholtes/PS2EXE" -ForegroundColor Yellow
    exit 1
}

# Check if source file exists
if (-not (Test-Path $SourceFile)) {
    Write-Host "*cross* Source file '$SourceFile' not found!" -ForegroundColor Red
    exit 1
}

Write-Host "*folder* Source File: $SourceFile" -ForegroundColor Green
Write-Host "*package* Output File: $OutputFile" -ForegroundColor Green
Write-Host "*label* Title: $Title" -ForegroundColor Green
Write-Host "*memo* Description: $Description" -ForegroundColor Green
Write-Host "*building* Company: $Company" -ForegroundColor Green
Write-Host "*package* Product: $Product" -ForegroundColor Green
Write-Host "*copyright* Copyright: $Copyright" -ForegroundColor Green
Write-Host "*numbers* Version: $Version" -ForegroundColor Green

Write-Host "`n*tools* Starting compilation..." -ForegroundColor Yellow

try {
    # Compile to executable
    Invoke-PS2EXE `
        -InputFile $SourceFile `
        -OutputFile $OutputFile `
        -Title $Title `
        -Description $Description `
        -Company $Company `
        -Product $Product `
        -Copyright $Copyright `
        -Version $Version `
        -NoConsole `
        -RequireAdmin $false `
        -Unicode

    Write-Host "`n*check* Compilation successful!" -ForegroundColor Green
    Write-Host "*folder* Executable created: $OutputFile" -ForegroundColor Green

    # Get file info
    $fileInfo = Get-Item $OutputFile
    Write-Host "*chart* File Size: $([math]::Round($fileInfo.Length / 1MB, 2)) MB" -ForegroundColor Cyan
    Write-Host "*calendar* Created: $($fileInfo.CreationTime)" -ForegroundColor Cyan

    Write-Host "`n<3 Your Love Gift Chatbot executable is ready! <3" -ForegroundColor Magenta
    Write-Host "Double-click '$OutputFile' to start the loving conversation!" -ForegroundColor Yellow

} catch {
    Write-Host "`n*cross* Compilation failed!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`n*gift* Love Gift Compilation Complete! *gift*" -ForegroundColor Magenta