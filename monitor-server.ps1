# SVYD LEDGER - Server Monitor Script
# This script monitors the Vite development server

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   SVYD LEDGER - Server Monitor           " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

while ($true) {
    Clear-Host
    
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "   SVYD LEDGER - Server Monitor           " -ForegroundColor Cyan
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Check Node.js processes
    $nodeProcesses = Get-Process -Name "node" -ErrorAction SilentlyContinue
    $nodeCount = ($nodeProcesses | Measure-Object).Count
    
    Write-Host "?? Estado del Servidor" -ForegroundColor Yellow
    Write-Host "?????????????????????????????????????????" -ForegroundColor DarkGray
    Write-Host ""
    
    if ($nodeCount -gt 0) {
        Write-Host "  ? Servidor: " -NoNewline -ForegroundColor Green
        Write-Host "ACTIVO" -ForegroundColor Green
        Write-Host "  ?? Procesos Node.js: $nodeCount" -ForegroundColor Cyan
        
        $totalMemory = ($nodeProcesses | Measure-Object -Property WorkingSet -Sum).Sum / 1MB
        Write-Host "  ?? Memoria Total: $([math]::Round($totalMemory, 2)) MB" -ForegroundColor Cyan
    } else {
        Write-Host "  ? Servidor: " -NoNewline -ForegroundColor Red
        Write-Host "DETENIDO" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "?????????????????????????????????????????" -ForegroundColor DarkGray
    Write-Host ""
    
    # Check if port 3000 is listening
    $port3000 = Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue
    
    if ($port3000) {
        Write-Host "  ?? Puerto 3000: " -NoNewline -ForegroundColor Green
        Write-Host "ESCUCHANDO" -ForegroundColor Green
        Write-Host "  ?? URL: http://localhost:3000" -ForegroundColor Cyan
    } else {
        Write-Host "  ?? Puerto 3000: " -NoNewline -ForegroundColor Red
        Write-Host "NO DISPONIBLE" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "?????????????????????????????????????????" -ForegroundColor DarkGray
    Write-Host ""
    
    # Test HTTP connection
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:3000" -Method Head -TimeoutSec 2 -ErrorAction Stop
        Write-Host "  ?? HTTP Status: " -NoNewline -ForegroundColor Green
        Write-Host "$($response.StatusCode) OK" -ForegroundColor Green
    } catch {
        Write-Host "  ?? HTTP Status: " -NoNewline -ForegroundColor Red
        Write-Host "NO RESPONDE" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  ?? Presiona Ctrl+C para detener el monitor" -ForegroundColor Yellow
    Write-Host "  ?? Actualizando cada 3 segundos..." -ForegroundColor DarkGray
    Write-Host ""
    
    Start-Sleep -Seconds 3
}
