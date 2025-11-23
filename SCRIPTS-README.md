# ?? Scripts de Gesti�n - SVYD LEDGER

## ?? Scripts Disponibles

### ? Recomendados (Usar Siempre)

#### 1. start-single-process.ps1
**Prop�sito:** Inicio con garant�a de proceso �nico

```powershell
.\start-single-process.ps1
```

**Caracter�sticas:**
- ? Sistema de bloqueo (.node-lock)
- ? Mata procesos anteriores autom�ticamente
- ? Solo permite 1 proceso activo
- ? Auto-limpieza al salir (Ctrl+C)
- ? Detecta y limpia procesos zombies

**Cu�ndo usar:**
- Al empezar el d�a
- Cada vez que quieras iniciar el frontend
- Como reemplazo de `npm run dev`

---

#### 2. dev-manager.ps1
**Prop�sito:** Men� interactivo para gesti�n completa

```powershell
.\dev-manager.ps1
```

**Opciones:**
1. **Start Frontend (Single Process Mode)** ? Recomendado
2. Start Frontend (Safe Mode)
3. Kill All Node.js Processes
4. Clean & Reinstall Dependencies
5. Check System Status
6. Open WelcomePage Documentation
7. Deploy to Azure
Q. Quit

**Cu�ndo usar:**
- Cuando necesitas varias opciones
- Para verificar el estado del sistema
- Para limpiar dependencias
- Para gesti�n completa

---

### ?? Herramientas de Monitoreo

#### 3. monitor-node-processes.ps1
**Prop�sito:** Monitoreo y prevenci�n autom�tica

```powershell
# Solo alertas
.\monitor-node-processes.ps1

# Con auto-kill (mantiene solo 1 proceso)
.\monitor-node-processes.ps1 -AutoKill

# Intervalo personalizado (segundos)
.\monitor-node-processes.ps1 -IntervalSeconds 60 -AutoKill
```

**Caracter�sticas:**
- ?? Revisa cada N segundos (default: 30)
- ?? Alerta cuando detecta m�ltiples procesos
- ?? Modo auto-kill: elimina procesos extras
- ?? Muestra uso de memoria en tiempo real

**Cu�ndo usar:**
- En una terminal separada
- Para sesiones de desarrollo largas
- Como protecci�n extra
- Si el problema persiste

---

### ?? Herramientas de Limpieza

#### 4. kill-node-processes.ps1
**Prop�sito:** Matar todos los procesos Node.js

```powershell
.\kill-node-processes.ps1
```

**Caracter�sticas:**
- Usa 3 m�todos diferentes
- Verifica que todo se detuvo
- Muestra estad�sticas

**Cu�ndo usar:**
- Cuando hay m�ltiples procesos corriendo
- Antes de un reinicio limpio
- Si algo no funciona
- Emergencias

---

#### 5. start-frontend.ps1
**Prop�sito:** Inicio seguro tradicional

```powershell
.\start-frontend.ps1
```

**Caracter�sticas:**
- Mata procesos antes de iniciar
- Verifica dependencias
- Limpia cach� de Vite
- Muestra informaci�n �til

**Cu�ndo usar:**
- Como alternativa a start-single-process.ps1
- Si el sistema de bloqueo da problemas
- Para pruebas

---

### ?? Despliegue

#### 6. deploy-to-azure.ps1
**Prop�sito:** Desplegar a Azure

```powershell
.\deploy-to-azure.ps1
```

**Cu�ndo usar:**
- Para desplegar a producci�n
- Despu�s de probar localmente
- Cuando todo est� listo

---

#### 7. setup-welcomepage.ps1
**Prop�sito:** Configuraci�n inicial del WelcomePage

```powershell
.\setup-welcomepage.ps1
```

**Cu�ndo usar:**
- Primera instalaci�n
- Despu�s de clonar el repo
- Para verificar instalaci�n

---

## ?? Flujos de Trabajo Recomendados

### ?? Trabajo Diario Normal

```powershell
# Al empezar:
.\start-single-process.ps1

# Desarrollar...

# Al terminar: Ctrl+C
```

**Resultado:** 1 proceso limpio, sin acumulaci�n

---

### ??? Trabajo con Protecci�n M�xima

```powershell
# Terminal 1 (Monitor):
.\monitor-node-processes.ps1 -AutoKill

# Terminal 2 (Desarrollo):
.\start-single-process.ps1

# El monitor mantiene solo 1 proceso autom�ticamente
```

**Resultado:** Protecci�n continua contra m�ltiples procesos

---

### ?? Trabajo con Gesti�n Completa

```powershell
# Ejecutar:
.\dev-manager.ps1

# Usar men� interactivo seg�n necesidad
```

**Resultado:** Control total desde un solo lugar

---

### ?? Limpieza Profunda

```powershell
# 1. Matar procesos
.\kill-node-processes.ps1

# 2. Abrir dev-manager
.\dev-manager.ps1

# 3. Seleccionar: Opci�n 3 (Clean & Reinstall)

# 4. Iniciar limpio
.\start-single-process.ps1
```

**Resultado:** Sistema completamente limpio

---

## ?? Par�metros Disponibles

### monitor-node-processes.ps1

| Par�metro | Tipo | Default | Descripci�n |
|-----------|------|---------|-------------|
| `-IntervalSeconds` | int | 30 | Segundos entre revisiones |
| `-AutoKill` | switch | false | Eliminar procesos extras autom�ticamente |

**Ejemplos:**
```powershell
# Revisi�n cada minuto
.\monitor-node-processes.ps1 -IntervalSeconds 60

# Auto-kill cada 15 segundos
.\monitor-node-processes.ps1 -IntervalSeconds 15 -AutoKill

# Solo con auto-kill (30 segundos)
.\monitor-node-processes.ps1 -AutoKill
```

---

## ?? Comparaci�n de Scripts

| Script | Proceso �nico | Auto-Limpieza | Monitoreo | Men� | Recomendado |
|--------|---------------|---------------|-----------|------|-------------|
| `start-single-process.ps1` | ?? | ?? | ? | ? | ??? |
| `monitor-node-processes.ps1` | ? (con -AutoKill) | ? | ?? | ? | ?? |
| `dev-manager.ps1` | ? (opci�n 1) | ? | ? | ?? | ??? |
| `start-frontend.ps1` | ?? | ?? | ? | ? | ? |
| `kill-node-processes.ps1` | ? | ?? | ? | ? | ? |

---

## ?? Soluci�n de Problemas

### Problema: "Script no se ejecuta"

**Soluci�n:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Problema: "Lock file existe pero no hay proceso"

**Soluci�n:**
```powershell
Remove-Item .node-lock -Force
.\start-single-process.ps1
```

### Problema: "M�ltiples procesos siguen apareciendo"

**Soluci�n:**
```powershell
# Terminal 1:
.\monitor-node-processes.ps1 -AutoKill

# Terminal 2:
.\start-single-process.ps1
```

### Problema: "Todo falla"

**Soluci�n:**
```powershell
# Limpieza extrema:
Get-Process node | Stop-Process -Force
Remove-Item .node-lock -Force -ErrorAction SilentlyContinue
.\dev-manager.ps1
# Opci�n 3: Clean & Reinstall
# Opci�n 1: Start Frontend
```

---

## ?? Archivos Generados

### .node-lock
**Ubicaci�n:** Ra�z del proyecto
**Prop�sito:** Bloqueo de proceso �nico
**Contenido:**
```json
{
  "ProcessId": 12345,
  "StartTime": "2024-01-15 10:30:00",
  "Port": 5173
}
```

**Gesti�n:**
- ? Creado autom�ticamente por `start-single-process.ps1`
- ? Eliminado autom�ticamente al salir (Ctrl+C)
- ? Verificado antes de iniciar nuevo proceso
- ?? No versionar (agregado a .gitignore)

---

## ?? Documentaci�n Relacionada

| Archivo | Descripci�n |
|---------|-------------|
| `SOLUCI�N-PROCESOS-NODE.md` | Gu�a completa del problema y soluci�n |
| `QUICK-START-SINGLE-PROCESS.md` | Gu�a r�pida de uso diario |
| `PROBLEMA-RESUELTO.md` | Resumen de la soluci�n implementada |
| `docs\TROUBLESHOOTING.md` | Soluci�n de todos los problemas |
| `WELCOMEPAGE-README.md` | README principal del proyecto |

---

## ?? Tips y Mejores Pr�cticas

### ? DO (Hacer)

1. **Usar siempre `start-single-process.ps1`**
   ```powershell
   .\start-single-process.ps1
   ```

2. **Terminar con Ctrl+C**
   - Limpia autom�ticamente
   - Elimina el lock file
   - Cierra el proceso correctamente

3. **Usar monitor en sesiones largas**
   ```powershell
   .\monitor-node-processes.ps1 -AutoKill
   ```

4. **Verificar peri�dicamente**
   ```powershell
   .\dev-manager.ps1
   # Opci�n 5: Check System Status
   ```

### ? DON'T (No Hacer)

1. **No usar `npm run dev` directamente**
   - No tiene protecci�n
   - Puede crear m�ltiples procesos

2. **No cerrar el terminal directamente**
   - El lock file no se limpia
   - El proceso queda hu�rfano

3. **No ignorar las alertas del monitor**
   - Si detecta m�ltiples procesos, investiga
   - Usa `kill-node-processes.ps1`

4. **No ejecutar m�ltiples veces seguidas**
   - Espera a que termine el anterior
   - Verifica con Task Manager

---

## ?? C�mo Funciona

### Sistema de Bloqueo

```
Usuario ejecuta: .\start-single-process.ps1
         ?
         ?
    �Existe .node-lock?
         ?
    ???????????
   NO         S�
    ?          ?
    ?     �Proceso vivo?
    ?          ?
    ?     ???????????
    ?    S�        NO
    ?     ?         ?
    ?  Mostrar   Limpiar
    ?  opciones  lock
    ?     ?         ?
    ?????????????????
         ?
    Crear .node-lock
         ?
    Iniciar servidor
         ?
    (Ctrl+C)
         ?
    Eliminar .node-lock
```

### Monitor Autom�tico

```
Inicio del monitor
         ?
         ?
    Revisar procesos
         ?
    ???????????
    ?         ?
    1      2+
proceso   procesos
    ?         ?
 Normal    Alerta
    ?         ?
    ?    �AutoKill?
    ?         ?
    ?    ???????????
    ?   S�        NO
    ?    ?         ?
    ?  Matar     Solo
    ?  extras   avisar
    ?    ?         ?
    ????????????????
         ?
    Esperar N segundos
         ?
         ???(loop)
```

---

## ?? Estado del Sistema

### Verificaciones R�pidas

**1. Procesos activos:**
```powershell
Get-Process node -ErrorAction SilentlyContinue
```

**2. Cantidad de procesos:**
```powershell
(Get-Process node -ErrorAction SilentlyContinue | Measure-Object).Count
```

**3. Memoria usada:**
```powershell
Get-Process node | Measure-Object -Property WS -Sum | Select-Object @{N='TotalMB';E={[math]::Round($_.Sum/1MB,1)}}
```

**4. Lock file:**
```powershell
Get-Content .node-lock -ErrorAction SilentlyContinue | ConvertFrom-Json
```

---

## ?? Objetivo del Sistema

**Antes:** M�ltiples procesos Node.js consumiendo recursos innecesarios
**Despu�s:** Solo 1 proceso controlado y monitoreado

**Ahorro t�pico:** 
- Memoria: ~680 MB
- Procesos: 3 menos
- Control: 100%

---

**�ltima actualizaci�n:** 2024-01-15  
**Versi�n:** 2.0.0 (Sistema de Proceso �nico)  
**Mantenedor:** SVYD LEDGER Team
