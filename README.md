# Inti Project - DigitalOcean Deployment Configuration Archive

This archive contains all deployment configuration files for the Inti project running on DigitalOcean.

## Server Information
- **Host**: 159.203.103.160
- **SSH**: `ssh -i "vast" root@159.203.103.160`
- **Platform**: DigitalOcean CPU Optimized (8 vCPUs, 16GB RAM)
- **Last Archived**: September 11, 2025

## Directory Structure

### `/ssl-certificates/`
SSL certificates from IONOS for `inti.intellipedia.ai`:
- `inti.intellipedia.ai.crt` - Main certificate file
- `inti.intellipedia.ai.key` - Private key file (NOT IN REPO - copy from server)
- `fullchain.pem` - Full certificate chain (NOT IN REPO - copy from server)
- `privkey.pem` - Private key in PEM format (NOT IN REPO - copy from server)
- `tls.yml` - Traefik TLS configuration for IONOS certificates

### `/swarm-configs/`
Docker Swarm deployment configurations:
- `swarm-deploy-fixed-ssl.yml` - **ACTIVE** deployment config with IONOS SSL
- `swarm-deploy-manual-ssl.yml` - Manual SSL variant (older)
- `swarm-deploy-groq.yml` - Original Groq integration (older)
- `traefik.yml` - Basic Traefik TLS config
- `.env.template` - Environment variables template (copy to .env and fill in API keys)

### `/scripts/`
Deployment and maintenance scripts:
- `docker-entrypoint.sh` - Docker container entrypoint
- `run_stt_probe.sh` - STT service health check
- `test_stt.sh` - STT testing script
- `update_stt_service.sh` - STT service update script

## Current Stack Services

```bash
ID             NAME                          MODE         REPLICAS   IMAGE
scr8pzjiyshg   unmute_backend                replicated   1/1        intellipedia/inti-backend:latest
ukn23vdrrnax   unmute_frontend               replicated   1/1        intellipedia/inti-frontend:v15.5-enhanced
fdyqj2qgskhu   unmute_traefik                replicated   1/1        intellipedia/inti-traefik:v3.3.1
orwlugwx96oz   unmute_unmute                 replicated   1/1        intellipedia/unmute-websocket:v2
4nmsqj597mnc   unmute_unmute_llm             replicated   1/1        intellipedia/inti-llm-groq-proxy:v1.1
tbxftrlh0lfa   unmute_unmute_stt             replicated   1/1        inti-stt-groq-bridge-v2:latest
raduoy7kj5xs   unmute_unmute_tts             replicated   1/1        inti-tts-groq-bridge-v2:latest
rw8rok3fzxda   unmute_unmute_voice_cloning   replicated   1/1        nginx:alpine
```

## Key Notes

1. **SSL Configuration**: Currently using IONOS SSL certificates (working properly)
2. **Groq Integration**: All AI services (STT, LLM, TTS) proxy to Groq.ai API
3. **Active Config**: `swarm-deploy-fixed-ssl.yml` is the current production deployment
4. **Domain**: Production runs at `inti.intellipedia.ai`

## Deployment Command

```bash
docker stack deploy -c swarm-deploy-fixed-ssl.yml unmute
```

---
*Archive created: September 11, 2025*
*Source: DigitalOcean server root@159.203.103.160*