#!/bin/bash
set -e

# Roda setup só uma vez, para não repetir em cada start
if [ ! -f tmp/.app_setup_done ]; then
  echo "🛠️ Running app setup (db:drop, create, migrate, seed)..."
  bundle exec rake app:setup
  touch tmp/.app_setup_done
fi

exec "$@"
