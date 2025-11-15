# Dockerfile para servicios Node.js (Accounting, Reports, Payments)
# Multi-stage build para optimizar tamaño

FROM node:20-alpine as builder

WORKDIR /app

# Copiar package files
COPY package*.json ./
COPY tsconfig.json ./

# Instalar dependencias (cambio a npm install)
RUN npm install

# Copiar código fuente
COPY src ./src

# Copiar directorio prisma si existe (solo para el servicio de contabilidad)
COPY prisma* ./prisma/ 2>/dev/null || mkdir -p prisma

# Generar Prisma Client si existe el esquema
RUN if [ -f "prisma/schema.prisma" ]; then npx prisma generate; fi

# Build TypeScript
RUN npm run build

# Etapa final
FROM node:20-alpine

WORKDIR /app

# Instalar curl para health checks
RUN apk add --no-cache curl

# Copiar package files
COPY package*.json ./

# Instalar solo dependencias de producción
RUN npm install --production

# Copiar archivos compilados y prisma
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma 2>/dev/null || true
COPY --from=builder /app/prisma ./prisma 2>/dev/null || true

# Crear usuario no-root
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

USER nodejs

# Exponer puerto
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# Comando de inicio
CMD ["node", "dist/index.js"]
