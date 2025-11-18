# SVYD LEDGER - Single Process Enforcer
# This script ensures ONLY ONE Node.js development server runs at a time
# It prevents the problem of multiple Node.js processes consuming excessive memory

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   SVYD LEDGER - Single Process Mode      " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$lockFile = Join-Path $PSScriptRoot ".node-lock"

# Function to clean up lock file on exit
function Cleanup {
    if (Test-Path $lockFile) {
        Remove-Item $lockFile -Force
        Write-Host ""
        Write-Host "? Lock released" -ForegroundColor Green
    }
}

# Register cleanup on exit
$null = Register-EngineEvent PowerShell.Exiting -Action { Cleanup }

# Check if another instance is running
if (Test-Path $lockFile) {
    $lockContent = Get-Content $lockFile -Raw | ConvertFrom-Json
    $processExists = Get-Process -Id $lockContent.ProcessId -ErrorAction SilentlyContinue
    
    if ($processExists) {
        Write-Host "? Another instance is already running!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Process Information:" -ForegroundColor Yellow
        Write-Host "  PID: $($lockContent.ProcessId)" -ForegroundColor Gray
        Write-Host "  Started: $($lockContent.StartTime)" -ForegroundColor Gray
        Write-Host "  Port: $($lockContent.Port)" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Options:" -ForegroundColor Yellow
        Write-Host "  1. Open http://localhost:$($lockContent.Port) in browser" -ForegroundColor Cyan
        Write-Host "  2. Kill existing process and start new one" -ForegroundColor Cyan
        Write-Host "  3. Exit" -ForegroundColor Cyan
        Write-Host ""
        
        $choice = Read-Host "Select an option (1/2/3)"
        
        switch ($choice) {
            '1' {
                Start-Process "http://localhost:$($lockContent.Port)"
                Write-Host "? Browser opened" -ForegroundColor Green
                exit 0
            }
            '2' {
                Write-Host ""
                Write-Host "Killing existing process..." -ForegroundColor Yellow
                Stop-Process -Id $lockContent.ProcessId -Force -ErrorAction SilentlyContinue
                Start-Sleep -Seconds 2
                Remove-Item $lockFile -Force
                Write-Host "? Process terminated" -ForegroundColor Green
            }
            default {
                Write-Host "Exiting..." -ForegroundColor Gray
                exit 0
            }
        }
    } else {
        # Lock file exists but process is dead, clean up
        Remove-Item $lockFile -Force
    }
}

# Kill ALL existing Node.js processes to start clean
Write-Host "Cleaning up all Node.js processes..." -ForegroundColor Yellow
Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

$remainingProcesses = Get-Process node -ErrorAction SilentlyContinue
if ($remainingProcesses) {
    Write-Host "? Warning: $($remainingProcesses.Count) process(es) still running" -ForegroundColor Yellow
    Write-Host "Attempting force kill with taskkill..." -ForegroundColor Yellow
    taskkill /F /IM node.exe /T 2>$null | Out-Null
    Start-Sleep -Seconds 2
} else {
    Write-Host "? All processes cleaned" -ForegroundColor Green
}

Write-Host ""

# Navigate to frontend
$frontendPath = Join-Path $PSScriptRoot "frontend"
if (-not (Test-Path $frontendPath)) {
    Write-Host "? Frontend directory not found!" -ForegroundColor Red
    exit 1
}

Set-Location $frontendPath

# Verify dependencies
if (-not (Test-Path "node_modules")) {
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    npm install
}

# Clean Vite cache
if (Test-Path ".vite") {
    Remove-Item -Recurse -Force .vite -ErrorAction SilentlyContinue
}

Write-Host "Starting development server (single process mode)..." -ForegroundColor Green
Write-Host ""

# Create lock file with process info
$lockInfo = @{
    ProcessId = $PID
    StartTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Port = 5173
} | ConvertTo-Json

Set-Content -Path $lockFile -Value $lockInfo

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   Server Starting...                      " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "? Lock acquired - Only ONE process will run" -ForegroundColor Green
Write-Host "? Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

# Start the server
try {
    npm run dev
} catch {
    Write-Host ""
    Write-Host "? Server stopped" -ForegroundColor Red
} finally {
    Cleanup
}
