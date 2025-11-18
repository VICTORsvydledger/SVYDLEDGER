# ?? Arquitectura de Puertos - SVYD LEDGER

## ?? **RESUMEN EJECUTIVO**

Este documento define y documenta **definitivamente** todos los puertos utilizados en el proyecto SVYD LEDGER para eliminar confusiones.

---

## ?? **PUERTOS UNIFICADOS Y DEFINITIVOS**

### **? FRONTEND - DESARROLLO LOCAL**

```
Puerto: 5173
Protocolo: HTTP
Servicio: Vite Dev Server
URL: http://localhost:5173
```

**Configurado en:**
- `frontend/vite.config.ts`
- `frontend/package.json` (script `dev`)
- Todos los scripts PowerShell

**Este es el ÚNICO puerto que usarás para desarrollo local del frontend.**

---

### **? BACKEND SERVICES - DESARROLLO LOCAL**

Los servicios backend usan puertos diferentes para no colisionar:

| Servicio | Puerto | URL | Archivo |
|----------|--------|-----|---------|
| **Identity Service** | 8001 | http://localhost:8001 | `backend/identity-service/main.py` |
| **Language Service** | 8002 | http://localhost:8002 | `backend/language-service/main.py` |
| **Country Service** | 8003 | http://localhost:8003 | `backend/country-service/main.py` |
| **Accounting Service** | 3000 | http://localhost:3000 | `backend/accounting-service/src/index.ts` |
| **Reports Service** | 3000 | http://localhost:3000 | `backend/reports-service/src/index.ts` |
| **Payments Service** | 3000 | http://localhost:3000 | `backend/payments-service/src/index.ts` |

**Nota:** Los servicios Node.js usan puerto 3000 porque se ejecutan en **contenedores Docker separados**, no en tu máquina local directamente.

---

### **? PRODUCCIÓN - AZURE**

```
Frontend (Static Web App):
  Puerto: 443 (HTTPS)
  URL: https://www.svydledger.com

Backend (AKS + API Management):
  Puerto: 443 (HTTPS)
  URL: https://api.svydledger.com
```

**Configurado en:**
- `infrastructure/terraform/` (infraestructura Azure)
- `docs/AZURE-DNS-SETUP.md` (configuración DNS)

---

## ?? **¿POR QUÉ DIFERENTES PUERTOS?**

### **Frontend: Puerto 5173**
- ? Puerto estándar de Vite (herramienta de build)
- ? Usado solo en desarrollo local
- ? No colisiona con nada

### **Backend Services: Puertos 3000, 8001-8003**
- ? Python services: 8001-8003 (desarrollo local directo)
- ? Node.js services: 3000 (dentro de Docker, aislados)
- ? En producción: Todo detrás de HTTPS/443

### **Producción: Puerto 443**
- ? HTTPS estándar
- ? Certificado SSL/TLS automático
- ? Azure gestiona todo

---

## ?? **CÓMO FUNCIONA EN CADA ENTORNO**

### **Desarrollo Local (TÚ)**

```
Tu navegador:
  http://localhost:5173 (Frontend)
  ?
Vite Dev Server:
  Puerto 5173
  ?
Proxy a Backend:
  https://api.svydledger.com/api/*
  (configurado en vite.config.ts)
```

**Comando:**
```powershell
.\start-single-process.ps1
```

---

### **Docker Local (Testing)**

```
Docker Compose:
  Frontend: localhost:5173
  Backend Services: localhost:3000 (cada uno en su contenedor)
  
docker-compose up
  ?
Todos los servicios arrancan
  ?
Nginx (dentro de Docker): Puerto 80 ? Frontend
Backend: Puertos internos (3000, 8001, 8002, 8003)
```

**Comando:**
```powershell
docker-compose up
```

---

### **Producción Azure**

```
Usuario:
  https://www.svydledger.com
  ?
Azure Static Web App (Frontend):
  Certificado SSL automático
  Puerto: 443 (HTTPS)
  ?
Azure API Management:
  https://api.svydledger.com
  Puerto: 443 (HTTPS)
  ?
AKS (Backend Services):
  Puertos internos (no expuestos)
```

---

## ?? **MATRIZ DE PUERTOS**

| Entorno | Frontend | Backend | Protocolo | SSL |
|---------|----------|---------|-----------|-----|
| **Desarrollo Local** | 5173 | N/A* | HTTP | ? |
| **Docker Local** | 5173 | 3000† | HTTP | ? |
| **Producción Azure** | 443 | 443 | HTTPS | ? |

**Notas:**
- \* Backend en producción (Azure), no local
- † Puerto interno de Docker, no accesible directamente

---

## ?? **PUERTOS QUE NO SE USAN (PARA EVITAR CONFUSIÓN)**

| Puerto | Estado | Razón |
|--------|--------|-------|
| 3000 | ?? Solo en Docker | No se usa en desarrollo local del frontend |
| 80 | ? No usado | Desarrollo usa 5173, producción usa 443 |
| 8080 | ? No usado | No es necesario |
| 4200 | ? No usado | Ese es Angular, no Vite |

---

## ?? **CONFIGURACIÓN DE ARCHIVOS**

### **frontend/vite.config.ts** ?

```typescript
export default defineConfig({
  server: {
    port: 5173,  // ? Puerto de desarrollo
    proxy: {
      '/api': {
        target: 'https://api.svydledger.com',
        changeOrigin: true,
        secure: true,
      },
    },
  },
})
```

**? Correcto y no tocar**

---

### **backend/\*/main.py** ?

```python
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8001)  # ? Puerto específico
```

**? Correcto y no tocar**

---

### **docker-compose.yml** ?

```yaml
services:
  frontend:
    ports:
      - "5173:80"  # ? Host:Container
  
  backend:
    ports:
      - "3000:3000"  # ? Interno de Docker
```

**? Correcto y no tocar**

---

## ?? **REGLAS DE ORO**

### **1. Desarrollo Local del Frontend**
```powershell
# SIEMPRE usa esto:
.\start-single-process.ps1

# Abre en navegador:
http://localhost:5173

# ? Puerto: 5173
```

### **2. Backend Services**
```powershell
# En producción (Azure):
https://api.svydledger.com

# En desarrollo local (Docker):
docker-compose up
# Puertos internos: 3000, 8001-8003
```

### **3. Producción**
```
Frontend: https://www.svydledger.com (Puerto 443)
Backend: https://api.svydledger.com (Puerto 443)

? Todo HTTPS
? Certificados automáticos
? Gestionado por Azure
```

---

## ?? **VERIFICACIÓN DE PUERTOS**

### **Ver Qué Está Usando el Puerto 5173**

```powershell
Get-NetTCPConnection -LocalPort 5173 -State Listen -ErrorAction SilentlyContinue
```

**Resultado esperado:**
- Si hay servidor: Muestra el PID
- Si no hay servidor: No muestra nada

---

### **Ver Qué Está Usando el Puerto 3000**

```powershell
Get-NetTCPConnection -LocalPort 3000 -State Listen -ErrorAction SilentlyContinue
```

**Resultado esperado:**
- En desarrollo local: No debería haber nada
- En Docker: Muestra procesos de Docker

---

### **Ver Todos los Puertos Node.js**

```powershell
Get-Process node -ErrorAction SilentlyContinue | 
  Select-Object Id, ProcessName, @{N='Port';E={
    (Get-NetTCPConnection -OwningProcess $_.Id -ErrorAction SilentlyContinue | 
     Where-Object {$_.State -eq 'Listen'}).LocalPort
  }}
```

---

## ?? **TROUBLESHOOTING COMÚN**

### **Problema: "Puerto 5173 ocupado"**

**Solución:**
```powershell
# Matar proceso en puerto 5173
$proc = Get-NetTCPConnection -LocalPort 5173 -ErrorAction SilentlyContinue
if ($proc) {
    Stop-Process -Id $proc.OwningProcess -Force
}

# Reiniciar
.\start-single-process.ps1
```

---

### **Problema: "No puedo acceder a http://localhost:3000"**

**Causa:** El puerto 3000 es interno de Docker o backend, no es para acceso directo.

**Solución:**
```
En desarrollo local del frontend:
  ? Usa: http://localhost:5173

En producción:
  ? Usa: https://www.svydledger.com
```

---

### **Problema: "Veo referencias al puerto 3000 en el código"**

**Es normal:** El puerto 3000 es para:
1. Backend services (dentro de Docker)
2. Dockerfiles (definición de contenedores)
3. No afecta tu desarrollo del frontend

**No cambiar nada** en esos archivos.

---

## ?? **DOCUMENTACIÓN RELACIONADA**

| Archivo | Descripción |
|---------|-------------|
| `frontend/vite.config.ts` | Configuración del puerto 5173 |
| `docker-compose.yml` | Puertos de Docker |
| `docs/AZURE-DNS-SETUP.md` | Configuración de producción |
| `ARQUITECTURA-PUERTOS.md` | Este documento |

---

## ? **CHECKLIST DE VERIFICACIÓN**

Antes de reportar problemas de puertos, verifica:

- [ ] ¿Estás usando `.\start-single-process.ps1`?
- [ ] ¿Abres http://localhost:**5173** (no 3000)?
- [ ] ¿Solo hay 1 proceso Node.js corriendo?
- [ ] ¿El puerto 5173 está libre?
- [ ] ¿Reiniciaste VS Code después de cambios?

---

## ?? **CONCLUSIÓN**

### **Para Desarrollo Local (TÚ):**

```
Puerto: 5173
Comando: .\start-single-process.ps1
URL: http://localhost:5173
```

**¡Eso es TODO lo que necesitas saber!** ??

El puerto 3000 y otros son internos y no te afectan.

---

**Estado:** ? Arquitectura de puertos documentada y unificada  
**Última actualización:** 2024-01-15  
**Puerto de desarrollo:** 5173 (DEFINITIVO)
