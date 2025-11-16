# ?? SVYD LEDGER - Guía de Inicio Paso a Paso

## ?? Índice
1. [Requisitos Previos](#requisitos-previos)
2. [Paso 1: Configurar Azure](#paso-1-configurar-azure)
3. [Paso 2: Configurar GitHub](#paso-2-configurar-github)
4. [Paso 3: Configurar Variables de Entorno](#paso-3-configurar-variables-de-entorno)
5. [Paso 4: Desplegar Infraestructura](#paso-4-desplegar-infraestructura)
6. [Paso 5: Publicar en la Web](#paso-5-publicar-en-la-web)
7. [Solución de Problemas](#solución-de-problemas)

---

## ?? Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- [ ] **Azure CLI** - [Descargar aquí](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [ ] **GitHub CLI** - [Descargar aquí](https://cli.github.com/)
- [ ] **Node.js 20+** - [Descargar aquí](https://nodejs.org/)
- [ ] **Python 3.11+** - [Descargar aquí](https://www.python.org/)
- [ ] **Docker Desktop** - [Descargar aquí](https://www.docker.com/products/docker-desktop)
- [ ] **Visual Studio Enterprise 2026** (ya lo tienes)
- [ ] **PowerShell 7+** - [Descargar aquí](https://docs.microsoft.com/en-us/powershell/)
- [ ] **Terraform** - [Descargar aquí](https://www.terraform.io/downloads)

---

## ?? Paso 1: Configurar Azure

### 1.1 Iniciar Sesión en Azure

**?? ATENCIÓN**: Necesitarás iniciar sesión en Azure manualmente.

1. Abre PowerShell como Administrador
2. Navega a la carpeta del proyecto:
   ```powershell
   cd C:\Users\svcon\Desktop\SVYDDATALEDGER
   ```

3. Ejecuta el script de configuración de Azure:
   ```powershell
   .\infrastructure\scripts\setup-azure.ps1
   ```

4. **TE PEDIRÁ AUTENTICACIÓN**: Cuando veas el mensaje de login, se abrirá una ventana del navegador.
   - Inicia sesión con tu cuenta de Azure
   - Selecciona la suscripción correcta
   - Autoriza el acceso

5. El script creará automáticamente:
   - Resource Group (si no existe)
   - Storage Account para Terraform
   - Azure Container Registry (ACR)

### 1.2 Verificar Recursos Creados

```powershell
# Ver todos los recursos en el grupo
az resource list --resource-group svydledger-data --output table
```

**? Resultado Esperado**: Deberías ver:
- Storage Account: `svydledgerstore`
- Container Registry: `svydledgeracr`

---

## ?? Paso 2: Configurar GitHub

### 2.1 Autenticación en GitHub

**?? ATENCIÓN**: Necesitarás iniciar sesión en GitHub manualmente.

1. Ejecuta el script de GitHub Secrets:
   ```powershell
   .\infrastructure\scripts\setup-github-secrets.ps1
   ```

2. **TE PEDIRÁ AUTENTICACIÓN**: 
   - Selecciona "Login with a web browser"
   - Copia el código de un solo uso que te muestra
   - Presiona Enter para abrir el navegador
   - Pega el código en GitHub
   - Autoriza GitHub CLI

3. El script configurará automáticamente:
   - `AZURE_CREDENTIALS` (Service Principal)
   - `ACR_USERNAME`
   - `ACR_PASSWORD`

### 2.2 Configurar Secrets Manualmente

**?? ATENCIÓN**: Los siguientes secrets DEBES configurarlos manualmente:

1. Ve a: https://github.com/VICTORsvydledger/SVYDLEDGER/settings/secrets/actions

2. Click en "New repository secret" para cada uno:

#### a) DATABASE_URL
```
Nombre: DATABASE_URL
Valor: Server=tcp:svydserver.database.windows.net,1433;Database=svydledger-hyperescala;User ID=ADMIN_USER;Password=ADMIN_PASSWORD;Encrypt=true;
```
**?? NOTA**: Reemplaza `ADMIN_USER` y `ADMIN_PASSWORD` con tus credenciales reales de Azure SQL.

#### b) JWT_SECRET_KEY
```
Nombre: JWT_SECRET_KEY
Valor: [Genera una clave aleatoria fuerte de 64 caracteres]
```
**?? Cómo generar**:
```powershell
# En PowerShell
-join ((48..57) + (65..90) + (97..122) | Get-Random -Count 64 | ForEach-Object {[char]$_})
```

#### c) STRIPE_SECRET_KEY
```
Nombre: STRIPE_SECRET_KEY
Valor: sk_test_XXXXXXXXXXXXX
```
**?? NOTA**: Obtener de tu cuenta de Stripe ? Developers ? API Keys

#### d) STRIPE_WEBHOOK_SECRET
```
Nombre: STRIPE_WEBHOOK_SECRET
Valor: whsec_XXXXXXXXXXXXX
```
**?? NOTA**: Crear webhook en Stripe ? Developers ? Webhooks

---

## ?? Paso 3: Configurar Variables de Entorno

### 3.1 Crear archivo .env

1. Copia el archivo de ejemplo:
   ```powershell
   Copy-Item .env.example .env
   ```

2. Abre `.env` en Visual Studio Code:
   ```powershell
   code .env
   ```

3. **?? DEBES LLENAR ESTOS VALORES**:

```env
# Suscripción de Azure
AZURE_SUBSCRIPTION_ID=TU-SUBSCRIPTION-ID-AQUI

# Base de datos
DATABASE_URL=Server=tcp:svydserver.database.windows.net,1433;Database=svydledger-hyperescala;User ID=TU-ADMIN;Password=TU-PASSWORD;Encrypt=true;

# JWT
JWT_SECRET_KEY=TU-CLAVE-SECRETA-AQUI

# Stripe
STRIPE_SECRET_KEY=sk_test_TU-CLAVE-AQUI
STRIPE_WEBHOOK_SECRET=whsec_TU-SECRET-AQUI
```

**?? GUARDAR EL ARCHIVO**

---

## ??? Paso 4: Desplegar Infraestructura

### 4.1 Inicializar Terraform

```powershell
cd infrastructure\terraform
terraform init
```

**? Resultado Esperado**: "Terraform has been successfully initialized!"

### 4.2 Planificar Despliegue

```powershell
terraform plan -out=tfplan
```

**?? TE PREGUNTARÁ**:
- SQL Admin Username ? Ingresa un usuario (ej: `svydadmin`)
- SQL Admin Password ? Ingresa una contraseña fuerte

**? Resultado Esperado**: "Plan: X to add, 0 to change, 0 to destroy"

### 4.3 Aplicar Infraestructura

**?? ATENCIÓN**: Este paso creará recursos en Azure (puede tomar 15-30 minutos)

```powershell
terraform apply tfplan
```

**?? Recursos que se crearán**:
- Azure Kubernetes Service (AKS)
- Azure SQL Hyperscale
- Azure Key Vault
- Azure Service Bus
- Azure API Management

**?? COSTO ESTIMADO**: ~$500-800/mes (dependiendo del uso)

### 4.4 Obtener Outputs

```powershell
terraform output
```

**?? GUARDA ESTOS VALORES**:
- `aks_cluster_name`
- `acr_login_server`
- `sql_server_fqdn`
- `api_management_gateway_url`

---

## ?? Paso 5: Publicar en la Web

### 5.1 Conectar a AKS

```powershell
az aks get-credentials --resource-group svydledger-data --name svydledger-aks-dev
```

### 5.2 Construir y Subir Imágenes Docker

**?? ATENCIÓN**: Asegúrate de que Docker Desktop esté corriendo.

#### a) Backend Services (Python)

```powershell
# Identity Service
cd backend\identity-service
az acr build --registry svydledgeracr --image svydledger/identity-service:latest --file ..\..\docker\backend\python.Dockerfile .

# Language Service
cd ..\language-service
az acr build --registry svydledgeracr --image svydledger/language-service:latest --file ..\..\docker\backend\python.Dockerfile .

# Country Service
cd ..\country-service
az acr build --registry svydledgeracr --image svydledger/country-service:latest --file ..\..\docker\backend\python.Dockerfile .
```

#### b) Backend Services (Node.js)

```powershell
# Accounting Service
cd ..\accounting-service
az acr build --registry svydledgeracr --image svydledger/accounting-service:latest --file ..\..\docker\backend\nodejs.Dockerfile .

# Reports Service
cd ..\reports-service
az acr build --registry svydledgeracr --image svydledger/reports-service:latest --file ..\..\docker\backend\nodejs.Dockerfile .

# Payments Service
cd ..\payments-service
az acr build --registry svydledgeracr --image svydledger/payments-service:latest --file ..\..\docker\backend\nodejs.Dockerfile .
```

#### c) Frontend

```powershell
cd ..\..\frontend
az acr build --registry svydledgeracr --image svydledger/frontend:latest --file ..\docker\frontend\Dockerfile .
```

### 5.3 Configurar Secrets en Kubernetes

```powershell
cd ..\infrastructure\kubernetes

# Crear namespace
kubectl create namespace production

# Crear secret para Azure SQL
kubectl create secret generic database-secrets `
  --from-literal=connection-string="TU-CONNECTION-STRING-AQUI" `
  --namespace=production

# Crear secret para aplicación
kubectl create secret generic app-secrets `
  --from-literal=jwt-secret="TU-JWT-SECRET-AQUI" `
  --from-literal=stripe-secret-key="TU-STRIPE-KEY-AQUI" `
  --from-literal=stripe-webhook-secret="TU-STRIPE-WEBHOOK-AQUI" `
  --namespace=production

# Crear secret de ACR
kubectl create secret docker-registry acr-secret `
  --docker-server=svydledgeracr.azurecr.io `
  --docker-username=svydledgeracr `
  --docker-password=$(az acr credential show --name svydledgeracr --query "passwords[0].value" -o tsv) `
  --namespace=production
```

### 5.4 Desplegar a Kubernetes

```powershell
# Aplicar ConfigMap
kubectl apply -f base\configmap.yaml --namespace=production

# Desplegar servicios
kubectl apply -f services\identity-service.yaml --namespace=production
kubectl apply -f services\accounting-service.yaml --namespace=production

# Ver estado
kubectl get pods --namespace=production
kubectl get services --namespace=production
```

### 5.5 Verificar Despliegue

```powershell
# Ver logs de un servicio
kubectl logs -l app=identity-service --namespace=production

# Verificar health
kubectl port-forward service/identity-service 8001:80 --namespace=production
```

Abre en navegador: http://localhost:8001/health

**? Resultado Esperado**:
```json
{
  "status": "healthy",
  "service": "Identity Service",
  "version": "v1",
  "region": "centralus"
}
```

### 5.6 Configurar Dominio (svydledger.com)

**?? ATENCIÓN**: Necesitas acceso al DNS de tu dominio.

1. Obtén la IP pública del Load Balancer:
   ```powershell
   kubectl get service identity-service --namespace=production
   ```

2. En tu proveedor de DNS (ej: GoDaddy, Namecheap):
   - Crea registro A: `api.svydledger.com` ? IP del Load Balancer
   - Crea registro A: `www.svydledger.com` ? IP del Load Balancer

3. Espera propagación DNS (puede tomar 1-48 horas)

4. Verifica:
   ```powershell
   curl https://api.svydledger.com/health
   ```

---

## ?? Solución de Problemas

### Problema: "az command not found"
**Solución**: Instalar Azure CLI y reiniciar PowerShell

### Problema: "terraform command not found"
**Solución**: Instalar Terraform y agregarlo al PATH

### Problema: "Cannot connect to Docker daemon"
**Solución**: Iniciar Docker Desktop

### Problema: "Authentication failed"
**Solución**: 
```powershell
az login
az account set --subscription TU-SUBSCRIPTION-ID
```

### Problema: Pods en estado "ImagePullBackOff"
**Solución**: Verificar secreto de ACR
```powershell
kubectl get secret acr-secret --namespace=production
```

### Problema: Base de datos no conecta
**Solución**: Verificar firewall de Azure SQL
```powershell
az sql server firewall-rule create `
  --resource-group svydledger-data `
  --server svydserver `
  --name AllowAKS `
  --start-ip-address 0.0.0.0 `
  --end-ip-address 255.255.255.255
```
**?? NOTA**: En producción, configurar IPs específicas

---

## ? Checklist Final

- [ ] Azure CLI instalado y autenticado
- [ ] GitHub CLI instalado y autenticado
- [ ] Secrets configurados en GitHub
- [ ] Variables de entorno en `.env`
- [ ] Terraform aplicado exitosamente
- [ ] Imágenes Docker subidas a ACR
- [ ] Secrets de Kubernetes creados
- [ ] Servicios desplegados en AKS
- [ ] Health checks funcionando
- [ ] DNS configurado (opcional para inicio)

---

## ?? Próximos Pasos

Una vez que todo esté funcionando:

1. **Crear tablas en Azure SQL** (cuando tú lo indiques)
2. **Configurar Azure API Management**
3. **Configurar SSL/TLS con certificados**
4. **Configurar monitoreo con Application Insights**
5. **Configurar alertas y notificaciones**

---

## ?? ¿Necesitas Ayuda?

**Cuando encuentres un error o necesites mi ayuda**:

1. Copia el mensaje de error completo
2. Indica en qué paso estás
3. Muéstrame el comando que ejecutaste
4. Te daré instrucciones específicas paso a paso

**¡Estoy aquí para ayudarte en cada paso del camino!**
