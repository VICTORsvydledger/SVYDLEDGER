# SVYD LEDGER - Safe Frontend Startup Script
# This script kills existing Node.js processes and starts the frontend safely

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   SVYD LEDGER - Safe Frontend Startup    " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Kill existing Node.js processes
Write-Host "Step 1: Cleaning up existing Node.js processes..." -ForegroundColor Yellow
$nodeProcesses = Get-Process node -ErrorAction SilentlyContinue

if ($nodeProcesses) {
    Write-Host "Found $($nodeProcesses.Count) Node.js process(es) running" -ForegroundColor Yellow
    Write-Host "Stopping all Node.js processes..." -ForegroundColor Yellow
    
    foreach ($process in $nodeProcesses) {
        try {
            Stop-Process -Id $process.Id -Force
            Write-Host "  ? Stopped process ID: $($process.Id)" -ForegroundColor Green
        } catch {
            Write-Host "  ? Failed to stop process ID: $($process.Id)" -ForegroundColor Red
        }
    }
    
    Start-Sleep -Seconds 2
    
    # Verify all processes are stopped
    $remainingProcesses = Get-Process node -ErrorAction SilentlyContinue
    if ($remainingProcesses) {
        Write-Host "? Warning: Some Node.js processes are still running" -ForegroundColor Yellow
    } else {
        Write-Host "? All Node.js processes stopped successfully" -ForegroundColor Green
    }
} else {
    Write-Host "? No Node.js processes running" -ForegroundColor Green
}

Write-Host ""

# Step 2: Check Node.js installation
Write-Host "Step 2: Verifying Node.js installation..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    $npmVersion = npm --version
    Write-Host "? Node.js version: $nodeVersion" -ForegroundColor Green
    Write-Host "? npm version: $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "? Node.js is not installed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Node.js from: https://nodejs.org/" -ForegroundColor Yellow
    Write-Host "Download the LTS version (v20.x or higher)" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""

# Step 3: Navigate to frontend directory
Write-Host "Step 3: Navigating to frontend directory..." -ForegroundColor Yellow
$frontendPath = Join-Path $PSScriptRoot "frontend"

if (-not (Test-Path $frontendPath)) {
    Write-Host "? Frontend directory not found at: $frontendPath" -ForegroundColor Red
    exit 1
}

Set-Location $frontendPath
Write-Host "? Changed to frontend directory" -ForegroundColor Green
Write-Host ""

# Step 4: Verify package.json
Write-Host "Step 4: Verifying project configuration..." -ForegroundColor Yellow
if (-not (Test-Path "package.json")) {
    Write-Host "? package.json not found!" -ForegroundColor Red
    exit 1
}
Write-Host "? package.json found" -ForegroundColor Green
Write-Host ""

# Step 5: Check and install dependencies
Write-Host "Step 5: Checking dependencies..." -ForegroundColor Yellow
if (-not (Test-Path "node_modules")) {
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    Write-Host "This may take a few minutes..." -ForegroundColor Yellow
    Write-Host ""
    
    try {
        npm install
        Write-Host ""
        Write-Host "? Dependencies installed successfully!" -ForegroundColor Green
    } catch {
        Write-Host "? Failed to install dependencies!" -ForegroundColor Red
        Write-Host "Error: $_" -ForegroundColor Red
        Write-Host ""
        Write-Host "Try running manually:" -ForegroundColor Yellow
        Write-Host "  cd frontend" -ForegroundColor Gray
        Write-Host "  npm install" -ForegroundColor Gray
        Read-Host "Press Enter to exit"
        exit 1
    }
} else {
    Write-Host "? Dependencies already installed" -ForegroundColor Green
    
    # Check if node_modules is corrupted
    $modulesCount = (Get-ChildItem -Path "node_modules" -Directory -ErrorAction SilentlyContinue).Count
    if ($modulesCount -lt 10) {
        Write-Host "? Warning: node_modules seems incomplete ($modulesCount folders)" -ForegroundColor Yellow
        $reinstall = Read-Host "Do you want to reinstall dependencies? (y/n)"
        if ($reinstall -eq 'y' -or $reinstall -eq 'Y') {
            Write-Host "Reinstalling dependencies..." -ForegroundColor Yellow
            Remove-Item -Recurse -Force node_modules
            npm install
            Write-Host "? Dependencies reinstalled" -ForegroundColor Green
        }
    }
}

Write-Host ""

# Step 6: Check for background image
Write-Host "Step 6: Checking WelcomePage assets..." -ForegroundColor Yellow
$backgroundImage = "public/images/backgrounds/background-1.png"
if (Test-Path $backgroundImage) {
    $imageSize = (Get-Item $backgroundImage).Length / 1KB
    Write-Host "? Background image found ($([math]::Round($imageSize, 2)) KB)" -ForegroundColor Green
} else {
    Write-Host "? Warning: Background image not found" -ForegroundColor Yellow
    Write-Host "  Expected location: $backgroundImage" -ForegroundColor Gray
    Write-Host "  See: frontend/public/images/backgrounds/README.md" -ForegroundColor Gray
}

Write-Host ""

# Step 7: Clean up any lock files
Write-Host "Step 7: Cleaning up..." -ForegroundColor Yellow
if (Test-Path ".vite") {
    Remove-Item -Recurse -Force .vite -ErrorAction SilentlyContinue
    Write-Host "? Cleared Vite cache" -ForegroundColor Green
}

Write-Host ""

# Step 8: Start development server
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   Starting Development Server...          " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "The application will be available at:" -ForegroundColor Yellow
Write-Host "  Local:   http://localhost:5173" -ForegroundColor Cyan
Write-Host ""
Write-Host "WelcomePage features:" -ForegroundColor Yellow
Write-Host "  ? Multi-language selector (27 languages)" -ForegroundColor Gray
Write-Host "  ? Sign In / Sign Up forms" -ForegroundColor Gray
Write-Host "  ? Two-Factor Authentication" -ForegroundColor Gray
Write-Host "  ? Password recovery" -ForegroundColor Gray
Write-Host "  ? Responsive design" -ForegroundColor Gray
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""
Write-Host "Starting in 3 seconds..." -ForegroundColor Gray
Start-Sleep -Seconds 3

try {
    npm run dev
} catch {
    Write-Host ""
    Write-Host "? Failed to start development server!" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "  1. Make sure port 5173 is not in use" -ForegroundColor Gray
    Write-Host "  2. Try running: npm run dev manually" -ForegroundColor Gray
    Write-Host "  3. Check for errors in the console" -ForegroundColor Gray
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}
