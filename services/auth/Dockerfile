FROM node:18-alpine

WORKDIR /app

# Copy package files from current context (auth service)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy ALL auth service code (index.js, src, etc.)
COPY . .

EXPOSE 3001

CMD ["npm", "run", "dev"]
