# ?? GUÍA RÁPIDA - Solución Proceso Único Node.js

## ? USO DIARIO (Recomendado)

### Opción 1: Inicio Directo
```powershell
.\start-single-process.ps1
```

### Opción 2: Menú Interactivo
```powershell
.\dev-manager.ps1
```
Selecciona: **Opción 1** (Single Process Mode)

---

## ??? PREVENCIÓN AUTOMÁTICA (Opcional)

### Ejecutar Monitor en Segundo Plano

**Terminal 1 (Monitor):**
```powershell
.\monitor-node-processes.ps1 -AutoKill
```

**Terminal 2 (Desarrollo):**
```powershell
.\start-single-process.ps1
```

---

## ?? SCRIPTS DISPONIBLES

| Script | Comando | Uso |
|--------|---------|-----|
| **Proceso Único** ? | `.\start-single-process.ps1` | Inicio diario |
| **Monitor** | `.\monitor-node-processes.ps1` | Prevención |
| **Dev Manager** | `.\dev-manager.ps1` | Menú completo |
| **Limpieza** | `.\kill-node-processes.ps1` | Matar procesos |
| **Safe Start** | `.\start-frontend.ps1` | Alternativa |

---

## ?? SOLUCIÓN DE EMERGENCIA

Si todo falla:

```powershell
# 1. Matar TODO
taskkill /F /IM node.exe /T
Start-Sleep -Seconds 3

# 2. Limpiar lock
Remove-Item .node-lock -Force -ErrorAction SilentlyContinue

# 3. Verificar
Get-Process node -ErrorAction SilentlyContinue
# Debe mostrar: nada o error

# 4. Reiniciar
.\start-single-process.ps1
```

---

## ? VERIFICACIÓN

### Comando Rápido
```powershell
Get-Process node | Measure-Object
```

**Resultado esperado:**
```
Count: 1
```

### En Task Manager
- ? Solo 1 proceso Node.js
- ? ~150-200 MB de memoria

---

## ?? DOCUMENTACIÓN COMPLETA

| Archivo | Descripción |
|---------|-------------|
| `SOLUCIÓN-PROCESOS-NODE.md` | Guía completa del problema |
| `docs\TROUBLESHOOTING.md` | Todos los problemas comunes |
| `WELCOMEPAGE-README.md` | README principal del proyecto |

---

## ?? CARACTERÍSTICAS DEL SISTEMA

### start-single-process.ps1
- ? Detecta servidores corriendo
- ? Archivo de bloqueo (.node-lock)
- ? Mata procesos automáticamente
- ? Auto-limpieza al salir
- ? Solo 1 proceso garantizado

### monitor-node-processes.ps1
- ?? Monitoreo cada 30 segundos
- ?? Alertas de múltiples procesos
- ?? Auto-kill opcional (-AutoKill)
- ?? Estadísticas de memoria

### dev-manager.ps1
- ?? Menú interactivo
- ? Proceso único (Opción 1)
- ?? Safe mode (Opción 2)
- ??? Limpieza (Opción 3)
- ?? Status (Opción 5)

---

## ?? FLUJOS DE TRABAJO

### Trabajo Normal
```powershell
.\start-single-process.ps1
```

### Con Protección Extra
```powershell
# Terminal 1:
.\monitor-node-processes.ps1 -AutoKill

# Terminal 2:
.\start-single-process.ps1
```

### Gestión Completa
```powershell
.\dev-manager.ps1
# Usar menú según necesidad
```

---

## ?? CICLO DE DESARROLLO

```
???????????????????????????????????????
?  1. Ejecutar:                       ?
?     .\start-single-process.ps1      ?
???????????????????????????????????????
               ?
               ?
???????????????????????????????????????
?  2. Desarrollar en:                 ?
?     http://localhost:5173           ?
???????????????????????????????????????
               ?
               ?
???????????????????????????????????????
?  3. Terminar con Ctrl+C             ?
?     (Auto-limpieza automática)      ?
???????????????????????????????????????
               ?
               ?
???????????????????????????????????????
?  4. Reiniciar cuando necesites:     ?
?     .\start-single-process.ps1      ?
???????????????????????????????????????
```

---

## ? FAQ RÁPIDO

**Q: ¿Qué hace el archivo .node-lock?**  
A: Guarda info del proceso activo para evitar duplicados.

**Q: ¿Se elimina automáticamente?**  
A: Sí, al presionar Ctrl+C se limpia solo.

**Q: ¿Qué pasa si crashea?**  
A: El script detecta el lock huérfano y lo limpia.

**Q: ¿Puedo usar npm run dev normal?**  
A: Sí, pero no tendrás protección contra duplicados.

**Q: ¿El monitor consume recursos?**  
A: Mínimo: revisa cada 30 segundos (configurable).

---

## ?? RESULTADO

### Antes
```
Task Manager:
  Node.js (350 MB)
  Node.js (207 MB)
  Node.js (276 MB)
  Node.js (28 MB)
  ????????????????
  Total: ~862 MB
  Procesos: 4 ?
```

### Después
```
Task Manager:
  Node.js (180 MB)
  ????????????????
  Total: ~180 MB
  Procesos: 1 ?
```

**Ahorro: 680 MB y 3 procesos** ??

---

**Estado:** ? Sistema implementado y funcionando  
**Última actualización:** 2024-01-15  
**Versión:** 2.0.0 (con proceso único)
