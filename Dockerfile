# Stage 1: Build app
FROM --platform=linux/amd64 node:18.10-alpine as build

WORKDIR /app

COPY package.json package-lock.json ./


RUN npm install


COPY . .

RUN NODE_OPTIONS="--max-old-space-size=1400" npm run build


# Stage 2: Run app
FROM --platform=linux/amd64 node:18.20-alpine

WORKDIR /app

# Copy từ stage build
COPY --from=build /app/dist ./dist
COPY --from=build /app/package.json ./
COPY --from=build /app/node_modules ./node_modules

EXPOSE 3000

CMD ["node", "dist/main.js"]
