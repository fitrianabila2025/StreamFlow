FROM node:22-slim
WORKDIR /app
RUN apt-get update && apt-get install -y \
    ffmpeg \
    git \
    && rm -rf /var/lib/apt/lists/*
COPY package*.json ./
RUN npm install
RUN npm install -g pm2
COPY . .
RUN npm run generate-secret
RUN mkdir -p public/uploads && chmod -R 755 public/uploads
EXPOSE 7575
CMD ["pm2-runtime", "app.js", "--name", "streamflow"]
