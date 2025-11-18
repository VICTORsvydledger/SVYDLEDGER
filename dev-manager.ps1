# SVYD LEDGER - Master Startup Script
# This script provides a menu to manage the development environment

param(
    [switch]$Clean,
    [switch]$Force
)

function Show-Menu {
    Clear-Host
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "   SVYD LEDGER - Development Manager      " -ForegroundColor Cyan
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Show current Node.js process status
    $nodeProcesses = Get-Process node -ErrorAction SilentlyContinue
    if ($nodeProcesses) {
        $totalMemory = ($nodeProcesses | Measure-Object -Property WorkingSet64 -Sum).Sum / 1MB
        Write-Host "? WARNING: $($nodeProcesses.Count) Node.js process(es) running - $([math]::Round($totalMemory, 1)) MB" -ForegroundColor Yellow
        Write-Host ""
    }
    
    Write-Host "1. Start Frontend (Single Process Mode) ? RECOMMENDED" -ForegroundColor Green
    Write-Host "2. Start Frontend (Safe Mode)" -ForegroundColor Green
    Write-Host "3. Kill All Node.js Processes" -ForegroundColor Red
    Write-Host "4. Clean & Reinstall Dependencies" -ForegroundColor Yellow
    Write-Host "5. Check System Status" -ForegroundColor Cyan
    Write-Host "6. Open WelcomePage Documentation" -ForegroundColor Magenta
    Write-Host "7. Deploy to Azure" -ForegroundColor Blue
    Write-Host "Q. Quit" -ForegroundColor Gray
    Write-Host ""
}

function Start-SingleProcess {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "   Starting Frontend (Single Process)     " -ForegroundColor Cyan
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host ""
    
    & "$PSScriptRoot\start-single-process.ps1"
}

function Start-Frontend {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "   Starting Frontend...                    " -ForegroundColor Cyan
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Kill existing processes
    Write-Host "Cleaning up existing Node.js processes..." -ForegroundColor Yellow
    & "$PSScriptRoot\kill-node-processes.ps1"
    
    Write-Host ""
    Write-Host "Starting frontend server..." -ForegroundColor Yellow
    & "$PSScriptRoot\start-frontend.ps1"
}

function Kill-NodeProcesses {
    Write-Host ""
    & "$PSScriptRoot\kill-node-processes.ps1"
    Write-Host ""
    Read-Host "Press Enter to continue"
}

function Clean-Dependencies {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Yellow
    Write-Host "   Cleaning Dependencies...                " -ForegroundColor Yellow
    Write-Host "============================================" -ForegroundColor Yellow
    Write-Host ""
    
    $frontendPath = Join-Path $PSScriptRoot "frontend"
    
    if (-not (Test-Path $frontendPath)) {
        Write-Host "? Frontend directory not found!" -ForegroundColor Red
        Read-Host "Press Enter to continue"
        return
    }
    
    Set-Location $frontendPath
    
    # Kill Node processes first
    Write-Host "Stopping Node.js processes..." -ForegroundColor Yellow
    Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 2
    
    # Remove node_modules
    if (Test-Path "node_modules") {
        Write-Host "Removing node_modules..." -ForegroundColor Yellow
        Remove-Item -Recurse -Force node_modules
        Write-Host "? node_modules removed" -ForegroundColor Green
    }
    
    # Remove package-lock.json
    if (Test-Path "package-lock.json") {
        Write-Host "Removing package-lock.json..." -ForegroundColor Yellow
        Remove-Item -Force package-lock.json
        Write-Host "? package-lock.json removed" -ForegroundColor Green
    }
    
    # Remove .vite cache
    if (Test-Path ".vite") {
        Write-Host "Removing .vite cache..." -ForegroundColor Yellow
        Remove-Item -Recurse -Force .vite
        Write-Host "? .vite cache removed" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "Installing fresh dependencies..." -ForegroundColor Yellow
    npm install
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "? Dependencies reinstalled successfully!" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "? Failed to install dependencies!" -ForegroundColor Red
    }
    
    Set-Location $PSScriptRoot
    Write-Host ""
    Read-Host "Press Enter to continue"
}

function Show-SystemStatus {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "   System Status                           " -ForegroundColor Cyan
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Node.js
    Write-Host "Node.js:" -ForegroundColor Yellow
    try {
        $nodeVersion = node --version
        Write-Host "  ? Version: $nodeVersion" -ForegroundColor Green
    } catch {
        Write-Host "  ? Not installed" -ForegroundColor Red
    }
    
    # npm
    Write-Host "npm:" -ForegroundColor Yellow
    try {
        $npmVersion = npm --version
        Write-Host "  ? Version: $npmVersion" -ForegroundColor Green
    } catch {
        Write-Host "  ? Not installed" -ForegroundColor Red
    }
    
    # Node processes
    Write-Host "Node.js Processes:" -ForegroundColor Yellow
    $nodeProcesses = Get-Process node -ErrorAction SilentlyContinue
    if ($nodeProcesses) {
        Write-Host "  ? $($nodeProcesses.Count) process(es) running:" -ForegroundColor Yellow
        foreach ($process in $nodeProcesses) {
            $memoryMB = [math]::Round($process.WorkingSet64 / 1MB, 1)
            Write-Host "    - PID $($process.Id): $memoryMB MB" -ForegroundColor Gray
        }
    } else {
        Write-Host "  ? No processes running" -ForegroundColor Green
    }
    
    # Port 5173 (Vite)
    Write-Host "Port 5173 (Vite):" -ForegroundColor Yellow
    $port5173 = Get-NetTCPConnection -LocalPort 5173 -State Listen -ErrorAction SilentlyContinue
    if ($port5173) {
        Write-Host "  ? Port in use (PID: $($port5173.OwningProcess))" -ForegroundColor Yellow
    } else {
        Write-Host "  ? Port available" -ForegroundColor Green
    }
    
    # Frontend directory
    Write-Host "Frontend Directory:" -ForegroundColor Yellow
    $frontendPath = Join-Path $PSScriptRoot "frontend"
    if (Test-Path $frontendPath) {
        Write-Host "  ? Found at: $frontendPath" -ForegroundColor Green
        
        # node_modules
        $nodeModulesPath = Join-Path $frontendPath "node_modules"
        if (Test-Path $nodeModulesPath) {
            $modulesCount = (Get-ChildItem -Path $nodeModulesPath -Directory).Count
            Write-Host "  ? node_modules: $modulesCount packages" -ForegroundColor Green
        } else {
            Write-Host "  ? node_modules not found (run npm install)" -ForegroundColor Red
        }
        
        # Background image
        $bgImage = Join-Path $frontendPath "public\images\backgrounds\background-1.png"
        if (Test-Path $bgImage) {
            $imageSize = [math]::Round((Get-Item $bgImage).Length / 1KB, 1)
            Write-Host "  ? Background image: $imageSize KB" -ForegroundColor Green
        } else {
            Write-Host "  ? Background image not found" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  ? Not found" -ForegroundColor Red
    }
    
    # Azure CLI
    Write-Host "Azure CLI:" -ForegroundColor Yellow
    try {
        $azVersion = az version --query '\"azure-cli\"' -o tsv 2>$null
        if ($azVersion) {
            Write-Host "  ? Version: $azVersion" -ForegroundColor Green
        } else {
            Write-Host "  ? Not installed" -ForegroundColor Red
        }
    } catch {
        Write-Host "  ? Not installed" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "Documentation Files:" -ForegroundColor Yellow
    $docFiles = @(
        "WELCOMEPAGE-README.md",
        "docs\WELCOMEPAGE-QUICKSTART.md",
        "docs\WELCOMEPAGE-STATUS.md",
        "docs\AZURE-DNS-SETUP.md"
    )
    
    foreach ($file in $docFiles) {
        $fullPath = Join-Path $PSScriptRoot $file
        if (Test-Path $fullPath) {
            Write-Host "  ? $file" -ForegroundColor Green
        } else {
            Write-Host "  ? $file" -ForegroundColor Red
        }
    }
    
    Write-Host ""
    Read-Host "Press Enter to continue"
}

function Open-Documentation {
    Write-Host ""
    Write-Host "Opening documentation..." -ForegroundColor Yellow
    
    $docs = @(
        @{ Name = "WelcomePage README"; Path = "WELCOMEPAGE-README.md" },
        @{ Name = "Quick Start"; Path = "docs\WELCOMEPAGE-QUICKSTART.md" },
        @{ Name = "Status"; Path = "docs\WELCOMEPAGE-STATUS.md" },
        @{ Name = "Azure DNS Setup"; Path = "docs\AZURE-DNS-SETUP.md" }
    )
    
    foreach ($doc in $docs) {
        $fullPath = Join-Path $PSScriptRoot $doc.Path
        if (Test-Path $fullPath) {
            Start-Process $fullPath
            Write-Host "? Opened: $($doc.Name)" -ForegroundColor Green
        }
    }
    
    Start-Sleep -Seconds 2
}

function Deploy-ToAzure {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Blue
    Write-Host "   Azure Deployment                        " -ForegroundColor Blue
    Write-Host "============================================" -ForegroundColor Blue
    Write-Host ""
    
    $deployScript = Join-Path $PSScriptRoot "deploy-to-azure.ps1"
    if (Test-Path $deployScript) {
        & $deployScript
    } else {
        Write-Host "? deploy-to-azure.ps1 not found!" -ForegroundColor Red
        Read-Host "Press Enter to continue"
    }
}

# Main loop
do {
    Show-Menu
    $choice = Read-Host "Select an option"
    
    switch ($choice) {
        '1' { Start-SingleProcess }
        '2' { Start-Frontend }
        '3' { Kill-NodeProcesses }
        '4' { Clean-Dependencies }
        '5' { Show-SystemStatus }
        '6' { Open-Documentation }
        '7' { Deploy-ToAzure }
        'Q' { 
            Write-Host ""
            Write-Host "Goodbye!" -ForegroundColor Cyan
            exit 
        }
        default {
            Write-Host ""
            Write-Host "Invalid option!" -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
} while ($choice -ne 'Q')
