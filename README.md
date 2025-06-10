![logo](https://github.com/user-attachments/assets/50231124-d546-43cb-9cf4-7a06a1dad5bd)

# StreamFlow v2.0: Fresh From The Oven🔥

StreamFlow adalah aplikasi live streaming yang memungkinkan kamu untuk melakukan live streaming ke berbagai platform seperti YouTube, Facebook, dan platform lainnya menggunakan protokol RTMP. Aplikasi ini bisa berjalan di VPS (Virtual Private Server) atau di platform berbasis Docker seperti Phala Cloud, dan mendukung streaming ke banyak platform sekaligus.

![Untitled-2](https://github.com/user-attachments/assets/3d7bb367-a1b2-43a5-839b-b6aa8dd5de90)

## 🚀 Fitur Utama

- **Multi-Platform Streaming**: Mendukung streaming ke berbagai platform populer
- **Video Gallery**: Kelola koleksi video dengan mudah
- **Upload Video**: Upload video dari local atau import dari Google Drive
- **Scheduled Streaming**: Jadwalkan streaming dengan waktu tertentu
- **Advanced Settings**: Kontrol bitrate, resolution, FPS, dan orientasi
- **Real-time Monitoring**: Monitor status streaming secara real-time
- **Responsive UI**: Tampilan modern yang responsive di semua device

## 📋 Requirements

- **Node.js** v16 atau lebih baru (untuk instalasi manual)
- **FFmpeg** (diperlukan untuk streaming)
- **SQLite3** (sudah termasuk)
- **VPS/Server** dengan minimal 1 Core & 1GB RAM (untuk instalasi manual)
- **Docker** dan **Docker Compose** (untuk instalasi berbasis Docker)
- **Port** 7575 (dapat diubah di `.env`)

## 🛠️ Instalasi

StreamFlow dapat diinstal secara manual di VPS atau menggunakan Docker untuk deployment yang lebih mudah, termasuk di platform seperti Phala Cloud, Railway, atau lainnya yang mendukung Docker Compose.

### Pilihan 1: Instalasi Manual di VPS

#### 1. Persiapan VPS

Update sistem:

```bash
sudo apt update && sudo apt upgrade -y
```

Install Node.js:

```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
```

Verifikasi instalasi Node.js:

```bash
node --version
npm --version
```

Install FFmpeg:

```bash
sudo apt install ffmpeg -y
```

Verifikasi FFmpeg:

```bash
ffmpeg -version
```

Install Git:

```bash
sudo apt install git -y
```

#### 2. Setup Projek StreamFlow

Clone repository ke VPS:

```bash
git clone https://github.com/bangtutorial/streamflow
cd streamflow
```

Install dependencies:

```bash
npm install
```

Generate session secret:

```bash
npm run generate-secret
```

**Konfigurasi tambahan (opsional):**

Port default aplikasi adalah **7575**. Jika perlu ubah port, edit file `.env` (contoh: 8080, 3300, dll):

```bash
nano .env
```

#### 3. Setup Firewall

Buka port sesuai dengan yang ada di `.env` (default: 7575):

```bash
sudo ufw allow 7575
sudo ufw enable
sudo ufw status
```

#### 4. Install Process Manager (PM2)

Install PM2:

```bash
sudo npm install -g pm2
```

#### 5. Jalankan Aplikasi

Jalankan aplikasi dengan PM2:

```bash
pm2 start app.js --name streamflow
```

Akses aplikasi di `http://<IP_SERVER>:7575` (contoh: `http://88.12.34.56:7575`).

Buat username dan password di dashboard, lalu **Sign Out** dan restart aplikasi:

```bash
pm2 restart streamflow
```

### Pilihan 2: Instalasi Menggunakan Docker

StreamFlow mendukung deployment menggunakan Docker dan Docker Compose, cocok untuk VPS atau platform seperti Phala Cloud.

#### 1. Persiapan Docker

Pastikan Docker dan Docker Compose terinstal:

```bash
# Install Docker
sudo apt update
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

Verifikasi instalasi:

```bash
docker --version
docker-compose --version
```

#### 2. Clone Repository

```bash
git clone https://github.com/bangtutorial/streamflow
cd streamflow
```

#### 3. Buat Dockerfile

Buat file `Dockerfile` di direktori proyek:

```Dockerfile
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
```

#### 4. Buat docker-compose.yml

Buat file `docker-compose.yml` untuk deployment lokal atau di platform seperti Phala Cloud:

```yaml
services:
  streamflow:
    image: fitrianabila2025/streamflow:latest
    container_name: streamflow
    environment:
      - PORT=7575
      - TZ=Asia/Jakarta
    ports:
      - "7575:7575"
    volumes:
      - streamflow-data:/app/public/uploads
      - streamflow-db:/app/db
    restart: unless-stopped

volumes:
  streamflow-data:
  streamflow-db:
```

#### 5. Build dan Push Image ke Docker Hub

Build image:

```bash
docker-compose build
```

Login ke Docker Hub:

```bash
docker login
```

Push image:

```bash
docker push fitrianabila2025/streamflow:latest
```

**Catatan**: Pastikan repository `streamflow` sudah dibuat di akun Docker Hub Anda (`fitrianabila2025`).

#### 6. Deploy di VPS

Jalankan aplikasi:

```bash
docker-compose up -d
```

Akses di `http://<IP_SERVER>:7575`, buat username dan password, lalu restart:

```bash
docker-compose restart
```

#### 7. Deploy di Platform seperti Phala Cloud

- Login ke [Phala Cloud](https://phalacloud.app) atau platform serupa.
- Buat proyek baru dan unggah `docker-compose.yml` di atas.
- Jika diperlukan, atur environment variables di dashboard:
  ```
  PORT=7575
  TZ=Asia/Jakarta
  ```
- Deploy aplikasi. Phala Cloud akan menarik image `fitrianabila2025/streamflow:latest` dari Docker Hub.
- Akses aplikasi melalui URL yang diberikan (misalnya, `<app-id>.phalacloud.app:7575`).
- Buat username dan password, lalu restart aplikasi melalui dashboard atau CLI:
  ```bash
  docker-compose restart
  ```

## 📝 Informasi Tambahan

### Reset Password

Jika lupa password atau ingin reset:

Masuk ke folder aplikasi:

```bash
cd streamflow
```

Jalankan perintah reset password:

```bash
node reset-password.js
```

Untuk Docker:

```bash
docker exec streamflow node reset-password.js
```

### Setup Waktu Server (Timezone)

Untuk scheduled streaming yang akurat, atur timezone server ke zona waktu Anda:

#### 1. Cek Timezone Saat Ini

```bash
timedatectl status
```

#### 2. Lihat Daftar Timezone

Cari timezone Indonesia:

```bash
timedatectl list-timezones | grep Asia
```

Contoh set ke WIB (Jakarta):

```bash
sudo timedatectl set-timezone Asia/Jakarta
```

Verifikasi perubahan:

```bash
timedatectl status
```

Restart aplikasi:

```bash
pm2 restart streamflow
```

Untuk Docker:

```bash
docker-compose restart
```

## 🪛 Troubleshooting

### Permission Error

Fix izin folder uploads:

```bash
chmod -R 755 public/uploads/
```

Untuk Docker, pastikan direktori dibuat di `Dockerfile`.

### Port Already in Use

Cek proses yang menggunakan port:

```bash
sudo lsof -i :7575
```

Hentikan proses jika perlu:

```bash
sudo kill -9 <PID>
```

Untuk Docker, cek container yang berjalan:

```bash
docker ps
docker stop <container_id>
```

### Database Error

Reset database (HATI-HATI: menghapus semua data):

```bash
rm db/*.db
```

Untuk Docker:

```bash
docker-compose down -v
docker-compose up -d
```

### Docker-Specific Issues

- **Image Not Found**: Pastikan `fitrianabila2025/streamflow:latest` sudah di-push ke Docker Hub.
- **Build Fails**: Verifikasi semua file proyek (`package.json`, `app.js`) ada di direktori.
- **Port Not Accessible**: Ubah port di `docker-compose.yml` jika 7575 diblokir (misalnya, `- "80:7575"`).

© 2025 - [fitrianabila2025](https://github.com/fitrianabila2025/StreamFlow)
