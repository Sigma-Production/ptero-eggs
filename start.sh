#!/bin/ash

# Colors for output
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

log_success() { echo -e "${GREEN}[SUCCESS] $1${RESET}"; }
log_warning() { echo -e "${YELLOW}[WARNING] $1${RESET}"; }
log_error()   { echo -e "${RED}[ERROR] $1${RESET}"; }

# Clean up temp directory
echo "⏳ Cleaning up temporary files..."
if rm -rf /home/container/tmp/*; then
    log_success "Temporary files removed successfully."
else
    log_error "Failed to remove temporary files."
    exit 1
fi

# Start PHP-FPM
echo "⏳ Starting PHP-FPM..."
if /usr/sbin/php-fpm8 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize; then
    log_success "PHP-FPM started successfully."
else
    log_error "Failed to start PHP-FPM."
    exit 1
fi

# Determine Nginx port from Pterodactyl environment
# Pterodactyl standard port variable: PORT
NGINX_PORT=${PORT:-8080}  # fallback auf 8080, falls PORT nicht gesetzt
NEXTCLOUD_CONF="/home/container/nginx/conf.d/nextcloud.conf"

# Replace template variable in nextcloud.conf with actual port
if grep -q "{{server.allocations.default.port}}" "$NEXTCLOUD_CONF"; then
    sed -i "s/{{server.allocations.default.port}}/$NGINX_PORT/" "$NEXTCLOUD_CONF"
    log_success "Nextcloud Nginx config updated with port $NGINX_PORT."
else
    log_warning "No template variable found in nextcloud.conf. Skipping replacement."
fi

# Start Nginx
echo "⏳ Starting Nginx..."
if /usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/; then
    log_success "Web server is running. All services started successfully."
else
    log_error "Failed to start Nginx."
    exit 1
fi

# Keep the container alive
tail -f /dev/null
