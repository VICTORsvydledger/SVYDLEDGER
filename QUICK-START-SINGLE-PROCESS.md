# ?? GU�A R�PIDA - Soluci�n Proceso �nico Node.js

## ? USO DIARIO (Recomendado)

### Opci�n 1: Inicio Directo
```powershell
.\start-single-process.ps1
```

### Opci�n 2: Men� Interactivo
```powershell
.\dev-manager.ps1
```
Selecciona: **Opci�n 1** (Single Process Mode)

---

## ??? PREVENCI�N AUTOM�TICA (Opcional)

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
| **Proceso �nico** ? | `.\start-single-process.ps1` | Inicio diario |
| **Monitor** | `.\monitor-node-processes.ps1` | Prevenci�n |
| **Dev Manager** | `.\dev-manager.ps1` | Men� completo |
| **Limpieza** | `.\kill-node-processes.ps1` | Matar procesos |
| **Safe Start** | `.\start-frontend.ps1` | Alternativa |

---

## ?? SOLUCI�N DE EMERGENCIA

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

## ? VERIFICACI�N

### Comando R�pido
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

## ?? DOCUMENTACI�N COMPLETA

| Archivo | Descripci�n |
|---------|-------------|
| `SOLUCI�N-PROCESOS-NODE.md` | Gu�a completa del problema |
| `docs\TROUBLESHOOTING.md` | Todos los problemas comunes |
| `WELCOMEPAGE-README.md` | README principal del proyecto |

---

## ?? CARACTER�STICAS DEL SISTEMA

### start-single-process.ps1
- ? Detecta servidores corriendo
- ? Archivo de bloqueo (.node-lock)
- ? Mata procesos autom�ticamente
- ? Auto-limpieza al salir
- ? Solo 1 proceso garantizado

### monitor-node-processes.ps1
- ?? Monitoreo cada 30 segundos
- ?? Alertas de m�ltiples procesos
- ?? Auto-kill opcional (-AutoKill)
- ?? Estad�sticas de memoria

### dev-manager.ps1
- ?? Men� interactivo
- ? Proceso �nico (Opci�n 1)
- ?? Safe mode (Opci�n 2)
- ??? Limpieza (Opci�n 3)
- ?? Status (Opci�n 5)

---

## ?? FLUJOS DE TRABAJO

### Trabajo Normal
```powershell
.\start-single-process.ps1
```

### Con Protecci�n Extra
```powershell
# Terminal 1:
.\monitor-node-processes.ps1 -AutoKill

# Terminal 2:
.\start-single-process.ps1
```

### Gesti�n Completa
```powershell
.\dev-manager.ps1
# Usar men� seg�n necesidad
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
?     (Auto-limpieza autom�tica)      ?
???????????????????????????????????????
               ?
               ?
???????????????????????????????????????
?  4. Reiniciar cuando necesites:     ?
?     .\start-single-process.ps1      ?
???????????????????????????????????????
```

---

## ? FAQ R�PIDO

**Q: �Qu� hace el archivo .node-lock?**  
A: Guarda info del proceso activo para evitar duplicados.

**Q: �Se elimina autom�ticamente?**  
A: S�, al presionar Ctrl+C se limpia solo.

**Q: �Qu� pasa si crashea?**  
A: El script detecta el lock hu�rfano y lo limpia.

**Q: �Puedo usar npm run dev normal?**  
A: S�, pero no tendr�s protecci�n contra duplicados.

**Q: �El monitor consume recursos?**  
A: M�nimo: revisa cada 30 segundos (configurable).

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

### Despu�s
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
**�ltima actualizaci�n:** 2024-01-15  
**Versi�n:** 2.0.0 (con proceso �nico)
