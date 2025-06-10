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

StreamFlow dapat diinstal secara manual di VPS atau menggunakan Docker untuk deployment yang lebih mudah, termasuk di platform seperti Phala Cloud yang mendukung Docker Compose.

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
git clone https://github.com/fitrianabila2025/StreamFlow
cd StreamFlow
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

StreamFlow mendukung deployment menggunakan Docker, baik melalui perintah `docker run` untuk VPS sederhana atau `docker-compose` untuk platform seperti Phala Cloud.

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

#### 2. Deploy Menggunakan docker run

Jalankan container menggunakan image `fitrianabila2025/streamflow:latest`:

```bash
docker run -d \
  --name streamflow \
  -p 7575:7575 \
  -e PORT=7575 \
  -e TZ=Asia/Jakarta \
  -v streamflow-data:/app/public/uploads \
  -v streamflow-db:/app/db \
  --restart unless-stopped \
  fitrianabila2025/streamflow:latest
```

Akses aplikasi di `http://<IP_SERVER>:7575`, buat username dan password, lalu restart container:

```bash
docker restart streamflow
```

#### 3. Deploy Menggunakan Docker Compose

Buat file `docker-compose.yml` di direktori proyek:

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

Jalankan aplikasi:

```bash
docker-compose up -d
```

Akses di `http://<IP_SERVER>:7575`, buat username dan password, lalu restart:

```bash
docker-compose restart
```

#### 4. Deploy di Platform seperti Phala Cloud

- Login ke [Phala Cloud](https://cloud.phala.network/) atau platform serupa.
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
cd StreamFlow
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

Untuk Docker, pastikan volume memiliki izin yang sesuai:

```bash
docker volume inspect streamflow-data
```

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

- **Image Not Found**: Pastikan `fitrianabila2025/streamflow:latest` tersedia di Docker Hub.
- **Port Not Accessible**: Jika port 7575 diblokir, ubah di `docker-compose.yml` (misalnya, `- "80:7575"`) atau cek pengaturan firewall platform.
- **Container Exits**: Periksa log untuk error:
  ```bash
  docker logs streamflow
  ```

## Lisensi

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/fitrianabila2025/StreamFlow/blob/main/LICENSE)

© 2025 - [Fitri Anabila](https://github.com/fitrianabila2025) | Berdasarkan karya asli [Bang Tutorial](https://youtube.com/bangtutorial)
