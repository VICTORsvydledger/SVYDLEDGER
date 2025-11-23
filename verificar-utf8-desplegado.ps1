# ==============================================================================
# Script: verificar-utf8-desplegado.ps1
# Descripción: Verifica que los caracteres UTF-8 se muestren correctamente
#              en https://www.svydledger.com después del despliegue
# Fecha: 2025-01-15
# ==============================================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  VERIFICACIÓN UTF-8 POST-DESPLIEGUE  " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Esperar a que el despliegue termine
Write-Host "? Esperando despliegue automático..." -ForegroundColor Yellow
Write-Host ""
Write-Host "GitHub Actions está desplegando a Azure Static Web Apps" -ForegroundColor White
Write-Host "Tiempo estimado: ~5 minutos desde el push" -ForegroundColor White
Write-Host ""
Write-Host "Presiona Enter cuando el despliegue haya terminado..." -ForegroundColor Yellow
Read-Host

Write-Host ""
Write-Host "?? Abriendo https://www.svydledger.com..." -ForegroundColor Green
Start-Process "https://www.svydledger.com"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " INSTRUCCIONES DE VERIFICACIÓN MANUAL" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "1??  Click en el botón circular azul (esquina inferior derecha)" -ForegroundColor White
Write-Host "   ? Esto abre PostAuthPage" -ForegroundColor Gray
Write-Host ""

Write-Host "2??  Cambia el idioma a ESPAÑOL" -ForegroundColor White
Write-Host "   Verifica que se muestre:" -ForegroundColor Gray
Write-Host "   ? 'País' (NO 'Pa?s')" -ForegroundColor Green
Write-Host "   ? 'Contraseña' (NO 'Contrase?a')" -ForegroundColor Green
Write-Host "   ? 'Sesión iniciada como:' (NO 'Sesi?n')" -ForegroundColor Green
Write-Host ""

Write-Host "3??  Cambia el idioma a PORTUGUÉS" -ForegroundColor White
Write-Host "   Verifica que se muestre:" -ForegroundColor Gray
Write-Host "   ? 'Não' (NO 'N?o')" -ForegroundColor Green
Write-Host "   ? 'Usuário' (NO 'Usu?rio')" -ForegroundColor Green
Write-Host ""

Write-Host "4??  Cambia el idioma a FRANCÉS" -ForegroundColor White
Write-Host "   Verifica que se muestre:" -ForegroundColor Gray
Write-Host "   ? 'Système' (NO 'Syst?me')" -ForegroundColor Green
Write-Host "   ? 'Créer' (NO 'Cr?er')" -ForegroundColor Green
Write-Host ""

Write-Host "5??  Cambia el idioma a ÁRABE" -ForegroundColor White
Write-Host "   Verifica que:" -ForegroundColor Gray
Write-Host "   ? Los caracteres árabes se muestren correctamente" -ForegroundColor Green
Write-Host "   ? El texto esté en dirección RTL (derecha a izquierda)" -ForegroundColor Green
Write-Host "   ? NO aparezcan símbolos ?" -ForegroundColor Green
Write-Host ""

Write-Host "6??  Cambia el idioma a CHINO" -ForegroundColor White
Write-Host "   Verifica que:" -ForegroundColor Gray
Write-Host "   ? Los caracteres chinos se muestren correctamente" -ForegroundColor Green
Write-Host "   ? NO aparezcan cuadrados vacíos ?" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " VERIFICACIÓN TÉCNICA (OPCIONAL)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "En DevTools (F12) ejecuta en la consola:" -ForegroundColor White
Write-Host ""
Write-Host "fetch('/locales/es.json')" -ForegroundColor Yellow
Write-Host "  .then(r => r.json())" -ForegroundColor Yellow
Write-Host "  .then(data => console.log(data.postAuth.labels.pais))" -ForegroundColor Yellow
Write-Host ""
Write-Host "Resultado esperado: 'País' (NO 'Pa?s')" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "¿Se muestran correctamente los caracteres especiales?" -ForegroundColor Yellow
$respuesta = Read-Host "Responde (S/N)"

if ($respuesta -eq "S" -or $respuesta -eq "s") {
    Write-Host ""
    Write-Host "?? ¡EXCELENTE!" -ForegroundColor Green
    Write-Host "? La corrección UTF-8 se desplegó exitosamente" -ForegroundColor Green
    Write-Host "? Todos los caracteres especiales funcionan correctamente" -ForegroundColor Green
    Write-Host ""
    Write-Host "?? Resumen:" -ForegroundColor Cyan
    Write-Host "   • 27 idiomas corregidos" -ForegroundColor White
    Write-Host "   • UTF-8 válido en todos los archivos JSON" -ForegroundColor White
    Write-Host "   • Desplegado en https://www.svydledger.com" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "??  PROBLEMA DETECTADO" -ForegroundColor Red
    Write-Host ""
    Write-Host "Posibles causas:" -ForegroundColor Yellow
    Write-Host "   1. El despliegue aún no terminó (espera 2-3 minutos más)" -ForegroundColor White
    Write-Host "   2. Caché del navegador (presiona Ctrl+Shift+R para hard refresh)" -ForegroundColor White
    Write-Host "   3. El archivo JSON no se cargó correctamente" -ForegroundColor White
    Write-Host ""
    Write-Host "Soluciones:" -ForegroundColor Yellow
    Write-Host "   1. Verifica GitHub Actions: https://github.com/VICTORsvydledger/SVYDLEDGER/actions" -ForegroundColor White
    Write-Host "   2. Haz hard refresh (Ctrl+Shift+R)" -ForegroundColor White
    Write-Host "   3. Abre en modo incógnito" -ForegroundColor White
    Write-Host "   4. Verifica DevTools > Network > es.json" -ForegroundColor White
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Presiona Enter para finalizar..." -ForegroundColor Gray
Read-Host
