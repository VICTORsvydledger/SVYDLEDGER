# ?? SCRIPT DE VERIFICACIÓN DE RESPALDO EN GITHUB
# Ejecuta este script MANUALMENTE para verificar que el respaldo fue exitoso

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "   VERIFICACIÓN DE RESPALDO EN GITHUB" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

# ==============================================
#  PASO 1: Verificar último commit local
# ==============================================

Write-Host "?? PASO 1: Último commit local`n" -ForegroundColor Yellow

$lastCommit = git log -1 --oneline
Write-Host "Último commit: " -ForegroundColor White -NoNewline
Write-Host "$lastCommit" -ForegroundColor Green

$commitHash = git log -1 --format="%H"
$commitMessage = git log -1 --format="%s"
$commitDate = git log -1 --format="%ai"
$commitAuthor = git log -1 --format="%an"

Write-Host "`nDetalles del commit:" -ForegroundColor Cyan
Write-Host "  Hash completo: $commitHash" -ForegroundColor White
Write-Host "  Mensaje: $commitMessage" -ForegroundColor White
Write-Host "  Fecha: $commitDate" -ForegroundColor White
Write-Host "  Autor: $commitAuthor" -ForegroundColor White

# ==============================================
#  PASO 2: Verificar estado del repositorio
# ==============================================

Write-Host "`n?? PASO 2: Estado del repositorio`n" -ForegroundColor Yellow

$gitStatus = git status --porcelain
if ([string]::IsNullOrWhiteSpace($gitStatus)) {
    Write-Host "? No hay cambios pendientes - Todo está commiteado" -ForegroundColor Green
} else {
    Write-Host "?? Hay cambios pendientes que NO están commiteados:" -ForegroundColor Yellow
    git status --short
}

# ==============================================
#  PASO 3: Comparar local vs remoto
# ==============================================

Write-Host "`n?? PASO 3: Comparación local vs remoto`n" -ForegroundColor Yellow

$localCommit = git rev-parse HEAD
$remoteCommit = git rev-parse origin/main

Write-Host "Commit local:  $localCommit" -ForegroundColor White
Write-Host "Commit remoto: $remoteCommit" -ForegroundColor White

if ($localCommit -eq $remoteCommit) {
    Write-Host "`n? LOCAL Y REMOTO ESTÁN SINCRONIZADOS" -ForegroundColor Green
    Write-Host "   Tu código está respaldado en GitHub correctamente" -ForegroundColor Green
} else {
    Write-Host "`n?? LOCAL Y REMOTO NO ESTÁN SINCRONIZADOS" -ForegroundColor Yellow
    
    $aheadBehind = git rev-list --left-right --count origin/main...HEAD
    $behind, $ahead = $aheadBehind -split '\s+'
    
    if ($ahead -gt 0) {
        Write-Host "   Tienes $ahead commit(s) locales que NO están en GitHub" -ForegroundColor Yellow
        Write-Host "   Ejecuta: git push origin main" -ForegroundColor Yellow
    }
    
    if ($behind -gt 0) {
        Write-Host "   GitHub tiene $behind commit(s) que NO tienes localmente" -ForegroundColor Yellow
        Write-Host "   Ejecuta: git pull origin main" -ForegroundColor Yellow
    }
}

# ==============================================
#  PASO 4: Listar archivos en el último commit
# ==============================================

Write-Host "`n?? PASO 4: Archivos en el último commit`n" -ForegroundColor Yellow

$filesChanged = git diff-tree --no-commit-id --name-only -r HEAD
$fileCount = ($filesChanged | Measure-Object).Count

Write-Host "Total de archivos modificados: $fileCount" -ForegroundColor Cyan
Write-Host "`nArchivos:" -ForegroundColor Cyan

$filesChanged | ForEach-Object {
    $status = git diff-tree --no-commit-id --name-status -r HEAD | Select-String $_
    if ($status -match "^A\s+(.+)") {
        Write-Host "  ? NUEVO:      $_" -ForegroundColor Green
    } elseif ($status -match "^M\s+(.+)") {
        Write-Host "  ?? MODIFICADO: $_" -ForegroundColor Yellow
    } elseif ($status -match "^D\s+(.+)") {
        Write-Host "  ? ELIMINADO:  $_" -ForegroundColor Red
    } else {
        Write-Host "  ?? $_" -ForegroundColor White
    }
}

# ==============================================
#  PASO 5: Estadísticas del commit
# ==============================================

Write-Host "`n?? PASO 5: Estadísticas del último commit`n" -ForegroundColor Yellow

$stats = git diff-tree --no-commit-id --stat HEAD
Write-Host $stats -ForegroundColor White

# ==============================================
#  PASO 6: URL del repositorio remoto
# ==============================================

Write-Host "`n?? PASO 6: Información del repositorio remoto`n" -ForegroundColor Yellow

$remoteUrl = git config --get remote.origin.url
Write-Host "URL del repositorio: $remoteUrl" -ForegroundColor Cyan

$repoUrl = $remoteUrl -replace '\.git$', ''
$commitsUrl = "$repoUrl/commits/main"

Write-Host "`n?? Verifica tu respaldo en:" -ForegroundColor Cyan
Write-Host "   $commitsUrl" -ForegroundColor Yellow
Write-Host "`n   Deberías ver tu commit más reciente al inicio de la lista" -ForegroundColor White

# ==============================================
#  PASO 7: Últimos 5 commits
# ==============================================

Write-Host "`n?? PASO 7: Últimos 5 commits`n" -ForegroundColor Yellow

$recentCommits = git log -5 --oneline --decorate
Write-Host $recentCommits -ForegroundColor White

# ==============================================
#  RESUMEN FINAL
# ==============================================

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "   RESUMEN DE VERIFICACIÓN" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

# Verificar sincronización
if ($localCommit -eq $remoteCommit) {
    Write-Host "? Estado del respaldo: EXITOSO" -ForegroundColor Green
    Write-Host "? Local y remoto sincronizados: SÍ" -ForegroundColor Green
    Write-Host "? Código en GitHub: ACTUALIZADO" -ForegroundColor Green
} else {
    Write-Host "?? Estado del respaldo: PENDIENTE" -ForegroundColor Yellow
    Write-Host "?? Local y remoto sincronizados: NO" -ForegroundColor Yellow
    Write-Host "?? Acción requerida: git push origin main" -ForegroundColor Yellow
}

# Verificar cambios pendientes
if ([string]::IsNullOrWhiteSpace($gitStatus)) {
    Write-Host "? Cambios pendientes: NINGUNO" -ForegroundColor Green
} else {
    Write-Host "?? Cambios pendientes: SÍ (no commiteados)" -ForegroundColor Yellow
}

Write-Host "`nÚltimo commit respaldado:" -ForegroundColor Cyan
Write-Host "  ?? $commitMessage" -ForegroundColor White
Write-Host "  ?? $commitDate" -ForegroundColor White
Write-Host "  ?? $fileCount archivo(s) modificado(s)" -ForegroundColor White

Write-Host "`n?? Verifica en GitHub:" -ForegroundColor Cyan
Write-Host "   $commitsUrl`n" -ForegroundColor Yellow

# ==============================================
#  RECOMENDACIONES
# ==============================================

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   RECOMENDACIONES" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

if ($localCommit -eq $remoteCommit) {
    Write-Host "?? ¡TODO ESTÁ PERFECTO!" -ForegroundColor Green
    Write-Host "`nPróximos pasos:" -ForegroundColor Cyan
    Write-Host "  1. Abre el enlace de arriba en tu navegador" -ForegroundColor White
    Write-Host "  2. Verifica que veas tu commit más reciente" -ForegroundColor White
    Write-Host "  3. (Opcional) Inicia el servidor:" -ForegroundColor White
    Write-Host "     .\start-single-process.ps1" -ForegroundColor Yellow
} else {
    Write-Host "?? ACCIÓN REQUERIDA" -ForegroundColor Yellow
    Write-Host "`nParece que el push no se completó correctamente." -ForegroundColor White
    Write-Host "Ejecuta:" -ForegroundColor Cyan
    Write-Host "  git push origin main`n" -ForegroundColor Yellow
}

Write-Host ""
