# SVYD LEDGER - Arquitectura Detallada
## Sistema de Contabilidad Universal

---

## ?? Tabla de Contenidos

1. [Visión General](#visión-general)
2. [Arquitectura de Microservicios](#arquitectura-de-microservicios)
3. [Componentes Principales](#componentes-principales)
4. [Infraestructura en Azure](#infraestructura-en-azure)
5. [Flujo de Datos](#flujo-de-datos)
6. [Seguridad](#seguridad)
7. [Escalabilidad](#escalabilidad)
8. [Despliegue](#despliegue)

---

## ?? Visión General

SVYD LEDGER es un sistema de contabilidad universal diseñado para operar a escala global, soportando múltiples países, monedas, idiomas y normativas contables.

### Características Principales

- ? **Multi-país**: Soporte para diferentes sistemas tributarios
- ? **Multi-moneda**: Manejo de múltiples monedas
- ? **Multi-idioma**: Interfaz traducible
- ? **Escalable**: Arquitectura cloud-native
- ? **Seguro**: OAuth 2.0, JWT, Azure Key Vault
- ? **Alta disponibilidad**: 99.9% SLA

---

## ??? Arquitectura de Microservicios

```
???????????????????????????????????????????????????????????????
?                    CLIENTE (Browser)                         ?
???????????????????????????????????????????????????????????????
                        ? HTTPS
                        ?
???????????????????????????????????????????????????????????????
?              Azure Front Door / CDN                          ?
?                   (www.svydledger.com)                       ?
???????????????????????????????????????????????????????????????
                        ?
        ?????????????????????????????????
        ?                               ?
        ?                               ?
????????????????              ????????????????????
?   Frontend   ?              ?  API Management  ?
?   (React)    ?              ?    (Gateway)     ?
????????????????              ????????????????????
                                       ?
                    ???????????????????????????????????????
                    ?                  ?                  ?
                    ?                  ?                  ?
        ????????????????????  ????????????????  ????????????????
        ?  Identity Service?  ?   Language   ?  ?   Country    ?
        ?   (Python/FastAPI)?  ?   Service    ?  ?   Service    ?
        ????????????????????  ????????????????  ????????????????
                 ?                   ?                  ?
                 ????????????????????????????????????????
                                     ?
                    ???????????????????????????????????
                    ?                ?                ?
                    ?                ?                ?
        ????????????????????  ????????????????  ????????????????
        ?   Accounting     ?  ?   Reports    ?  ?   Payments   ?
        ?     Service      ?  ?   Service    ?  ?   Service    ?
        ? (Node.js/TypeScript)? ?(Node.js/TS)?  ?(Node.js/TS+Stripe)?
        ????????????????????  ????????????????  ????????????????
                 ?                   ?                  ?
                 ????????????????????????????????????????
                                     ?
                        ???????????????????????????
                        ?                         ?
                        ?                         ?
            ????????????????????      ????????????????????
            ?  Azure Service   ?      ?   Azure SQL      ?
            ?      Bus         ?      ?   Hyperscale     ?
            ?  (Event-Driven)  ?      ?  (Database)      ?
            ????????????????????      ????????????????????
```

---

## ?? Componentes Principales

### 1. **Identity Service** (Python + FastAPI)
- **Puerto**: 8001
- **Responsabilidades**:
  - Autenticación de usuarios (OAuth 2.0, JWT)
  - Gestión de roles y permisos
  - Integración con Azure AD B2C
- **Base de datos**: Schema `identity` en Azure SQL

### 2. **Language Service** (Python + FastAPI)
- **Puerto**: 8002
- **Responsabilidades**:
  - Gestión de traducciones
  - Soporte multi-idioma
  - Exportación/importación de traducciones
- **Base de datos**: Schema `language` en Azure SQL

### 3. **Country Service** (Python + FastAPI)
- **Puerto**: 8003
- **Responsabilidades**:
  - Gestión de países y sistemas tributarios
  - Configuración de impuestos por país
  - Normas contables (IFRS, GAAP)
- **Base de datos**: Schema `country` en Azure SQL

### 4. **Accounting Service** (Node.js + TypeScript)
- **Puerto**: 8004
- **Responsabilidades**:
  - Plan de cuentas (Chart of Accounts)
  - Asientos contables (Journal Entries)
  - Balances y estados financieros
- **Base de datos**: Schema `accounting` en Azure SQL
- **ORM**: Prisma

### 5. **Reports Service** (Node.js + TypeScript)
- **Puerto**: 8005
- **Responsabilidades**:
  - Generación de reportes financieros
  - Estados financieros (Balance, P&L, Cash Flow)
  - Exportación a PDF, Excel, CSV
- **Base de datos**: Schema `reports` en Azure SQL

### 6. **Payments Service** (Node.js + TypeScript + Stripe)
- **Puerto**: 8006
- **Responsabilidades**:
  - Gestión de suscripciones
  - Integración con Stripe Billing
  - Manejo de webhooks de pago
- **Base de datos**: Schema `payments` en Azure SQL

---

## ?? Infraestructura en Azure

### Región Principal: **Central US**

Todos los recursos están desplegados en la región `centralus` para garantizar baja latencia y cumplimiento normativo.

### Recursos Azure

| Recurso | Nombre | Propósito |
|---------|--------|-----------|
| **Resource Group** | svydledger-data | Contenedor de todos los recursos |
| **AKS Cluster** | svydledger-aks-{env} | Orquestación de microservicios |
| **Container Registry** | svydledgeracr | Registro de imágenes Docker |
| **SQL Server** | svydserver | Servidor de base de datos |
| **SQL Database** | svydledger-hyperescala | Base de datos Hyperscale |
| **Key Vault** | svydledger-kv | Gestión de secretos |
| **Service Bus** | svydledger-sb | Mensajería asíncrona |
| **API Management** | svydledger-apim | API Gateway |
| **Storage Account** | svydledgerstore | Almacenamiento de archivos |
| **App Insights** | svydledger-insights | Monitoreo y telemetría |

---

## ?? Flujo de Datos

### 1. Autenticación
```
Usuario ? Frontend ? API Gateway ? Identity Service ? Azure SQL
                                          ?
                                    JWT Token
                                          ?
                                    Frontend (localStorage)
```

### 2. Creación de Asiento Contable
```
Usuario ? Frontend ? API Gateway ? Accounting Service
                                          ?
                                   Validación de Balance
                                          ?
                                   Azure SQL (Transacción)
                                          ?
                                   Azure Service Bus (Evento)
                                          ?
                           ???????????????????????????????
                           ?                             ?
                    Reports Service              Other Subscribers
```

### 3. Generación de Reporte
```
Usuario ? Frontend ? API Gateway ? Reports Service
                                          ?
                                   Consulta Azure SQL
                                          ?
                                   Genera PDF/Excel
                                          ?
                                   Azure Blob Storage
                                          ?
                                   URL de descarga
```

---

## ?? Seguridad

### Capas de Seguridad

1. **Transporte**: HTTPS/TLS en todas las comunicaciones
2. **Autenticación**: OAuth 2.0 + JWT
3. **Autorización**: RBAC (Role-Based Access Control)
4. **Secretos**: Azure Key Vault
5. **Red**: Virtual Network, Network Security Groups
6. **Base de datos**: Cifrado en reposo y en tránsito
7. **API**: Rate limiting, throttling

### Flujo de Autenticación

```
1. Usuario envía credenciales
2. Identity Service verifica en Azure SQL
3. Genera JWT con claims (userId, roles, exp)
4. Frontend almacena token
5. Cada request incluye: Authorization: Bearer <token>
6. API Gateway valida token
7. Microservicio recibe userId y roles
```

---

## ?? Escalabilidad

### Horizontal Pod Autoscaler (HPA)

```yaml
Métricas:
  - CPU: 70%
  - Memory: 80%

Replicas:
  Min: 2
  Max: 10 (identity, language, country)
  Max: 15 (accounting, reports, payments)
```

### Azure SQL Hyperscale

- **Escalado automático** de compute y storage
- **Read replicas** para consultas de solo lectura
- **Backup** automático con retención de 35 días

### CDN y Cache

- **Azure Front Door**: Cache global
- **Redis Cache**: Cache de sesiones y consultas frecuentes

---

## ?? Despliegue

### Pipeline CI/CD

```
Commit ? GitHub Actions
           ?
      Run Tests
           ?
      Build Docker Images
           ?
      Push to ACR
           ?
      Update K8s Manifests
           ?
      Deploy to AKS
           ?
      Health Checks
           ?
      Smoke Tests
```

### Ambientes

| Ambiente | Branch | URL | AKS Cluster |
|----------|--------|-----|-------------|
| **Development** | develop | dev.svydledger.com | svydledger-aks-dev |
| **Staging** | staging | stage.svydledger.com | svydledger-aks-stage |
| **Production** | main | www.svydledger.com | svydledger-aks-prod |

---

## ?? Monitoreo

### Azure Monitor + Application Insights

- **Métricas**: CPU, Memory, Request rate, Error rate
- **Logs**: Structured logging con Log Analytics
- **Alertas**: Configuradas para anomalías
- **Dashboards**: Grafana + Prometheus

### Health Checks

Todos los servicios exponen `/health`:

```json
{
  "status": "healthy",
  "service": "Accounting Service",
  "version": "v1",
  "region": "centralus",
  "timestamp": "2025-01-15T10:30:00Z"
}
```

---

## ?? Comunicación entre Servicios

### Síncrona (HTTP/REST)
- Frontend ? API Gateway ? Microservicios
- Timeout: 30 segundos
- Retry: Exponential backoff

### Asíncrona (Azure Service Bus)
- **Topics**: journal-entries, invoices, payments
- **Subscriptions**: Por cada servicio interesado
- **Dead Letter Queue**: Para mensajes fallidos

---

## ?? Patrones de Diseño

1. **API Gateway**: Punto único de entrada
2. **Database per Service**: Cada servicio su schema
3. **Event-Driven**: Comunicación asíncrona
4. **Circuit Breaker**: Fallback en caso de fallo
5. **Saga Pattern**: Transacciones distribuidas
6. **CQRS**: Separación de comandos y consultas

---

## ?? Tecnologías Utilizadas

### Backend
- Python 3.11 + FastAPI
- Node.js 20 + TypeScript
- Prisma ORM
- JWT + OAuth 2.0

### Frontend
- React 18 + TypeScript
- Redux Toolkit
- Material-UI + Ant Design
- Vite

### Infraestructura
- Azure Kubernetes Service (AKS)
- Azure SQL Hyperscale
- Azure Container Registry
- Terraform
- GitHub Actions

---

## ?? Contacto y Soporte

**Proyecto**: SVYD LEDGER  
**Repositorio**: github.com/VICTORsvydledger/SVYDLEDGER  
**Región**: Central US  
**Versión**: 1.0.0
