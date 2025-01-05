FROM node:23.5.0 AS builder
FROM node:23.5.0-alpine
WORKDIR /app
COPY package.json package.json
COPY package-lock.json package-lock.json
RUN npm install
COPY . .
RUN npm run build
CMD ["npx", "-y", "http-server", "-p", "3000", "/app/build"]
