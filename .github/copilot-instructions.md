# ?? REGLAS ESTRICTAS PARA GITHUB COPILOT AGENT

**FECHA:** 2025-01-15  
**PRIORIDAD:** CRÍTICA  
**RAZÓN:** Prevenir congelamiento del sistema

---

## ? PROHIBIDO ABSOLUTAMENTE

### 1. **NUNCA ejecutar comandos de servidor automáticamente**

**NUNCA ejecutes:**
- ? `.\start-single-process.ps1`
- ? `.\dev-manager.ps1`
- ? `npm run dev`
- ? `cd frontend; npm run dev`
- ? Cualquier comando que inicie un servidor web

**RAZÓN:** Causa congelamiento del agente y pérdida de trabajo.

---

### 2. **NUNCA usar run_command_in_terminal para:**

- ? Iniciar procesos que corren indefinidamente
- ? Ejecutar scripts PowerShell que inicien servidores
- ? Comandos que requieren interacción del usuario
- ? Procesos que no terminan automáticamente

---

### 3. **NUNCA pedir confirmación para ejecutar servidor**

Si el usuario menciona "servidor", "iniciar", "ejecutar", "WelcomePage en navegador":

**NO preguntes:**
- ? "¿Quieres que inicie el servidor?"
- ? "¿Procedo a ejecutar `start-single-process.ps1`?"
- ? "¿Inicio `npm run dev`?"

**EN SU LUGAR:**
- ? Proporciona las instrucciones manuales
- ? Muestra el comando para que el usuario lo ejecute
- ? Explica qué hacer, NO lo hagas automáticamente

---

## ? LO QUE SÍ PUEDES HACER

### Verificaciones permitidas:

? **Verificar archivos:**
```powershell
Get-ChildItem frontend/src/pages/auth
Test-Path "frontend/node_modules"
```

? **Verificar procesos (lectura):**
```powershell
Get-Process node -ErrorAction SilentlyContinue
```

? **Verificar puertos (lectura):**
```powershell
Get-NetTCPConnection -LocalPort 5173 -ErrorAction SilentlyContinue
```

? **Verificar configuración:**
```powershell
Get-Content frontend/vite.config.ts
```

? **Compilar código (NO ejecutar):**
```powershell
cd frontend; npx tsc --noEmit
```

---

## ?? RESPUESTAS CORRECTAS

### ? Respuesta INCORRECTA (causa congelamiento):

```
Voy a iniciar el servidor ahora...

[Ejecuta: .\start-single-process.ps1]
```

**RESULTADO:** Sistema congelado, usuario pierde trabajo.

---

### ? Respuesta CORRECTA:

```
Para ver tu WelcomePage, ejecuta MANUALMENTE:

1. Abre una terminal PowerShell
2. Ejecuta:
   .\start-single-process.ps1
3. Espera a ver: "Local: http://localhost:5173"
4. Abre tu navegador en: http://localhost:5173

NO voy a ejecutarlo automáticamente para prevenir congelamiento.
```

**RESULTADO:** Usuario tiene control, sin congelamiento.

---

## ?? CASOS DE USO ESPECÍFICOS

### Caso 1: Usuario dice "muestra mi WelcomePage"

**NO hagas:**
- ? Ejecutar servidor
- ? Abrir navegador
- ? Pedir confirmación para ejecutar

**SÍ haz:**
- ? Verificar que los archivos existan
- ? Verificar que no haya errores de compilación
- ? Dar instrucciones manuales claras
- ? Mencionar el puerto correcto (5173)

---

### Caso 2: Usuario dice "verifica el servidor"

**NO hagas:**
- ? Iniciar el servidor
- ? Ejecutar `npm run dev`

**SÍ haz:**
- ? Verificar si hay procesos Node.js corriendo
- ? Verificar si el puerto 5173 está en uso
- ? Verificar el archivo .node-lock
- ? Reportar el estado actual

---

### Caso 3: Usuario dice "hay un error en el servidor"

**NO hagas:**
- ? Reiniciar el servidor automáticamente
- ? Matar procesos sin permiso explícito

**SÍ haz:**
- ? Pedir que copie el error completo
- ? Analizar el error
- ? Sugerir soluciones
- ? Dar comandos para que el usuario ejecute

---

## ?? SEÑALES DE ADVERTENCIA

Si estás a punto de hacer cualquiera de esto, **DETENTE**:

1. ?? Vas a usar `run_command_in_terminal` con un script de inicio
2. ?? Vas a preguntar "¿Quieres que inicie el servidor?"
3. ?? Vas a ejecutar algo que toma más de 5 segundos
4. ?? Vas a ejecutar algo que no termina automáticamente
5. ?? Vas a abrir un navegador o aplicación externa

**SOLUCIÓN:** Proporciona instrucciones manuales en su lugar.

---

## ?? CHECKLIST ANTES DE EJECUTAR CUALQUIER COMANDO

Antes de usar `run_command_in_terminal`, pregúntate:

- [ ] ¿Este comando termina en menos de 5 segundos?
- [ ] ¿Este comando es de solo lectura (no inicia procesos)?
- [ ] ¿Este comando NO requiere interacción del usuario?
- [ ] ¿Este comando NO inicia un servidor web?
- [ ] ¿Este comando NO abre aplicaciones externas?

**Si respondiste NO a cualquiera:** NO ejecutes el comando. Da instrucciones manuales.

---

## ?? RESUMEN DE REGLAS

| Acción | Estado | Alternativa |
|--------|--------|-------------|
| Iniciar servidor | ? PROHIBIDO | Dar instrucciones manuales |
| Verificar archivos | ? PERMITIDO | Usar `Get-ChildItem`, `Test-Path` |
| Verificar procesos | ? PERMITIDO | Usar `Get-Process` (solo lectura) |
| Compilar código | ? PERMITIDO | Usar `npx tsc --noEmit` |
| Matar procesos | ?? PEDIR PERMISO | Preguntar explícitamente primero |
| Ejecutar scripts .ps1 | ? PROHIBIDO | Dar instrucciones manuales |
| Abrir navegador | ? PROHIBIDO | Dar URL para copiar |

---

## ?? FILOSOFÍA GENERAL

**PRINCIPIO:** El agente es un ASISTENTE, no un EJECUTOR.

- ? **Analiza** el código
- ? **Verifica** la estructura
- ? **Sugiere** soluciones
- ? **Documenta** cambios
- ? **Explica** cómo hacer las cosas

- ? **NO ejecuta** servidores
- ? **NO inicia** procesos largos
- ? **NO abre** aplicaciones
- ? **NO hace** cosas que congelen el sistema

---

## ?? COMANDOS SEGUROS (WHITELIST)

Estos comandos SÍ puedes ejecutar sin pedir permiso:

```powershell
# Verificación de archivos
Get-ChildItem
Test-Path
Get-Content

# Verificación de procesos (solo lectura)
Get-Process node -ErrorAction SilentlyContinue | Select-Object Id, ProcessName, WS

# Verificación de red (solo lectura)
Get-NetTCPConnection -LocalPort 5173 -ErrorAction SilentlyContinue

# Compilación (no ejecución)
npx tsc --noEmit

# Git (solo lectura)
git status
git log --oneline -5
git diff --stat

# NPM (solo lectura)
npm list --depth=0
```

---

## ?? COMANDOS PROHIBIDOS (BLACKLIST)

Estos comandos NUNCA debes ejecutar automáticamente:

```powershell
# Inicio de servidores
.\start-single-process.ps1
.\dev-manager.ps1
npm run dev
npm start

# Procesos largos
npm install
npm ci

# Destructivos (requieren permiso explícito)
Remove-Item
Stop-Process
taskkill

# Navegadores
Start-Process chrome
Start-Process firefox
```

---

## ?? DOCUMENTACIÓN RELACIONADA

- `TUTORIAL-USO-PROCESO-UNICO.md` - Cómo el USUARIO debe usar el sistema
- `SOLUCION-CONGELAMIENTO.md` - Por qué NO ejecutar automáticamente
- `ARQUITECTURA-PUERTOS.md` - Puerto único 5173
- `SOLUCION-COMPONENTES-AUTH.md` - Código salvado y funcional

---

## ?? EJEMPLO PERFECTO DE INTERACCIÓN

**Usuario:** "Muestra mi WelcomePage en el navegador"

**Respuesta del Agente:**

```
? He verificado tu WelcomePage:

Archivos:
- WelcomePage.tsx ? Existe y funciona
- WelcomePage.scss ? Estilos configurados
- SignInForm.tsx ? Componente creado
- SignUpForm.tsx ? Componente creado

Configuración:
- Puerto: 5173 ?
- Dependencias: Instaladas ?
- Sin errores de compilación ?

Para ver tu WelcomePage:

1. Abre PowerShell
2. Ejecuta:
   .\start-single-process.ps1
3. Abre en tu navegador:
   http://localhost:5173

NO voy a iniciar el servidor automáticamente para 
prevenir congelamiento del sistema.
```

**RESULTADO:** Usuario feliz, sistema funcionando, sin congelamiento. ?

---

**Última actualización:** 2025-01-15  
**Estado:** ?? CRÍTICO - Seguir estas reglas SIEMPRE  
**Razón:** Prevenir pérdida de trabajo y frustración del usuario

---

**SI ROMPES ESTAS REGLAS, EL SISTEMA SE CONGELA Y EL USUARIO PIERDE TODO SU TRABAJO.** ??
