#!/bin/sh
set -e

# Substitute environment variables in nginx config
echo "Substituting environment variables in nginx configuration..."
envsubst '${GROQ_API_KEY}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

# Validate that GROQ_API_KEY is set
if [ -z "$GROQ_API_KEY" ]; then
    echo "ERROR: GROQ_API_KEY environment variable is not set"
    exit 1
fi

echo "LLM Proxy starting with Groq API key: ${GROQ_API_KEY:0:10}..."
echo "Configuration generated:"
cat /etc/nginx/conf.d/default.conf

# Start nginx
exec "$@"