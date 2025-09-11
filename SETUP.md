# Deployment Setup Instructions

## Prerequisites
- SSH access to DigitalOcean server: `ssh -i "vast" root@159.203.103.160`
- Docker Swarm initialized on server
- GitHub access for updates

## Initial Setup

1. **Clone this repository to the server:**
   ```bash
   git clone https://github.com/StevenVincentOne/inti-digitalocean-deployment-config.git
   cd inti-digitalocean-deployment-config
   ```

2. **Copy SSL certificates from backup:**
   ```bash
   # Copy from local backup or re-download from IONOS
   cp /path/to/ssl/certs/* ssl-certificates/
   ```

3. **Setup environment variables:**
   ```bash
   cp .env.template .env
   # Edit .env and add your actual Groq API key:
   # GROQ_API_KEY=your_actual_groq_api_key_here
   ```

4. **Update YAML files with actual API key:**
   ```bash
   sed -i 's/YOUR_GROQ_API_KEY_HERE/your_actual_groq_api_key_here/g' swarm-configs/*.yml
   ```

## Deployment

1. **Deploy the stack:**
   ```bash
   docker stack deploy -c swarm-configs/swarm-deploy-fixed-ssl.yml unmute
   ```

2. **Verify deployment:**
   ```bash
   docker service ls
   curl -s https://inti.intellipedia.ai/api/v1/health
   ```

## Updating Configuration

1. **Make changes to configuration files**
2. **Commit and push to GitHub:**
   ```bash
   git add .
   git commit -m "Update deployment config"
   git push
   ```

3. **Pull updates on server:**
   ```bash
   git pull origin main
   docker stack deploy -c swarm-configs/swarm-deploy-fixed-ssl.yml unmute
   ```

## Important Notes

- SSL certificates are not stored in the repository for security
- API keys are templated and must be filled in manually
- Always test changes in a staging environment first
- Keep this repository private if it contains sensitive configuration details