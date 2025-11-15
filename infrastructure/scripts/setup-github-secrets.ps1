<#
.SYNOPSIS
    Setup GitHub Secrets for SVYD LEDGER CI/CD

.DESCRIPTION
    Este script configura los secrets necesarios en GitHub para CI/CD
    Requiere GitHub CLI (gh)

.NOTES
    Author: SVYD LEDGER Team
    Requires: GitHub CLI, Azure CLI
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$GitHubRepo = "VICTORsvydledger/SVYDLEDGER",
    
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroup = "svydledger-data",
    
    [Parameter(Mandatory=$false)]
    [string]$Location = "centralus"
)

function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

Write-ColorOutput Green "========================================="
Write-ColorOutput Green "   SVYD LEDGER - GitHub Secrets Setup"
Write-ColorOutput Green "========================================="
Write-Output ""

# Verificar GitHub CLI
Write-ColorOutput Yellow "Verificando GitHub CLI..."
$ghVersion = gh --version 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-ColorOutput Red "? GitHub CLI no está instalado."
    Write-Output ""
    Write-ColorOutput Yellow "Por favor instale GitHub CLI desde: https://cli.github.com/"
    Write-Output ""
    Write-ColorOutput Yellow "?? INSTRUCCIONES MANUALES:"
    Write-Output ""
    Write-Output "Deberá configurar estos secrets manualmente en GitHub:"
    Write-Output "https://github.com/$GitHubRepo/settings/secrets/actions"
    Write-Output ""
    Write-Output "Secrets necesarios:"
    Write-Output "  - AZURE_CREDENTIALS"
    Write-Output "  - ACR_USERNAME"
    Write-Output "  - ACR_PASSWORD"
    Write-Output "  - DATABASE_URL"
    Write-Output "  - JWT_SECRET_KEY"
    Write-Output "  - STRIPE_SECRET_KEY"
    Write-Output "  - STRIPE_WEBHOOK_SECRET"
    Write-Output ""
    
    # Mostrar cómo obtener AZURE_CREDENTIALS
    Write-ColorOutput Yellow "Para obtener AZURE_CREDENTIALS, ejecute:"
    Write-Output ""
    Write-Output "az ad sp create-for-rbac --name `"svydledger-github`" --role contributor --scopes /subscriptions/{SUBSCRIPTION_ID}/resourceGroups/$ResourceGroup --sdk-auth"
    Write-Output ""
    
    exit 0
}

Write-ColorOutput Green "? GitHub CLI está instalado"
Write-Output ""

# Verificar autenticación de GitHub
Write-ColorOutput Yellow "Verificando autenticación de GitHub..."
$ghAuth = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-ColorOutput Yellow "?? No hay sesión activa en GitHub. Por favor inicie sesión:"
    Write-Output ""
    gh auth login
    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput Red "? Error al iniciar sesión en GitHub"
        exit 1
    }
}
Write-ColorOutput Green "? Autenticado en GitHub"
Write-Output ""

# Verificar Azure CLI
Write-ColorOutput Yellow "Verificando Azure CLI..."
$azAccount = az account show --output json 2>$null | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) {
    Write-ColorOutput Red "? No hay sesión activa en Azure"
    Write-Output ""
    Write-ColorOutput Yellow "Por favor ejecute primero: .\setup-azure.ps1"
    exit 1
}
Write-ColorOutput Green "? Sesión activa en Azure"
Write-Output ""

# Obtener información de Azure
Write-ColorOutput Yellow "Obteniendo información de Azure..."
$subscriptionId = $azAccount.id

# Crear Service Principal para GitHub Actions
Write-ColorOutput Yellow "Creando Service Principal para GitHub Actions..."
Write-Output ""
Write-ColorOutput Yellow "?? ATENCIÓN: Se creará un Service Principal con permisos de 'contributor'"
Write-Output ""
$confirmation = Read-Host "¿Desea continuar? (S/N)"
if ($confirmation -ne 'S' -and $confirmation -ne 's') {
    Write-ColorOutput Yellow "Operación cancelada"
    exit 0
}

$spName = "svydledger-github-actions"
$sp = az ad sp create-for-rbac `
    --name $spName `
    --role contributor `
    --scopes "/subscriptions/$subscriptionId/resourceGroups/$ResourceGroup" `
    --sdk-auth `
    --output json | ConvertFrom-Json

if ($LASTEXITCODE -eq 0) {
    Write-ColorOutput Green "? Service Principal creado"
    
    # Configurar AZURE_CREDENTIALS
    Write-ColorOutput Yellow "Configurando AZURE_CREDENTIALS en GitHub..."
    $azureCredentials = $sp | ConvertTo-Json -Compress
    gh secret set AZURE_CREDENTIALS --body $azureCredentials --repo $GitHubRepo
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput Green "? AZURE_CREDENTIALS configurado"
    }
} else {
    Write-ColorOutput Red "? Error al crear Service Principal"
}
Write-Output ""

# Obtener credenciales de ACR
Write-ColorOutput Yellow "Obteniendo credenciales de ACR..."
$acrName = "svydledgeracr"
$acrCreds = az acr credential show --name $acrName --resource-group $ResourceGroup --output json | ConvertFrom-Json

if ($LASTEXITCODE -eq 0) {
    gh secret set ACR_USERNAME --body $acrCreds.username --repo $GitHubRepo
    gh secret set ACR_PASSWORD --body $acrCreds.passwords[0].value --repo $GitHubRepo
    Write-ColorOutput Green "? Credenciales de ACR configuradas"
} else {
    Write-ColorOutput Red "? Error al obtener credenciales de ACR"
}
Write-Output ""

# Secrets adicionales que deben configurarse manualmente
Write-ColorOutput Yellow "========================================="
Write-ColorOutput Yellow "   ?? SECRETS ADICIONALES REQUERIDOS"
Write-ColorOutput Yellow "========================================="
Write-Output ""
Write-Output "Los siguientes secrets deben configurarse manualmente en:"
Write-Output "https://github.com/$GitHubRepo/settings/secrets/actions"
Write-Output ""
Write-Output "1. DATABASE_URL"
Write-Output "   Connection string de Azure SQL Hyperscale"
Write-Output "   Formato: Server=tcp:svydserver.database.windows.net,1433;Database=svydledger-hyperescala;..."
Write-Output ""
Write-Output "2. JWT_SECRET_KEY"
Write-Output "   Clave secreta para JWT (generar una clave fuerte)"
Write-Output ""
Write-Output "3. STRIPE_SECRET_KEY"
Write-Output "   API Key de Stripe (obtener desde Stripe Dashboard)"
Write-Output ""
Write-Output "4. STRIPE_WEBHOOK_SECRET"
Write-Output "   Webhook secret de Stripe"
Write-Output ""
Write-ColorOutput Green "========================================="
Write-ColorOutput Green "   ? GitHub Secrets Setup Completado"
Write-ColorOutput Green "========================================="
Write-Output ""
Write-Output "Puede verificar los secrets en:"
Write-Output "https://github.com/$GitHubRepo/settings/secrets/actions"
Write-Output ""
