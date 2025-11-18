# SVYD LEDGER - Deploy to Azure Script
# Este script automatiza el despliegue a Azure

param(
    [string]$Environment = "dev",
    [switch]$SkipBuild,
    [switch]$SkipTests
)

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  SVYD LEDGER - Azure Deployment" -ForegroundColor Cyan
Write-Host "  Environment: $Environment" -ForegroundColor Yellow
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Variables
$resourceGroup = "svydledger-data"
$location = "centralus"
$storageAccount = "svydledgerstore"
$containerName = '$web'
$frontendPath = "frontend"

# Función para verificar comando
function Test-Command {
    param([string]$Command)
    
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

# Verificar Azure CLI
Write-Host "Verificando Azure CLI..." -ForegroundColor Yellow
if (-not (Test-Command "az")) {
    Write-Host "[ERROR] Azure CLI no está instalado" -ForegroundColor Red
    Write-Host "Descarga desde: https://aka.ms/installazurecliwindows" -ForegroundColor White
    exit 1
}
Write-Host "[OK] Azure CLI instalado" -ForegroundColor Green
Write-Host ""

# Verificar login en Azure
Write-Host "Verificando autenticación en Azure..." -ForegroundColor Yellow
$azAccount = az account show 2>$null
if (-not $azAccount) {
    Write-Host "[INFO] No autenticado. Iniciando login..." -ForegroundColor Yellow
    az login
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] No se pudo autenticar en Azure" -ForegroundColor Red
        exit 1
    }
}

$accountInfo = az account show | ConvertFrom-Json
Write-Host "[OK] Autenticado como: $($accountInfo.user.name)" -ForegroundColor Green
Write-Host "    Suscripción: $($accountInfo.name)" -ForegroundColor Gray
Write-Host ""

# Build Frontend (si no se salta)
if (-not $SkipBuild) {
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host "  Building Frontend" -ForegroundColor Cyan
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host ""
    
    Push-Location $frontendPath
    
    # Instalar dependencias
    Write-Host "Instalando dependencias..." -ForegroundColor Yellow
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Falló npm install" -ForegroundColor Red
        Pop-Location
        exit 1
    }
    Write-Host "[OK] Dependencias instaladas" -ForegroundColor Green
    Write-Host ""
    
    # Lint (si no se saltan tests)
    if (-not $SkipTests) {
        Write-Host "Ejecutando linter..." -ForegroundColor Yellow
        npm run lint
        if ($LASTEXITCODE -ne 0) {
            Write-Host "[WARNING] Lint encontró problemas" -ForegroundColor Yellow
            $continue = Read-Host "¿Continuar de todas formas? (s/n)"
            if ($continue -ne 's' -and $continue -ne 'S') {
                Pop-Location
                exit 1
            }
        }
        Write-Host "[OK] Lint completado" -ForegroundColor Green
        Write-Host ""
    }
    
    # Build
    Write-Host "Compilando frontend..." -ForegroundColor Yellow
    npm run build
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Falló la compilación" -ForegroundColor Red
        Pop-Location
        exit 1
    }
    Write-Host "[OK] Compilación exitosa" -ForegroundColor Green
    Write-Host ""
    
    # Verificar dist
    if (-not (Test-Path "dist")) {
        Write-Host "[ERROR] Carpeta dist no encontrada" -ForegroundColor Red
        Pop-Location
        exit 1
    }
    
    $distSize = (Get-ChildItem -Path "dist" -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB
    Write-Host "    Tamaño del build: $([math]::Round($distSize, 2)) MB" -ForegroundColor Gray
    
    Pop-Location
    Write-Host ""
} else {
    Write-Host "[INFO] Build omitido (-SkipBuild)" -ForegroundColor Yellow
    Write-Host ""
}

# Verificar Resource Group
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Verificando Azure Resources" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Verificando Resource Group..." -ForegroundColor Yellow
$rgExists = az group exists --name $resourceGroup
if ($rgExists -eq "false") {
    Write-Host "[ERROR] Resource Group '$resourceGroup' no existe" -ForegroundColor Red
    Write-Host ""
    Write-Host "Crear con:" -ForegroundColor White
    Write-Host "  az group create --name $resourceGroup --location $location" -ForegroundColor Gray
    exit 1
}
Write-Host "[OK] Resource Group encontrado" -ForegroundColor Green
Write-Host ""

# Verificar Storage Account
Write-Host "Verificando Storage Account..." -ForegroundColor Yellow
$storageExists = az storage account show --name $storageAccount --resource-group $resourceGroup 2>$null
if (-not $storageExists) {
    Write-Host "[ERROR] Storage Account '$storageAccount' no existe" -ForegroundColor Red
    Write-Host ""
    Write-Host "Crear con:" -ForegroundColor White
    Write-Host "  az storage account create --name $storageAccount --resource-group $resourceGroup --location $location --sku Standard_LRS" -ForegroundColor Gray
    exit 1
}
Write-Host "[OK] Storage Account encontrado" -ForegroundColor Green
Write-Host ""

# Habilitar Static Website
Write-Host "Habilitando Static Website..." -ForegroundColor Yellow
az storage blob service-properties update `
  --account-name $storageAccount `
  --static-website `
  --index-document index.html `
  --404-document index.html

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] No se pudo habilitar Static Website" -ForegroundColor Red
    exit 1
}
Write-Host "[OK] Static Website habilitado" -ForegroundColor Green
Write-Host ""

# Obtener URL del Static Website
$staticWebsiteUrl = az storage account show --name $storageAccount --resource-group $resourceGroup --query "primaryEndpoints.web" -o tsv
Write-Host "    URL: $staticWebsiteUrl" -ForegroundColor Cyan
Write-Host ""

# Limpiar contenedor
Write-Host "Limpiando contenedor anterior..." -ForegroundColor Yellow
az storage blob delete-batch `
  --account-name $storageAccount `
  --source $containerName `
  --auth-mode login 2>$null

Write-Host "[OK] Contenedor limpio" -ForegroundColor Green
Write-Host ""

# Subir archivos
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Uploading Files" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Subiendo archivos a Azure Storage..." -ForegroundColor Yellow
$uploadPath = Join-Path $frontendPath "dist"

az storage blob upload-batch `
  --account-name $storageAccount `
  --destination $containerName `
  --source $uploadPath `
  --auth-mode login `
  --overwrite

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Falló la subida de archivos" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Archivos subidos exitosamente" -ForegroundColor Green
Write-Host ""

# Verificar archivos subidos
Write-Host "Verificando archivos..." -ForegroundColor Yellow
$blobCount = (az storage blob list --account-name $storageAccount --container-name $containerName --auth-mode login | ConvertFrom-Json).Count
Write-Host "    Archivos subidos: $blobCount" -ForegroundColor Gray
Write-Host ""

# Purgar CDN (si existe)
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  CDN Purge (Optional)" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

$frontDoorName = "svydledger-fd"
$fdExists = az afd profile show --profile-name $frontDoorName --resource-group $resourceGroup 2>$null

if ($fdExists) {
    Write-Host "Purgando cache de Azure Front Door..." -ForegroundColor Yellow
    
    az afd endpoint purge `
      --resource-group $resourceGroup `
      --profile-name $frontDoorName `
      --endpoint-name "svydledger-endpoint" `
      --content-paths "/*" 2>$null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Cache purgado" -ForegroundColor Green
    } else {
        Write-Host "[WARNING] No se pudo purgar cache (puede que no exista endpoint)" -ForegroundColor Yellow
    }
} else {
    Write-Host "[INFO] Azure Front Door no configurado aún" -ForegroundColor Yellow
}
Write-Host ""

# Resumen
Write-Host "=====================================" -ForegroundColor Green
Write-Host "  DEPLOYMENT SUCCESSFUL!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host ""

Write-Host "URLs de acceso:" -ForegroundColor White
Write-Host "  Static Website: $staticWebsiteUrl" -ForegroundColor Cyan

if ($fdExists) {
    $customDomain = "www.svydledger.com"
    Write-Host "  Custom Domain:  https://$customDomain" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "Siguiente paso:" -ForegroundColor Yellow
if (-not $fdExists) {
    Write-Host "  Configurar Azure Front Door y DNS" -ForegroundColor White
    Write-Host "  Ver: docs/AZURE-DNS-SETUP.md" -ForegroundColor Gray
} else {
    Write-Host "  Verificar la aplicación en el navegador" -ForegroundColor White
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Preguntar si abrir en navegador
$response = Read-Host "¿Abrir en navegador? (s/n)"
if ($response -eq 's' -or $response -eq 'S') {
    Start-Process $staticWebsiteUrl
}
