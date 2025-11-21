# Script para verificar si los nameservers de GoDaddy están configurados correctamente

Write-Host "?? Verificando configuración DNS de svydledger.com" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host ""

# Nameservers esperados
$expectedNameservers = @(
    "ns1-07.azure-dns.com",
    "ns2-07.azure-dns.net",
    "ns3-07.azure-dns.org",
    "ns4-07.azure-dns.info"
)

Write-Host "Nameservers esperados:" -ForegroundColor Yellow
$expectedNameservers | ForEach-Object { Write-Host "  - $_" -ForegroundColor White }
Write-Host ""

# Verificar nameservers
Write-Host "Consultando nameservers actuales..." -ForegroundColor Green
Write-Host ""

try {
    $result = nslookup -type=NS svydledger.com 2>&1 | Out-String
    Write-Host $result
    
    # Verificar si están todos
    $allFound = $true
    foreach ($ns in $expectedNameservers) {
        if ($result -match $ns) {
            Write-Host "  ? $ns encontrado" -ForegroundColor Green
        } else {
            Write-Host "  ? $ns NO encontrado" -ForegroundColor Red
            $allFound = $false
        }
    }
    
    Write-Host ""
    
    if ($allFound) {
        Write-Host "?? ¡Nameservers configurados correctamente!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Ahora ejecuta:" -ForegroundColor Cyan
        Write-Host "  .\add-custom-domain.ps1" -ForegroundColor White
        Write-Host ""
        Write-Host "Para agregar el dominio personalizado a tu Static Web App." -ForegroundColor Yellow
    } else {
        Write-Host "? Los nameservers aún no están propagados" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Posibles razones:" -ForegroundColor Yellow
        Write-Host "  1. Los cambios aún no se han propagado (espera 1-4 horas)" -ForegroundColor White
        Write-Host "  2. No guardaste los cambios en GoDaddy" -ForegroundColor White
        Write-Host "  3. GoDaddy está procesando los cambios" -ForegroundColor White
        Write-Host ""
        Write-Host "Vuelve a ejecutar este script en 30 minutos." -ForegroundColor Cyan
    }
} catch {
    Write-Host "? Error al consultar DNS: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Esto es normal si acabas de comprar el dominio." -ForegroundColor Yellow
    Write-Host "Espera 30 minutos y vuelve a intentar." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=" * 60 -ForegroundColor Cyan
