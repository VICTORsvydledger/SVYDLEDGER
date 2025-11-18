# ?? PROBLEMA: Múltiples Instancias de Node.js en Visual Studio

## ?? SÍNTOMAS DEL PROBLEMA

```
Node.js JavaScript Runtime     0%    350.6 MB
Node.js JavaScript Runtime     0%    207.1 MB
Node.js JavaScript Runtime (2) 0%    490.4 MB
Node.js JavaScript Runtime     0%     28.8 MB
??????????????????????????????????????????
TOTAL:                              ~876 MB
```

### Problemas Causados:
- ?? **Alto consumo de memoria** (RAM)
- ?? **Visual Studio se congela**
- ?? **Hot reload no funciona**
- ?? **Servidor de desarrollo no responde**
- ?? **Build failures aleatorios**
- ?? **Puerto 5173 en conflicto**

---

## ?? CAUSA DEL PROBLEMA

Visual Studio Enterprise 2022 tiene integración con Node.js para:
- IntelliSense de JavaScript/TypeScript
- Debugging de frontend
- NPM Tasks
- Live Preview

**Cuando falla el cierre correcto**, quedan procesos huérfanos en memoria.

---

## ? SOLUCIÓN RÁPIDA (2 minutos)

### Opción 1: Script Automático (RECOMENDADO)

```powershell
# Ejecutar en PowerShell como Administrador
.\kill-node-processes.ps1
```

Este script:
1. ? Lista todos los procesos de Node.js
2. ? Muestra memoria consumida
3. ? Termina todos los procesos
4. ? Verifica que se hayan cerrado
5. ? Muestra puertos en uso

### Opción 2: Comando Manual

```powershell
# Método 1: Terminar por nombre
taskkill /F /IM node.exe /T

# Método 2: PowerShell
Get-Process -Name node | Stop-Process -Force

# Método 3: Verificar y terminar
Get-Process -Name node | ForEach-Object { Stop-Process -Id $_.Id -Force }
```

---

## ??? SOLUCIÓN PERMANENTE

### 1. Configurar Visual Studio

#### A. Deshabilitar Node.js Integrado de VS

**Herramientas ? Opciones ? Proyectos y soluciones ? Web Package Management**

```
? Deshabilitar la instalación automática de paquetes externos en apertura de proyecto
? Deshabilitar npm en cierre de proyecto
```

#### B. Configurar TypeScript/JavaScript

**Herramientas ? Opciones ? Proyectos y soluciones ? Web Package Management ? Externo**

```
Ubicación de Node.js externa (recomendado):
C:\Program Files\nodejs\node.exe
```

#### C. Deshabilitar Live Preview (opcional)

Si no lo usas:
```
Ver ? Otras ventanas ? Live Preview (cerrar)
```

---

### 2. Usar Terminal Externa

**En lugar de usar el terminal integrado de VS:**

```powershell
# Opción A: Windows Terminal (Recomendado)
# 1. Abrir Windows Terminal
# 2. Navegar a carpeta frontend
cd C:\Users\svcon\Desktop\SVYDDATALEDGER\frontend
npm run dev

# Opción B: PowerShell separado
# 1. Abrir PowerShell como Admin
# 2. Navegar y ejecutar
cd C:\Users\svcon\Desktop\SVYDDATALEDGER\frontend
npm run dev
```

**Ventajas:**
- ? Mejor control del proceso
- ? Fácil de cerrar (Ctrl+C)
- ? No depende de Visual Studio
- ? Logs más claros

---

### 3. Script de Inicio Controlado

Crear archivo: `start-dev-safe.ps1`

<function_calls>
<invoke name="create_file">
<parameter name="content"># SVYD LEDGER - Safe Development Server Start
# Este script inicia el servidor de desarrollo de forma segura

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  SVYD LEDGER - Safe Dev Start" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# 1. Verificar si hay procesos de Node.js
Write-Host "[1/5] Verificando procesos existentes..." -ForegroundColor Yellow
$nodeProcesses = Get-Process -Name node -ErrorAction SilentlyContinue

if ($nodeProcesses) {
    $count = ($nodeProcesses | Measure-Object).Count
    Write-Host "    [WARNING] Encontrados $count procesos de Node.js" -ForegroundColor Red
    
    $response = Read-Host "¿Deseas terminarlos antes de continuar? (s/n)"
    if ($response -eq 's' -or $response -eq 'S') {
        Write-Host "    Terminando procesos..." -ForegroundColor Yellow
        $nodeProcesses | Stop-Process -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        Write-Host "    [OK] Procesos terminados" -ForegroundColor Green
    }
} else {
    Write-Host "    [OK] No hay procesos de Node.js" -ForegroundColor Green
}
Write-Host ""

# 2. Verificar puerto 5173
Write-Host "[2/5] Verificando puerto 5173..." -ForegroundColor Yellow
$portInUse = Get-NetTCPConnection -LocalPort 5173 -ErrorAction SilentlyContinue

if ($portInUse) {
    $pid = $portInUse.OwningProcess
    $process = Get-Process -Id $pid -ErrorAction SilentlyContinue
    
    Write-Host "    [WARNING] Puerto 5173 en uso por PID: $pid" -ForegroundColor Red
    if ($process) {
        Write-Host "    Proceso: $($process.Name)" -ForegroundColor Gray
    }
    
    $response = Read-Host "¿Deseas liberar el puerto? (s/n)"
    if ($response -eq 's' -or $response -eq 'S') {
        Write-Host "    Terminando proceso..." -ForegroundColor Yellow
        Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        Write-Host "    [OK] Puerto liberado" -ForegroundColor Green
    }
} else {
    Write-Host "    [OK] Puerto 5173 disponible" -ForegroundColor Green
}
Write-Host ""

# 3. Verificar carpeta frontend
Write-Host "[3/5] Verificando proyecto frontend..." -ForegroundColor Yellow
if (Test-Path "frontend") {
    Write-Host "    [OK] Carpeta frontend encontrada" -ForegroundColor Green
} else {
    Write-Host "    [ERROR] Carpeta frontend no encontrada" -ForegroundColor Red
    Write-Host "    Asegúrate de ejecutar este script desde la raíz del proyecto" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# 4. Verificar node_modules
Write-Host "[4/5] Verificando dependencias..." -ForegroundColor Yellow
if (Test-Path "frontend\node_modules") {
    Write-Host "    [OK] Dependencias instaladas" -ForegroundColor Green
} else {
    Write-Host "    [WARNING] Dependencias no instaladas" -ForegroundColor Yellow
    $response = Read-Host "¿Deseas instalar ahora? (s/n)"
    if ($response -eq 's' -or $response -eq 'S') {
        Write-Host "    Instalando dependencias..." -ForegroundColor Yellow
        Push-Location frontend
        npm install
        Pop-Location
        Write-Host "    [OK] Dependencias instaladas" -ForegroundColor Green
    } else {
        Write-Host "    [ERROR] No se puede continuar sin dependencias" -ForegroundColor Red
        exit 1
    }
}
Write-Host ""

# 5. Iniciar servidor
Write-Host "[5/5] Iniciando servidor de desarrollo..." -ForegroundColor Yellow
Write-Host ""
Write-Host "=====================================" -ForegroundColor Green
Write-Host "  SERVIDOR INICIANDO..." -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host ""
Write-Host "URL: http://localhost:5173" -ForegroundColor Cyan
Write-Host ""
Write-Host "Presiona Ctrl+C para detener el servidor" -ForegroundColor Yellow
Write-Host ""

# Cambiar a carpeta frontend
Push-Location frontend

# Iniciar servidor (esto bloqueará el terminal)
npm run dev

# Cleanup al salir (se ejecuta cuando se presiona Ctrl+C)
Pop-Location
Write-Host ""
Write-Host "Servidor detenido" -ForegroundColor Yellow
