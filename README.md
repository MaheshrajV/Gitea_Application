# Gitea + PostgreSQL with Docker Compose

This setup runs [Gitea](https://gitea.io/) (self-hosted Git service) with a PostgreSQL database using Docker Compose.  
It uses Docker health checks so Gitea only starts after the database is ready.

---

## 🚀 Quick Start

### 1. Clone this repo (or copy files)
git clone https://github.com/your-repo/gitea-docker.git
cd gitea-docker

2. Start the stack
docker compose up -d

4. Access Gitea
Web UI: http://localhost:3000
SSH Git: ssh://git@localhost:222

⚙️ Services
PostgreSQL (gitea_db)
Image: postgres:15

Database: gitea

User: gitea

Password: gitea

Data stored in ./postgres

Gitea (gitea)
Image: gitea/gitea:1.22.0-rootless
Data stored in ./gitea

Ports:
3000 → Web UI
222 → SSH

🔑 Initial Web Setup
When you first open http://localhost:3000, fill in:

Database Settings

Type: PostgreSQL
Host: gitea_db:5432
Name: gitea
User: gitea
Password: gitea
General Settings
Repository Root: /data/git/repositories
SSH Port: 222
App URL: http://localhost:3000/

Admin Account
Username: choose one (e.g. admin)
Password: set a strong password
Email: your email
Click Install Gitea → login with your new admin account.

📂 Volumes
./postgres → PostgreSQL data
./gitea → Gitea repositories and configuration (app.ini)
Both directories persist data across container restarts.

🛠️ Useful Commands
Check logs:
docker compose logs -f gitea
docker compose logs -f gitea_db

Restart:
docker compose restart

Stop:
docker compose down
Stop + remove data:

docker compose down -v
🔐 Production Notes
For public access, put Gitea behind an Nginx/Traefik reverse proxy with HTTPS.

Change default DB password in docker-compose.yml.
Consider backups of ./postgres and ./gitea.

