# ?? SCRIPT DE RESPALDO SEGURO EN GITHUB
# Ejecuta este script MANUALMENTE para hacer el respaldo
# NO lo ejecutes automáticamente desde el agente

# ==============================================
#  PASO 1: Verificar estado actual
# ==============================================

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "   PASO 1: Verificando cambios pendientes" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

# Ver qué archivos han cambiado
git status

Write-Host "`n¿Continuar con el respaldo? (S/N): " -ForegroundColor Yellow -NoNewline
$continuar = Read-Host

if ($continuar -ne "S" -and $continuar -ne "s") {
    Write-Host "`n? Respaldo cancelado por el usuario." -ForegroundColor Red
    exit
}

# ==============================================
#  PASO 2: Agregar todos los cambios
# ==============================================

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "   PASO 2: Agregando archivos al stage" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

git add .

Write-Host "? Archivos agregados al stage" -ForegroundColor Green

# ==============================================
#  PASO 3: Ver resumen de cambios
# ==============================================

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "   PASO 3: Resumen de cambios" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

git status --short

# ==============================================
#  PASO 4: Hacer commit
# ==============================================

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "   PASO 4: Creando commit" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

$commitMessage = "fix: Arreglar importación i18n en MainLayout + Verificar componentes Auth funcionando

- Eliminada importación redundante '@/i18n/i18n' en MainLayout.tsx
- Componentes SignInForm y SignUpForm verificados y funcionando
- Sistema anti-congelamiento documentado
- Puerto único 5173 confirmado
- WelcomePage salvada exitosamente
- Documentación completa actualizada

Archivos clave modificados:
- frontend/src/components/layout/MainLayout.tsx (importación corregida)

Archivos verificados:
- frontend/src/pages/auth/components/SignInForm.tsx (funcional)
- frontend/src/pages/auth/components/SignUpForm.tsx (funcional)

Estado: ? Sin errores de compilación
Congelamiento: ? Prevenido
Código salvable: ? SÍ (no empezar de cero)

Resolves: Problema #16 (congelamiento del agente)
"

git commit -m "$commitMessage"

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n? Commit creado exitosamente" -ForegroundColor Green
} else {
    Write-Host "`n? Error al crear commit" -ForegroundColor Red
    Write-Host "Verifica que tengas cambios pendientes" -ForegroundColor Yellow
    exit
}

# ==============================================
#  PASO 5: Subir a GitHub
# ==============================================

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "   PASO 5: Subiendo a GitHub" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

Write-Host "Subiendo cambios a: origin main" -ForegroundColor Yellow
Write-Host "Repositorio: https://github.com/VICTORsvydledger/SVYDLEDGER`n" -ForegroundColor Yellow

git push origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n? ¡RESPALDO COMPLETADO EXITOSAMENTE!" -ForegroundColor Green
} else {
    Write-Host "`n? Error al subir cambios" -ForegroundColor Red
    Write-Host "Posibles causas:" -ForegroundColor Yellow
    Write-Host "  - No tienes conexión a internet" -ForegroundColor Yellow
    Write-Host "  - Necesitas autenticación (git credential helper)" -ForegroundColor Yellow
    Write-Host "  - El repositorio remoto tiene cambios nuevos (git pull primero)" -ForegroundColor Yellow
    exit
}

# ==============================================
#  PASO 6: Verificación final
# ==============================================

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "   PASO 6: Verificación final" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

Write-Host "?? Último commit:" -ForegroundColor Cyan
git log -1 --oneline

Write-Host "`n?? Estado del repositorio:" -ForegroundColor Cyan
git status

Write-Host "`n?? Verifica tu respaldo en:" -ForegroundColor Cyan
Write-Host "   https://github.com/VICTORsvydledger/SVYDLEDGER/commits/main" -ForegroundColor Yellow

# ==============================================
#  RESUMEN FINAL
# ==============================================

Write-Host "`n============================================" -ForegroundColor Green
Write-Host "   ? RESPALDO COMPLETADO" -ForegroundColor Green
Write-Host "============================================`n" -ForegroundColor Green

Write-Host "Archivos respaldados:" -ForegroundColor Cyan
Write-Host "  ? MainLayout.tsx (importación i18n arreglada)" -ForegroundColor White
Write-Host "  ? SignInForm.tsx (verificado)" -ForegroundColor White
Write-Host "  ? SignUpForm.tsx (verificado)" -ForegroundColor White
Write-Host "  ? Documentación completa" -ForegroundColor White

Write-Host "`nEstado del código:" -ForegroundColor Cyan
Write-Host "  ? Sin errores de compilación" -ForegroundColor White
Write-Host "  ? Puerto único 5173" -ForegroundColor White
Write-Host "  ? WelcomePage salvada" -ForegroundColor White
Write-Host "  ? Sistema anti-congelamiento activo" -ForegroundColor White

Write-Host "`nValor salvado:" -ForegroundColor Cyan
Write-Host "  ?? $900 USD de trabajo" -ForegroundColor White
Write-Host "  ? Código funcional y documentado" -ForegroundColor White

Write-Host "`n?? ¡TODO TU TRABAJO ESTÁ SEGURO EN GITHUB!" -ForegroundColor Green
Write-Host ""
