#!/usr/bin/env bash
set -euo pipefail

# Ensure probe script exists on server at /root/ws_probe.py
if [ ! -f /root/ws_probe.py ]; then
  echo "/root/ws_probe.py not found" >&2
  exit 1
fi

# Create/update docker config for probe script
docker config rm stt_ws_probe >/dev/null 2>&1 || true
docker config create stt_ws_probe /root/ws_probe.py >/dev/null

# Recreate probe service on overlay network
docker service rm stt_probe >/dev/null 2>&1 || true

docker service create \
  --name stt_probe \
  --network unmute-net \
  --restart-condition=none \
  --config-add source=stt_ws_probe,target=/ws_probe.py,mode=0444 \
  python:3.12-slim \
  bash -lc "pip install --no-cache-dir websockets numpy >/dev/null 2>&1; python /ws_probe.py"

sleep 10

echo '--- stt_probe logs ---'
docker service logs stt_probe --raw --tail 200 | cat || true

echo

echo '--- stt bridge logs ---'
docker service logs unmute_unmute_stt --tail 120 | cat || true

echo

echo '--- unmute stt connect lines ---'
docker service logs unmute_unmute --tail 200 | grep -n "Connecting to STT" || true

# Cleanup probe service
docker service rm stt_probe >/dev/null 2>&1 || true
