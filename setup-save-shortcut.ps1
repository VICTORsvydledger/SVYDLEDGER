# ============================================
#   ? ATAJO ULTRA RÁPIDO PARA GUARDAR
# ============================================
# INSTALACIÓN (solo una vez):
#   1. Ejecuta este script: .\setup-save-shortcut.ps1
#   2. Después solo escribe: s
#
# Esto crea un alias "s" que ejecuta el comando guardar

Write-Host "`n? CONFIGURANDO ATAJO RÁPIDO..." -ForegroundColor Cyan

# Crear o actualizar perfil de PowerShell
$profilePath = $PROFILE.CurrentUserAllHosts

# Crear directorio si no existe
$profileDir = Split-Path $profilePath
if (-not (Test-Path $profileDir)) {
    New-Item -Path $profileDir -ItemType Directory -Force | Out-Null
}

# Verificar si ya existe el alias
$aliasExists = $false
if (Test-Path $profilePath) {
    $content = Get-Content $profilePath -Raw
    if ($content -match "Set-Alias s") {
        $aliasExists = $true
    }
}

if ($aliasExists) {
    Write-Host "`n? El atajo 's' ya está configurado" -ForegroundColor Green
} else {
    # Agregar alias al perfil
    $workspaceRoot = $PWD.Path
    $aliasCommand = @"

# ===== ATAJO PARA GUARDAR CAMBIOS =====
# Uso: solo escribe 's' en la terminal
Set-Location '$workspaceRoot'
function Quick-Save { & '$workspaceRoot\save.ps1' }
Set-Alias s Quick-Save
# ======================================

"@
    
    Add-Content -Path $profilePath -Value $aliasCommand
    
    Write-Host "`n? ¡Atajo configurado exitosamente!" -ForegroundColor Green
}

Write-Host "`n????????????????????????????????????" -ForegroundColor Cyan
Write-Host "  INSTRUCCIONES DE USO              " -ForegroundColor White
Write-Host "????????????????????????????????????" -ForegroundColor Cyan

Write-Host "`nPASO 1: Reinicia PowerShell" -ForegroundColor Yellow
Write-Host "  (Cierra y abre de nuevo la terminal)" -ForegroundColor Gray

Write-Host "`nPASO 2: Ahora solo escribe:" -ForegroundColor Yellow
Write-Host "  s" -ForegroundColor White -BackgroundColor DarkBlue

Write-Host "`n¡Y listo! Tus cambios se guardarán automáticamente ?" -ForegroundColor Green

Write-Host "`n????????????????????????????????????" -ForegroundColor Cyan
Write-Host ""

Write-Host "?? BONUS: También puedes usar:" -ForegroundColor Cyan
Write-Host "   .\save           - Guardar rápido" -ForegroundColor Gray
Write-Host "   .\save-with-note - Guardar con nota" -ForegroundColor Gray
Write-Host ""
