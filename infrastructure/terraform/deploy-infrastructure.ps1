<#
.SYNOPSIS
    Deploy SVYD LEDGER Infrastructure
    Region: Central US

.DESCRIPTION
    Script automatizado para desplegar toda la infraestructura de SVYD LEDGER usando Terraform

.PARAMETER Environment
    Ambiente a desplegar (dev, stage, prod)

.PARAMETER AutoApprove
    Aplicar automáticamente sin confirmación

.EXAMPLE
    .\deploy-infrastructure.ps1 -Environment dev
    .\deploy-infrastructure.ps1 -Environment prod -AutoApprove

.NOTES
    Author: SVYD LEDGER Team
    Requires: Azure CLI, Terraform 1.5+
#>

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('dev', 'stage', 'prod')]
    [string]$Environment,
    
    [Parameter(Mandatory=$false)]
    [switch]$AutoApprove,
    
    [Parameter(Mandatory=$false)]
    [string]$TerraformDir = "."
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

function Write-Step($message) {
    Write-Output ""
    Write-ColorOutput Cyan "=================================="
    Write-ColorOutput Cyan "  $message"
    Write-ColorOutput Cyan "=================================="
    Write-Output ""
}

function Write-Success($message) {
    Write-ColorOutput Green "? $message"
}

function Write-Error-Custom($message) {
    Write-ColorOutput Red "? $message"
}

function Write-Warning-Custom($message) {
    Write-ColorOutput Yellow "??  $message"
}

# Banner
Clear-Host
Write-ColorOutput Green @"
   
   ???????????   ??????   ??????????     ???     ???????????????  ??????? ??????????????? 
   ???????????   ??????? ????????????    ???     ???????????????????????? ????????????????
   ???????????   ??? ??????? ???  ???    ???     ??????  ???  ??????  ??????????  ????????
   ???????????? ????  ?????  ???  ???    ???     ??????  ???  ??????   ?????????  ????????
   ???????? ???????    ???   ????????    ????????????????????????????????????????????  ???
   ????????  ?????     ???   ???????     ???????????????????????  ??????? ???????????  ???
   
   Infrastructure Deployment - Region: Central US
   Environment: $Environment
   
"@

# ================================================
# PASO 1: Verificar Prerequisitos
# ================================================
Write-Step "Verificando Prerequisitos"

# Verificar Azure CLI
Write-Output "Verificando Azure CLI..."
try {
    $azVersion = az version --output json 2>$null | ConvertFrom-Json
    Write-Success "Azure CLI version: $($azVersion.'azure-cli')"
} catch {
    Write-Error-Custom "Azure CLI no está instalado"
    Write-Output "Instalar desde: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
}

# Verificar Terraform
Write-Output "Verificando Terraform..."
try {
    $tfVersion = terraform version -json 2>$null | ConvertFrom-Json
    Write-Success "Terraform version: $($tfVersion.terraform_version)"
    
    if ([version]$tfVersion.terraform_version -lt [version]"1.5.0") {
        Write-Error-Custom "Terraform version debe ser >= 1.5.0"
        exit 1
    }
} catch {
    Write-Error-Custom "Terraform no está instalado"
    Write-Output "Instalar desde: https://www.terraform.io/downloads"
    exit 1
}

# Verificar autenticación Azure
Write-Output "Verificando autenticación Azure..."
try {
    $account = az account show --output json 2>$null | ConvertFrom-Json
    Write-Success "Autenticado como: $($account.user.name)"
    Write-Success "Suscripción: $($account.name)"
} catch {
    Write-Error-Custom "No hay sesión activa en Azure"
    Write-Output ""
    Write-ColorOutput Yellow "Ejecutando 'az login'..."
    az login
    if ($LASTEXITCODE -ne 0) {
        Write-Error-Custom "Error al iniciar sesión"
        exit 1
    }
}

# ================================================
# PASO 2: Verificar archivo terraform.tfvars
# ================================================
Write-Step "Verificando Configuración"

$tfvarsPath = Join-Path $TerraformDir "terraform.tfvars"
if (-not (Test-Path $tfvarsPath)) {
    Write-Error-Custom "Archivo terraform.tfvars no existe"
    Write-Output ""
    Write-ColorOutput Yellow "Creando desde terraform.tfvars.example..."
    
    $examplePath = Join-Path $TerraformDir "terraform.tfvars.example"
    if (Test-Path $examplePath) {
        Copy-Item $examplePath $tfvarsPath
        Write-Success "Archivo terraform.tfvars creado"
        Write-Output ""
        Write-ColorOutput Yellow "??  DEBES EDITAR terraform.tfvars con tus valores reales"
        Write-Output ""
        Write-Output "Presiona ENTER para abrir el archivo en el editor..."
        Read-Host
        code $tfvarsPath
        Write-Output ""
        Write-Output "Presiona ENTER cuando hayas terminado de editar..."
        Read-Host
    } else {
        Write-Error-Custom "No se encontró terraform.tfvars.example"
        exit 1
    }
}

Write-Success "Archivo terraform.tfvars existe"

# Validar que environment en tfvars coincida
$tfvarsContent = Get-Content $tfvarsPath -Raw
if ($tfvarsContent -match 'environment\s*=\s*"(\w+)"') {
    $tfvarsEnv = $matches[1]
    if ($tfvarsEnv -ne $Environment) {
        Write-Warning-Custom "Environment en terraform.tfvars ($tfvarsEnv) no coincide con el parámetro ($Environment)"
        Write-Output ""
        $continue = Read-Host "¿Deseas continuar de todas formas? (S/N)"
        if ($continue -ne 'S' -and $continue -ne 's') {
            Write-Output "Operación cancelada"
            exit 0
        }
    }
}

# ================================================
# PASO 3: Terraform Init
# ================================================
Write-Step "Inicializando Terraform"

Push-Location $TerraformDir

terraform init -upgrade
if ($LASTEXITCODE -ne 0) {
    Write-Error-Custom "Error al inicializar Terraform"
    Pop-Location
    exit 1
}

Write-Success "Terraform inicializado correctamente"

# ================================================
# PASO 4: Terraform Validate
# ================================================
Write-Step "Validando Configuración"

terraform validate
if ($LASTEXITCODE -ne 0) {
    Write-Error-Custom "Error de validación en la configuración"
    Pop-Location
    exit 1
}

Write-Success "Configuración validada correctamente"

# ================================================
# PASO 5: Terraform Plan
# ================================================
Write-Step "Generando Plan de Despliegue"

$planFile = "tfplan-$Environment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

terraform plan -var="environment=$Environment" -out=$planFile
if ($LASTEXITCODE -ne 0) {
    Write-Error-Custom "Error al generar el plan"
    Pop-Location
    exit 1
}

Write-Success "Plan generado: $planFile"

# ================================================
# PASO 6: Revisión del Plan
# ================================================
if (-not $AutoApprove) {
    Write-Output ""
    Write-ColorOutput Yellow "=================================="
    Write-ColorOutput Yellow "  REVISIÓN DEL PLAN"
    Write-ColorOutput Yellow "=================================="
    Write-Output ""
    Write-Output "Revisa cuidadosamente el plan anterior."
    Write-Output ""
    Write-ColorOutput Cyan "Recursos a crear, modificar o eliminar:"
    terraform show -json $planFile | ConvertFrom-Json | Select-Object -ExpandProperty resource_changes | 
        Group-Object -Property change.actions | 
        ForEach-Object { 
            $action = $_.Name -replace '[\[\]]', ''
            $count = $_.Count
            Write-Output "  - $action : $count recursos"
        }
    Write-Output ""
    
    $confirmation = Read-Host "¿Deseas aplicar este plan? (S/N)"
    if ($confirmation -ne 'S' -and $confirmation -ne 's') {
        Write-ColorOutput Yellow "Operación cancelada por el usuario"
        Pop-Location
        exit 0
    }
}

# ================================================
# PASO 7: Terraform Apply
# ================================================
Write-Step "Aplicando Infraestructura"

Write-ColorOutput Yellow "??  Esto puede tomar 20-30 minutos..."
Write-Output ""

$startTime = Get-Date

if ($AutoApprove) {
    terraform apply $planFile
} else {
    terraform apply $planFile
}

if ($LASTEXITCODE -ne 0) {
    Write-Error-Custom "Error al aplicar la infraestructura"
    Pop-Location
    exit 1
}

$endTime = Get-Date
$duration = $endTime - $startTime

Write-Success "Infraestructura desplegada exitosamente"
Write-Output ""
Write-ColorOutput Cyan "??  Tiempo total: $($duration.ToString('mm\:ss')) minutos"

# ================================================
# PASO 8: Mostrar Outputs
# ================================================
Write-Step "Información de Despliegue"

terraform output -json | ConvertFrom-Json | ConvertTo-Json -Depth 10 | Write-Output

Write-Output ""
Write-ColorOutput Green "=================================="
Write-ColorOutput Green "  NEXT STEPS"
Write-ColorOutput Green "=================================="
Write-Output ""

# Obtener información de outputs
$aksCommand = terraform output -raw aks_kube_config_command 2>$null
$apimUrl = terraform output -raw apim_gateway_url 2>$null
$sqlFqdn = terraform output -raw sql_server_fqdn 2>$null

if ($aksCommand) {
    Write-Output "1. Conectar a AKS:"
    Write-ColorOutput Cyan "   $aksCommand"
    Write-Output ""
}

Write-Output "2. Verificar cluster:"
Write-ColorOutput Cyan "   kubectl get nodes"
Write-Output ""

Write-Output "3. Crear secrets en Kubernetes:"
Write-ColorOutput Cyan "   kubectl create namespace production"
Write-ColorOutput Cyan "   kubectl create secret generic app-secrets --from-literal=... --namespace=production"
Write-Output ""

if ($apimUrl) {
    Write-Output "4. API Gateway URL:"
    Write-ColorOutput Cyan "   $apimUrl"
    Write-Output ""
}

if ($sqlFqdn) {
    Write-Output "5. SQL Server:"
    Write-ColorOutput Cyan "   $sqlFqdn"
    Write-Output ""
}

Write-Output "6. Monitoreo:"
Write-ColorOutput Cyan "   https://portal.azure.com"
Write-Output ""

# ================================================
# PASO 9: Guardar Outputs
# ================================================
$outputFile = "deployment-output-$Environment-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
terraform output -json | Out-File $outputFile
Write-Success "Outputs guardados en: $outputFile"

Pop-Location

Write-Output ""
Write-ColorOutput Green "=================================="
Write-ColorOutput Green "  ?? DESPLIEGUE COMPLETADO!"
Write-ColorOutput Green "=================================="
Write-Output ""
