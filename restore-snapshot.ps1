# ============================================
#   RESTORE: Recupera Snapshot de WelcomePage
# ============================================
# USO: .\restore-snapshot.ps1 [timestamp]
# Ejemplo: .\restore-snapshot.ps1 2025-01-15_143022

param(
    [Parameter(Mandatory=$false)]
    [string]$Timestamp
)

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "   ?? RESTORE: Recuperar Snapshot        " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Si no se proporciona timestamp, listar snapshots disponibles
if ([string]::IsNullOrWhiteSpace($Timestamp)) {
    Write-Host "`n?? Snapshots disponibles:" -ForegroundColor Yellow
    
    if (Test-Path ".snapshots\welcomepage") {
        $snapshots = Get-ChildItem ".snapshots\welcomepage" -Directory | Sort-Object Name -Descending
        
        if ($snapshots.Count -eq 0) {
            Write-Host "  ??  No hay snapshots disponibles" -ForegroundColor Yellow
            exit 1
        }
        
        $index = 1
        foreach ($snapshot in $snapshots) {
            $metadataPath = Join-Path $snapshot.FullName "metadata.json"
            if (Test-Path $metadataPath) {
                $metadata = Get-Content $metadataPath | ConvertFrom-Json
                Write-Host "`n  [$index] $($snapshot.Name)" -ForegroundColor Cyan
                Write-Host "      Creado: $($metadata.CreatedAt)" -ForegroundColor Gray
                Write-Host "      Commit: $($metadata.LastCommit)" -ForegroundColor Gray
            }
            $index++
        }
        
        Write-Host "`n?? Uso: .\restore-snapshot.ps1 [timestamp]" -ForegroundColor Yellow
        Write-Host "   Ejemplo: .\restore-snapshot.ps1 $($snapshots[0].Name)" -ForegroundColor Gray
    } else {
        Write-Host "  ??  Directorio de snapshots no existe" -ForegroundColor Yellow
    }
    exit 0
}

# Verificar que existe el snapshot
$snapshotPath = ".snapshots\welcomepage\$Timestamp"
if (-not (Test-Path $snapshotPath)) {
    Write-Host "`n? Snapshot no encontrado: $Timestamp" -ForegroundColor Red
    Write-Host "`n?? Ejecuta sin parámetros para ver snapshots disponibles:" -ForegroundColor Yellow
    Write-Host "   .\restore-snapshot.ps1" -ForegroundColor White
    exit 1
}

# Confirmar restauración
Write-Host "`n??  ¿RESTAURAR SNAPSHOT $Timestamp?" -ForegroundColor Yellow
Write-Host "   Esto sobrescribirá los archivos actuales" -ForegroundColor Gray
Write-Host "`n   [Y] Sí  [N] No  (default es 'N'): " -NoNewline -ForegroundColor White
$confirmation = Read-Host

if ($confirmation -ne 'Y' -and $confirmation -ne 'y') {
    Write-Host "`n? Restauración cancelada" -ForegroundColor Yellow
    exit 0
}

# Restaurar archivos
Write-Host "`n?? Restaurando archivos..." -ForegroundColor Yellow

$files = Get-ChildItem -Path $snapshotPath -Recurse -File | Where-Object { $_.Name -ne "metadata.json" }

foreach ($file in $files) {
    $relativePath = $file.FullName.Replace($snapshotPath + "\", "")
    $destPath = "frontend\$relativePath"
    
    # Crear directorio si no existe
    $destDir = Split-Path $destPath -Parent
    if (-not (Test-Path $destDir)) {
        New-Item -Path $destDir -ItemType Directory -Force | Out-Null
    }
    
    # Copiar archivo
    Copy-Item -Path $file.FullName -Destination $destPath -Force
    Write-Host "  ? Restaurado: $destPath" -ForegroundColor Green
}

# Crear commit de restauración
Write-Host "`n?? Creando commit de restauración..." -ForegroundColor Yellow
git add frontend
git commit -m "Restore: WelcomePage from snapshot $Timestamp"

Write-Host "`n? ¡SNAPSHOT RESTAURADO!" -ForegroundColor Green
Write-Host "   ?? Snapshot: $Timestamp" -ForegroundColor Gray
Write-Host "   ?? Archivos restaurados en: frontend\" -ForegroundColor Gray

Write-Host "`n?? Recuerda:" -ForegroundColor Cyan
Write-Host "   - Verifica los cambios con 'git status'" -ForegroundColor White
Write-Host "   - Ejecuta el servidor para probar: .\start-single-process.ps1" -ForegroundColor White
Write-Host ""
