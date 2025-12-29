FROM node:18-alpine
WORKDIR /app
COPY services/booking/package*.json ./
RUN npm install
COPY services/booking/src ./src
EXPOSE 3000
CMD ["node", "src/index.js"]
