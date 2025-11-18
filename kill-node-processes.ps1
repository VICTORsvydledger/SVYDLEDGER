# SVYD LEDGER - Kill All Node Processes Script
# This script forcefully terminates all Node.js processes

Write-Host "============================================" -ForegroundColor Red
Write-Host "   Stopping All Node.js Processes...      " -ForegroundColor Red
Write-Host "============================================" -ForegroundColor Red
Write-Host ""

# Method 1: Get-Process
Write-Host "Method 1: Using Get-Process..." -ForegroundColor Yellow
Get-Process -Name "node" -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "  Killing process: $($_.Id) - $($_.ProcessName)" -ForegroundColor Cyan
    Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
}

Start-Sleep -Seconds 1

# Method 2: taskkill
Write-Host "Method 2: Using taskkill..." -ForegroundColor Yellow
taskkill /F /IM node.exe /T 2>$null | Out-Null

Start-Sleep -Seconds 1

# Method 3: WMI
Write-Host "Method 3: Using WMI..." -ForegroundColor Yellow
Get-WmiObject Win32_Process | Where-Object { $_.Name -like "*node*" } | ForEach-Object {
    Write-Host "  Terminating: $($_.ProcessId) - $($_.Name)" -ForegroundColor Cyan
    $_.Terminate() | Out-Null
}

Start-Sleep -Seconds 2

# Verify
Write-Host ""
Write-Host "Verifying..." -ForegroundColor Yellow
$remaining = Get-Process -Name "node" -ErrorAction SilentlyContinue | Measure-Object | Select-Object -ExpandProperty Count

if ($remaining -eq 0) {
    Write-Host "? All Node.js processes have been terminated!" -ForegroundColor Green
} else {
    Write-Host "? Warning: $remaining Node.js process(es) still running" -ForegroundColor Red
    Write-Host ""
    Write-Host "Remaining processes:" -ForegroundColor Yellow
    Get-Process -Name "node" -ErrorAction SilentlyContinue | Format-Table Id, ProcessName, WorkingSet -AutoSize
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "   Cleanup Complete                        " -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
