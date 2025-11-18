# ?? SVYD LEDGER - Font Configuration

## Vladimir Script Font Issue

?? **Important**: La fuente "Vladimir Script" que solicitaste es una fuente de sistema de Windows que no está disponible en Google Fonts.

## Solución Implementada

He usado la fuente **"Carattere"** de Google Fonts, que es muy similar a Vladimir Script:
- ? Estilo caligráfico elegante
- ? Apariencia profesional
- ? Disponible en Google Fonts (carga automática)
- ? Compatible con todos los navegadores
- ? Sin necesidad de archivos locales

## ?? Si quieres usar Vladimir Script exactamente

### Opción 1: Usar fuente del sistema (solo funciona en Windows)

Edita el archivo `frontend/src/pages/auth/WelcomePage.scss`:

```scss
.logo {
  font-family: 'Vladimir Script', cursive !important;
  // ...resto del código
}

.subtitle {
  font-family: 'Vladimir Script', cursive !important;
  // ...resto del código
}
```

**Limitaciones**:
- ? Solo funciona si el usuario tiene Windows
- ? No funcionará en Mac, Linux, o móviles
- ? No es profesional para un sitio web público

### Opción 2: Convertir Vladimir Script a Web Font

Si realmente necesitas usar Vladimir Script:

1. **Encuentra el archivo de fuente** en tu sistema Windows:
   ```
   C:\Windows\Fonts\vladimir.ttf
   ```

2. **Convierte la fuente** a formato web:
   - Ve a: https://transfonter.org/
   - Sube `vladimir.ttf`
   - Descarga el paquete convertido (woff, woff2)

3. **Agrega la fuente al proyecto**:
   
   Crea `frontend/public/fonts/vladimir-script/vladimir.woff2`
   
   Luego edita `frontend/src/pages/auth/WelcomePage.scss`:
   ```scss
   @font-face {
     font-family: 'Vladimir Script';
     src: url('/fonts/vladimir-script/vladimir.woff2') format('woff2');
     font-weight: normal;
     font-style: normal;
   }
   
   .logo {
     font-family: 'Vladimir Script', cursive !important;
   }
   ```

**?? Consideración Legal**: Asegúrate de tener los derechos para usar Vladimir Script en un sitio web comercial.

## ?? Recomendación

**Mantener "Carattere"** porque:
- ? Es gratuita y libre de licencias
- ? Funciona en todos los dispositivos
- ? Carga rápido desde Google CDN
- ? Tiene un estilo muy similar
- ? Es profesional para producción

## ?? Fuentes Alternativas (Similar a Vladimir Script)

Si no te gusta "Carattere", estas son alternativas similares disponibles en Google Fonts:

1. **Tangerine** - Muy elegante
2. **Great Vibes** - Estilo caligráfico
3. **Allura** - Cursiva elegante
4. **Parisienne** - Estilo francés
5. **Sacramento** - Manuscrita elegante

### Para cambiar la fuente:

Edita `frontend/src/pages/auth/WelcomePage.scss`:

```scss
// En la línea 1, cambia:
@import url('https://fonts.googleapis.com/css2?family=Carattere&display=swap');

// Por ejemplo, para usar Tangerine:
@import url('https://fonts.googleapis.com/css2?family=Tangerine:wght@400;700&display=swap');

// Y luego en .logo y .subtitle:
font-family: 'Tangerine', cursive !important;
```

## ??? Vista Previa de Fuentes

Puedes previsualizar todas las fuentes en:
https://fonts.google.com/?category=Handwriting

Busca en la categoría "Handwriting" para fuentes similares a Vladimir Script.

## ? Estado Actual

**Fuente Actual**: Carattere  
**Tamaños**:
- Logo: 72px (48px en móvil)
- Subtitle: 36px (24px en móvil)

**Color**: Blanco (#ffffff)  
**Peso**: Bold (700)  
**Efectos**: Text-shadow para mejor legibilidad sobre la imagen de fondo

---

**Nota**: Si decides cambiar la fuente, avísame y te ayudaré a implementarla correctamente.
