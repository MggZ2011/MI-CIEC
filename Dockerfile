# ---- Etapa 1: Compilación (Build) ----
# Usamos una imagen oficial de Node.js como base. 'alpine' es una versión ligera.
FROM node:20-alpine as builder

# Establecemos el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiamos package.json y package-lock.json para instalar dependencias
COPY package*.json ./
RUN npm install

# Copiamos el resto del código fuente de la aplicación
COPY . .

# Ejecutamos el script de compilación de Vite
RUN npm run build

# ---- Etapa 2: Servidor (Server) ----
# Usamos Nginx, un servidor web ligero y eficiente, para servir los archivos estáticos.
FROM nginx:stable-alpine

# Copiamos los archivos compilados desde la etapa 'builder' al directorio web de Nginx
# El resultado de 'npm run build' en Vite está en la carpeta 'dist'
COPY --from=builder /app/dist /usr/share/nginx/html

# Copiamos nuestro archivo de configuración personalizado de Nginx
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Exponemos el puerto 80 para que el servidor Nginx sea accesible
EXPOSE 80

# Comando para iniciar Nginx cuando el contenedor se ejecute
CMD ["nginx", "-g", "daemon off;"]