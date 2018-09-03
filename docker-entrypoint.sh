#!/bin/bash
set -e

if [[ "$*" == node*current/index.js* ]] && [ "$(id -u)" = '0' ];
  then
    chown -R node "$GHOST_CONTENT"
    exec su-exec node "$BASH_SOURCE" "$@"
fi

if [[ "$*" == node*current/index.js* ]];
  then
    baseDir="$GHOST_INSTALL/content.orig"
    for src in "$baseDir"/*/ "$baseDir"/themes/*;
      do
        src="${src%/}"
        target="$GHOST_CONTENT/${src#$baseDir/}"
        mkdir -p "$(dirname "$target")"
        if [ ! -e "$target" ];
          then
            tar -cC "$(dirname "$src")" "$(basename "$src")" | tar -xC "$(dirname "$target")"
        fi
      done

    knex-migrator-migrate --init --mgpath "$GHOST_INSTALL/current"
fi

# environment variables
#sed -i "s/localhost:2368/${SERVER_URL-localhost:2368}/"g /var/lib/ghost/config.production.json
prod() {
cat > /var/lib/ghost/config.development.json << EOF
{
  "url": "http://${SERVER_URL:-localhost}:${SERVER_PORT:-2368}",
  "server": {
    "port": ${SERVER_PORT:-2368},
    "host": "0.0.0.0"
  },
  "database": {
    "client": "sqlite3",
    "connection": {
      "filename": "/var/lib/ghost/content/data/ghost.db"
    }
  },
  "mail": {
    "transport": "SMTP",
    "from": "${FROM_NAME:-MyBlog} <${FROM_EMAIL:-ghost-blog@localhost}>",
    "options": {
      "service": "Mailgun",
      "host": "${SMTP_HOST:-localhost}",
      "port": ${SMTP_PORT:-25},
      "auth": {
        "user": "${SMTP_AUTH_USERNAME:-root}",
        "pass": "${SMTP_AUTH_PASSWORD:-password}"
      }
    }
  },
  "logging": {
    "transports": [
      "file",
      "stdout"
    ]
  },
  "process": "systemd",
  "paths": {
    "contentPath": "/var/lib/ghost/content"
  }
}
EOF
}

dev() {
cat > /var/lib/ghost/config.development.json << EOF
{
  "url": "http://${SERVER_URL:-localhost}:${SERVER_PORT:-2368}",
  "server": {
    "port": ${SERVER_PORT:-2368},
    "host": "0.0.0.0"
  },
  "database": {
    "client": "sqlite3",
    "connection": {
      "filename": "/var/lib/ghost/content/data/ghost.db"
    }
  },
  "mail": {
    "transport": "Direct"
  },
  "logging": {
    "transports": [
      "file",
      "stdout"
    ]
  },
  "process": "systemd",
  "paths": {
    "contentPath": "/var/lib/ghost/content"
  }
}
EOF
}

test(){
cat > /var/lib/ghost/config.development.json << EOF
{
  "url": "http://localhost:2368",
  "server": {
    "port": 2368,
    "host": "0.0.0.0"
  },
  "database": {
    "client": "sqlite3",
    "connection": {
      "filename": "/var/lib/ghost/content/data/ghost.db"
    }
  },
  "mail": {
    "transport": "Direct"
  },
  "logging": {
    "transports": [
      "file",
      "stdout"
    ]
  },
  "process": "systemd",
  "paths": {
    "contentPath": "/var/lib/ghost/content"
  }
}
EOF
}

if  [ "${ENV_TYPE}" = "PROD" ]
  then prod

elif [ "${ENV_TYPE}" = "DEV" ]
  then dev
  else test

fi

exec "$@"
