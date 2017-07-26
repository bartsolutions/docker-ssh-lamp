# A minimal configuration to set up a docker with Ubuntu 16.04 + SSH access + LAMP
### How to Use:
1. Modify `Dockerfile` to set up password for SSH
1. Execute: `docker-compose up -d` (remove `-d` for foreground mode)
2. Log into server: `ssh root@localhost -p 2022`
2. Set up root password for mysql: `mysqladmin -u root password '<NEW_PASSWORD>'`
