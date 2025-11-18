# ?? Guía Rápida - WelcomePage

## ? Inicio Rápido (3 Pasos)

### 1?? Agregar Imagen de Fondo

```powershell
# Descarga una imagen de cielo azul con nubes
# Recomendación: https://unsplash.com/s/photos/blue-sky-clouds
# Guárdala como: background-1.png
# Ubicación: frontend/public/images/backgrounds/background-1.png
```

### 2?? Instalar Dependencias (Primera vez)

```powershell
cd frontend
npm install
```

### 3?? Iniciar Servidor

```powershell
npm run dev
```

Abre: **http://localhost:5173**

---

## ?? Características Implementadas

### ? Diseño Visual
- Logo "Svyd" con fuente elegante (48px)
- Subtítulo "Sistema de Contabilidad Universal" (30px)
- Fondo de pantalla con overlay semitransparente
- Efectos de desenfoque modernos (backdrop-filter)
- Animaciones suaves y profesionales

### ? Selector de Idiomas
- 27 idiomas soportados
- Orden: EN ? ES ? FR ? IT ? DE ? otros alfabéticamente
- Nombres en inglés + nombres nativos

### ? Formularios
**Sign In (Iniciar Sesión)**
- Email
- Password
- ¿Forgot your password?
- Botón: Log in

**Sign Up (Crear Cuenta)**
- Email
- Password
- Confirm password
- Botón: Create Account

### ? Seguridad
- Autenticación de dos factores (2FA)
- Recuperación de contraseña
- Validación de campos
- Código de verificación de 6 dígitos

### ? Responsive
- Desktop: 2 formularios lado a lado
- Mobile: 1 formulario por línea
- Adaptación automática de tamaños

---

## ??? Script de Verificación

Usa el script de PowerShell para verificar todo:

```powershell
.\setup-welcomepage.ps1
```

Este script verifica:
- ? Archivos del proyecto
- ? Imagen de fondo
- ? Dependencias instaladas
- ? Ofrece iniciar servidor automáticamente

---

## ?? Idiomas Soportados

| # | Idioma | Código | Nativo |
|---|--------|--------|--------|
| 1 | English | en | English |
| 2 | Spanish | es | Español |
| 3 | French | fr | Français |
| 4 | Italian | it | Italiano |
| 5 | German | de | Deutsch |
| 6 | Arabic | ar | ??????? |
| 7 | Bengali | bn | ????? |
| 8 | Chinese Mandarin | zh | ?? |
| 9 | Egyptian Arabic | ar-eg | ??????? ??????? |
| 10 | Hindi | hi | ?????? |
| 11 | Indonesian | id | Bahasa Indonesia |
| 12 | Japanese | ja | ??? |
| 13 | Korean | ko | ??? |
| 14 | Marathi | mr | ????? |
| 15 | Nigerian Pidgin | pcm | Nigerian Pidgin |
| 16 | Panjabi | pa | ?????? |
| 17 | Persian | fa | ????? |
| 18 | Portuguese | pt | Português |
| 19 | Russian | ru | ??????? |
| 20 | Swahili | sw | Kiswahili |
| 21 | Tagalog | tl | Tagalog |
| 22 | Tamil | ta | ????? |
| 23 | Telugu | te | ?????? |
| 24 | Turkish | tr | Türkçe |
| 25 | Ukrainian | uk | ?????????? |
| 26 | Urdu | ur | ???? |
| 27 | Vietnamese | vi | Ti?ng Vi?t |

---

## ?? Comandos Útiles

### Desarrollo
```powershell
cd frontend
npm run dev          # Iniciar servidor de desarrollo
npm run build        # Compilar para producción
npm run preview      # Previsualizar build de producción
```

### Linting
```powershell
npm run lint         # Verificar código
```

---

## ?? URLs

### Local
- **Desarrollo:** http://localhost:5173
- **Preview:** http://localhost:4173

### Producción (Próximamente)
- **DNS:** www.svydledger.com
- **Azure:** svydledger.azurewebsites.net

---

## ?? Especificaciones Técnicas

### Fuentes
- **Logo/Subtítulo:** Pinyon Script (similar a Vladimir Script)
- **Texto:** Arial
- **Tamaños:**
  - Logo: 48px
  - Subtítulo: 30px
  - Texto promocional: 12px
  - Formularios: 16px

### Colores
- **Fondo:** Imagen de cielo azul
- **Overlay:** Linear gradient negro con transparencia
- **Texto:** Blanco con sombra
- **Botones:** Azul (#1976d2)
- **Inputs:** Blanco con transparencia

### Efectos
- `backdrop-filter: blur(20px)` en tarjetas
- Transiciones suaves (0.3s)
- Animaciones de entrada
- Hover effects

---

## ?? Solución de Problemas

### Problema: No se ve la imagen de fondo
**Solución:**
1. Verifica que existe: `frontend/public/images/backgrounds/background-1.png`
2. Verifica el nombre exacto (sin doble extensión)
3. Reinicia el servidor: `Ctrl+C` y luego `npm run dev`

### Problema: Error de fuente
**Solución:**
- La fuente Pinyon Script se carga desde Google Fonts
- Verifica tu conexión a internet
- Fallback: Usa fuente cursiva del sistema

### Problema: Formularios no funcionan
**Solución:**
- Los formularios están listos para integración con backend
- Por ahora, usan simulación (setTimeout)
- Abre DevTools (F12) para ver logs

---

## ?? Próximos Pasos

1. **Backend Integration**
   - Conectar con Identity Service (puerto 8001)
   - Implementar envío de emails 2FA
   - Integrar Language Service (puerto 8002)

2. **Multi-idioma**
   - Traducir logo, subtítulo y texto promocional
   - Mantener formularios en inglés

3. **Despliegue**
   - Configurar Azure Front Door
   - DNS: www.svydledger.com
   - SSL/TLS

---

## ? ¡Listo para Probar!

Ejecuta:
```powershell
.\setup-welcomepage.ps1
```

O manualmente:
```powershell
cd frontend
npm run dev
```

?? Disfruta tu WelcomePage profesional!
