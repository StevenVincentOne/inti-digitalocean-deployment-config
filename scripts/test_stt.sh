#!/usr/bin/env bash
set -euo pipefail
apk add --no-cache curl >/dev/null 2>&1 || true
curl -s http://unmute_unmute_stt:8080/api/build_info || echo FAIL
