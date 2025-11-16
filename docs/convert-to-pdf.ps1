# Script para convertir EXECUTIVE-SUMMARY.md a PDF
# Requiere Google Chrome o Microsoft Edge instalado

$markdownFile = "EXECUTIVE-SUMMARY.md"
$htmlFile = "EXECUTIVE-SUMMARY.html"
$pdfFile = "EXECUTIVE-SUMMARY.pdf"

Write-Host "Convirtiendo Markdown a HTML..." -ForegroundColor Cyan

# Leer el contenido del Markdown
$content = Get-Content $markdownFile -Raw -Encoding UTF8

# Crear HTML con estilos
$html = @"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SVYD LEDGER - Resumen Ejecutivo</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            color: #333;
        }
        h1 {
            color: #1976d2;
            border-bottom: 3px solid #1976d2;
            padding-bottom: 10px;
        }
        h2 {
            color: #1976d2;
            border-bottom: 2px solid #e0e0e0;
            padding-bottom: 8px;
            margin-top: 30px;
        }
        h3 {
            color: #424242;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            margin: 20px 0;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #1976d2;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f5f5f5;
        }
        code {
            background-color: #f5f5f5;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Consolas', monospace;
        }
        pre {
            background-color: #f5f5f5;
            padding: 15px;
            border-radius: 5px;
            overflow-x: auto;
        }
        .emoji {
            font-size: 1.2em;
        }
        @media print {
            body { font-size: 10pt; }
            h1 { page-break-before: always; }
            table { page-break-inside: avoid; }
        }
    </style>
</head>
<body>
"@

# Convertir Markdown básico a HTML (simple)
$content = $content -replace '### (.*)', '<h3>$1</h3>'
$content = $content -replace '## (.*)', '<h2>$1</h2>'
$content = $content -replace '# (.*)', '<h1>$1</h1>'
$content = $content -replace '\*\*(.*?)\*\*', '<strong>$1</strong>'
$content = $content -replace '\*(.*?)\*', '<em>$1</em>'
$content = $content -replace '`(.*?)`', '<code>$1</code>'
$content = $content -replace '\n\n', '</p><p>'
$content = $content -replace '\n', '<br>'

$html += "<p>$content</p>"
$html += "</body></html>"

# Guardar HTML
$html | Out-File -FilePath $htmlFile -Encoding UTF8

Write-Host "HTML creado: $htmlFile" -ForegroundColor Green
Write-Host ""
Write-Host "Para convertir a PDF, usa una de estas opciones:" -ForegroundColor Yellow
Write-Host "1. Abre el archivo HTML en Chrome/Edge y usa Ctrl+P > Guardar como PDF" -ForegroundColor Cyan
Write-Host "2. Usa la extensión 'Markdown PDF' de VS Code" -ForegroundColor Cyan
Write-Host "3. Instala Pandoc: choco install pandoc" -ForegroundColor Cyan
Write-Host ""
Write-Host "O ejecuta este comando para abrir el HTML en el navegador:" -ForegroundColor Yellow
Write-Host "Start-Process $htmlFile" -ForegroundColor White
