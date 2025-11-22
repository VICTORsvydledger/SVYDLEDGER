# ?? FLUJO DE DESPLIEGUE AUTOMÁTICO - SVCONTA.COM

**Fecha**: 2025-01-15  
**URL Producción**: https://www.svconta.com  
**Plataforma**: Azure Static Web Apps  
**Estado**: ? ACTIVO

---

## ?? CONFIGURACIÓN ACTUAL

### Información del Sitio
- **URL Pública**: https://www.svconta.com
- **URL Azure**: https://[generated-name].azurestaticapps.net
- **Plataforma**: Azure Static Web Apps
- **Región**: Auto (Azure CDN global)
- **Plan**: Free o Standard

### Repositorio GitHub
- **Repo**: https://github.com/VICTORsvydledger/SVYDLEDGER
- **Branch Principal**: `main`
- **Workflow**: `.github/workflows/swa-frontend.yml`

---

## ?? DESPLIEGUE AUTOMÁTICO

### Trigger del Workflow

El despliegue se ejecuta automáticamente cuando:

1. ? **Push a `main`** con cambios en `frontend/**`
2. ? **Workflow manual** (workflow_dispatch)

```yaml
on:
  push:
    branches:
      - main
    paths:
      - 'frontend/**'  # Solo si hay cambios en frontend
  workflow_dispatch:      # Permite ejecución manual
```

### Pasos del Despliegue

```
???????????????????????????????????????????
? 1. PUSH a GitHub (branch main)          ?
?    - Cambios en frontend/               ?
???????????????????????????????????????????
                  ?
???????????????????????????????????????????
? 2. GitHub Actions se activa             ?
?    - Checkout código                    ?
?    - Setup Node.js 20                   ?
???????????????????????????????????????????
                  ?
???????????????????????????????????????????
? 3. Install Dependencies                 ?
?    - npm ci en frontend/                ?
???????????????????????????????????????????
                  ?
???????????????????????????????????????????
? 4. Build                                ?
?    - npm run build                      ?
?    - Genera frontend/dist/              ?
???????????????????????????????????????????
                  ?
???????????????????????????????????????????
? 5. Upload Artifact                      ?
?    - Guarda frontend/dist/              ?
???????????????????????????????????????????
                  ?
???????????????????????????????????????????
? 6. Deploy a Azure Static Web Apps       ?
?    - Usa token secreto                  ?
?    - Sube a https://www.svconta.com     ?
???????????????????????????????????????????
                  ?
???????????????????????????????????????????
? 7. CDN Propagation (2-5 minutos)        ?
?    - Azure actualiza cache global       ?
???????????????????????????????????????????
                  ?
            ? LIVE en
        https://www.svconta.com
```

---

## ?? SECRETS REQUERIDOS

### En GitHub Repository Settings ? Secrets

| Secret Name | Descripción | Dónde Obtenerlo |
|-------------|-------------|-----------------|
| `AZURE_STATIC_WEB_APPS_API_TOKEN` | Token de despliegue de Azure SWA | Azure Portal ? Static Web App ? Deployment Tokens |

### En GitHub Repository Settings ? Variables

| Variable Name | Descripción | Valor |
|---------------|-------------|-------|
| `VITE_API_URL` | URL del API backend | URL del backend (cuando esté listo) |

---

## ?? TIEMPOS DE DESPLIEGUE

### Proceso Completo
```
Git Push                    ? 0:00
?? GitHub Actions inicia    ? 0:05
?? npm ci                   ? 0:30
?? npm run build            ? 1:00
?? Upload artifact          ? 1:30
?? Deploy a Azure           ? 2:00
?? CDN Propagation          ? 2:00-5:00
??????????????????????????????????
Total: 2-5 minutos
```

### Tiempos Aproximados
- **Checkout + Setup**: ~5 segundos
- **npm ci**: ~20-30 segundos
- **npm run build**: ~30 segundos
- **Deploy**: ~30 segundos
- **CDN Propagation**: ~1-3 minutos

**Total**: 2-5 minutos desde push hasta visualización

---

## ? COMANDOS PARA DESPLEGAR

### 1. Despliegue Normal (Automático)
```bash
# En la raíz del proyecto
git add frontend/src/pages/auth/PostAuthPage.tsx
git commit -m "feat: Agregar nueva funcionalidad"
git push origin main

# Esperar 2-5 minutos
# Verificar en https://www.svconta.com
```

### 2. Despliegue Manual (Force Deploy)
```bash
# Si necesitas forzar un redespliegue
gh workflow run "Azure Static Web Apps CI/CD"

# O desde GitHub UI:
# Actions ? Azure Static Web Apps CI/CD ? Run workflow
```

### 3. Verificar Estado del Despliegue
```bash
# Ver último workflow
gh run list --workflow="swa-frontend.yml" --limit 1

# Ver logs en tiempo real
gh run watch
```

---

## ?? VERIFICACIÓN POST-DESPLIEGUE

### Checklist de Verificación

1. ? **GitHub Actions**
   ```bash
   # Ver estado del workflow
   https://github.com/VICTORsvydledger/SVYDLEDGER/actions
   ```

2. ? **Producción**
   ```bash
   # Abrir sitio
   https://www.svconta.com
   
   # Verificar consola del navegador
   # - Sin errores 404
   # - Sin errores de CORS
   # - Recursos cargados correctamente
   ```

3. ? **Caché**
   ```bash
   # Si no ves cambios, hacer hard refresh
   Ctrl + Shift + R  (Windows/Linux)
   Cmd + Shift + R   (Mac)
   ```

---

## ?? ARCHIVOS IMPORTANTES

### Workflow de GitHub Actions
```
.github/workflows/swa-frontend.yml
```

### Configuración de Azure Static Web Apps
```
frontend/staticwebapp.config.json
```

### Build Configuration
```
frontend/vite.config.ts
frontend/package.json
```

---

## ?? TROUBLESHOOTING

### Problema 1: Despliegue Falla

**Síntomas:**
- ? GitHub Actions muestra error rojo
- ? Build falla

**Solución:**
```bash
# 1. Ver logs del workflow
gh run view --log-failed

# 2. Verificar que compile localmente
cd frontend
npm install
npm run build

# 3. Si falla localmente, corregir primero
# 4. Luego hacer push
```

### Problema 2: No Veo los Cambios

**Síntomas:**
- ? GitHub Actions exitoso (verde)
- ? No veo cambios en https://www.svconta.com

**Solución:**
```bash
# 1. Esperar 5 minutos completos (CDN propagation)

# 2. Hard refresh en navegador
Ctrl + Shift + R

# 3. Verificar en modo incógnito
Ctrl + Shift + N (Chrome)

# 4. Verificar que el archivo cambió en el commit
git show HEAD:frontend/src/pages/auth/PostAuthPage.tsx
```

### Problema 3: Token Expirado

**Síntomas:**
- ? Error: "Invalid deployment token"

**Solución:**
```bash
# 1. Ir a Azure Portal
# 2. Static Web Apps ? Tu app ? Deployment tokens
# 3. Regenerar token
# 4. Actualizar secret en GitHub:
#    Settings ? Secrets ? AZURE_STATIC_WEB_APPS_API_TOKEN
```

---

## ?? FLUJO DE TRABAJO RECOMENDADO

### Para Cada Cambio

1. **Hacer cambios localmente**
   ```bash
   # Editar archivo
   code frontend/src/pages/auth/PostAuthPage.tsx
   ```

2. **Verificar localmente** (opcional pero recomendado)
   ```bash
   cd frontend
   npm run dev
   # Abrir http://localhost:5173
   ```

3. **Commit y Push**
   ```bash
   git add frontend/
   git commit -m "feat: Descripción clara del cambio"
   git push origin main
   ```

4. **Monitorear Despliegue**
   ```bash
   # Ver en GitHub Actions
   https://github.com/VICTORsvydledger/SVYDLEDGER/actions
   ```

5. **Verificar en Producción** (después de 2-5 min)
   ```bash
   # Abrir en navegador
   https://www.svconta.com
   
   # Hard refresh
   Ctrl + Shift + R
   ```

---

## ?? MEJORES PRÁCTICAS

### Commits

? **Hacer:**
```bash
git commit -m "feat: Agregar botones EDITAR y PAPELERA"
git commit -m "fix: Corregir codificación UTF-8 en labels"
git commit -m "style: Ajustar colores de botones"
```

? **Evitar:**
```bash
git commit -m "cambios"
git commit -m "fix"
git commit -m "asdf"
```

### Testing

? **Antes de Push:**
1. Verificar que compile sin errores
2. Probar localmente en http://localhost:5173
3. Verificar que no haya errores en consola

? **Evitar:**
1. Push sin verificar
2. "Arreglar" con múltiples commits pequeños
3. Romper el build en producción

---

## ?? DOCUMENTACIÓN RELACIONADA

### Azure Static Web Apps
- [Documentación oficial](https://learn.microsoft.com/en-us/azure/static-web-apps/)
- [GitHub Actions integration](https://learn.microsoft.com/en-us/azure/static-web-apps/github-actions-workflow)

### Vite (Build Tool)
- [Vite config](https://vitejs.dev/config/)
- [Build for production](https://vitejs.dev/guide/build.html)

### GitHub Actions
- [Workflow syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Azure SWA Deploy action](https://github.com/Azure/static-web-apps-deploy)

---

## ?? COMANDOS DE VERIFICACIÓN

### Verificar Último Commit Desplegado
```bash
# Ver último commit en main
git log -1 --oneline

# Ver si hay commits sin desplegar
git fetch origin
git log HEAD..origin/main --oneline
```

### Verificar Estado de Despliegue
```bash
# Con GitHub CLI
gh run list --workflow="swa-frontend.yml" --limit 5

# Ver logs del último run
gh run view

# Ver logs de un run específico
gh run view [RUN_ID] --log
```

### Verificar Archivos Desplegados
```bash
# Ver archivos que se desplegaron en último commit
git diff HEAD~1 HEAD --name-only
```

---

## ? SHORTCUTS Y COMANDOS RÁPIDOS

### Despliegue Rápido (Todo en uno)
```bash
# Guardar, commit y desplegar en un solo paso
git add frontend/ && \
git commit -m "feat: $1" && \
git push origin main

# Uso:
# ./quick-deploy.sh "Agregar nueva funcionalidad"
```

### Verificación Rápida
```bash
# Ver estado + último workflow
git status && gh run list --limit 1
```

### Rollback Rápido (Si algo sale mal)
```bash
# Volver al commit anterior
git revert HEAD
git push origin main

# Esperar redespliegue automático
```

---

## ?? MONITOREO Y ANALYTICS

### Azure Portal
```
https://portal.azure.com
? Static Web Apps
? [Tu app]
? Overview
  - Solicitudes/hora
  - Ancho de banda usado
  - Errores
```

### GitHub Insights
```
https://github.com/VICTORsvydledger/SVYDLEDGER/actions
? Ver historial de deployments
? Tiempos de ejecución
? Tasa de éxito
```

---

## ? RESUMEN EJECUTIVO

### ¿Qué Recordar?

1. **Cada push a `main` con cambios en `frontend/` despliega automáticamente**
2. **El despliegue toma 2-5 minutos**
3. **Siempre hacer hard refresh (Ctrl+Shift+R) después de despliegue**
4. **Verificar en GitHub Actions que el despliegue fue exitoso**
5. **Los cambios se reflejan en https://www.svconta.com**

### Workflow Simple
```
Editar código ? Commit ? Push ? Esperar 2-5 min ? Hard Refresh ? Verificar
```

---

**Última actualización**: 2025-01-15  
**Mantenido por**: GitHub Copilot Agent  
**Estado**: ? Activo y funcionando  
**URL**: https://www.svconta.com
