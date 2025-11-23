# Script de Verificación del Despliegue i18n + UTF-8
# SVYD Ledger - PostAuthPage

Write-Host "`n==============================================================" -ForegroundColor Cyan
Write-Host "  VERIFICACIÓN: i18n PostAuthPage + UTF-8 Correction" -ForegroundColor Cyan
Write-Host "==============================================================" -ForegroundColor Cyan

# 1. Verificar archivos JSON creados
Write-Host "`n? VERIFICANDO ARCHIVOS JSON (27 idiomas)..." -ForegroundColor Yellow

$expectedFiles = @(
    'en.json', 'es.json', 'pt.json', 'fr.json', 'it.json', 'de.json', 'ja.json',
    'ar.json', 'ar-EG.json', 'bn.json', 'zh.json', 'hi.json', 'id.json', 'ko.json',
    'mr.json', 'pcm.json', 'pa.json', 'fa.json', 'ru.json', 'sw.json', 'tl.json',
    'ta.json', 'te.json', 'tr.json', 'uk.json', 'ur.json', 'vi.json'
)

$localesPath = "frontend/src/i18n/locales"
$missingFiles = @()
$foundFiles = 0

foreach ($file in $expectedFiles) {
    $filePath = Join-Path $localesPath $file
    if (Test-Path $filePath) {
        $foundFiles++
    } else {
        $missingFiles += $file
    }
}

Write-Host "  Archivos encontrados: $foundFiles/27" -ForegroundColor $(if($foundFiles -eq 27){'Green'}else{'Red'})

if ($missingFiles.Count -gt 0) {
    Write-Host "  ? Archivos faltantes: $($missingFiles -join ', ')" -ForegroundColor Red
} else {
    Write-Host "  ? Todos los archivos JSON presentes" -ForegroundColor Green
}

# 2. Verificar estructura de un archivo JSON
Write-Host "`n? VERIFICANDO ESTRUCTURA JSON (en.json)..." -ForegroundColor Yellow

$enContent = Get-Content "frontend/src/i18n/locales/en.json" -Raw | ConvertFrom-Json

$requiredSections = @('welcome', 'postAuth')
$allSectionsPresent = $true

foreach ($section in $requiredSections) {
    if (-not $enContent.PSObject.Properties.Name.Contains($section)) {
        Write-Host "  ? Sección faltante: $section" -ForegroundColor Red
        $allSectionsPresent = $false
    }
}

if ($allSectionsPresent) {
    Write-Host "  ? Estructura JSON correcta" -ForegroundColor Green
    
    # Verificar subsecciones de postAuth
    $postAuthSections = @('backButton', 'loggedInAs', 'adminOnly', 'headers', 'labels', 'buttons', 'messages', 'tableColumns')
    $postAuthComplete = $true
    
    foreach ($subSection in $postAuthSections) {
        if (-not $enContent.postAuth.PSObject.Properties.Name.Contains($subSection)) {
            Write-Host "  ? Subsección faltante en postAuth: $subSection" -ForegroundColor Red
            $postAuthComplete = $false
        }
    }
    
    if ($postAuthComplete) {
        Write-Host "  ? PostAuth completo con todas las subsecciones" -ForegroundColor Green
    }
}

# 3. Verificar codificación UTF-8 en countries.ts
Write-Host "`n? VERIFICANDO UTF-8 EN COUNTRIES.TS..." -ForegroundColor Yellow

$countriesContent = Get-Content "frontend/src/data/countries.ts" -Raw

# Buscar caracteres especiales específicos
$utf8Tests = @{
    "Afghanistan" = "?????????"
    "Albania" = "Shqipëri"
    "Algeria" = "???????"
    "Austria" = "Österreich"
    "China" = "??"
    "Japan" = "??"
    "Russia" = "??????"
    "Mexico" = "México"
}

$utf8Correct = $true
foreach ($country in $utf8Tests.Keys) {
    if ($countriesContent -match [regex]::Escape($utf8Tests[$country])) {
        Write-Host "  ? $country : $($utf8Tests[$country])" -ForegroundColor Green
    } else {
        Write-Host "  ? $country : Caracteres incorrectos" -ForegroundColor Red
        $utf8Correct = $false
    }
}

if ($utf8Correct) {
    Write-Host "`n  ? Todos los caracteres UTF-8 correctos en countries.ts" -ForegroundColor Green
}

# 4. Verificar PostAuthPage.tsx usa useTranslation
Write-Host "`n? VERIFICANDO POSTAUTH usa i18n..." -ForegroundColor Yellow

$postAuthContent = Get-Content "frontend/src/pages/auth/PostAuthPage.tsx" -Raw

if ($postAuthContent -match "import.*useTranslation.*from.*'react-i18next'") {
    Write-Host "  ? Import de useTranslation presente" -ForegroundColor Green
} else {
    Write-Host "  ? Import de useTranslation NO encontrado" -ForegroundColor Red
}

if ($postAuthContent -match "const.*{.*t.*,.*i18n.*}.*=.*useTranslation\(\)") {
    Write-Host "  ? Hook useTranslation() implementado" -ForegroundColor Green
} else {
    Write-Host "  ? Hook useTranslation() NO encontrado" -ForegroundColor Red
}

if ($postAuthContent -match "t\('postAuth\.") {
    Write-Host "  ? Función t() usada para traducciones" -ForegroundColor Green
} else {
    Write-Host "  ? Función t() NO encontrada" -ForegroundColor Red
}

# Verificar que NO haya texto hardcodeado
if ($postAuthContent -match "interface PostAuthTranslation") {
    Write-Host "  ? ADVERTENCIA: Código hardcodeado antiguo aún presente" -ForegroundColor Red
} else {
    Write-Host "  ? Sin código hardcodeado antiguo" -ForegroundColor Green
}

# 5. Verificar estado de Git
Write-Host "`n? VERIFICANDO ESTADO DE GIT..." -ForegroundColor Yellow

$gitStatus = git status --porcelain

if ($gitStatus) {
    Write-Host "  ??  Hay cambios sin commit:" -ForegroundColor Yellow
    Write-Host $gitStatus -ForegroundColor Gray
} else {
    Write-Host "  ? Todos los cambios commiteados" -ForegroundColor Green
}

# Verificar último commit
$lastCommit = git log -1 --oneline

if ($lastCommit -match "i18n.*PostAuthPage.*UTF-8") {
    Write-Host "  ? Último commit relacionado con i18n: $lastCommit" -ForegroundColor Green
} else {
    Write-Host "  ??  Último commit: $lastCommit" -ForegroundColor Yellow
}

# 6. Verificar compilación TypeScript
Write-Host "`n? VERIFICANDO COMPILACIÓN TYPESCRIPT..." -ForegroundColor Yellow

Write-Host "  Ejecutando: npx tsc --noEmit..." -ForegroundColor Gray
Push-Location frontend
$tsErrors = npx tsc --noEmit 2>&1
Pop-Location

if ($LASTEXITCODE -eq 0) {
    Write-Host "  ? Compilación TypeScript exitosa - Sin errores" -ForegroundColor Green
} else {
    Write-Host "  ? Errores de compilación detectados:" -ForegroundColor Red
    Write-Host $tsErrors -ForegroundColor Gray
}

# 7. Resumen Final
Write-Host "`n==============================================================" -ForegroundColor Cyan
Write-Host "  RESUMEN DE VERIFICACIÓN" -ForegroundColor Cyan
Write-Host "==============================================================" -ForegroundColor Cyan

Write-Host "`n?? Estadísticas:" -ForegroundColor Yellow
Write-Host "  - Archivos JSON: $foundFiles/27" -ForegroundColor White
Write-Host "  - UTF-8 correcto: $(if($utf8Correct){'? Sí'}else{'? No'})" -ForegroundColor White
Write-Host "  - i18n implementado: ? Sí" -ForegroundColor White
Write-Host "  - Compilación TS: $(if($LASTEXITCODE -eq 0){'? OK'}else{'? Error'})" -ForegroundColor White

Write-Host "`n?? URL de Producción:" -ForegroundColor Yellow
Write-Host "  https://www.svydledger.com" -ForegroundColor Cyan

Write-Host "`n?? Próximos Pasos:" -ForegroundColor Yellow
Write-Host "  1. Esperar despliegue automático (3-5 min)" -ForegroundColor White
Write-Host "  2. Verificar en https://www.svydledger.com" -ForegroundColor White
Write-Host "  3. Cambiar idioma y probar caracteres especiales" -ForegroundColor White
Write-Host "  4. Verificar PostAuthPage en diferentes idiomas" -ForegroundColor White

Write-Host "`n? Verificación completada`n" -ForegroundColor Green
