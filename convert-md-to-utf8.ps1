# Script: convert-md-to-utf8.ps1
# Descripción: Convierte todos los archivos .md en la raíz a UTF-8 sin BOM
# Fecha: 2025-01-15

Write-Host "?? Convirtiendo archivos .md a UTF-8..." -ForegroundColor Cyan
Write-Host ""

# Obtener todos los archivos .md en la raíz (excluyendo carpetas)
$mdFiles = Get-ChildItem -Path "." -Filter "*.md" -File

$count = 0
$converted = 0
$alreadyUtf8 = 0
$errors = 0

foreach ($file in $mdFiles) {
    $count++
    try {
        # Leer contenido con encoding por defecto
        $content = Get-Content $file.FullName -Raw -Encoding Default
        
        # Detectar si tiene caracteres especiales españoles
        $hasSpanishChars = $content -match '[áéíóúñÁÉÍÓÚÑ¿¡]'
        
        # Escribir con UTF-8 sin BOM
        [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.UTF8Encoding]::new($false))
        
        if ($hasSpanishChars) {
            Write-Host "? Convertido: $($file.Name)" -ForegroundColor Green
            $converted++
        } else {
            Write-Host "??  Sin cambios: $($file.Name)" -ForegroundColor Gray
            $alreadyUtf8++
        }
    }
    catch {
        Write-Host "? Error: $($file.Name) - $($_.Exception.Message)" -ForegroundColor Red
        $errors++
    }
}

Write-Host ""
Write-Host "?? RESUMEN:" -ForegroundColor Cyan
Write-Host "   Total archivos: $count" -ForegroundColor White
Write-Host "   Convertidos: $converted" -ForegroundColor Green
Write-Host "   Ya UTF-8: $alreadyUtf8" -ForegroundColor Gray
Write-Host "   Errores: $errors" -ForegroundColor Red
Write-Host ""

if ($errors -eq 0) {
    Write-Host "? Conversión completada sin errores" -ForegroundColor Green
} else {
    Write-Host "??  Conversión completada con $errors errores" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "?? Siguiente paso: Revisar cambios con 'git status' y 'git diff'" -ForegroundColor Cyan
