# SVYD LEDGER - Terraform Infrastructure
## Región: Central US

Esta carpeta contiene la infraestructura como código (IaC) para SVYD LEDGER.

---

## ?? Prerequisitos

Antes de comenzar, asegúrate de tener instalado:

- [x] **Azure CLI** - `az --version`
- [x] **Terraform** >= 1.5.0 - `terraform --version`
- [x] **Cuenta de Azure** con permisos de Contributor
- [x] **Suscripción activa de Azure**

---

## ?? Inicio Rápido

### 1. Autenticarse en Azure

```powershell
az login
az account set --subscription <SUBSCRIPTION_ID>
```

### 2. Configurar Variables

```powershell
# Copiar archivo de ejemplo
Copy-Item terraform.tfvars.example terraform.tfvars

# Editar con tus valores
code terraform.tfvars
```

**?? IMPORTANTE**: Genera secretos seguros para `sql_admin_password` y `jwt_secret_key`.

### 3. Inicializar Terraform

```powershell
terraform init
```

Esto descargará los providers necesarios y configurará el backend en Azure Storage.

### 4. Planificar Despliegue

```powershell
terraform plan -out=tfplan
```

Revisa cuidadosamente los recursos que se crearán.

### 5. Aplicar Infraestructura

```powershell
terraform apply tfplan
```

**?? Tiempo estimado**: 20-30 minutos.

---

## ?? Módulos Incluidos

| Módulo | Descripción | Recursos Principales |
|--------|-------------|---------------------|
| **app-insights** | Monitoreo y telemetría | Log Analytics, Application Insights, Alerts |
| **aks** | Kubernetes cluster | Azure Kubernetes Service |
| **acr** | Registro de contenedores | Azure Container Registry |
| **sql** | Base de datos | Azure SQL Hyperscale |
| **keyvault** | Gestión de secretos | Azure Key Vault |
| **service-bus** | Mensajería asíncrona | Service Bus (Topics, Subscriptions) |
| **api-management** | API Gateway | API Management (APIs, Products, Policies) |
| **storage** | Almacenamiento | Blob Storage (Containers, Lifecycle) |

---

## ??? Arquitectura de Módulos

```
main.tf
??? app-insights    (primero - Log Analytics necesario por otros)
??? storage         (segundo - necesario por SQL auditing)
??? aks             (cluster Kubernetes)
??? acr             (registro Docker)
??? sql             (base de datos Hyperscale)
??? keyvault        (secretos - depende de AKS y SQL)
??? service-bus     (mensajería)
??? api-management  (gateway - depende de App Insights)
```

---

## ?? Variables Requeridas

### Obligatorias

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `environment` | Ambiente (dev/stage/prod) | `"dev"` |
| `sql_admin_username` | Usuario admin de SQL | `"svydadmin"` |
| `sql_admin_password` | Contraseña de SQL | `"YourStrong@Pass123"` |
| `jwt_secret_key` | Clave para JWT | (64 caracteres) |
| `admin_email` | Email para alertas | `"admin@svydledger.com"` |

### Opcionales

| Variable | Descripción | Default |
|----------|-------------|---------|
| `location` | Región Azure | `"centralus"` |
| `stripe_secret_key` | API key de Stripe | `""` |
| `stripe_webhook_secret` | Webhook de Stripe | `""` |
| `alert_email_recipients` | Emails adicionales | `[]` |

---

## ?? Seguridad

### Generar Secretos Seguros

#### SQL Password (PowerShell)
```powershell
-join ((48..57) + (65..90) + (97..122) + (33,35,36,37,38,42,43,45,61,63,64) | Get-Random -Count 24 | ForEach-Object {[char]$_})
```

#### JWT Secret (PowerShell)
```powershell
-join ((48..57) + (65..90) + (97..122) | Get-Random -Count 64 | ForEach-Object {[char]$_})
```

### Archivo terraform.tfvars

**? NUNCA** commitear `terraform.tfvars` al repositorio.

El archivo `.gitignore` ya está configurado para excluirlo.

---

## ?? Outputs

Después del despliegue, obtendrás:

```powershell
terraform output
```

### Outputs Principales

- `aks_kube_config_command` - Comando para conectar a AKS
- `apim_gateway_url` - URL del API Gateway
- `sql_server_fqdn` - FQDN del servidor SQL
- `key_vault_uri` - URI del Key Vault
- `deployment_summary` - Resumen completo

---

## ?? Ambientes

### Development

```powershell
terraform workspace select dev
terraform apply -var="environment=dev"
```

### Staging

```powershell
terraform workspace select stage
terraform apply -var="environment=stage"
```

### Production

```powershell
terraform workspace select prod
terraform apply -var="environment=prod"
```

---

## ?? Validar Configuración

```powershell
# Validar sintaxis
terraform validate

# Formatear archivos
terraform fmt -recursive

# Ver plan sin aplicar
terraform plan
```

---

## ??? Destruir Infraestructura

**?? CUIDADO**: Esto eliminará TODOS los recursos.

```powershell
terraform destroy
```

Para ambientes de desarrollo solamente.

---

## ?? Mantenimiento

### Actualizar Módulos

```powershell
terraform get -update
```

### Refrescar Estado

```powershell
terraform refresh
```

### Importar Recursos Existentes

Si el recurso ya existe en Azure:

```powershell
terraform import module.sql.azurerm_mssql_server.main /subscriptions/<SUB_ID>/resourceGroups/svydledger-data/providers/Microsoft.Sql/servers/svydserver
```

---

## ?? Troubleshooting

### Error: Backend Initialization Failed

**Problema**: No puede conectar con Azure Storage.

**Solución**:
```powershell
# Verificar autenticación
az account show

# Verificar que el storage account existe
az storage account show --name svydledgerstore --resource-group svydledger-data
```

### Error: Insufficient Permissions

**Problema**: No tienes permisos suficientes.

**Solución**: Solicita rol `Contributor` en el Resource Group `svydledger-data`.

### Error: Resource Already Exists

**Problema**: El recurso ya existe en Azure.

**Solución**: Importar el recurso o usar data source en lugar de resource.

### Error: Invalid Credentials

**Solución**:
```powershell
az login --use-device-code
az account set --subscription <SUBSCRIPTION_ID>
```

---

## ?? Documentación

- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure SQL Hyperscale](https://learn.microsoft.com/en-us/azure/azure-sql/database/service-tier-hyperscale)
- [Azure AKS Best Practices](https://learn.microsoft.com/en-us/azure/aks/best-practices)

---

## ?? Soporte

Si encuentras problemas:

1. Verifica los logs: `terraform show`
2. Revisa el plan: `terraform plan`
3. Consulta la documentación de los módulos
4. Contacta al equipo de DevOps

---

## ? Checklist de Despliegue

- [ ] Azure CLI instalado y autenticado
- [ ] Terraform >= 1.5.0 instalado
- [ ] `terraform.tfvars` configurado con valores reales
- [ ] Secretos generados de forma segura
- [ ] `terraform init` ejecutado exitosamente
- [ ] `terraform plan` revisado cuidadosamente
- [ ] `terraform apply` completado sin errores
- [ ] Outputs verificados
- [ ] AKS accesible con kubectl
- [ ] SQL Server accesible
- [ ] Key Vault configurado

---

**Proyecto**: SVYD LEDGER  
**Región**: Central US  
**Terraform**: >= 1.5.0  
**Azure Provider**: ~> 3.80
