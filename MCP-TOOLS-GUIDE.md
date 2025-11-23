# ??? Gu�a de Configuraci�n de Herramientas MCP - SVYD LEDGER

## ?? �Qu� es MCP?

**Model Context Protocol (MCP)** es un protocolo est�ndar que permite a los asistentes de IA (como GitHub Copilot) acceder a herramientas externas, datos y servicios de forma segura y controlada.

---

## ? **HERRAMIENTAS MCP ACTIVADAS PARA TU PROYECTO**

### **1. Azure MCP Server** (? CR�TICA)

**Por qu� la necesitas:**
- Gesti�n de recursos Azure (AKS, ACR, Storage, SQL, Service Bus)
- Deployment de infraestructura con Terraform
- Monitoreo y logs
- Gesti�n de Key Vault y secretos

**Herramientas espec�ficas activadas:**
```
? appservice        - Azure App Services (frontend)
? functionapp       - Azure Functions (si las usas)
? storage           - Azure Storage (blobs, files)
? keyvault          - Azure Key Vault (secretos)
? deploy            - Deployment automation
? get_bestpractices - Best practices para Azure
? azureterraformbestpractices - Terraform best practices
? monitor           - Azure Monitor (logs/m�tricas)
? resourcehealth    - Estado de recursos
? group_list        - Listar resource groups
? applens           - Diagnostics avanzados
```

---

### **2. Microsoft Learn** (? CR�TICA)

**Por qu� la necesitas:**
- Documentaci�n oficial de Azure
- Ejemplos de c�digo de React, TypeScript, Node.js
- Best practices de desarrollo

**Herramientas espec�ficas activadas:**
```
? microsoft_docs_search      - Buscar documentaci�n
? microsoft_docs_fetch       - Obtener docs completas
? microsoft_code_sample_search - Buscar ejemplos de c�digo
```

---

## ? **HERRAMIENTAS DESACTIVADAS (No necesarias para tu proyecto)**

| Herramienta | Por Qu� Desactivada |
|-------------|---------------------|
| ? **Azure SignalR** | No usas comunicaci�n en tiempo real |
| ? **Azure Grafana** | Ya tienes Azure Monitor + App Insights |
| ? **Azure Speech** | No hay speech-to-text en tu app |
| ? **Azure Marketplace** | No necesitas servicios de marketplace ahora |

---

## ?? **C�MO FUNCIONA EN VS CODE**

### **Archivo de Configuraci�n: `.mcp.json`**

He creado el archivo `.mcp.json` en la ra�z de tu proyecto con la configuraci�n optimizada.

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

## ?? **OPTIMIZACI�N POR FASE DEL PROYECTO**

### **Fase 1: Desarrollo Frontend (ACTUAL)**

```
ACTIVAS:
  ? Microsoft Learn (docs de React/TypeScript)
  ? Azure App Service (para deployment)
  ? Azure Best Practices (c�digo)

DESACTIVADAS:
  ? Azure Monitor (no hay deployment a�n)
  ? Azure App Lens (no hay issues a�n)
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

### **Fase 4: Producci�n**

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

## ?? **VENTAJAS DE ESTA CONFIGURACI�N**

### ? **Rendimiento Optimizado**
- Solo las herramientas necesarias est�n activas
- Menos llamadas a APIs innecesarias
- Respuestas m�s r�pidas de Copilot

### ? **Seguridad**
- Control granular de qu� herramientas pueden ejecutarse
- No se exponen APIs innecesarias
- Autenticaci�n solo donde se necesita

### ? **Costos Reducidos**
- Menos uso de tokens MCP
- Menos llamadas a servicios Azure
- Optimizaci�n de recursos

### ? **Mejor Experiencia de Desarrollo**
- Sugerencias m�s relevantes
- Menos ruido en las opciones
- Contexto m�s preciso para Copilot

---

## ?? **VERIFICAR HERRAMIENTAS ACTIVAS**

### **En VS Code:**

1. Abre la **Paleta de Comandos** (Ctrl+Shift+P)
2. Busca: `GitHub Copilot: Show MCP Servers`
3. Ver�s la lista de servidores MCP activos

### **En GitHub Copilot Chat:**

Pregunta:
```
@workspace Qu� herramientas MCP est�n activas?
```

---

## ??? **APROBACI�N DE HERRAMIENTAS**

Cuando una herramienta MCP intenta ejecutarse por primera vez, VS Code te pedir� confirmaci�n:

```
??????????????????????????????????????????
? Allow Azure MCP Server to:            ?
? � Access Azure resources               ?
? � Deploy infrastructure                ?
? � Read/write storage                   ?
?                                        ?
? [ ] Allow for this session             ?
? [ ] Allow for this solution            ?
? [?] Allow always                       ?
?                                        ?
?     [Cancel]  [Allow]                  ?
??????????????????????????????????????????
```

**Recomendaci�n:**
- Primera vez: "Allow for this session" (probar)
- Si funciona bien: "Allow for this solution"
- Solo si conf�as 100%: "Allow always"

---

## ?? **CONFIGURACI�N AVANZADA**

### **Settings en `.mcp.json`:**

```json
{
  "settings": {
    "autoApprove": false,        // Siempre pedir confirmaci�n
    "sessionCache": true,        // Cache de herramientas en sesi�n
    "timeout": 30000            // Timeout de 30 segundos
  }
}
```

### **�Cu�ndo cambiar?**

| Setting | Valor Recomendado | Cu�ndo Cambiar |
|---------|-------------------|----------------|
| `autoApprove` | `false` | Solo `true` en CI/CD automatizado |
| `sessionCache` | `true` | `false` si hay problemas de estado |
| `timeout` | `30000` | Aumentar si operaciones son lentas |

---

## ?? **RECURSOS Y DOCUMENTACI�N**

### **Oficiales:**
- [MCP Specification](https://modelcontextprotocol.io/specification)
- [Azure MCP Server Docs](https://learn.microsoft.com/azure/developer/azure-mcp-server/)
- [VS Code MCP Integration](https://code.visualstudio.com/docs/copilot/mcp)

### **En tu proyecto:**
- `.mcp.json` - Configuraci�n de herramientas
- `MCP-TOOLS-GUIDE.md` - Esta gu�a (este archivo)
- `docs/TROUBLESHOOTING.md` - Soluci�n de problemas

---

## ?? **PR�XIMOS PASOS**

### **1. Reiniciar VS Code**
```powershell
# Cierra y abre VS Code para aplicar la configuraci�n
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
Si alguna herramienta no funciona o necesitas m�s, edita `.mcp.json`

---

## ? **PREGUNTAS FRECUENTES**

### **Q: �Necesito instalar algo m�s?**
A: No, solo necesitas:
- VS Code con GitHub Copilot
- Node.js (para Azure MCP Server)
- Azure CLI (si usas Azure)

### **Q: �Puedo agregar m�s herramientas?**
A: S�, edita `.mcp.json` y agrega en `allowedTools`

### **Q: �C�mo desactivo una herramienta temporalmente?**
A: Agr�gala a `disabledTools` en `.mcp.json`

### **Q: �Las herramientas MCP tienen costo?**
A: No directamente, pero:
- Las llamadas a Azure APIs pueden tener costo
- GitHub Copilot requiere suscripci�n

### **Q: �C�mo s� si una herramienta est� funcionando?**
A: Usa GitHub Copilot Chat y pregunta algo espec�fico:
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
  ? Repo Access - Para acceder a tu c�digo
```

### **Best Practices:**

1. ? **Nunca auto-aprobar todo**
   - Revisa cada herramienta antes de aprobar

2. ? **Usa secretos de Azure Key Vault**
   - No hardcodees credenciales

3. ? **Revisa logs de MCP**
   - Verifica qu� herramientas se ejecutan

4. ? **Limita alcance de herramientas**
   - Solo activa lo que necesitas

---

## ?? **MONITOREO Y LOGS**

### **Ver Logs de MCP:**

En VS Code:
1. **View** > **Output**
2. Selecciona: **GitHub Copilot** en el dropdown
3. Busca l�neas con `[MCP]`

### **Logs Comunes:**

```
[MCP] Azure MCP Server initialized ?
[MCP] Tool 'storage_list' executed successfully ?
[MCP] Authentication required for 'keyvault_get' ??
[MCP] Tool 'signalr_list' disabled ?
```

---

## ?? **RESULTADO ESPERADO**

Con esta configuraci�n, tendr�s:

? **Herramientas Optimizadas**
- Solo lo necesario para SVYD LEDGER
- Sin overhead innecesario

? **Mejor Rendimiento**
- Respuestas m�s r�pidas
- Menos errores

? **M�s Seguridad**
- Control granular
- Aprobaciones expl�citas

? **Desarrollo M�s Eficiente**
- Sugerencias relevantes
- Contexto preciso

---

**�Configuraci�n de herramientas MCP optimizada para SVYD LEDGER!** ???

---

**�ltima actualizaci�n:** 2024-01-15  
**Versi�n:** 1.0.0  
**Estado:** ? Configuraci�n lista para usar
