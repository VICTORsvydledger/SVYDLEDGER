# ?? Guía de Solución de Problemas - SVYD LEDGER

## ?? Problema: Múltiples Procesos Node.js Corriendo

### Síntomas
- Task Manager muestra varios procesos "Node.js JavaScript Runtime"
- Alto uso de memoria (200-350 MB por proceso)
- Puerto 5173 ocupado
- Error: "Port 5173 is already in use"

### ? Solución Rápida

#### Opción 1: Script Automático (Recomendado)
```powershell
.\dev-manager.ps1
```
Luego selecciona:
- Opción `2`: Kill All Node.js Processes
- Opción `1`: Start Frontend (Safe Mode)

#### Opción 2: Script Directo
```powershell
.\kill-node-processes.ps1
.\start-frontend.ps1
```

#### Opción 3: Manual
```powershell
# Matar procesos Node.js
Get-Process node | Stop-Process -Force

# Esperar 2 segundos
Start-Sleep -Seconds 2

# Iniciar frontend
cd frontend
npm run dev
```

#### Opción 4: Task Manager
1. Abrir Task Manager (Ctrl+Shift+Esc)
2. Buscar "Node.js JavaScript Runtime"
3. Click derecho ? End Task en cada uno
4. Ejecutar `.\start-frontend.ps1`

---

## ?? Problema: Error "Cannot find module"

### Síntomas
- Error al iniciar: `Cannot find module 'vite'`
- Error: `Cannot find module '@vitejs/plugin-react'`

### ? Solución

#### Opción 1: Reinstalar Dependencias (Recomendado)
```powershell
.\dev-manager.ps1
```
Selecciona: Opción `3` - Clean & Reinstall Dependencies

#### Opción 2: Manual
```powershell
cd frontend
Remove-Item -Recurse -Force node_modules
Remove-Item -Force package-lock.json
npm install
```

---

## ?? Problema: Puerto 5173 Ocupado

### Síntomas
- Error: `Port 5173 is already in use`
- Vite no puede iniciar

### ? Solución

#### Opción 1: Cambiar Puerto Temporalmente
```powershell
cd frontend
npm run dev -- --port 3000
```

#### Opción 2: Liberar Puerto
```powershell
# Ver qué proceso usa el puerto
Get-NetTCPConnection -LocalPort 5173 -State Listen

# Matar el proceso (reemplaza PID con el número real)
Stop-Process -Id <PID> -Force
```

#### Opción 3: Cambiar Puerto Permanente
Editar `frontend/vite.config.ts`:
```typescript
export default defineConfig({
  server: {
    port: 3000, // Cambiar de 5173 a 3000
    // ...resto de configuración
  }
})
```

---

## ?? Problema: Imagen de Fondo No Aparece

### Síntomas
- WelcomePage muestra fondo negro/blanco
- No se ve la imagen del cielo

### ? Solución

#### Verificar Imagen
```powershell
# Verificar si existe la imagen
Test-Path frontend\public\images\backgrounds\background-1.png
```

#### Agregar Imagen
1. Descargar imagen de cielo azul con nubes:
   - https://unsplash.com/s/photos/blue-sky-clouds
   - https://www.pexels.com/search/blue%20sky%20clouds/

2. Renombrar a: `background-1.png`

3. Colocar en: `frontend\public\images\backgrounds\`

4. Verificar:
```powershell
Get-Item frontend\public\images\backgrounds\background-1.png
```

---

## ?? Problema: Caracteres Raros en Idiomas

### Síntomas
- Idiomas muestran: â€œ, ????, etc.
- No se ven caracteres nativos correctamente

### ? Solución

#### Verificar Archivo
Los idiomas ya fueron corregidos en `WelcomePage.tsx`. Si aún ves caracteres raros:

```powershell
# Verificar encoding del archivo
Get-Content frontend\src\pages\auth\WelcomePage.tsx -Encoding UTF8 | Select-String "Español"
```

Debería mostrar: `Español` (no `Espa?ol`)

#### Si el problema persiste:
1. Abrir `WelcomePage.tsx` en VS Code
2. Abajo a la derecha, verificar encoding: debe ser **UTF-8**
3. Si no lo es, cambiar a UTF-8 y guardar

---

## ?? Problema: Warnings de TypeScript

### Síntomas
- `TS6133: 'variable' is declared but its value is never read`
- Build falla con errores de TypeScript

### ? Solución

#### Para WelcomePage
Ya se corrigieron los warnings. Si aparecen nuevos:

```powershell
cd frontend
npm run lint
```

#### Ignorar temporalmente (no recomendado)
Editar `frontend\tsconfig.json`:
```json
{
  "compilerOptions": {
    "noUnusedLocals": false,
    "noUnusedParameters": false
  }
}
```

---

## ?? Problema: Build Falla

### Síntomas
- `npm run build` falla
- Errores de compilación

### ? Solución

#### Verificar Errores
```powershell
cd frontend
npm run build
```

#### Limpiar y Reconstruir
```powershell
Remove-Item -Recurse -Force .vite
Remove-Item -Recurse -Force dist
npm run build
```

#### Si persiste:
```powershell
.\dev-manager.ps1
```
Opción `3`: Clean & Reinstall Dependencies

---

## ?? Problema: "npm is not recognized"

### Síntomas
- Error: `npm : The term 'npm' is not recognized`
- Node.js no funciona en PowerShell

### ? Solución

#### Verificar Instalación
```powershell
node --version
npm --version
```

#### Si falla:
1. Reinstalar Node.js desde: https://nodejs.org/
2. Descargar LTS (v20.x o superior)
3. Instalar con opción "Add to PATH"
4. **Reiniciar VS Code completamente**
5. Abrir nueva terminal PowerShell
6. Probar de nuevo

---

## ?? Problema: Azure CLI No Funciona

### Síntomas
- Error: `az : The term 'az' is not recognized`
- No puede desplegar a Azure

### ? Solución

#### Instalar Azure CLI
1. Descargar desde: https://aka.ms/installazurecliwindows
2. Ejecutar instalador
3. Reiniciar VS Code
4. Verificar:
```powershell
az --version
```

#### Login en Azure
```powershell
az login
```

---

## ?? Problema: WelcomePage No Responde

### Síntomas
- Formularios no funcionan
- Botones no responden
- Selector de idiomas no cambia

### ? Solución

#### Verificar en DevTools
1. Abrir página: http://localhost:5173
2. Presionar F12 (DevTools)
3. Ver tab "Console"
4. Buscar errores en rojo

#### Errores Comunes:

**Error de CORS:**
```
Access to XMLHttpRequest at '...' from origin '...' has been blocked
```
**Solución:** Backend no está corriendo o CORS mal configurado

**Error 404:**
```
GET http://localhost:5173/api/... 404 (Not Found)
```
**Solución:** API no está corriendo en puerto esperado

---

## ?? Problema: Responsive No Funciona

### Síntomas
- En móvil se ve mal
- Formularios no se adaptan
- Texto muy pequeño o muy grande

### ? Solución

#### Verificar en DevTools
1. Abrir página: http://localhost:5173
2. Presionar F12
3. Click en icono de móvil (Toggle Device Toolbar)
4. Probar diferentes dispositivos

#### Si persiste:
El CSS ya está configurado con breakpoints. Verificar que `WelcomePage.scss` esté cargando:

```powershell
Get-Content frontend\src\pages\auth\WelcomePage.scss | Select-String "@media"
```

Debería mostrar varios `@media` queries.

---

## ??? COMANDOS ÚTILES

### Verificar Estado del Sistema
```powershell
.\dev-manager.ps1
```
Opción `4`: Check System Status

### Logs de Node.js
```powershell
# Ver procesos Node.js
Get-Process node | Format-Table Id, ProcessName, WorkingSet64

# Ver puertos en uso
Get-NetTCPConnection -State Listen | Where-Object {$_.LocalPort -eq 5173}
```

### Limpiar Todo
```powershell
# Matar Node.js
Get-Process node | Stop-Process -Force

# Limpiar frontend
cd frontend
Remove-Item -Recurse -Force node_modules, .vite, dist
npm install
```

---

## ?? SI NADA FUNCIONA

### Último Recurso: Reset Completo

```powershell
# 1. Cerrar VS Code completamente

# 2. Abrir PowerShell como Administrador

# 3. Ejecutar:
Get-Process node | Stop-Process -Force
taskkill /F /IM node.exe /T

# 4. Navegar al proyecto
cd C:\Users\svcon\Desktop\SVYDDATALEDGER

# 5. Limpiar frontend
cd frontend
Remove-Item -Recurse -Force node_modules
Remove-Item -Force package-lock.json
npm cache clean --force
npm install

# 6. Iniciar
npm run dev
```

---

## ?? DOCUMENTACIÓN ADICIONAL

| Documento | Ubicación | Descripción |
|-----------|-----------|-------------|
| Quick Start | `docs\WELCOMEPAGE-QUICKSTART.md` | Guía rápida de inicio |
| Status | `docs\WELCOMEPAGE-STATUS.md` | Estado del proyecto |
| Azure Setup | `docs\AZURE-DNS-SETUP.md` | Configuración de Azure |
| Executive Summary | `docs\EXECUTIVE-SUMMARY-WELCOMEPAGE.md` | Resumen ejecutivo |

---

## ? CHECKLIST DE VERIFICACIÓN

Antes de reportar un problema, verifica:

- [ ] Node.js instalado (`node --version`)
- [ ] npm instalado (`npm --version`)
- [ ] No hay procesos Node.js corriendo innecesariamente
- [ ] Puerto 5173 está libre
- [ ] `node_modules` existe en `frontend/`
- [ ] `package.json` existe en `frontend/`
- [ ] Imagen de fondo existe (opcional)
- [ ] DevTools Console sin errores
- [ ] VS Code reiniciado recientemente

---

**Última actualización:** 15 de Enero, 2025  
**Versión:** 1.0.0
