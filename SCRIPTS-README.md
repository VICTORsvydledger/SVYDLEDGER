# ?? Scripts de Gestión - SVYD LEDGER

## ?? Scripts Disponibles

### ? Recomendados (Usar Siempre)

#### 1. start-single-process.ps1
**Propósito:** Inicio con garantía de proceso único

```powershell
.\start-single-process.ps1
```

**Características:**
- ? Sistema de bloqueo (.node-lock)
- ? Mata procesos anteriores automáticamente
- ? Solo permite 1 proceso activo
- ? Auto-limpieza al salir (Ctrl+C)
- ? Detecta y limpia procesos zombies

**Cuándo usar:**
- Al empezar el día
- Cada vez que quieras iniciar el frontend
- Como reemplazo de `npm run dev`

---

#### 2. dev-manager.ps1
**Propósito:** Menú interactivo para gestión completa

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

**Cuándo usar:**
- Cuando necesitas varias opciones
- Para verificar el estado del sistema
- Para limpiar dependencias
- Para gestión completa

---

### ?? Herramientas de Monitoreo

#### 3. monitor-node-processes.ps1
**Propósito:** Monitoreo y prevención automática

```powershell
# Solo alertas
.\monitor-node-processes.ps1

# Con auto-kill (mantiene solo 1 proceso)
.\monitor-node-processes.ps1 -AutoKill

# Intervalo personalizado (segundos)
.\monitor-node-processes.ps1 -IntervalSeconds 60 -AutoKill
```

**Características:**
- ?? Revisa cada N segundos (default: 30)
- ?? Alerta cuando detecta múltiples procesos
- ?? Modo auto-kill: elimina procesos extras
- ?? Muestra uso de memoria en tiempo real

**Cuándo usar:**
- En una terminal separada
- Para sesiones de desarrollo largas
- Como protección extra
- Si el problema persiste

---

### ?? Herramientas de Limpieza

#### 4. kill-node-processes.ps1
**Propósito:** Matar todos los procesos Node.js

```powershell
.\kill-node-processes.ps1
```

**Características:**
- Usa 3 métodos diferentes
- Verifica que todo se detuvo
- Muestra estadísticas

**Cuándo usar:**
- Cuando hay múltiples procesos corriendo
- Antes de un reinicio limpio
- Si algo no funciona
- Emergencias

---

#### 5. start-frontend.ps1
**Propósito:** Inicio seguro tradicional

```powershell
.\start-frontend.ps1
```

**Características:**
- Mata procesos antes de iniciar
- Verifica dependencias
- Limpia caché de Vite
- Muestra información útil

**Cuándo usar:**
- Como alternativa a start-single-process.ps1
- Si el sistema de bloqueo da problemas
- Para pruebas

---

### ?? Despliegue

#### 6. deploy-to-azure.ps1
**Propósito:** Desplegar a Azure

```powershell
.\deploy-to-azure.ps1
```

**Cuándo usar:**
- Para desplegar a producción
- Después de probar localmente
- Cuando todo esté listo

---

#### 7. setup-welcomepage.ps1
**Propósito:** Configuración inicial del WelcomePage

```powershell
.\setup-welcomepage.ps1
```

**Cuándo usar:**
- Primera instalación
- Después de clonar el repo
- Para verificar instalación

---

## ?? Flujos de Trabajo Recomendados

### ?? Trabajo Diario Normal

```powershell
# Al empezar:
.\start-single-process.ps1

# Desarrollar...

# Al terminar: Ctrl+C
```

**Resultado:** 1 proceso limpio, sin acumulación

---

### ??? Trabajo con Protección Máxima

```powershell
# Terminal 1 (Monitor):
.\monitor-node-processes.ps1 -AutoKill

# Terminal 2 (Desarrollo):
.\start-single-process.ps1

# El monitor mantiene solo 1 proceso automáticamente
```

**Resultado:** Protección continua contra múltiples procesos

---

### ?? Trabajo con Gestión Completa

```powershell
# Ejecutar:
.\dev-manager.ps1

# Usar menú interactivo según necesidad
```

**Resultado:** Control total desde un solo lugar

---

### ?? Limpieza Profunda

```powershell
# 1. Matar procesos
.\kill-node-processes.ps1

# 2. Abrir dev-manager
.\dev-manager.ps1

# 3. Seleccionar: Opción 3 (Clean & Reinstall)

# 4. Iniciar limpio
.\start-single-process.ps1
```

**Resultado:** Sistema completamente limpio

---

## ?? Parámetros Disponibles

### monitor-node-processes.ps1

| Parámetro | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `-IntervalSeconds` | int | 30 | Segundos entre revisiones |
| `-AutoKill` | switch | false | Eliminar procesos extras automáticamente |

**Ejemplos:**
```powershell
# Revisión cada minuto
.\monitor-node-processes.ps1 -IntervalSeconds 60

# Auto-kill cada 15 segundos
.\monitor-node-processes.ps1 -IntervalSeconds 15 -AutoKill

# Solo con auto-kill (30 segundos)
.\monitor-node-processes.ps1 -AutoKill
```

---

## ?? Comparación de Scripts

| Script | Proceso Único | Auto-Limpieza | Monitoreo | Menú | Recomendado |
|--------|---------------|---------------|-----------|------|-------------|
| `start-single-process.ps1` | ?? | ?? | ? | ? | ??? |
| `monitor-node-processes.ps1` | ? (con -AutoKill) | ? | ?? | ? | ?? |
| `dev-manager.ps1` | ? (opción 1) | ? | ? | ?? | ??? |
| `start-frontend.ps1` | ?? | ?? | ? | ? | ? |
| `kill-node-processes.ps1` | ? | ?? | ? | ? | ? |

---

## ?? Solución de Problemas

### Problema: "Script no se ejecuta"

**Solución:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Problema: "Lock file existe pero no hay proceso"

**Solución:**
```powershell
Remove-Item .node-lock -Force
.\start-single-process.ps1
```

### Problema: "Múltiples procesos siguen apareciendo"

**Solución:**
```powershell
# Terminal 1:
.\monitor-node-processes.ps1 -AutoKill

# Terminal 2:
.\start-single-process.ps1
```

### Problema: "Todo falla"

**Solución:**
```powershell
# Limpieza extrema:
Get-Process node | Stop-Process -Force
Remove-Item .node-lock -Force -ErrorAction SilentlyContinue
.\dev-manager.ps1
# Opción 3: Clean & Reinstall
# Opción 1: Start Frontend
```

---

## ?? Archivos Generados

### .node-lock
**Ubicación:** Raíz del proyecto
**Propósito:** Bloqueo de proceso único
**Contenido:**
```json
{
  "ProcessId": 12345,
  "StartTime": "2024-01-15 10:30:00",
  "Port": 5173
}
```

**Gestión:**
- ? Creado automáticamente por `start-single-process.ps1`
- ? Eliminado automáticamente al salir (Ctrl+C)
- ? Verificado antes de iniciar nuevo proceso
- ?? No versionar (agregado a .gitignore)

---

## ?? Documentación Relacionada

| Archivo | Descripción |
|---------|-------------|
| `SOLUCIÓN-PROCESOS-NODE.md` | Guía completa del problema y solución |
| `QUICK-START-SINGLE-PROCESS.md` | Guía rápida de uso diario |
| `PROBLEMA-RESUELTO.md` | Resumen de la solución implementada |
| `docs\TROUBLESHOOTING.md` | Solución de todos los problemas |
| `WELCOMEPAGE-README.md` | README principal del proyecto |

---

## ?? Tips y Mejores Prácticas

### ? DO (Hacer)

1. **Usar siempre `start-single-process.ps1`**
   ```powershell
   .\start-single-process.ps1
   ```

2. **Terminar con Ctrl+C**
   - Limpia automáticamente
   - Elimina el lock file
   - Cierra el proceso correctamente

3. **Usar monitor en sesiones largas**
   ```powershell
   .\monitor-node-processes.ps1 -AutoKill
   ```

4. **Verificar periódicamente**
   ```powershell
   .\dev-manager.ps1
   # Opción 5: Check System Status
   ```

### ? DON'T (No Hacer)

1. **No usar `npm run dev` directamente**
   - No tiene protección
   - Puede crear múltiples procesos

2. **No cerrar el terminal directamente**
   - El lock file no se limpia
   - El proceso queda huérfano

3. **No ignorar las alertas del monitor**
   - Si detecta múltiples procesos, investiga
   - Usa `kill-node-processes.ps1`

4. **No ejecutar múltiples veces seguidas**
   - Espera a que termine el anterior
   - Verifica con Task Manager

---

## ?? Cómo Funciona

### Sistema de Bloqueo

```
Usuario ejecuta: .\start-single-process.ps1
         ?
         ?
    ¿Existe .node-lock?
         ?
    ???????????
   NO         SÍ
    ?          ?
    ?     ¿Proceso vivo?
    ?          ?
    ?     ???????????
    ?    SÍ        NO
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

### Monitor Automático

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
    ?    ¿AutoKill?
    ?         ?
    ?    ???????????
    ?   SÍ        NO
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

### Verificaciones Rápidas

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

**Antes:** Múltiples procesos Node.js consumiendo recursos innecesarios
**Después:** Solo 1 proceso controlado y monitoreado

**Ahorro típico:** 
- Memoria: ~680 MB
- Procesos: 3 menos
- Control: 100%

---

**Última actualización:** 2024-01-15  
**Versión:** 2.0.0 (Sistema de Proceso Único)  
**Mantenedor:** SVYD LEDGER Team
