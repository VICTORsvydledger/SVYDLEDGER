<#
.SYNOPSIS
    Setup Azure Infrastructure for SVYD LEDGER
    Region: Central US

.DESCRIPTION
    Este script configura toda la infraestructura de Azure necesaria para SVYD LEDGER

.NOTES
    Author: SVYD LEDGER Team
    Requires: Azure CLI, PowerShell 7+
#>

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('dev', 'stage', 'prod')]
    [string]$Environment = 'dev',
    
    [Parameter(Mandatory=$false)]
    [string]$Location = 'centralus',  # Región parametrizada
    
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroup = 'svydledger-data'
)

# Colores para output
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

Write-ColorOutput Green "========================================="
Write-ColorOutput Green "   SVYD LEDGER - Azure Setup"
Write-ColorOutput Green "   Region: $Location"
Write-ColorOutput Green "   Environment: $Environment"
Write-ColorOutput Green "========================================="
Write-Output ""

# Verificar Azure CLI
Write-ColorOutput Yellow "Verificando Azure CLI..."
$azVersion = az version --output json 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-ColorOutput Red "? Azure CLI no está instalado. Por favor instale Azure CLI."
    exit 1
}
Write-ColorOutput Green "? Azure CLI está instalado"
Write-Output ""

# Login a Azure
Write-ColorOutput Yellow "Verificando sesión de Azure..."
$account = az account show --output json 2>$null | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) {
    Write-ColorOutput Yellow "?? No hay sesión activa. Por favor inicie sesión en Azure:"
    Write-Output ""
    az login
    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput Red "? Error al iniciar sesión en Azure"
        exit 1
    }
}

$account = az account show --output json | ConvertFrom-Json
Write-ColorOutput Green "? Sesión activa: $($account.name)"
Write-ColorOutput Green "   Subscription: $($account.id)"
Write-Output ""

# Verificar/Crear Resource Group
Write-ColorOutput Yellow "Verificando Resource Group..."
$rg = az group show --name $ResourceGroup --output json 2>$null | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) {
    Write-ColorOutput Yellow "?? Resource Group no existe. Creando..."
    az group create --name $ResourceGroup --location $Location --output none
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput Green "? Resource Group creado: $ResourceGroup"
    } else {
        Write-ColorOutput Red "? Error al crear Resource Group"
        exit 1
    }
} else {
    Write-ColorOutput Green "? Resource Group existe: $ResourceGroup"
}
Write-Output ""

# Crear Storage Account para Terraform State
Write-ColorOutput Yellow "Configurando Storage Account para Terraform..."
$storageAccount = "svydledgerstore"
$container = "tfstate"

$storage = az storage account show --name $storageAccount --resource-group $ResourceGroup --output json 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-ColorOutput Yellow "Creando Storage Account..."
    az storage account create `
        --name $storageAccount `
        --resource-group $ResourceGroup `
        --location $Location `
        --sku Standard_LRS `
        --encryption-services blob `
        --output none
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput Green "? Storage Account creado"
    } else {
        Write-ColorOutput Red "? Error al crear Storage Account"
        exit 1
    }
}

# Crear container para Terraform state
$containerExists = az storage container show --name $container --account-name $storageAccount --output json 2>$null
if ($LASTEXITCODE -ne 0) {
    az storage container create --name $container --account-name $storageAccount --output none
    Write-ColorOutput Green "? Container de Terraform creado"
}
Write-Output ""

# Crear Azure Container Registry
Write-ColorOutput Yellow "Configurando Azure Container Registry..."
$acrName = "svydledgeracr"
$acr = az acr show --name $acrName --resource-group $ResourceGroup --output json 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-ColorOutput Yellow "Creando ACR..."
    az acr create `
        --name $acrName `
        --resource-group $ResourceGroup `
        --location $Location `
        --sku Premium `
        --admin-enabled false `
        --output none
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput Green "? ACR creado: $acrName.azurecr.io"
    } else {
        Write-ColorOutput Red "? Error al crear ACR"
        exit 1
    }
} else {
    Write-ColorOutput Green "? ACR existe: $acrName.azurecr.io"
}
Write-Output ""

# Información de próximos pasos
Write-ColorOutput Green "========================================="
Write-ColorOutput Green "   ? Configuración de Azure Completada"
Write-ColorOutput Green "========================================="
Write-Output ""
Write-ColorOutput Yellow "PRÓXIMOS PASOS:"
Write-Output ""
Write-Output "1. Configurar GitHub Secrets:"
Write-Output "   - Ejecutar: .\infrastructure\scripts\setup-github-secrets.ps1"
Write-Output ""
Write-Output "2. Desplegar infraestructura con Terraform:"
Write-Output "   cd infrastructure\terraform"
Write-Output "   terraform init"
Write-Output "   terraform plan"
Write-Output "   terraform apply"
Write-Output ""
Write-Output "3. Configurar Kubernetes:"
Write-Output "   az aks get-credentials --resource-group $ResourceGroup --name svydledger-aks-$Environment"
Write-Output "   kubectl apply -f infrastructure\kubernetes\base\"
Write-Output ""
Write-ColorOutput Green "========================================="
