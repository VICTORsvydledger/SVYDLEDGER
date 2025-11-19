# ============================================
#   SNAPSHOT: Guarda Estado de WelcomePage
# ============================================
# Crea una copia de seguridad timestamped del trabajo actual

$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$snapshotDir = ".snapshots\welcomepage\$timestamp"

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "   ?? SNAPSHOT: WelcomePage               " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Crear directorio de snapshot
Write-Host "`n?? Creando snapshot en: $snapshotDir" -ForegroundColor Yellow
New-Item -Path $snapshotDir -ItemType Directory -Force | Out-Null

# Archivos críticos a respaldar
$criticalFiles = @(
    "frontend\src\pages\auth\WelcomePage.tsx",
    "frontend\src\pages\auth\WelcomePage.scss",
    "frontend\src\pages\auth\components\SignInForm.tsx",
    "frontend\src\pages\auth\components\SignUpForm.tsx",
    "frontend\src\i18n\locales\en.json",
    "frontend\src\i18n\locales\es.json",
    "frontend\vite.config.ts",
    "frontend\package.json"
)

# Copiar archivos
Write-Host "`n?? Copiando archivos..." -ForegroundColor Yellow
foreach ($file in $criticalFiles) {
    if (Test-Path $file) {
        $relativePath = $file -replace "frontend\\", ""
        $destPath = Join-Path $snapshotDir $relativePath
        $destDir = Split-Path $destPath -Parent
        
        New-Item -Path $destDir -ItemType Directory -Force | Out-Null
        Copy-Item -Path $file -Destination $destPath -Force
        
        Write-Host "  ? $file" -ForegroundColor Green
    } else {
        Write-Host "  ??  No encontrado: $file" -ForegroundColor Yellow
    }
}

# Crear archivo de metadata
$metadata = @{
    Timestamp = $timestamp
    CreatedAt = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    Branch = (git branch --show-current)
    LastCommit = (git log -1 --pretty=format:"%h - %s")
    Files = $criticalFiles
} | ConvertTo-Json

$metadata | Out-File -FilePath "$snapshotDir\metadata.json" -Encoding UTF8

# Crear commit automático
Write-Host "`n?? Creando commit de snapshot..." -ForegroundColor Yellow
git add .snapshots
git commit -m "Snapshot: WelcomePage - $timestamp" 2>&1 | Out-Null

Write-Host "`n? ¡SNAPSHOT CREADO!" -ForegroundColor Green
Write-Host "   ?? Ubicación: $snapshotDir" -ForegroundColor Gray
Write-Host "   ?? Timestamp: $timestamp" -ForegroundColor Gray

Write-Host "`n?? Para restaurar este snapshot:" -ForegroundColor Cyan
Write-Host "   .\restore-snapshot.ps1 $timestamp" -ForegroundColor White
Write-Host ""
