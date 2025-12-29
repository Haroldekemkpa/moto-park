# ---- Base Image ----
FROM node:18-alpine

# ---- Set working directory inside container ----
WORKDIR /usr/src/app

# ---- Copy package files and install only production dependencies ----
COPY package*.json ./
RUN npm ci --only=production

# ---- Copy source code ----
COPY src ./src

# ---- Environment ----
ENV NODE_ENV=production
ENV PORT=4006

# ---- Expose service port ----
EXPOSE 4006

# ---- Start the app ----
CMD ["node", "src/server.js"]
