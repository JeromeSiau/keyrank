FROM node:20-slim

# Install Chromium for Crawlee (if needed later)
RUN apt-get update && apt-get install -y \
    chromium \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY dist/ ./dist/

ENV PORT=3001
EXPOSE 3001

CMD ["node", "dist/index.js"]
