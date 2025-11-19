# ============================================================================
# VERIFICADOR DE ESTADO DEL SERVIDOR - SIN AUTO-EJECUCIÓN
# ============================================================================
# Descripción: Verifica el estado del servidor sin intentar ejecutarlo
# Uso: .\check-server-status.ps1
# ============================================================================

# Colores y símbolos
$ColorSuccess = "Green"
$ColorWarning = "Yellow"
$ColorError = "Red"
$ColorInfo = "Cyan"

function Show-Header {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor $ColorInfo
    Write-Host "   VERIFICACIÓN DE ESTADO DEL SERVIDOR   " -ForegroundColor $ColorInfo
    Write-Host "============================================" -ForegroundColor $ColorInfo
    Write-Host ""
}

function Check-NodeProcesses {
    Write-Host "?? Verificando procesos Node.js..." -ForegroundColor $ColorInfo
    
    $nodeProcesses = Get-Process -Name node -ErrorAction SilentlyContinue
    
    if ($nodeProcesses) {
        Write-Host "  ??  ENCONTRADOS: $($nodeProcesses.Count) proceso(s) Node.js" -ForegroundColor $ColorWarning
        
        foreach ($proc in $nodeProcesses) {
            $memoryMB = [math]::Round($proc.WorkingSet64 / 1MB, 1)
            Write-Host "     • PID: $($proc.Id) | Memoria: $memoryMB MB | Inicio: $($proc.StartTime)" -ForegroundColor Yellow
        }
        
        return $true
    } else {
        Write-Host "  ? No hay procesos Node.js corriendo" -ForegroundColor $ColorSuccess
        return $false
    }
}

function Check-Port {
    param([int]$Port = 5173)
    
    Write-Host ""
    Write-Host "?? Verificando puerto $Port..." -ForegroundColor $ColorInfo
    
    $listener = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
    
    if ($listener) {
        Write-Host "  ??  Puerto $Port OCUPADO por proceso: $($listener.OwningProcess)" -ForegroundColor $ColorWarning
        return $true
    } else {
        Write-Host "  ? Puerto $Port LIBRE" -ForegroundColor $ColorSuccess
        return $false
    }
}

function Check-LockFile {
    Write-Host ""
    Write-Host "?? Verificando archivo .node-lock..." -ForegroundColor $ColorInfo
    
    if (Test-Path ".node-lock") {
        Write-Host "  ??  Archivo .node-lock EXISTE" -ForegroundColor $ColorWarning
        
        try {
            $lockData = Get-Content ".node-lock" | ConvertFrom-Json
            Write-Host "     • PID: $($lockData.ProcessId)" -ForegroundColor Yellow
            Write-Host "     • Inicio: $($lockData.StartTime)" -ForegroundColor Yellow
            Write-Host "     • Puerto: $($lockData.Port)" -ForegroundColor Yellow
            
            # Verificar si el proceso sigue vivo
            $processAlive = Get-Process -Id $lockData.ProcessId -ErrorAction SilentlyContinue
            
            if ($processAlive) {
                Write-Host "     • Estado: ? Proceso VIVO" -ForegroundColor Green
            } else {
                Write-Host "     • Estado: ? Proceso MUERTO (lock huérfano)" -ForegroundColor Red
            }
        } catch {
            Write-Host "  ? Error leyendo .node-lock" -ForegroundColor $ColorError
        }
        
        return $true
    } else {
        Write-Host "  ? No existe archivo .node-lock" -ForegroundColor $ColorSuccess
        return $false
    }
}

function Check-Dependencies {
    Write-Host ""
    Write-Host "?? Verificando dependencias..." -ForegroundColor $ColorInfo
    
    if (Test-Path "frontend/node_modules") {
        Write-Host "  ? node_modules encontrado" -ForegroundColor $ColorSuccess
        return $true
    } else {
        Write-Host "  ? node_modules NO encontrado" -ForegroundColor $ColorError
        Write-Host "     Ejecuta: cd frontend && npm install" -ForegroundColor Yellow
        return $false
    }
}

function Show-Summary {
    param(
        [bool]$HasProcesses,
        [bool]$PortOccupied,
        [bool]$HasLock,
        [bool]$HasDependencies
    )
    
    Write-Host ""
    Write-Host "============================================" -ForegroundColor $ColorInfo
    Write-Host "   RESUMEN DEL ESTADO                      " -ForegroundColor $ColorInfo
    Write-Host "============================================" -ForegroundColor $ColorInfo
    
    if ($HasProcesses -or $PortOccupied -or $HasLock) {
        Write-Host ""
        Write-Host "??  SERVIDOR POSIBLEMENTE CORRIENDO" -ForegroundColor $ColorWarning
        Write-Host ""
        Write-Host "Opciones:" -ForegroundColor $ColorInfo
        Write-Host "  1. Abrir http://localhost:5173 en navegador" -ForegroundColor White
        Write-Host "  2. Ejecutar: .\kill-node-processes.ps1 (para limpiar)" -ForegroundColor White
        Write-Host "  3. Ejecutar: .\dev-manager.ps1 (menú interactivo)" -ForegroundColor White
    } elseif (-not $HasDependencies) {
        Write-Host ""
        Write-Host "? FALTAN DEPENDENCIAS" -ForegroundColor $ColorError
        Write-Host ""
        Write-Host "Ejecuta:" -ForegroundColor $ColorInfo
        Write-Host "  cd frontend && npm install" -ForegroundColor White
    } else {
        Write-Host ""
        Write-Host "? SISTEMA LIMPIO Y LISTO" -ForegroundColor $ColorSuccess
        Write-Host ""
        Write-Host "Para iniciar el servidor:" -ForegroundColor $ColorInfo
        Write-Host "  .\start-single-process.ps1" -ForegroundColor White
        Write-Host ""
        Write-Host "O usa el menú interactivo:" -ForegroundColor $ColorInfo
        Write-Host "  .\dev-manager.ps1" -ForegroundColor White
    }
    
    Write-Host ""
}

# ============================================================================
# EJECUCIÓN PRINCIPAL
# ============================================================================

Show-Header

$hasProcesses = Check-NodeProcesses
$portOccupied = Check-Port -Port 5173
$hasLock = Check-LockFile
$hasDependencies = Check-Dependencies

Show-Summary -HasProcesses $hasProcesses -PortOccupied $portOccupied -HasLock $hasLock -HasDependencies $hasDependencies

Write-Host "============================================" -ForegroundColor $ColorInfo
Write-Host ""
