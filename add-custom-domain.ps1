# Script para agregar dominio personalizado a Azure Static Web App
# Ejecutar DESPUÉS de configurar los nameservers en GoDaddy y esperar propagación DNS

Write-Host "?? SVYD LEDGER - Configuración de Dominio Personalizado" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host ""

# Variables
$resourceGroup = "svydledger-data"
$staticWebAppName = "svydledger-frontend"
$customDomain = "www.svydledger.com"
$defaultHostname = "calm-cliff-0f4ed1210.3.azurestaticapps.net"

Write-Host "?? Configuración:" -ForegroundColor Yellow
Write-Host "  Resource Group: $resourceGroup"
Write-Host "  Static Web App: $staticWebAppName"
Write-Host "  Dominio Personalizado: $customDomain"
Write-Host "  Default Hostname: $defaultHostname"
Write-Host ""

# Paso 1: Verificar nameservers
Write-Host "?? PASO 1: Verificando nameservers..." -ForegroundColor Green
Write-Host ""

$expectedNameservers = @(
    "ns1-07.azure-dns.com",
    "ns2-07.azure-dns.net",
    "ns3-07.azure-dns.org",
    "ns4-07.azure-dns.info"
)

Write-Host "Nameservers esperados:" -ForegroundColor Yellow
$expectedNameservers | ForEach-Object { Write-Host "  - $_" -ForegroundColor White }
Write-Host ""

try {
    $nsLookup = nslookup -type=NS svydledger.com 2>&1 | Out-String
    Write-Host "Resultado de nslookup:" -ForegroundColor Yellow
    Write-Host $nsLookup
    
    $allNameserversFound = $true
    foreach ($ns in $expectedNameservers) {
        if ($nsLookup -notmatch $ns) {
            Write-Host "  ? Nameserver no encontrado: $ns" -ForegroundColor Red
            $allNameserversFound = $false
        }
    }
    
    if (-not $allNameserversFound) {
        Write-Host ""
        Write-Host "??  ADVERTENCIA: Los nameservers de Azure DNS no están completamente configurados." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Por favor, verifica que hayas configurado los nameservers en GoDaddy:" -ForegroundColor Yellow
        $expectedNameservers | ForEach-Object { Write-Host "  - $_" -ForegroundColor White }
        Write-Host ""
        $continue = Read-Host "¿Deseas continuar de todas formas? (y/n)"
        if ($continue -ne "y" -and $continue -ne "Y") {
            Write-Host "Operación cancelada por el usuario." -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "  ? Nameservers configurados correctamente" -ForegroundColor Green
    }
} catch {
    Write-Host "  ??  Error al verificar nameservers: $_" -ForegroundColor Yellow
    Write-Host "  Continuando de todas formas..." -ForegroundColor Yellow
}

Write-Host ""

# Paso 2: Verificar CNAME
Write-Host "?? PASO 2: Verificando registro CNAME..." -ForegroundColor Green
Write-Host ""

try {
    $cnameResult = nslookup $customDomain ns1-07.azure-dns.com 2>&1 | Out-String
    Write-Host "Resultado de nslookup (desde Azure DNS):" -ForegroundColor Yellow
    Write-Host $cnameResult
    
    if ($cnameResult -match $defaultHostname) {
        Write-Host "  ? CNAME configurado correctamente" -ForegroundColor Green
    } else {
        Write-Host "  ??  CNAME podría no estar configurado correctamente" -ForegroundColor Yellow
        Write-Host "  Valor esperado: $defaultHostname" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ??  Error al verificar CNAME: $_" -ForegroundColor Yellow
}

Write-Host ""

# Paso 3: Verificar autenticación de Azure
Write-Host "?? PASO 3: Verificando autenticación de Azure..." -ForegroundColor Green
Write-Host ""

try {
    $account = az account show --output json 2>&1 | ConvertFrom-Json
    
    if ($account.name) {
        Write-Host "  ? Autenticado como: $($account.user.name)" -ForegroundColor Green
        Write-Host "  Suscripción: $($account.name)" -ForegroundColor White
    } else {
        throw "No se pudo verificar la autenticación"
    }
} catch {
    Write-Host "  ? No estás autenticado en Azure" -ForegroundColor Red
    Write-Host "  Por favor, ejecuta: az login" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Paso 4: Verificar que la Static Web App existe
Write-Host "?? PASO 4: Verificando Static Web App..." -ForegroundColor Green
Write-Host ""

try {
    $swa = az staticwebapp show --name $staticWebAppName --resource-group $resourceGroup --output json 2>&1 | ConvertFrom-Json
    
    if ($swa.name) {
        Write-Host "  ? Static Web App encontrada: $($swa.name)" -ForegroundColor Green
        Write-Host "  URL por defecto: https://$($swa.defaultHostname)" -ForegroundColor White
        Write-Host "  Estado: Activa" -ForegroundColor White
    } else {
        throw "Static Web App no encontrada"
    }
} catch {
    Write-Host "  ? Error al verificar Static Web App: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Paso 5: Verificar si el dominio ya está configurado
Write-Host "?? PASO 5: Verificando dominios existentes..." -ForegroundColor Green
Write-Host ""

try {
    $existingDomains = az staticwebapp hostname list --name $staticWebAppName --resource-group $resourceGroup --output json 2>&1 | ConvertFrom-Json
    
    if ($existingDomains -and $existingDomains.Count -gt 0) {
        Write-Host "  Dominios configurados:" -ForegroundColor Yellow
        $existingDomains | ForEach-Object { Write-Host "    - $_" -ForegroundColor White }
        
        if ($existingDomains -contains $customDomain) {
            Write-Host ""
            Write-Host "  ? El dominio $customDomain ya está configurado" -ForegroundColor Green
            Write-Host ""
            Write-Host "?? Tu sitio debería estar disponible en: https://$customDomain" -ForegroundColor Green
            exit 0
        }
    } else {
        Write-Host "  No hay dominios personalizados configurados" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ??  Error al listar dominios: $_" -ForegroundColor Yellow
}

Write-Host ""

# Paso 6: Agregar el dominio personalizado
Write-Host "?? PASO 6: Agregando dominio personalizado..." -ForegroundColor Green
Write-Host ""

Write-Host "  Dominio a agregar: $customDomain" -ForegroundColor Yellow
Write-Host ""

$confirm = Read-Host "¿Deseas continuar con la configuración? (y/n)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "Operación cancelada por el usuario." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "  Agregando dominio..." -ForegroundColor Yellow

try {
    $result = az staticwebapp hostname set `
        --name $staticWebAppName `
        --resource-group $resourceGroup `
        --hostname $customDomain `
        --output json 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "  ? Dominio personalizado agregado exitosamente" -ForegroundColor Green
        Write-Host ""
        
        # Mostrar información del dominio
        $domainInfo = $result | ConvertFrom-Json
        Write-Host "  Información del dominio:" -ForegroundColor Yellow
        Write-Host "    Dominio: $customDomain" -ForegroundColor White
        Write-Host "    Estado: Activo" -ForegroundColor White
        Write-Host ""
        
        # Paso 7: Verificar certificado SSL
        Write-Host "?? PASO 7: Verificando certificado SSL..." -ForegroundColor Green
        Write-Host ""
        Write-Host "  El certificado SSL se está generando automáticamente..." -ForegroundColor Yellow
        Write-Host "  Esto puede tardar de 5 a 15 minutos." -ForegroundColor Yellow
        Write-Host ""
        
        Write-Host "?? ¡CONFIGURACIÓN COMPLETADA!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Tu sitio estará disponible en:" -ForegroundColor Cyan
        Write-Host "  https://$customDomain" -ForegroundColor White
        Write-Host ""
        Write-Host "Notas:" -ForegroundColor Yellow
        Write-Host "  - El certificado SSL puede tardar hasta 15 minutos en activarse" -ForegroundColor White
        Write-Host "  - Puedes verificar el estado en: https://portal.azure.com" -ForegroundColor White
        Write-Host "  - URL temporal disponible: https://$defaultHostname" -ForegroundColor White
        Write-Host ""
        
    } else {
        throw $result
    }
} catch {
    Write-Host ""
    Write-Host "  ? Error al agregar dominio personalizado:" -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Posibles causas:" -ForegroundColor Yellow
    Write-Host "  1. Los nameservers de GoDaddy aún no están propagados" -ForegroundColor White
    Write-Host "  2. El registro CNAME no se ha propagado globalmente" -ForegroundColor White
    Write-Host "  3. El dominio ya está en uso en otro recurso de Azure" -ForegroundColor White
    Write-Host ""
    Write-Host "Solución:" -ForegroundColor Yellow
    Write-Host "  - Espera 1-2 horas más y vuelve a ejecutar este script" -ForegroundColor White
    Write-Host "  - Verifica los nameservers en GoDaddy" -ForegroundColor White
    Write-Host "  - Verifica el CNAME con: nslookup $customDomain" -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "Script completado." -ForegroundColor Cyan
