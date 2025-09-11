#!/usr/bin/env bash
set -euo pipefail
KEY=$(docker service inspect -f '{{json .Spec.TaskTemplate.ContainerSpec.Env}}' unmute_unmute | tr -d '[]"' | tr , '\n' | grep '^OPENAI_API_KEY=' | cut -d= -f2-)
: "${KEY:?missing OPENAI_API_KEY from unmute service}"

docker service rm unmute_unmute_stt >/dev/null 2>&1 || true

docker service create \
  --name unmute_unmute_stt \
  --network unmute-net \
  --env OPENAI_API_KEY="$KEY" \
  --env GROQ_API_KEY="$KEY" \
  --env GROQ_STT_MODEL=whisper-large-v3-turbo \
  intellipedia/inti-stt-groq-bridge:latest >/dev/null

docker service ps unmute_unmute_stt --no-trunc | cat
sleep 3
docker service logs unmute_unmute_stt --tail 120 | cat
curl -s https://inti.intellipedia.ai/api/v1/health | cat
