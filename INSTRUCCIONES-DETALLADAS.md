# ?? SVYD LEDGER - Instrucciones Paso a Paso (Para Principiantes)

## ?? Objetivo
Instalar Node.js, ejecutar el servidor de desarrollo y ver la página de bienvenida en tu navegador.

---

## ?? Tiempo Estimado: 15-20 minutos

---

## ?? PASO 1: Descargar Node.js

### Acción:
1. Abre tu navegador web (Chrome, Edge, Firefox)
2. Ve a esta dirección: **https://nodejs.org/**
3. Verás DOS botones verdes grandes
4. Haz clic en el botón de la **IZQUIERDA** que dice:
   - "20.x.x LTS" (Recommended For Most Users)
   - O el que diga "LTS" (Long Term Support)

### ¿Qué estás descargando?
Un archivo llamado algo como: `node-v20.11.0-x64.msi` (el número puede variar)

### Espera a que termine la descarga
- Verás el archivo en tu carpeta de Descargas
- Tamaño aproximado: 30-40 MB

---

## ?? PASO 2: Instalar Node.js

### Acción:
1. Ve a tu carpeta de **Descargas**
2. Busca el archivo que acabas de descargar (`.msi`)
3. Haz **doble clic** en el archivo
4. Si Windows pregunta "¿Quieres permitir que esta aplicación haga cambios?", haz clic en **Sí**

### Durante la instalación:
1. Pantalla 1: Haz clic en **Next**
2. Pantalla 2: Acepta los términos (checkbox) y haz clic en **Next**
3. Pantalla 3: Deja la carpeta por defecto, haz clic en **Next**
4. Pantalla 4: **MUY IMPORTANTE**
   - Verás una opción que dice:
   - "Automatically install the necessary tools"
   - ? **Marca esta casilla** (muy importante)
   - Haz clic en **Next**
5. Pantalla 5: Haz clic en **Install**
6. Espera 2-3 minutos mientras se instala
7. Pantalla final: Haz clic en **Finish**

### Después de hacer clic en Finish:
- Se abrirá una ventana negra (PowerShell)
- Dirá algo como "Installing additional tools"
- **NO CIERRES ESTA VENTANA**
- Espera hasta que termine (puede tomar 5-10 minutos)
- Cuando termine, puedes cerrar la ventana

---

## ?? PASO 3: Reiniciar Visual Studio Code

### ¿Por qué?
Para que VS Code reconozca que Node.js está instalado.

### Acción:
1. En Visual Studio Code, ve al menú **File** (arriba a la izquierda)
2. Haz clic en **Exit** (o presiona Alt+F4)
3. Espera 5 segundos
4. Abre Visual Studio Code de nuevo

---

## ?? PASO 4: Verificar que Node.js está instalado

### Acción:
1. En Visual Studio Code, presiona **Ctrl + `** (la tecla arriba de Tab)
   - Esto abrirá la Terminal en la parte inferior
2. En la terminal, escribe (o copia y pega):
   ```
   node --version
   ```
3. Presiona **Enter**

### ¿Qué deberías ver?
Algo como: `v20.11.0` (el número puede variar)

### Si ves el número:
? ¡Perfecto! Node.js está instalado correctamente

### Si dice "no se reconoce el comando":
? Repite el Paso 3 (cerrar y abrir VS Code)
? Si sigue sin funcionar, reinicia tu computadora

---

## ?? PASO 5: Instalar las dependencias del proyecto

### Acción:
1. En la Terminal de VS Code (la ventana negra abajo)
2. Escribe (o copia y pega):
   ```
   cd frontend
   ```
3. Presiona **Enter**
4. Ahora escribe:
   ```
   npm install
   ```
5. Presiona **Enter**

### ¿Qué está pasando?
- npm está descargando e instalando todas las librerías que el proyecto necesita
- Verás muchos mensajes pasando rápidamente
- Esto puede tomar **5-10 minutos**

### ¿Qué deberías ver?
- Líneas de texto pasando
- Barras de progreso
- Al final: "added 1234 packages" (el número varía)

### ?? ¿Ves errores en rojo?
- Si son **"WARN"**: No te preocupes, son solo advertencias
- Si son **"ERR!"**: Avísame y te ayudo

---

## ?? PASO 6: Iniciar el servidor de desarrollo

### Acción:
1. En la Terminal (debería estar en `frontend`), escribe:
   ```
   npm run dev
   ```
2. Presiona **Enter**

### ¿Qué está pasando?
- El servidor de desarrollo se está iniciando
- Va a compilar todo el código de React

### ¿Qué deberías ver?
Algo como:
```
  VITE v5.0.11  ready in 1234 ms

  ?  Local:   http://localhost:3000/
  ?  Network: http://192.168.1.100:3000/
  ?  press h to show help
```

### ? Si ves esto:
¡Perfecto! El servidor está corriendo

---

## ?? PASO 7: Abrir la página en tu navegador

### Opción 1: Hacer clic en el enlace
1. En VS Code, mantén presionada la tecla **Ctrl**
2. Haz clic en el enlace `http://localhost:3000/`
3. Se abrirá en tu navegador

### Opción 2: Copiar y pegar
1. Abre tu navegador (Chrome, Edge, Firefox)
2. En la barra de direcciones, escribe:
   ```
   http://localhost:3000
   ```
3. Presiona Enter

---

## ?? PASO 8: ¡Disfruta la página!

### ¿Qué deberías ver?

1. **Fondo**: Una hermosa imagen del cielo azul con nubes blancas
2. **Logo**: "Svyd" en letras grandes y elegantes (blancas)
3. **Subtítulo**: "Sistema de Contabilidad Universal"
4. **Párrafo**: Descripción del sistema
5. **Selector de idioma**: Combo con 27 idiomas
6. **Dos formularios**:
   - Izquierda: "Sign in" (Iniciar sesión)
   - Derecha: "Sign up" (Crear cuenta)

### Prueba las funciones:
- ? Cambia el idioma en el selector
- ? Escribe en los campos de Email y Password
- ? Haz clic en "¿Forgot your password?"
- ? Intenta hacer clic en "Log in" o "Create Account"
- ? Ve el cuadro de diálogo de verificación de dos pasos

---

## ?? Para detener el servidor

### Cuando quieras parar el servidor:
1. Ve a la Terminal en VS Code
2. Presiona **Ctrl + C**
3. Si pregunta algo, escribe **Y** y presiona Enter

---

## ?? Para volver a iniciar el servidor

### La próxima vez que quieras ver la página:
1. Abre Visual Studio Code
2. Abre la Terminal (**Ctrl + `**)
3. Escribe:
   ```
   cd frontend
   npm run dev
   ```
4. Abre el navegador en `http://localhost:3000`

---

## ?? ¡FELICIDADES!

Has completado la configuración del frontend de SVYD LEDGER.

---

## ?? Problemas Comunes

### Problema 1: "node no se reconoce como comando"
**Solución**:
1. Cierra VS Code completamente
2. Abre VS Code de nuevo
3. Si sigue sin funcionar, reinicia tu computadora

### Problema 2: "Puerto 3000 ya está en uso"
**Solución**:
1. Presiona **Ctrl + C** en la terminal para detener cualquier servidor
2. Espera 5 segundos
3. Intenta `npm run dev` de nuevo

### Problema 3: La página no carga
**Solución**:
1. Verifica que el servidor esté corriendo (deberías ver mensajes en la terminal)
2. Verifica la URL: debe ser exactamente `http://localhost:3000`
3. Intenta refrescar la página (**F5** o **Ctrl + R**)

### Problema 4: No veo las imágenes de fondo
**Solución**:
1. Verifica que las 5 imágenes estén en:
   ```
   C:\Users\svcon\Desktop\SVYDDATALEDGER\frontend\public\images\backgrounds\
   ```
2. Las imágenes deben llamarse:
   - background-1.png.png
   - background-2.png.png
   - etc.

---

## ?? Si necesitas ayuda

Avísame en qué paso estás y qué error o mensaje ves en la pantalla.

---

## ? Checklist Final

Marca cada paso cuando lo completes:

- [ ] PASO 1: Descargar Node.js desde nodejs.org
- [ ] PASO 2: Instalar Node.js (marca "install additional tools")
- [ ] PASO 3: Reiniciar VS Code
- [ ] PASO 4: Verificar con `node --version`
- [ ] PASO 5: Ejecutar `npm install` en frontend
- [ ] PASO 6: Ejecutar `npm run dev`
- [ ] PASO 7: Abrir http://localhost:3000 en el navegador
- [ ] PASO 8: ¡Ver la página de bienvenida funcionando!

---

**Tiempo Total Estimado**: 15-20 minutos  
**Dificultad**: ? Fácil (paso a paso)  
**Prerequisitos**: Ninguno (todo se explica)

**¡Mucha suerte! ??**
