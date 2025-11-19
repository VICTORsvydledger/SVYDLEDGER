# ============================================
#   AUTO-COMMIT: Guarda Cambios Automáticamente
# ============================================
# USO: .\auto-commit-changes.ps1 "descripción del cambio"

param(
    [Parameter(Mandatory=$false)]
    [string]$Message = "Auto-save: WIP changes"
)

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "   ?? AUTO-COMMIT: Guardando Cambios      " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$fullMessage = "[$timestamp] $Message"

# Verificar si hay cambios
Write-Host "`n?? Verificando cambios..." -ForegroundColor Yellow
$status = git status --short

if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host "? No hay cambios para guardar" -ForegroundColor Green
    exit 0
}

Write-Host "`n?? Cambios detectados:" -ForegroundColor Yellow
Write-Host $status

# Agregar todos los cambios
Write-Host "`n? Agregando archivos al stage..." -ForegroundColor Yellow
git add .

# Commit
Write-Host "`n?? Creando commit..." -ForegroundColor Yellow
git commit -m $fullMessage

# Push a GitHub
Write-Host "`n?? Subiendo a GitHub..." -ForegroundColor Yellow
$pushResult = git push origin main 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n? ¡CAMBIOS GUARDADOS Y RESPALDADOS EN GITHUB!" -ForegroundColor Green
    Write-Host "   Commit: $fullMessage" -ForegroundColor Gray
} else {
    Write-Host "`n??  Commit local creado, pero push falló" -ForegroundColor Yellow
    Write-Host "   Los cambios están en tu repositorio local" -ForegroundColor Gray
    Write-Host "   Error: $pushResult" -ForegroundColor Red
}

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "   ?? Resumen del Respaldo                " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "? Commit creado: $fullMessage" -ForegroundColor Green
Write-Host "?? Rama: main" -ForegroundColor Gray
Write-Host "?? Repo: https://github.com/VICTORsvydledger/SVYDLEDGER" -ForegroundColor Gray
Write-Host ""
