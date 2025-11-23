# ?? SVYD LEDGER - Instrucciones Paso a Paso (Para Principiantes)

## ?? Objetivo
Instalar Node.js, ejecutar el servidor de desarrollo y ver la p�gina de bienvenida en tu navegador.

---

## ?? Tiempo Estimado: 15-20 minutos

---

## ?? PASO 1: Descargar Node.js

### Acci�n:
1. Abre tu navegador web (Chrome, Edge, Firefox)
2. Ve a esta direcci�n: **https://nodejs.org/**
3. Ver�s DOS botones verdes grandes
4. Haz clic en el bot�n de la **IZQUIERDA** que dice:
   - "20.x.x LTS" (Recommended For Most Users)
   - O el que diga "LTS" (Long Term Support)

### �Qu� est�s descargando?
Un archivo llamado algo como: `node-v20.11.0-x64.msi` (el n�mero puede variar)

### Espera a que termine la descarga
- Ver�s el archivo en tu carpeta de Descargas
- Tama�o aproximado: 30-40 MB

---

## ?? PASO 2: Instalar Node.js

### Acci�n:
1. Ve a tu carpeta de **Descargas**
2. Busca el archivo que acabas de descargar (`.msi`)
3. Haz **doble clic** en el archivo
4. Si Windows pregunta "�Quieres permitir que esta aplicaci�n haga cambios?", haz clic en **S�**

### Durante la instalaci�n:
1. Pantalla 1: Haz clic en **Next**
2. Pantalla 2: Acepta los t�rminos (checkbox) y haz clic en **Next**
3. Pantalla 3: Deja la carpeta por defecto, haz clic en **Next**
4. Pantalla 4: **MUY IMPORTANTE**
   - Ver�s una opci�n que dice:
   - "Automatically install the necessary tools"
   - ? **Marca esta casilla** (muy importante)
   - Haz clic en **Next**
5. Pantalla 5: Haz clic en **Install**
6. Espera 2-3 minutos mientras se instala
7. Pantalla final: Haz clic en **Finish**

### Despu�s de hacer clic en Finish:
- Se abrir� una ventana negra (PowerShell)
- Dir� algo como "Installing additional tools"
- **NO CIERRES ESTA VENTANA**
- Espera hasta que termine (puede tomar 5-10 minutos)
- Cuando termine, puedes cerrar la ventana

---

## ?? PASO 3: Reiniciar Visual Studio Code

### �Por qu�?
Para que VS Code reconozca que Node.js est� instalado.

### Acci�n:
1. En Visual Studio Code, ve al men� **File** (arriba a la izquierda)
2. Haz clic en **Exit** (o presiona Alt+F4)
3. Espera 5 segundos
4. Abre Visual Studio Code de nuevo

---

## ?? PASO 4: Verificar que Node.js est� instalado

### Acci�n:
1. En Visual Studio Code, presiona **Ctrl + `** (la tecla arriba de Tab)
   - Esto abrir� la Terminal en la parte inferior
2. En la terminal, escribe (o copia y pega):
   ```
   node --version
   ```
3. Presiona **Enter**

### �Qu� deber�as ver?
Algo como: `v20.11.0` (el n�mero puede variar)

### Si ves el n�mero:
? �Perfecto! Node.js est� instalado correctamente

### Si dice "no se reconoce el comando":
? Repite el Paso 3 (cerrar y abrir VS Code)
? Si sigue sin funcionar, reinicia tu computadora

---

## ?? PASO 5: Instalar las dependencias del proyecto

### Acci�n:
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

### �Qu� est� pasando?
- npm est� descargando e instalando todas las librer�as que el proyecto necesita
- Ver�s muchos mensajes pasando r�pidamente
- Esto puede tomar **5-10 minutos**

### �Qu� deber�as ver?
- L�neas de texto pasando
- Barras de progreso
- Al final: "added 1234 packages" (el n�mero var�a)

### ?? �Ves errores en rojo?
- Si son **"WARN"**: No te preocupes, son solo advertencias
- Si son **"ERR!"**: Av�same y te ayudo

---

## ?? PASO 6: Iniciar el servidor de desarrollo

### Acci�n:
1. En la Terminal (deber�a estar en `frontend`), escribe:
   ```
   npm run dev
   ```
2. Presiona **Enter**

### �Qu� est� pasando?
- El servidor de desarrollo se est� iniciando
- Va a compilar todo el c�digo de React

### �Qu� deber�as ver?
Algo como:
```
  VITE v5.0.11  ready in 1234 ms

  ?  Local:   http://localhost:3000/
  ?  Network: http://192.168.1.100:3000/
  ?  press h to show help
```

### ? Si ves esto:
�Perfecto! El servidor est� corriendo

---

## ?? PASO 7: Abrir la p�gina en tu navegador

### Opci�n 1: Hacer clic en el enlace
1. En VS Code, mant�n presionada la tecla **Ctrl**
2. Haz clic en el enlace `http://localhost:3000/`
3. Se abrir� en tu navegador

### Opci�n 2: Copiar y pegar
1. Abre tu navegador (Chrome, Edge, Firefox)
2. En la barra de direcciones, escribe:
   ```
   http://localhost:3000
   ```
3. Presiona Enter

---

## ?? PASO 8: �Disfruta la p�gina!

### �Qu� deber�as ver?

1. **Fondo**: Una hermosa imagen del cielo azul con nubes blancas
2. **Logo**: "Svyd" en letras grandes y elegantes (blancas)
3. **Subt�tulo**: "Sistema de Contabilidad Universal"
4. **P�rrafo**: Descripci�n del sistema
5. **Selector de idioma**: Combo con 27 idiomas
6. **Dos formularios**:
   - Izquierda: "Sign in" (Iniciar sesi�n)
   - Derecha: "Sign up" (Crear cuenta)

### Prueba las funciones:
- ? Cambia el idioma en el selector
- ? Escribe en los campos de Email y Password
- ? Haz clic en "�Forgot your password?"
- ? Intenta hacer clic en "Log in" o "Create Account"
- ? Ve el cuadro de di�logo de verificaci�n de dos pasos

---

## ?? Para detener el servidor

### Cuando quieras parar el servidor:
1. Ve a la Terminal en VS Code
2. Presiona **Ctrl + C**
3. Si pregunta algo, escribe **Y** y presiona Enter

---

## ?? Para volver a iniciar el servidor

### La pr�xima vez que quieras ver la p�gina:
1. Abre Visual Studio Code
2. Abre la Terminal (**Ctrl + `**)
3. Escribe:
   ```
   cd frontend
   npm run dev
   ```
4. Abre el navegador en `http://localhost:3000`

---

## ?? �FELICIDADES!

Has completado la configuraci�n del frontend de SVYD LEDGER.

---

## ?? Problemas Comunes

### Problema 1: "node no se reconoce como comando"
**Soluci�n**:
1. Cierra VS Code completamente
2. Abre VS Code de nuevo
3. Si sigue sin funcionar, reinicia tu computadora

### Problema 2: "Puerto 3000 ya est� en uso"
**Soluci�n**:
1. Presiona **Ctrl + C** en la terminal para detener cualquier servidor
2. Espera 5 segundos
3. Intenta `npm run dev` de nuevo

### Problema 3: La p�gina no carga
**Soluci�n**:
1. Verifica que el servidor est� corriendo (deber�as ver mensajes en la terminal)
2. Verifica la URL: debe ser exactamente `http://localhost:3000`
3. Intenta refrescar la p�gina (**F5** o **Ctrl + R**)

### Problema 4: No veo las im�genes de fondo
**Soluci�n**:
1. Verifica que las 5 im�genes est�n en:
   ```
   C:\Users\svcon\Desktop\SVYDDATALEDGER\frontend\public\images\backgrounds\
   ```
2. Las im�genes deben llamarse:
   - background-1.png.png
   - background-2.png.png
   - etc.

---

## ?? Si necesitas ayuda

Av�same en qu� paso est�s y qu� error o mensaje ves en la pantalla.

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
- [ ] PASO 8: �Ver la p�gina de bienvenida funcionando!

---

**Tiempo Total Estimado**: 15-20 minutos  
**Dificultad**: ? F�cil (paso a paso)  
**Prerequisitos**: Ninguno (todo se explica)

**�Mucha suerte! ??**
