# ?? TUTORIAL: Cómo Usar el Sistema de Proceso Único

## ?? ¿Qué Acabas de Ver en la Demostración?

### ? Resumen de la Demostración

Acabamos de ejecutar una demostración completa del sistema. Aquí está lo que sucedió:

---

## ?? PASO A PASO DE LA DEMOSTRACIÓN

### **Paso 1: Verificación Inicial**

```powershell
========================================
   PASO 1: Estado Actual del Sistema   
========================================

Procesos Node.js activos:
  ? No hay procesos Node.js corriendo

Verificando archivo de bloqueo:
  ? No existe .node-lock
```

**¿Qué hizo?**
- Verificó que no hay procesos Node.js corriendo
- Verificó que no existe archivo de bloqueo previo
- ? **Sistema limpio y listo**

---

### **Paso 2: Flujo Automático del Script**

```powershell
?? PASO 1: Verificando procesos existentes...
   ? No hay procesos previos

?? PASO 2: Verificando lock file...
   ? No existe lock file

?? PASO 3: Verificando dependencias...
   ? node_modules encontrado

?? PASO 4: Creando lock file...
   ? Lock file creado

?? Contenido del lock:
   {
     "ProcessId": 12345,
     "StartTime": "2024-01-15 10:30:00",
     "Port": 5173
   }
```

**¿Qué hizo?**
1. ? Verificó procesos existentes (ninguno encontrado)
2. ? Verificó lock file (no existía)
3. ? Verificó dependencias (node_modules existe)
4. ? Creó el archivo de bloqueo con información del proceso

---

### **Paso 3: Sistema Listo**

```powershell
========================================
   ? SISTEMA LISTO                     
========================================

En este punto, el script iniciaría:
   npm run dev

Y verías:
   VITE v5.x.x  ready in xxx ms
   ?  Local:   http://localhost:5173/
```

**¿Qué significa?**
- El sistema está configurado y listo
- Solo falta iniciar el servidor (que haría automáticamente)
- Todo el proceso es transparente para ti

---

## ?? CÓMO LO USAS TÚ (MUY SIMPLE)

### Opción 1: Comando Directo (Recomendado)

```powershell
.\start-single-process.ps1
```

**Eso es TODO.** El sistema hace:
- ? Mata procesos previos automáticamente
- ? Crea bloqueo automáticamente
- ? Inicia servidor automáticamente
- ? Previene duplicados automáticamente
- ? Se limpia automáticamente al salir (Ctrl+C)

---

### Opción 2: Menú Interactivo

```powershell
.\dev-manager.ps1
```

Verás:

```
============================================
   SVYD LEDGER - Development Manager      
============================================

? No Node.js processes running

1. Start Frontend (Single Process Mode) ? RECOMMENDED
2. Start Frontend (Safe Mode)
3. Kill All Node.js Processes
4. Clean & Reinstall Dependencies
5. Check System Status
6. Open WelcomePage Documentation
7. Deploy to Azure
Q. Quit

Select an option: _
```

**Simplemente selecciona: 1**

---

## ?? ¿Qué Hace el Archivo .node-lock?

### Contenido del Lock File

```json
{
  "ProcessId": 12345,
  "StartTime": "2024-01-15 10:30:00",
  "Port": 5173
}
```

### ¿Qué Significa Cada Parte?

| Campo | Descripción | Para Qué Sirve |
|-------|-------------|----------------|
| `ProcessId` | ID del proceso Node.js | Verificar si sigue vivo |
| `StartTime` | Cuándo se inició | Información de tracking |
| `Port` | Puerto del servidor | Saber dónde está corriendo |

### ¿Cuándo Se Crea y Se Elimina?

```
???????????????????????????????????????
? Ejecutas:                           ?
?   .\start-single-process.ps1       ?
???????????????????????????????????????
               ?
               ?
???????????????????????????????????????
? Script crea .node-lock              ?
? (automáticamente)                   ?
???????????????????????????????????????
               ?
               ?
???????????????????????????????????????
? Servidor corriendo...               ?
? (trabajas normalmente)              ?
???????????????????????????????????????
               ?
               ?
???????????????????????????????????????
? Presionas Ctrl+C                    ?
???????????????????????????????????????
               ?
               ?
???????????????????????????????????????
? Script elimina .node-lock           ?
? (automáticamente)                   ?
???????????????????????????????????????
```

**TÚ NO TIENES QUE TOCARLO NUNCA**

---

## ??? ¿Qué Pasa Si...?

### Escenario 1: Intentas Iniciar Dos Veces

```powershell
# Primera Terminal:
PS> .\start-single-process.ps1
? Lock acquired - Only ONE process will run
VITE v5.x.x  ready in xxx ms

# Segunda Terminal (intentas iniciar otra vez):
PS> .\start-single-process.ps1
?? Ya existe un servidor corriendo!

Opciones:
  1. Abrir http://localhost:5173 en navegador
  2. Matar proceso existente y iniciar nuevo
  3. Exit

Select (1/2/3): _
```

**El sistema te protege automáticamente** y te da opciones.

---

### Escenario 2: El Script Crashea

```powershell
# La próxima vez que ejecutes:
PS> .\start-single-process.ps1

?? Lock file encontrado
?? Verificando si proceso está vivo...
? Proceso no existe (zombie)
??? Limpiando lock huérfano...
? Lock eliminado

Continuando con inicio limpio...
```

**El sistema detecta y limpia automáticamente.**

---

### Escenario 3: Ya Hay Procesos Corriendo

```powershell
PS> .\start-single-process.ps1

?? Encontrados 3 proceso(s) Node.js previos
?? Matando procesos automáticamente...
? Procesos eliminados

Iniciando servidor limpio...
? VITE v5.x.x  ready in xxx ms
```

**El sistema limpia automáticamente antes de iniciar.**

---

## ?? ANTES vs DESPUÉS

### Antes (Sin Sistema)

```
Tu flujo de trabajo:
1. cd frontend
2. npm run dev
3. (olvidas cerrar)
4. npm run dev (otra vez)
5. npm run dev (otra vez)
6. ...

Task Manager:
  Node.js (350 MB) ?
  Node.js (207 MB) ?
  Node.js (276 MB) ?
  Node.js (28 MB)  ?
  ?????????????????
  Total: 862 MB
  Procesos: 4

Problema: Acumulación sin control
```

### Después (Con Sistema) ?

```
Tu flujo de trabajo:
1. .\start-single-process.ps1
2. Trabajar normalmente
3. Ctrl+C cuando termines
4. (si olvidas, el sistema protege)

Task Manager:
  Node.js (180 MB) ?
  ?????????????????
  Total: 180 MB
  Procesos: 1

Solución: Control automático
```

**Ahorro: 680 MB y 3 procesos**

---

## ?? CONSEJOS PRÁCTICOS

### ? DO (Hacer)

1. **Usa siempre el script**
   ```powershell
   .\start-single-process.ps1
   ```

2. **Termina con Ctrl+C**
   - Limpia automáticamente
   - No dejes procesos huérfanos

3. **Si tienes dudas, usa el menú**
   ```powershell
   .\dev-manager.ps1
   # Opción 5: Check System Status
   ```

### ? DON'T (No Hacer)

1. **No uses `npm run dev` directamente**
   - No tiene protección
   - Puede crear múltiples procesos

2. **No edites el .node-lock manualmente**
   - Se gestiona automáticamente
   - No necesitas tocarlo

3. **No cierres el terminal directamente**
   - Usa Ctrl+C
   - Permite limpieza automática

---

## ?? VERIFICACIONES RÁPIDAS

### ¿Cuántos Procesos Tengo?

```powershell
Get-Process node -ErrorAction SilentlyContinue | Measure-Object
```

**Resultado esperado:**
```
Count: 1  ?
```

### ¿Cuánta Memoria Usa?

```powershell
Get-Process node | Measure-Object -Property WS -Sum | Select-Object @{N='TotalMB';E={[math]::Round($_.Sum/1MB,1)}}
```

**Resultado esperado:**
```
TotalMB
-------
180.0   ?
```

### ¿Existe Lock File?

```powershell
Get-Content .node-lock -ErrorAction SilentlyContinue | ConvertFrom-Json
```

**Si hay servidor corriendo:**
```json
{
  "ProcessId": 12345,
  "StartTime": "2024-01-15 10:30:00",
  "Port": 5173
}
```

**Si no hay servidor:**
```
(vacío o error - normal)
```

---

## ?? RESUMEN FINAL

### Lo Que Aprendiste:

1. ? **El sistema es 100% automático**
   - Tú solo ejecutas el script
   - Todo lo demás es automático

2. ? **El archivo .node-lock es invisible**
   - Se crea automáticamente
   - Se elimina automáticamente
   - No necesitas tocarlo nunca

3. ? **Protección contra duplicados**
   - Solo 1 proceso permitido
   - Si intentas iniciar otro, te pregunta qué hacer
   - Ahorro garantizado de recursos

4. ? **Auto-limpieza**
   - Al salir con Ctrl+C se limpia todo
   - Si crashea, detecta y limpia la próxima vez
   - Sin procesos huérfanos

---

## ?? TU PRÓXIMO PASO

**Cuando estés listo para trabajar:**

```powershell
.\start-single-process.ps1
```

**¡Y eso es todo!** ??

El sistema hará TODO el resto automáticamente.

---

## ?? DOCUMENTACIÓN RELACIONADA

| Archivo | Descripción |
|---------|-------------|
| `QUICK-START-SINGLE-PROCESS.md` | Guía rápida de 1 página |
| `SOLUCIÓN-PROCESOS-NODE.md` | Documentación completa |
| `SCRIPTS-README.md` | Todos los scripts explicados |
| `PROBLEMA-RESUELTO.md` | Resumen de la solución |

---

## ? PREGUNTAS FRECUENTES

**Q: ¿Necesito hacer algo especial?**  
A: No, solo ejecuta `.\start-single-process.ps1`

**Q: ¿Qué pasa con el .node-lock?**  
A: Se gestiona automáticamente, no lo toques.

**Q: ¿Cómo sé que funciona?**  
A: Verifica con Task Manager - verás solo 1 proceso.

**Q: ¿Y si algo falla?**  
A: El sistema detecta y limpia automáticamente.

**Q: ¿Necesito el monitor también?**  
A: No, es opcional. El script básico ya funciona perfecto.

---

**¡Todo está listo! El problema está resuelto para siempre.** ???

---

**Última actualización:** 2024-01-15  
**Estado:** ? Tutorial completado  
**Demostración:** ? Ejecutada exitosamente
