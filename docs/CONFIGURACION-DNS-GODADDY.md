# ?? Configuración DNS en GoDaddy para svydledger.com

## ?? Información General

Tu dominio `svydledger.com` necesita apuntar a los servidores DNS de Azure para que el dominio personalizado funcione correctamente con Azure Static Web Apps.

---

## ? PASO 5: CONFIGURAR DNS EN GODADDY

### ?? Objetivo
Configurar los nameservers de GoDaddy para que apunten a Azure DNS.

### ?? Nameservers de Azure DNS

Debes configurar los siguientes nameservers en GoDaddy:

```
ns1-07.azure-dns.com
ns2-07.azure-dns.net
ns3-07.azure-dns.org
ns4-07.azure-dns.info
```

---

## ?? Instrucciones Paso a Paso

### 1?? Acceder a GoDaddy

1. Ve a [https://www.godaddy.com](https://www.godaddy.com)
2. Inicia sesión con tu cuenta
3. Ve a **My Products** (Mis Productos)
4. Encuentra tu dominio `svydledger.com`

### 2?? Cambiar los Nameservers

1. Junto al dominio `svydledger.com`, haz clic en el botón **DNS** o **Manage DNS**
2. Desplázate hacia abajo hasta la sección **Nameservers**
3. Haz clic en **Change** o **Cambiar**
4. Selecciona la opción **Custom** o **Personalizado**
5. Elimina los nameservers existentes
6. Agrega los 4 nameservers de Azure uno por uno:
   - `ns1-07.azure-dns.com`
   - `ns2-07.azure-dns.net`
   - `ns3-07.azure-dns.org`
   - `ns4-07.azure-dns.info`
7. Haz clic en **Save** o **Guardar**

### 3?? Confirmación

GoDaddy mostrará un mensaje indicando que los cambios pueden tardar hasta 48 horas en propagarse, aunque generalmente es mucho más rápido (1-4 horas).

---

## ?? Tiempo de Propagación

- **Mínimo**: 1-2 horas
- **Típico**: 4-8 horas
- **Máximo**: 48 horas

---

## ?? Verificar la Configuración

### Verificar Nameservers

Después de configurar GoDaddy, puedes verificar que los nameservers estén configurados correctamente usando:

```powershell
nslookup -type=NS svydledger.com
```

Deberías ver los 4 nameservers de Azure en la respuesta.

### Verificar CNAME

Una vez que los nameservers estén propagados, verifica el registro CNAME:

```powershell
nslookup www.svydledger.com
```

Debería responder con: `calm-cliff-0f4ed1210.3.azurestaticapps.net`

---

## ?? URLs de tu Aplicación

### URL Temporal (Disponible Inmediatamente)
```
https://calm-cliff-0f4ed1210.3.azurestaticapps.net
```

### URL Personalizada (Disponible después de la propagación DNS)
```
https://www.svydledger.com
```

---

## ?? Estado Actual del Despliegue

### ? Completado

- [x] **PASO 1**: Azure Static Web App creada
  - **Nombre**: `svydledger-frontend`
  - **Grupo de recursos**: `svydledger-data`
  - **Ubicación**: `Central US`
  - **SKU**: `Free`

- [x] **PASO 2**: Token de despliegue obtenido
  - Token configurado y funcionando

- [x] **PASO 3**: GitHub Secret configurado
  - Secret: `AZURE_STATIC_WEB_APPS_API_TOKEN`
  - Repositorio: `VICTORsvydledger/SVYDLEDGER`

- [x] **PASO 4**: Dominio personalizado configurado en Azure
  - Registro CNAME creado en Azure DNS
  - `www.svydledger.com` ? `calm-cliff-0f4ed1210.3.azurestaticapps.net`

### ? Pendiente

- [ ] **PASO 5**: Configurar nameservers en GoDaddy
  - **Acción requerida**: Cambiar nameservers manualmente en GoDaddy
  - **Instrucciones**: Ver sección anterior

---

## ?? CI/CD Pipeline

El pipeline de GitHub Actions está configurado y funcional:

- **Workflow**: `.github/workflows/swa-frontend.yml`
- **Trigger**: Push a `main` en la carpeta `frontend/`
- **Despliegue automático**: ? Activo

### Último Despliegue

```
Estado: En progreso
Commit: Fix TypeScript error in ReportsPage - Remove unused import
URL: https://github.com/VICTORsvydledger/SVYDLEDGER/actions/runs/19554215335
```

---

## ?? Certificado SSL/TLS

Azure Static Web Apps proporciona automáticamente:

- ? Certificado SSL/TLS gratuito
- ? Renovación automática
- ? HTTPS forzado

El certificado se generará automáticamente una vez que:
1. Los nameservers de GoDaddy apunten a Azure DNS
2. El registro CNAME se haya propagado completamente
3. Azure Static Web Apps valide el dominio

---

## ?? Soporte

Si necesitas ayuda:

1. **Verificar estado del despliegue**:
   ```powershell
   gh run list --workflow="swa-frontend.yml" --limit 5
   ```

2. **Ver logs del último despliegue**:
   ```powershell
   gh run view --log
   ```

3. **Verificar recursos en Azure**:
   ```powershell
   az staticwebapp show --name svydledger-frontend --resource-group svydledger-data
   ```

---

## ?? Próximos Pasos

1. **Cambiar nameservers en GoDaddy** (PASO 5)
2. **Esperar propagación DNS** (1-4 horas)
3. **Verificar dominio personalizado**:
   ```powershell
   nslookup www.svydledger.com
   ```
4. **Agregar el dominio a Azure Static Web App**:
   ```powershell
   az staticwebapp hostname set --name svydledger-frontend --resource-group svydledger-data --hostname www.svydledger.com
   ```
5. **Abrir tu sitio**: https://www.svydledger.com

---

## ?? Notas Importantes

- ?? **NO ELIMINES** los registros DNS actuales en Azure DNS
- ?? El cambio de nameservers en GoDaddy es **SEGURO** - Azure DNS mantendrá todos los registros
- ? Puedes usar la URL temporal mientras esperas la propagación DNS
- ? El certificado SSL se generará automáticamente (gratis)

---

**Creado**: 2025-01-15  
**Última actualización**: 2025-01-15  
**Estado**: ? Esperando configuración en GoDaddy
