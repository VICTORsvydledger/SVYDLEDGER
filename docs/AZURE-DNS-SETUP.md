# ?? Integración con Azure - www.svydledger.com

## ?? Resumen

Esta guía explica cómo configurar el DNS **www.svydledger.com** para que apunte a tu aplicación SVYD LEDGER en Azure.

---

## ??? Arquitectura Actual

```
Usuario
   ?
www.svydledger.com (DNS)
   ?
Azure Front Door
   ?
Frontend (React - Vite)
   ?
API Gateway (Azure API Management)
   ?
Microservicios (AKS)
```

---

## ? PASO 1: Verificar Recursos en Azure

### Verificar Resource Group

```powershell
# Listar resource groups
az group list --output table

# Verificar recursos en svydledger-data
az resource list --resource-group svydledger-data --output table
```

**Recursos Esperados:**
- ? svydledger-aks-{env} (AKS Cluster)
- ? svydledgeracr (Container Registry)
- ? svydserver (SQL Server)
- ? svydledger-kv (Key Vault)
- ? svydledger-apim (API Management)

---

## ? PASO 2: Configurar Azure Front Door

### 2.1 Crear Azure Front Door

```powershell
# Variables
$resourceGroup = "svydledger-data"
$location = "centralus"
$frontDoorName = "svydledger-fd"
$backendAddress = "svydledger-apim.azure-api.net"

# Crear Front Door
az afd profile create `
  --resource-group $resourceGroup `
  --profile-name $frontDoorName `
  --sku Standard_AzureFrontDoor

# Crear endpoint
az afd endpoint create `
  --resource-group $resourceGroup `
  --profile-name $frontDoorName `
  --endpoint-name "svydledger-endpoint" `
  --enabled-state Enabled
```

### 2.2 Configurar Backend

```powershell
# Crear origin group
az afd origin-group create `
  --resource-group $resourceGroup `
  --profile-name $frontDoorName `
  --origin-group-name "backend-origin-group" `
  --probe-request-type GET `
  --probe-protocol Https `
  --probe-interval-in-seconds 120 `
  --probe-path "/health"

# Agregar origin
az afd origin create `
  --resource-group $resourceGroup `
  --profile-name $frontDoorName `
  --origin-group-name "backend-origin-group" `
  --origin-name "api-management" `
  --host-name $backendAddress `
  --http-port 80 `
  --https-port 443 `
  --priority 1 `
  --weight 1000
```

---

## ? PASO 3: Configurar Dominio Personalizado

### 3.1 Verificar Propiedad del Dominio

```powershell
# Agregar dominio personalizado
az afd custom-domain create `
  --resource-group $resourceGroup `
  --profile-name $frontDoorName `
  --custom-domain-name "svydledger-domain" `
  --host-name "www.svydledger.com"
```

### 3.2 Obtener Registro de Validación

```powershell
# Ver información de validación
az afd custom-domain show `
  --resource-group $resourceGroup `
  --profile-name $frontDoorName `
  --custom-domain-name "svydledger-domain"
```

**Output esperado:**
```json
{
  "validationProperties": {
    "validationToken": "abc123def456...",
    "expirationDate": "2025-XX-XX"
  }
}
```

---

## ? PASO 4: Configurar DNS

### 4.1 En tu Proveedor de DNS (GoDaddy, Namecheap, etc.)

Agrega los siguientes registros:

#### Registro TXT (Validación)
```
Tipo: TXT
Nombre: _dnsauth.www
Valor: [validationToken de paso 3.2]
TTL: 3600
```

#### Registro CNAME (Producción)
```
Tipo: CNAME
Nombre: www
Valor: svydledger-endpoint-[hash].z01.azurefd.net
TTL: 3600
```

### 4.2 Verificar DNS

```powershell
# Verificar propagación DNS
nslookup www.svydledger.com

# O usar online
# https://www.whatsmydns.net/#CNAME/www.svydledger.com
```

---

## ? PASO 5: Habilitar HTTPS

### 5.1 Certificado Administrado por Azure

```powershell
# Habilitar HTTPS con certificado de Azure
az afd custom-domain update `
  --resource-group $resourceGroup `
  --profile-name $frontDoorName `
  --custom-domain-name "svydledger-domain" `
  --certificate-type ManagedCertificate `
  --minimum-tls-version TLS12
```

### 5.2 Forzar HTTPS

```powershell
# Crear regla para redirección HTTPS
az afd rule create `
  --resource-group $resourceGroup `
  --profile-name $frontDoorName `
  --rule-set-name "redirect-to-https" `
  --order 1 `
  --match-variable RequestScheme `
  --operator Equal `
  --match-values HTTP `
  --action-name "UrlRedirect" `
  --redirect-protocol Https `
  --redirect-type Moved
```

---

## ? PASO 6: Configurar Rutas

### 6.1 Crear Ruta para Frontend

```powershell
# Ruta principal
az afd route create `
  --resource-group $resourceGroup `
  --profile-name $frontDoorName `
  --endpoint-name "svydledger-endpoint" `
  --route-name "frontend-route" `
  --origin-group "backend-origin-group" `
  --supported-protocols Http Https `
  --patterns-to-match "/*" `
  --forwarding-protocol HttpsOnly `
  --https-redirect Enabled
```

---

## ? PASO 7: Desplegar Frontend

### 7.1 Build de Producción

```powershell
cd frontend

# Instalar dependencias
npm install

# Build
npm run build
```

### 7.2 Subir a Azure Storage

```powershell
# Variables
$storageAccount = "svydledgerstore"
$containerName = '$web'

# Habilitar static website
az storage blob service-properties update `
  --account-name $storageAccount `
  --static-website `
  --index-document index.html `
  --404-document index.html

# Subir archivos
az storage blob upload-batch `
  --account-name $storageAccount `
  --destination $containerName `
  --source ./dist
```

---

## ? PASO 8: Actualizar API Management

### 8.1 Configurar CORS

```powershell
# Variables
$apimName = "svydledger-apim"

# Configurar CORS
az apim api update `
  --resource-group $resourceGroup `
  --service-name $apimName `
  --api-id "*" `
  --subscription-required false
```

### 8.2 Política de CORS

```xml
<policies>
  <inbound>
    <cors allow-credentials="true">
      <allowed-origins>
        <origin>https://www.svydledger.com</origin>
        <origin>http://localhost:5173</origin>
      </allowed-origins>
      <allowed-methods>
        <method>GET</method>
        <method>POST</method>
        <method>PUT</method>
        <method>DELETE</method>
        <method>OPTIONS</method>
      </allowed-methods>
      <allowed-headers>
        <header>*</header>
      </allowed-headers>
    </cors>
  </inbound>
</policies>
```

---

## ? PASO 9: Variables de Entorno

### 9.1 Actualizar .env.production

```env
# frontend/.env.production
VITE_API_BASE_URL=https://www.svydledger.com/api
VITE_IDENTITY_SERVICE_URL=https://www.svydledger.com/api/identity
VITE_LANGUAGE_SERVICE_URL=https://www.svydledger.com/api/language
VITE_COUNTRY_SERVICE_URL=https://www.svydledger.com/api/country
VITE_ACCOUNTING_SERVICE_URL=https://www.svydledger.com/api/accounting
VITE_REPORTS_SERVICE_URL=https://www.svydledger.com/api/reports
VITE_PAYMENTS_SERVICE_URL=https://www.svydledger.com/api/payments
```

---

## ? PASO 10: Testing

### 10.1 Verificar Endpoints

```powershell
# Health check
curl https://www.svydledger.com/api/health

# Frontend
curl https://www.svydledger.com
```

### 10.2 Pruebas en Navegador

```
1. Abrir: https://www.svydledger.com
2. Verificar certificado SSL (candado verde)
3. Probar WelcomePage
4. Probar formularios Sign In/Sign Up
5. Verificar selector de idiomas
```

---

## ?? CHECKLIST DE DESPLIEGUE

### Azure Resources
- [ ] Resource Group creado
- [ ] AKS Cluster funcionando
- [ ] Container Registry configurado
- [ ] SQL Database accesible
- [ ] Key Vault con secretos
- [ ] API Management configurado

### Azure Front Door
- [ ] Profile creado
- [ ] Endpoint configurado
- [ ] Origin group configurado
- [ ] Backend agregado

### DNS
- [ ] Dominio www.svydledger.com configurado
- [ ] Registro TXT de validación agregado
- [ ] Registro CNAME configurado
- [ ] DNS propagado (24-48 horas)

### SSL/TLS
- [ ] Certificado administrado habilitado
- [ ] HTTPS forzado
- [ ] Redirección HTTP ? HTTPS activa

### Frontend
- [ ] Build de producción compilado
- [ ] Archivos subidos a Storage
- [ ] Static website habilitado
- [ ] Variables de entorno actualizadas

### API
- [ ] CORS configurado
- [ ] Endpoints funcionales
- [ ] Health checks OK

### Testing
- [ ] https://www.svydledger.com accesible
- [ ] SSL válido
- [ ] WelcomePage carga correctamente
- [ ] Formularios funcionales
- [ ] API responde

---

## ?? TROUBLESHOOTING

### Problema: DNS no resuelve

```powershell
# Verificar propagación
nslookup www.svydledger.com

# Limpiar caché DNS local
ipconfig /flushdns
```

### Problema: SSL no válido

```powershell
# Verificar estado del certificado
az afd custom-domain show `
  --resource-group svydledger-data `
  --profile-name svydledger-fd `
  --custom-domain-name svydledger-domain
```

### Problema: 404 en rutas

- Verificar que index.html está en la raíz de /dist
- Configurar 404-document en Storage

### Problema: CORS errors

- Verificar política de CORS en API Management
- Verificar orígenes permitidos

---

## ?? COMANDOS ÚTILES

```powershell
# Ver logs de Front Door
az monitor activity-log list `
  --resource-group svydledger-data `
  --output table

# Ver estado de endpoints
az afd endpoint list `
  --resource-group svydledger-data `
  --profile-name svydledger-fd `
  --output table

# Ver configuración de dominio
az afd custom-domain list `
  --resource-group svydledger-data `
  --profile-name svydledger-fd `
  --output table
```

---

## ? RESULTADO FINAL

Una vez completados todos los pasos:

? **www.svydledger.com** apuntará a tu aplicación  
? SSL/TLS configurado automáticamente  
? Frontend servido desde Azure Storage  
? API accesible vía API Management  
? WelcomePage completamente funcional  

---

**Tiempo Estimado:** 2-3 horas (excluyendo propagación DNS)  
**Costo Mensual:** ~$50-100 USD (Front Door Standard + Storage)
