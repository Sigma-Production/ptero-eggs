#!/bin/ash

# Log Rotation Script for Pterodactyl Web Host Egg
# This script handles log rotation without requiring logrotate
# Created to solve the issue of logs growing indefinitely

# Configuration
MAX_LOG_SIZE=${LOG_MAX_SIZE:-10M}     # Maximum size before rotation (default: 10MB)
KEEP_LOGS=${LOG_KEEP_COUNT:-5}        # Number of rotated logs to keep (default: 5)
LOG_CHECK_INTERVAL=${LOG_CHECK_INTERVAL:-300}  # Check interval in seconds (default: 5 minutes)

# Colors for output
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
RESET="\033[0m"

# Function to print messages with colors
log_info() {
    echo -e "${BLUE}[LOG-ROTATE] $1${RESET}"
}

log_success() {
    echo -e "${GREEN}[LOG-ROTATE] $1${RESET}"
}

log_warning() {
    echo -e "${YELLOW}[LOG-ROTATE] $1${RESET}"
}

log_error() {
    echo -e "${RED}[LOG-ROTATE] $1${RESET}"
}

# Function to convert size string to bytes
size_to_bytes() {
    size=$1
    number=${size%[KMGT]*}
    unit=${size##*[0-9]}
    
    case $unit in
        [Kk]|[Kk][Bb]) echo $((number * 1024)) ;;
        [Mm]|[Mm][Bb]) echo $((number * 1024 * 1024)) ;;
        [Gg]|[Gg][Bb]) echo $((number * 1024 * 1024 * 1024)) ;;
        [Tt]|[Tt][Bb]) echo $((number * 1024 * 1024 * 1024 * 1024)) ;;
        *) echo $number ;;
    esac
}

# Function to rotate a single log file
rotate_log() {
    logfile=$1
    max_size_bytes=$(size_to_bytes $MAX_LOG_SIZE)
    
    # Check if file exists and is readable
    if [ ! -f "$logfile" ]; then
        return 0
    fi
    
    # Get file size
    file_size=$(stat -c%s "$logfile" 2>/dev/null || echo "0")
    
    # Check if rotation is needed
    if [ "$file_size" -gt "$max_size_bytes" ]; then
        log_info "Rotating log file: $logfile (size: $(($file_size / 1024 / 1024))MB)"
        
        # Remove oldest log if we have too many
        oldest_log="${logfile}.${KEEP_LOGS}"
        if [ -f "$oldest_log" ]; then
            rm -f "$oldest_log"
        fi
        
        # Rotate existing logs
        i=$KEEP_LOGS
        while [ $i -gt 1 ]; do
            current_log="${logfile}.$((i-1))"
            next_log="${logfile}.${i}"
            if [ -f "$current_log" ]; then
                mv "$current_log" "$next_log"
            fi
            i=$((i-1))
        done
        
        # Move current log to .1
        if [ -f "$logfile" ]; then
            mv "$logfile" "${logfile}.1"
            # Create new empty log file with correct permissions
            touch "$logfile"
            chmod 644 "$logfile"
            
            # Signal nginx to reopen log files if it's an nginx log
            case "$logfile" in
                */logs/access.log|*/logs/error.log|*/naccess.log|*/nerror.log)
                    if [ -f "/home/container/tmp/nginx.pid" ]; then
                        nginx_pid=$(cat /home/container/tmp/nginx.pid 2>/dev/null)
                        if [ -n "$nginx_pid" ] && kill -0 "$nginx_pid" 2>/dev/null; then
                            kill -USR1 "$nginx_pid" 2>/dev/null
                            log_success "Signaled nginx to reopen log files"
                        fi
                    fi
                    ;;
                */php-fpm.log)
                    # Signal PHP-FPM to reopen log files
                    if [ -f "/home/container/tmp/php-fpm.pid" ]; then
                        php_fpm_pid=$(cat /home/container/tmp/php-fpm.pid 2>/dev/null)
                        if [ -n "$php_fpm_pid" ] && kill -0 "$php_fpm_pid" 2>/dev/null; then
                            kill -USR1 "$php_fpm_pid" 2>/dev/null
                            log_success "Signaled PHP-FPM to reopen log files"
                        fi
                    fi
                    ;;
            esac
            
            log_success "Rotated log file: $logfile"
        fi
    fi
}

# Function to perform log rotation
perform_rotation() {
    log_info "Starting log rotation check..."
    
    # List of log files to rotate (space-separated)
    LOG_FILES="/home/container/logs/access.log /home/container/logs/error.log /home/container/php-fpm.log /home/container/naccess.log /home/container/nerror.log"
    
    # Rotate each log file
    for logfile in $LOG_FILES; do
        rotate_log "$logfile"
    done
    
    log_success "Log rotation check completed"
}

# Function to clean up old logs beyond retention policy
cleanup_old_logs() {
    log_info "Cleaning up old log files beyond retention policy..."
    
    LOG_DIRS="/home/container/logs /home/container"
    
    for dir in $LOG_DIRS; do
        if [ -d "$dir" ]; then
            # Find and remove log files older than the retention policy
            find "$dir" -name "*.log.*" -type f | while read -r logfile; do
                # Extract the rotation number
                rotation_num=$(echo "$logfile" | sed -n 's/.*\.log\.\([0-9]\+\)$/\1/p')
                if [ -n "$rotation_num" ] && [ "$rotation_num" -gt "$KEEP_LOGS" ]; then
                    log_warning "Removing old log file: $logfile"
                    rm -f "$logfile"
                fi
            done
        fi
    done
}

# Function to show current log status
show_log_status() {
    log_info "Current log file status:"
    echo ""
    
    LOG_FILES="/home/container/logs/access.log /home/container/logs/error.log /home/container/php-fpm.log /home/container/naccess.log /home/container/nerror.log"
    
    for logfile in $LOG_FILES; do
        if [ -f "$logfile" ]; then
            size=$(stat -c%s "$logfile" 2>/dev/null || echo "0")
            size_mb=$((size / 1024 / 1024))
            size_kb=$((size / 1024))
            
            if [ $size_mb -gt 0 ]; then
                echo "  $logfile: ${size_mb}MB"
            else
                echo "  $logfile: ${size_kb}KB"
            fi
            
            # Show rotated logs count
            rotated_count=$(ls "${logfile}".* 2>/dev/null | wc -l)
            if [ "$rotated_count" -gt 0 ]; then
                echo "    └─ Rotated copies: $rotated_count"
            fi
        fi
    done
    echo ""
}

# Main execution
case "${1:-}" in
    "rotate")
        perform_rotation
        cleanup_old_logs
        ;;
    "status")
        show_log_status
        ;;
    "daemon")
        log_info "Starting log rotation daemon (checking every ${LOG_CHECK_INTERVAL} seconds)"
        log_info "Max log size: $MAX_LOG_SIZE, Keep logs: $KEEP_LOGS"
        
        while true; do
            perform_rotation
            cleanup_old_logs
            sleep $LOG_CHECK_INTERVAL
        done
        ;;
    *)
        echo "Usage: $0 {rotate|status|daemon}"
        echo ""
        echo "Commands:"
        echo "  rotate  - Perform one-time log rotation"
        echo "  status  - Show current log file sizes"
        echo "  daemon  - Run as daemon, checking logs every $LOG_CHECK_INTERVAL seconds"
        echo ""
        echo "Environment variables:"
        echo "  LOG_MAX_SIZE        - Maximum log size before rotation (default: 10M)"
        echo "  LOG_KEEP_COUNT      - Number of rotated logs to keep (default: 5)"
        echo "  LOG_CHECK_INTERVAL  - Check interval in seconds (default: 300)"
        echo ""
        echo "Examples:"
        echo "  LOG_MAX_SIZE=50M LOG_KEEP_COUNT=10 $0 daemon"
        echo "  $0 rotate"
        echo "  $0 status"
        exit 1
        ;;
esac