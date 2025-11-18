# SVYD LEDGER - Node.js Process Monitor
# This script monitors Node.js processes and alerts when multiple instances are detected
# Can be run in the background to prevent memory issues

param(
    [int]$IntervalSeconds = 30,
    [switch]$AutoKill
)

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   Node.js Process Monitor                 " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Monitoring interval: $IntervalSeconds seconds" -ForegroundColor Gray
if ($AutoKill) {
    Write-Host "Auto-kill mode: ENABLED (will keep only 1 process)" -ForegroundColor Yellow
} else {
    Write-Host "Auto-kill mode: DISABLED (will only alert)" -ForegroundColor Gray
}
Write-Host ""
Write-Host "Press Ctrl+C to stop monitoring" -ForegroundColor Yellow
Write-Host ""

$lastCount = 0
$alertShown = $false

while ($true) {
    $nodeProcesses = Get-Process node -ErrorAction SilentlyContinue
    $currentCount = ($nodeProcesses | Measure-Object).Count
    
    if ($currentCount -ne $lastCount -or ($currentCount -gt 1 -and -not $alertShown)) {
        Clear-Host
        Write-Host "============================================" -ForegroundColor Cyan
        Write-Host "   Node.js Process Monitor                 " -ForegroundColor Cyan
        Write-Host "============================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Timestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
        Write-Host ""
        
        if ($currentCount -eq 0) {
            Write-Host "? No Node.js processes running" -ForegroundColor Green
            $alertShown = $false
        } elseif ($currentCount -eq 1) {
            Write-Host "? Normal: 1 Node.js process running" -ForegroundColor Green
            $process = $nodeProcesses[0]
            $memoryMB = [math]::Round($process.WorkingSet64 / 1MB, 1)
            Write-Host ""
            Write-Host "Process Details:" -ForegroundColor Yellow
            Write-Host "  PID: $($process.Id)" -ForegroundColor Gray
            Write-Host "  Memory: $memoryMB MB" -ForegroundColor Gray
            Write-Host "  Start Time: $($process.StartTime)" -ForegroundColor Gray
            $alertShown = $false
        } else {
            Write-Host "? WARNING: Multiple Node.js processes detected!" -ForegroundColor Red
            Write-Host ""
            
            $totalMemory = 0
            Write-Host "Processes:" -ForegroundColor Yellow
            foreach ($process in $nodeProcesses) {
                $memoryMB = [math]::Round($process.WorkingSet64 / 1MB, 1)
                $totalMemory += $memoryMB
                Write-Host "  ? PID $($process.Id): $memoryMB MB (Started: $($process.StartTime.ToString('HH:mm:ss')))" -ForegroundColor Yellow
            }
            
            Write-Host ""
            Write-Host "Total Memory Usage: $([math]::Round($totalMemory, 1)) MB" -ForegroundColor Red
            Write-Host ""
            
            if ($AutoKill) {
                Write-Host "Auto-kill mode: Keeping only the newest process..." -ForegroundColor Yellow
                
                # Sort by start time and keep the newest one
                $sortedProcesses = $nodeProcesses | Sort-Object StartTime -Descending
                $keepProcess = $sortedProcesses[0]
                $killProcesses = $sortedProcesses | Select-Object -Skip 1
                
                Write-Host "Keeping: PID $($keepProcess.Id)" -ForegroundColor Green
                
                foreach ($process in $killProcesses) {
                    try {
                        Stop-Process -Id $process.Id -Force
                        Write-Host "Killed: PID $($process.Id)" -ForegroundColor Red
                    } catch {
                        Write-Host "Failed to kill: PID $($process.Id)" -ForegroundColor Yellow
                    }
                }
                
                Start-Sleep -Seconds 2
                Write-Host ""
                Write-Host "? Cleanup complete" -ForegroundColor Green
            } else {
                Write-Host "Recommendation:" -ForegroundColor Yellow
                Write-Host "  Run: .\kill-node-processes.ps1" -ForegroundColor Cyan
                Write-Host "  Or:  .\dev-manager.ps1 -> Option 3" -ForegroundColor Cyan
            }
            
            $alertShown = $true
        }
        
        $lastCount = $currentCount
        Write-Host ""
        Write-Host "Next check in $IntervalSeconds seconds..." -ForegroundColor Gray
    }
    
    Start-Sleep -Seconds $IntervalSeconds
}
