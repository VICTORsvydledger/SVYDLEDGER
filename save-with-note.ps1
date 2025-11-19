# ============================================
#   ?? GUARDAR CON NOTA (Versión con descripción)
# ============================================
# USO: .\save-with-note
# Te permite agregar una nota de qué cambiaste

$timestamp = Get-Date -Format "HH:mm:ss"
$date = Get-Date -Format "yyyy-MM-dd"

Write-Host "`n?? GUARDAR CAMBIOS" -ForegroundColor Cyan -BackgroundColor Black
Write-Host ""

# Verificar si hay cambios
$status = git status --short

if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host "? " -ForegroundColor Green -NoNewline
    Write-Host "Ya está todo guardado (no hay cambios nuevos)" -ForegroundColor White
    Write-Host ""
    exit 0
}

# Mostrar qué se va a guardar
Write-Host "?? Archivos modificados:" -ForegroundColor Yellow
git status --short | ForEach-Object {
    Write-Host "   $_" -ForegroundColor Gray
}

# Pedir descripción opcional
Write-Host "`n?? ¿Qué cambiaste? (o presiona Enter para omitir): " -NoNewline -ForegroundColor Cyan
$userNote = Read-Host

# Crear mensaje
if ([string]::IsNullOrWhiteSpace($userNote)) {
    $message = "?? Save: $date $timestamp"
} else {
    $message = "?? Save: $userNote ($timestamp)"
}

# Guardar TODO
Write-Host "`n? Guardando..." -ForegroundColor Yellow -NoNewline
git add . 2>&1 | Out-Null
git commit -m $message 2>&1 | Out-Null
Write-Host " ?" -ForegroundColor Green

# Subir a GitHub
Write-Host "? Subiendo a GitHub..." -ForegroundColor Yellow -NoNewline
$pushOutput = git push origin main 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host " ?" -ForegroundColor Green
    Write-Host "`n?? " -ForegroundColor Green -NoNewline
    Write-Host "¡GUARDADO EXITOSO!" -ForegroundColor White -BackgroundColor DarkGreen
    Write-Host "   ?? Tus cambios están seguros en GitHub" -ForegroundColor Gray
    if (-not [string]::IsNullOrWhiteSpace($userNote)) {
        Write-Host "   ?? Nota: $userNote" -ForegroundColor Gray
    }
} else {
    Write-Host " ??" -ForegroundColor Yellow
    Write-Host "`n??  " -ForegroundColor Yellow -NoNewline
    Write-Host "Guardado localmente (GitHub no disponible)" -ForegroundColor White
    Write-Host "   ?? Tus cambios están guardados en tu computadora" -ForegroundColor Gray
}

Write-Host ""
