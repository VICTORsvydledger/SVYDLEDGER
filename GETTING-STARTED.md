# ?? SVYD LEDGER - Gu�a de Inicio Paso a Paso

## ?? �ndice
1. [Requisitos Previos](#requisitos-previos)
2. [Paso 1: Configurar Azure](#paso-1-configurar-azure)
3. [Paso 2: Configurar GitHub](#paso-2-configurar-github)
4. [Paso 3: Configurar Variables de Entorno](#paso-3-configurar-variables-de-entorno)
5. [Paso 4: Desplegar Infraestructura](#paso-4-desplegar-infraestructura)
6. [Paso 5: Publicar en la Web](#paso-5-publicar-en-la-web)
7. [Soluci�n de Problemas](#soluci�n-de-problemas)

---

## ?? Requisitos Previos

Antes de comenzar, aseg�rate de tener instalado:

- [ ] **Azure CLI** - [Descargar aqu�](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [ ] **GitHub CLI** - [Descargar aqu�](https://cli.github.com/)
- [ ] **Node.js 20+** - [Descargar aqu�](https://nodejs.org/)
- [ ] **Python 3.11+** - [Descargar aqu�](https://www.python.org/)
- [ ] **Docker Desktop** - [Descargar aqu�](https://www.docker.com/products/docker-desktop)
- [ ] **Visual Studio Enterprise 2026** (ya lo tienes)
- [ ] **PowerShell 7+** - [Descargar aqu�](https://docs.microsoft.com/en-us/powershell/)
- [ ] **Terraform** - [Descargar aqu�](https://www.terraform.io/downloads)

---

## ?? Paso 1: Configurar Azure

### 1.1 Iniciar Sesi�n en Azure

**?? ATENCI�N**: Necesitar�s iniciar sesi�n en Azure manualmente.

1. Abre PowerShell como Administrador
2. Navega a la carpeta del proyecto:
   ```powershell
   cd C:\Users\svcon\Desktop\SVYDDATALEDGER
   ```

3. Ejecuta el script de configuraci�n de Azure:
   ```powershell
   .\infrastructure\scripts\setup-azure.ps1
   ```

4. **TE PEDIR� AUTENTICACI�N**: Cuando veas el mensaje de login, se abrir� una ventana del navegador.
   - Inicia sesi�n con tu cuenta de Azure
   - Selecciona la suscripci�n correcta
   - Autoriza el acceso

5. El script crear� autom�ticamente:
   - Resource Group (si no existe)
   - Storage Account para Terraform
   - Azure Container Registry (ACR)

### 1.2 Verificar Recursos Creados

```powershell
# Ver todos los recursos en el grupo
az resource list --resource-group svydledger-data --output table
```

**? Resultado Esperado**: Deber�as ver:
- Storage Account: `svydledgerstore`
- Container Registry: `svydledgeracr`

---

## ?? Paso 2: Configurar GitHub

### 2.1 Autenticaci�n en GitHub

**?? ATENCI�N**: Necesitar�s iniciar sesi�n en GitHub manualmente.

1. Ejecuta el script de GitHub Secrets:
   ```powershell
   .\infrastructure\scripts\setup-github-secrets.ps1
   ```

2. **TE PEDIR� AUTENTICACI�N**: 
   - Selecciona "Login with a web browser"
   - Copia el c�digo de un solo uso que te muestra
   - Presiona Enter para abrir el navegador
   - Pega el c�digo en GitHub
   - Autoriza GitHub CLI

3. El script configurar� autom�ticamente:
   - `AZURE_CREDENTIALS` (Service Principal)
   - `ACR_USERNAME`
   - `ACR_PASSWORD`

### 2.2 Configurar Secrets Manualmente

**?? ATENCI�N**: Los siguientes secrets DEBES configurarlos manualmente:

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
**?? C�mo generar**:
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
# Suscripci�n de Azure
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

**?? TE PREGUNTAR�**:
- SQL Admin Username ? Ingresa un usuario (ej: `svydadmin`)
- SQL Admin Password ? Ingresa una contrase�a fuerte

**? Resultado Esperado**: "Plan: X to add, 0 to change, 0 to destroy"

### 4.3 Aplicar Infraestructura

**?? ATENCI�N**: Este paso crear� recursos en Azure (puede tomar 15-30 minutos)

```powershell
terraform apply tfplan
```

**?? Recursos que se crear�n**:
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

### 5.2 Construir y Subir Im�genes Docker

**?? ATENCI�N**: Aseg�rate de que Docker Desktop est� corriendo.

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

# Crear secret para aplicaci�n
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

**?? ATENCI�N**: Necesitas acceso al DNS de tu dominio.

1. Obt�n la IP p�blica del Load Balancer:
   ```powershell
   kubectl get service identity-service --namespace=production
   ```

2. En tu proveedor de DNS (ej: GoDaddy, Namecheap):
   - Crea registro A: `api.svydledger.com` ? IP del Load Balancer
   - Crea registro A: `www.svydledger.com` ? IP del Load Balancer

3. Espera propagaci�n DNS (puede tomar 1-48 horas)

4. Verifica:
   ```powershell
   curl https://api.svydledger.com/health
   ```

---

## ?? Soluci�n de Problemas

### Problema: "az command not found"
**Soluci�n**: Instalar Azure CLI y reiniciar PowerShell

### Problema: "terraform command not found"
**Soluci�n**: Instalar Terraform y agregarlo al PATH

### Problema: "Cannot connect to Docker daemon"
**Soluci�n**: Iniciar Docker Desktop

### Problema: "Authentication failed"
**Soluci�n**: 
```powershell
az login
az account set --subscription TU-SUBSCRIPTION-ID
```

### Problema: Pods en estado "ImagePullBackOff"
**Soluci�n**: Verificar secreto de ACR
```powershell
kubectl get secret acr-secret --namespace=production
```

### Problema: Base de datos no conecta
**Soluci�n**: Verificar firewall de Azure SQL
```powershell
az sql server firewall-rule create `
  --resource-group svydledger-data `
  --server svydserver `
  --name AllowAKS `
  --start-ip-address 0.0.0.0 `
  --end-ip-address 255.255.255.255
```
**?? NOTA**: En producci�n, configurar IPs espec�ficas

---

## ? Checklist Final

- [ ] Azure CLI instalado y autenticado
- [ ] GitHub CLI instalado y autenticado
- [ ] Secrets configurados en GitHub
- [ ] Variables de entorno en `.env`
- [ ] Terraform aplicado exitosamente
- [ ] Im�genes Docker subidas a ACR
- [ ] Secrets de Kubernetes creados
- [ ] Servicios desplegados en AKS
- [ ] Health checks funcionando
- [ ] DNS configurado (opcional para inicio)

---

## ?? Pr�ximos Pasos

Una vez que todo est� funcionando:

1. **Crear tablas en Azure SQL** (cuando t� lo indiques)
2. **Configurar Azure API Management**
3. **Configurar SSL/TLS con certificados**
4. **Configurar monitoreo con Application Insights**
5. **Configurar alertas y notificaciones**

---

## ?? �Necesitas Ayuda?

**Cuando encuentres un error o necesites mi ayuda**:

1. Copia el mensaje de error completo
2. Indica en qu� paso est�s
3. Mu�strame el comando que ejecutaste
4. Te dar� instrucciones espec�ficas paso a paso

**�Estoy aqu� para ayudarte en cada paso del camino!**
