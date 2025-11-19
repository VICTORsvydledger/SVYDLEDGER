# ============================================
#   ?? GUARDAR CAMBIOS (Como Ctrl+S)
# ============================================
# USO MÁS SIMPLE: Solo escribe ".\save" en la terminal
#
# Este script guarda TODOS tus cambios y los sube a GitHub
# Es como hacer Ctrl+S pero para TODO el proyecto

$timestamp = Get-Date -Format "HH:mm:ss"
$date = Get-Date -Format "yyyy-MM-dd"

Write-Host "`n" -NoNewline
Write-Host "?? GUARDANDO CAMBIOS..." -ForegroundColor Cyan -BackgroundColor Black
Write-Host "   Hora: $timestamp" -ForegroundColor Gray

# Verificar si hay cambios
$status = git status --short

if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host "`n? " -ForegroundColor Green -NoNewline
    Write-Host "Ya está todo guardado (no hay cambios nuevos)" -ForegroundColor White
    Write-Host ""
    exit 0
}

# Mostrar qué se va a guardar
Write-Host "`n?? Archivos que se van a guardar:" -ForegroundColor Yellow
git status --short | ForEach-Object {
    Write-Host "   $_" -ForegroundColor Gray
}

# Guardar TODO
Write-Host "`n? Guardando..." -ForegroundColor Yellow -NoNewline
git add . 2>&1 | Out-Null
git commit -m "?? Save: $date $timestamp" 2>&1 | Out-Null
Write-Host " ?" -ForegroundColor Green

# Subir a GitHub
Write-Host "? Subiendo a GitHub..." -ForegroundColor Yellow -NoNewline
$pushOutput = git push origin main 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host " ?" -ForegroundColor Green
    Write-Host "`n?? " -ForegroundColor Green -NoNewline
    Write-Host "¡GUARDADO EXITOSO!" -ForegroundColor White -BackgroundColor DarkGreen
    Write-Host "   ?? Tus cambios están seguros en GitHub" -ForegroundColor Gray
} else {
    Write-Host " ??" -ForegroundColor Yellow
    Write-Host "`n??  " -ForegroundColor Yellow -NoNewline
    Write-Host "Guardado localmente (GitHub no disponible)" -ForegroundColor White
    Write-Host "   ?? Tus cambios están guardados en tu computadora" -ForegroundColor Gray
}

Write-Host ""
