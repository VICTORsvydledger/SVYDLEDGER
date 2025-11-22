# ?? VERIFICACIÓN VISUAL - BLOQUES POSTAUTH

**URL:** https://www.svconta.com  
**Página:** PostAuthPage (después de login/registro)  
**Fecha:** 2025-01-15

---

## ? CHECKLIST DE VERIFICACIÓN VISUAL

### Logo y Header
- [ ] Logo "Svyd" visible en fuente cursiva Vladimir Script
- [ ] Texto "Logged in as: {email}" debajo del logo
- [ ] Botón "Back to Welcome" en esquina superior izquierda
- [ ] Fondo azul degradado (background-3.png)

---

## ?? BLOQUE 1: CREAR USUARIO NUEVO

**Ubicación:** Izquierda arriba  

### Header
- [ ] Fondo amarillo (#FFFF00)
- [ ] Texto "Crear Usuario Nuevo"
- [ ] Font-weight 600

### Formulario
- [ ] Campo "Nombre" con fondo verde claro (#D4F1D4)
- [ ] Campo "Id" con fondo verde claro (#D4F1D4)
- [ ] Campo "Id Tributario" con fondo verde claro (#D4F1D4)
- [ ] Campo "País" con fondo verde claro (#D4F1D4)
- [ ] Campo "Moneda" con fondo verde claro (#D4F1D4)
- [ ] Campo "Idioma" con fondo verde claro (#D4F1D4)
- [ ] Todos los campos editables (input text)

### Botón de Pago
- [ ] Botón verde (#00FF00)
- [ ] Texto "Pagar registro de usuario nuevo"
- [ ] Borde negro (2px)
- [ ] Hover cambia a #00DD00

### Footer
- [ ] Fondo amarillo claro (#FFFFCC)
- [ ] Texto "Monto mínimo a pagar $10"

---

## ?? BLOQUE 2: COBRO CON STRIPE

**Ubicación:** Izquierda abajo

### Header
- [ ] Fondo azul claro (#ADD8E6)
- [ ] Texto "AQUÍ PARA COBRAR CON PASARELA STRIPE"
- [ ] Centrado

### Contenido
- [ ] Fondo azul claro (#ADD8E6)
- [ ] Campo "NOMBRE" con fondo blanco
- [ ] Campo "ID" con fondo blanco
- [ ] Bordes grises en campos

---

## ?? BLOQUE 3: LISTA DE USUARIOS

**Ubicación:** Derecha arriba

### Header con Botones
- [ ] Fondo amarillo (#FFFF00)
- [ ] Texto "Lista de Usuarios" a la izquierda
- [ ] 3 botones verdes a la derecha:
  - [ ] Botón "ENTRAR"
  - [ ] Botón "PAGAR"
  - [ ] Botón "SALDO"
- [ ] Todos los botones con borde negro (2px)

### Tabla
- [ ] Header de columna "NOMBRE" con fondo verde claro (#D4F1D4)
- [ ] Header de columna "ID" con fondo amarillo (#FFFF00)
- [ ] Header de columna "$" con fondo gris (#E8E8E8)
- [ ] 10 filas de datos
- [ ] Primera columna (NOMBRE) con fondo verde claro
- [ ] Segunda columna (ID) con fondo amarillo
- [ ] Tercera columna ($) con fondo gris
- [ ] Bordes negros entre celdas

---

## ?? BLOQUE 4: CORREOS Y PASSWORD

**Ubicación:** Derecha abajo

### Tabla Izquierda - Correos Autorizados
- [ ] Header amarillo (#FFFF00)
- [ ] Texto "CORREOS AUTORIZADOS"
- [ ] 8 filas con fondo blanco
- [ ] Bordes negros

### Tabla Derecha - Password
- [ ] Header amarillo (#FFFF00)
- [ ] Texto "PASSWORD"
- [ ] 8 filas con fondo blanco
- [ ] Bordes negros

### Layout
- [ ] Dos tablas lado a lado (grid 1fr 1fr)
- [ ] Sin gap entre tablas
- [ ] Misma altura

---

## ?? RESPONSIVE DESIGN

### Desktop (>1200px)
- [ ] 2 columnas visibles
- [ ] Bloques distribuidos: 2 izquierda, 2 derecha
- [ ] Gap de 2rem entre bloques
- [ ] Max-width: 1600px centrado

### Tablet (768px - 1200px)
- [ ] 1 columna (stack vertical)
- [ ] Bloques en orden: Crear Usuario ? Stripe ? Lista ? Correos/Password
- [ ] Padding reducido a 2rem

### Mobile (<768px)
- [ ] 1 columna completa
- [ ] Botones del header más pequeños
- [ ] Tablas con scroll horizontal si necesario

---

## ?? COLORES - REFERENCIA RÁPIDA

```
Headers principales:      #FFFF00 (amarillo brillante)
Botones de acción:        #00FF00 (verde brillante)
Campos de formulario:     #D4F1D4 (verde claro pastel)
Bloque Stripe:            #ADD8E6 (azul claro)
Aviso de pago mínimo:     #FFFFCC (amarillo muy claro)
Columna saldo:            #E8E8E8 (gris claro)
Fondo de bloques:         rgba(255, 255, 255, 0.95) (blanco semi-transparente)
Bordes:                   #000000 (negro)
Texto:                    #000000 (negro)
```

---

## ?? INTERACCIONES A PROBAR

### Formulario Crear Usuario
- [ ] Hacer clic en campo "Nombre" - debe activarse
- [ ] Escribir texto - debe aparecer en verde claro
- [ ] Repetir para todos los campos
- [ ] Hover sobre botón "Pagar" - debe cambiar color a #00DD00

### Botones Lista de Usuarios
- [ ] Hover sobre "ENTRAR" - debe cambiar color
- [ ] Hover sobre "PAGAR" - debe cambiar color
- [ ] Hover sobre "SALDO" - debe cambiar color
- [ ] (Click todavía no implementado)

### Botón Back to Welcome
- [ ] Hover - debe moverse 4px a la izquierda
- [ ] Debe tener glow blanco
- [ ] Click - debe volver a WelcomePage

---

## ?? PROBLEMAS POTENCIALES A VERIFICAR

### Layout
- [ ] ? Bloques no se superponen
- [ ] ? No hay scroll horizontal innecesario
- [ ] ? Espaciado consistente entre bloques
- [ ] ? Contenido no sale de los bloques

### Colores
- [ ] ? Amarillo es #FFFF00 (no #FFFF33 o similar)
- [ ] ? Verde es #00FF00 (no #00DD00 excepto en hover)
- [ ] ? Fondos verde claro son #D4F1D4

### Texto
- [ ] ? Todo el texto es legible
- [ ] ? No hay texto cortado
- [ ] ? Font-sizes correctos

### Tablas
- [ ] ? Headers visibles
- [ ] ? Filas alineadas correctamente
- [ ] ? Bordes visibles entre celdas

---

## ?? CAPTURAS DE PANTALLA RECOMENDADAS

Para documentación futura, tomar capturas de:

1. **Vista completa desktop** - Los 4 bloques visibles
2. **Bloque 1** - Formulario Crear Usuario completo
3. **Bloque 2** - Área de Stripe
4. **Bloque 3** - Tabla de usuarios con botones
5. **Bloque 4** - Tablas de correos y password
6. **Vista mobile** - Stack vertical de bloques
7. **Hover states** - Botones con efectos hover

---

## ? APROBACIÓN VISUAL

Una vez verificado todo:

- [ ] Todos los bloques visibles y funcionales
- [ ] Colores coinciden con diseño original
- [ ] Layout responsivo funciona
- [ ] Sin errores visuales
- [ ] Interacciones básicas funcionan

**Aprobado por:** _________________  
**Fecha:** _________________  

---

## ?? PRÓXIMA ITERACIÓN

Después de aprobar visualmente, proceder con:

1. **Integración Backend**
   - Conectar formulario con API
   - Cargar datos reales en tablas
   
2. **Integración Stripe**
   - Agregar Stripe SDK
   - Implementar elementos de pago

3. **Funcionalidad de Botones**
   - Implementar lógica de "ENTRAR"
   - Implementar lógica de "PAGAR"
   - Implementar lógica de "SALDO"

4. **Validaciones**
   - Validar campos de formulario
   - Mensajes de error
   - Confirmaciones de éxito

---

**Última actualización:** 2025-01-15  
**Versión:** 1.0.0
