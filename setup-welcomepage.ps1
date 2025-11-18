# SVYD LEDGER - WelcomePage Setup Script
# Este script ayuda a verificar y preparar la WelcomePage

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  SVYD LEDGER - WelcomePage Setup" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Función para verificar archivos
function Test-FileExists {
    param([string]$Path, [string]$Description)
    
    if (Test-Path $Path) {
        Write-Host "[OK] $Description" -ForegroundColor Green
        return $true
    } else {
        Write-Host "[MISSING] $Description" -ForegroundColor Red
        return $false
    }
}

# Verificar estructura del proyecto
Write-Host "Verificando archivos del proyecto..." -ForegroundColor Yellow
Write-Host ""

$checks = @{
    "frontend/src/pages/auth/WelcomePage.tsx" = "Componente WelcomePage"
    "frontend/src/pages/auth/WelcomePage.scss" = "Estilos WelcomePage"
    "frontend/public/images/backgrounds" = "Carpeta de imágenes de fondo"
    "frontend/package.json" = "Configuración del proyecto"
}

$allOk = $true
foreach ($file in $checks.GetEnumerator()) {
    if (-not (Test-FileExists -Path $file.Key -Description $file.Value)) {
        $allOk = $false
    }
}

Write-Host ""

# Verificar imagen de fondo
$backgroundImage = "frontend/public/images/backgrounds/background-1.png"
Write-Host "Verificando imagen de fondo..." -ForegroundColor Yellow

if (Test-Path $backgroundImage) {
    Write-Host "[OK] Imagen de fondo encontrada" -ForegroundColor Green
    $imageSize = (Get-Item $backgroundImage).Length / 1MB
    Write-Host "    Tamaño: $([math]::Round($imageSize, 2)) MB" -ForegroundColor Gray
} else {
    Write-Host "[MISSING] Imagen de fondo NO encontrada" -ForegroundColor Red
    Write-Host ""
    Write-Host "ACCIÓN REQUERIDA:" -ForegroundColor Yellow
    Write-Host "1. Descarga una imagen de cielo azul con nubes blancas" -ForegroundColor White
    Write-Host "   Sugerencias:" -ForegroundColor Gray
    Write-Host "   - https://unsplash.com/s/photos/blue-sky-clouds" -ForegroundColor Gray
    Write-Host "   - https://www.pexels.com/search/blue%20sky%20clouds/" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. Renombra la imagen a: background-1.png" -ForegroundColor White
    Write-Host ""
    Write-Host "3. Colócala en: frontend/public/images/backgrounds/" -ForegroundColor White
    Write-Host ""
    $allOk = $false
}

Write-Host ""

# Verificar node_modules
Write-Host "Verificando dependencias..." -ForegroundColor Yellow

if (Test-Path "frontend/node_modules") {
    Write-Host "[OK] Dependencias instaladas" -ForegroundColor Green
} else {
    Write-Host "[MISSING] Dependencias NO instaladas" -ForegroundColor Red
    Write-Host ""
    Write-Host "Ejecuta: cd frontend && npm install" -ForegroundColor White
    $allOk = $false
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan

if ($allOk) {
    Write-Host "TODO LISTO! Puedes iniciar el proyecto" -ForegroundColor Green
    Write-Host ""
    Write-Host "Para iniciar el servidor de desarrollo:" -ForegroundColor White
    Write-Host "  cd frontend" -ForegroundColor Gray
    Write-Host "  npm run dev" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Luego abre: http://localhost:5173" -ForegroundColor Cyan
} else {
    Write-Host "HAY PROBLEMAS QUE RESOLVER" -ForegroundColor Red
    Write-Host "Por favor, revisa los mensajes anteriores" -ForegroundColor Yellow
}

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Preguntar si quiere iniciar el servidor
if ($allOk) {
    $response = Read-Host "¿Deseas iniciar el servidor de desarrollo ahora? (s/n)"
    if ($response -eq 's' -or $response -eq 'S') {
        Write-Host ""
        Write-Host "Iniciando servidor de desarrollo..." -ForegroundColor Green
        Set-Location frontend
        npm run dev
    }
}
