# ??? Guía de Configuración de Herramientas MCP - SVYD LEDGER

## ?? ¿Qué es MCP?

**Model Context Protocol (MCP)** es un protocolo estándar que permite a los asistentes de IA (como GitHub Copilot) acceder a herramientas externas, datos y servicios de forma segura y controlada.

---

## ? **HERRAMIENTAS MCP ACTIVADAS PARA TU PROYECTO**

### **1. Azure MCP Server** (? CRÍTICA)

**Por qué la necesitas:**
- Gestión de recursos Azure (AKS, ACR, Storage, SQL, Service Bus)
- Deployment de infraestructura con Terraform
- Monitoreo y logs
- Gestión de Key Vault y secretos

**Herramientas específicas activadas:**
```
? appservice        - Azure App Services (frontend)
? functionapp       - Azure Functions (si las usas)
? storage           - Azure Storage (blobs, files)
? keyvault          - Azure Key Vault (secretos)
? deploy            - Deployment automation
? get_bestpractices - Best practices para Azure
? azureterraformbestpractices - Terraform best practices
? monitor           - Azure Monitor (logs/métricas)
? resourcehealth    - Estado de recursos
? group_list        - Listar resource groups
? applens           - Diagnostics avanzados
```

---

### **2. Microsoft Learn** (? CRÍTICA)

**Por qué la necesitas:**
- Documentación oficial de Azure
- Ejemplos de código de React, TypeScript, Node.js
- Best practices de desarrollo

**Herramientas específicas activadas:**
```
? microsoft_docs_search      - Buscar documentación
? microsoft_docs_fetch       - Obtener docs completas
? microsoft_code_sample_search - Buscar ejemplos de código
```

---

## ? **HERRAMIENTAS DESACTIVADAS (No necesarias para tu proyecto)**

| Herramienta | Por Qué Desactivada |
|-------------|---------------------|
| ? **Azure SignalR** | No usas comunicación en tiempo real |
| ? **Azure Grafana** | Ya tienes Azure Monitor + App Insights |
| ? **Azure Speech** | No hay speech-to-text en tu app |
| ? **Azure Marketplace** | No necesitas servicios de marketplace ahora |

---

## ?? **CÓMO FUNCIONA EN VS CODE**

### **Archivo de Configuración: `.mcp.json`**

He creado el archivo `.mcp.json` en la raíz de tu proyecto con la configuración optimizada.

```json
{
  "mcpServers": {
    "Azure MCP Server": {
      "command": "npx",
      "args": ["-y", "@azure/mcp@latest", "server", "start"],
      "enabled": true
    },
    "Microsoft Learn": {
      "url": "https://learn.microsoft.com/mcp/",
      "enabled": true
    }
  },
  "allowedTools": [
    "Azure_MCP_Server_appservice",
    "Azure_MCP_Server_storage",
    ...
  ],
  "disabledTools": [
    "Azure_MCP_Server_signalr",
    "Azure_MCP_Server_grafana",
    ...
  ]
}
```

---

## ?? **OPTIMIZACIÓN POR FASE DEL PROYECTO**

### **Fase 1: Desarrollo Frontend (ACTUAL)**

```
ACTIVAS:
  ? Microsoft Learn (docs de React/TypeScript)
  ? Azure App Service (para deployment)
  ? Azure Best Practices (código)

DESACTIVADAS:
  ? Azure Monitor (no hay deployment aún)
  ? Azure App Lens (no hay issues aún)
```

---

### **Fase 2: Desarrollo Backend**

```
ACTIVAS:
  ? Azure Key Vault (secretos)
  ? Azure Storage (archivos)
  ? Azure Best Practices (Node.js/Python)
  ? Terraform Best Practices

DESACTIVADAS:
  ? (mantener las mismas)
```

---

### **Fase 3: Deployment & Testing**

```
ACTIVAS:
  ? Azure Deploy (CI/CD)
  ? Azure Monitor (logs)
  ? Azure Resource Health (estado)
  ? Azure App Lens (diagnostics)

DESACTIVADAS:
  ? (mantener las mismas)
```

---

### **Fase 4: Producción**

```
ACTIVAS:
  ? TODAS las herramientas Azure
  ?? Considerar activar Azure Marketplace (si necesitas servicios)

DESACTIVADAS:
  ? Azure SignalR (nunca necesaria)
  ? Azure Grafana (ya tienes App Insights)
  ? Azure Speech (no aplica)
```

---

## ?? **VENTAJAS DE ESTA CONFIGURACIÓN**

### ? **Rendimiento Optimizado**
- Solo las herramientas necesarias están activas
- Menos llamadas a APIs innecesarias
- Respuestas más rápidas de Copilot

### ? **Seguridad**
- Control granular de qué herramientas pueden ejecutarse
- No se exponen APIs innecesarias
- Autenticación solo donde se necesita

### ? **Costos Reducidos**
- Menos uso de tokens MCP
- Menos llamadas a servicios Azure
- Optimización de recursos

### ? **Mejor Experiencia de Desarrollo**
- Sugerencias más relevantes
- Menos ruido en las opciones
- Contexto más preciso para Copilot

---

## ?? **VERIFICAR HERRAMIENTAS ACTIVAS**

### **En VS Code:**

1. Abre la **Paleta de Comandos** (Ctrl+Shift+P)
2. Busca: `GitHub Copilot: Show MCP Servers`
3. Verás la lista de servidores MCP activos

### **En GitHub Copilot Chat:**

Pregunta:
```
@workspace Qué herramientas MCP están activas?
```

---

## ??? **APROBACIÓN DE HERRAMIENTAS**

Cuando una herramienta MCP intenta ejecutarse por primera vez, VS Code te pedirá confirmación:

```
??????????????????????????????????????????
? Allow Azure MCP Server to:            ?
? • Access Azure resources               ?
? • Deploy infrastructure                ?
? • Read/write storage                   ?
?                                        ?
? [ ] Allow for this session             ?
? [ ] Allow for this solution            ?
? [?] Allow always                       ?
?                                        ?
?     [Cancel]  [Allow]                  ?
??????????????????????????????????????????
```

**Recomendación:**
- Primera vez: "Allow for this session" (probar)
- Si funciona bien: "Allow for this solution"
- Solo si confías 100%: "Allow always"

---

## ?? **CONFIGURACIÓN AVANZADA**

### **Settings en `.mcp.json`:**

```json
{
  "settings": {
    "autoApprove": false,        // Siempre pedir confirmación
    "sessionCache": true,        // Cache de herramientas en sesión
    "timeout": 30000            // Timeout de 30 segundos
  }
}
```

### **¿Cuándo cambiar?**

| Setting | Valor Recomendado | Cuándo Cambiar |
|---------|-------------------|----------------|
| `autoApprove` | `false` | Solo `true` en CI/CD automatizado |
| `sessionCache` | `true` | `false` si hay problemas de estado |
| `timeout` | `30000` | Aumentar si operaciones son lentas |

---

## ?? **RECURSOS Y DOCUMENTACIÓN**

### **Oficiales:**
- [MCP Specification](https://modelcontextprotocol.io/specification)
- [Azure MCP Server Docs](https://learn.microsoft.com/azure/developer/azure-mcp-server/)
- [VS Code MCP Integration](https://code.visualstudio.com/docs/copilot/mcp)

### **En tu proyecto:**
- `.mcp.json` - Configuración de herramientas
- `MCP-TOOLS-GUIDE.md` - Esta guía (este archivo)
- `docs/TROUBLESHOOTING.md` - Solución de problemas

---

## ?? **PRÓXIMOS PASOS**

### **1. Reiniciar VS Code**
```powershell
# Cierra y abre VS Code para aplicar la configuración
```

### **2. Verificar Herramientas**
```powershell
# En GitHub Copilot Chat:
@workspace List available MCP tools
```

### **3. Probar una Herramienta**
```powershell
# En GitHub Copilot Chat:
@workspace List my Azure resource groups
```

### **4. Ajustar si Necesario**
Si alguna herramienta no funciona o necesitas más, edita `.mcp.json`

---

## ? **PREGUNTAS FRECUENTES**

### **Q: ¿Necesito instalar algo más?**
A: No, solo necesitas:
- VS Code con GitHub Copilot
- Node.js (para Azure MCP Server)
- Azure CLI (si usas Azure)

### **Q: ¿Puedo agregar más herramientas?**
A: Sí, edita `.mcp.json` y agrega en `allowedTools`

### **Q: ¿Cómo desactivo una herramienta temporalmente?**
A: Agrégala a `disabledTools` en `.mcp.json`

### **Q: ¿Las herramientas MCP tienen costo?**
A: No directamente, pero:
- Las llamadas a Azure APIs pueden tener costo
- GitHub Copilot requiere suscripción

### **Q: ¿Cómo sé si una herramienta está funcionando?**
A: Usa GitHub Copilot Chat y pregunta algo específico:
```
@workspace List my Azure storage accounts
```

---

## ?? **SEGURIDAD Y PERMISOS**

### **Permisos Requeridos:**

```
Azure:
  ? Lector (Reader) - Para listar recursos
  ? Contributor - Para crear/modificar recursos
  ? Key Vault Admin - Para gestionar secretos

GitHub Copilot:
  ? Copilot License - Para usar MCP tools
  ? Repo Access - Para acceder a tu código
```

### **Best Practices:**

1. ? **Nunca auto-aprobar todo**
   - Revisa cada herramienta antes de aprobar

2. ? **Usa secretos de Azure Key Vault**
   - No hardcodees credenciales

3. ? **Revisa logs de MCP**
   - Verifica qué herramientas se ejecutan

4. ? **Limita alcance de herramientas**
   - Solo activa lo que necesitas

---

## ?? **MONITOREO Y LOGS**

### **Ver Logs de MCP:**

En VS Code:
1. **View** > **Output**
2. Selecciona: **GitHub Copilot** en el dropdown
3. Busca líneas con `[MCP]`

### **Logs Comunes:**

```
[MCP] Azure MCP Server initialized ?
[MCP] Tool 'storage_list' executed successfully ?
[MCP] Authentication required for 'keyvault_get' ??
[MCP] Tool 'signalr_list' disabled ?
```

---

## ?? **RESULTADO ESPERADO**

Con esta configuración, tendrás:

? **Herramientas Optimizadas**
- Solo lo necesario para SVYD LEDGER
- Sin overhead innecesario

? **Mejor Rendimiento**
- Respuestas más rápidas
- Menos errores

? **Más Seguridad**
- Control granular
- Aprobaciones explícitas

? **Desarrollo Más Eficiente**
- Sugerencias relevantes
- Contexto preciso

---

**¡Configuración de herramientas MCP optimizada para SVYD LEDGER!** ???

---

**Última actualización:** 2024-01-15  
**Versión:** 1.0.0  
**Estado:** ? Configuración lista para usar
