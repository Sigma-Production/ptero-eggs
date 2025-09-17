# Log Management System

This document explains the automatic log rotation system implemented in the Pterodactyl Web Host Egg to prevent logs from growing indefinitely without logrotate.

## Overview

The log management system automatically handles log rotation for:
- Nginx access logs (`/home/container/logs/access.log`)
- Nginx error logs (`/home/container/logs/error.log`)
- PHP-FPM logs (`/home/container/php-fpm.log`)
- Additional optional logs (`/home/container/naccess.log`, `/home/container/nerror.log`)

## How It Works

1. **Automatic Daemon**: A background daemon runs continuously, checking log file sizes at regular intervals
2. **Size-Based Rotation**: When a log file exceeds the configured maximum size, it's automatically rotated
3. **Safe Rotation**: The system safely rotates logs by:
   - Moving the current log to a numbered backup (e.g., `access.log.1`)
   - Creating a new empty log file
   - Signaling nginx/php-fpm to reopen log files
4. **Retention Management**: Old rotated logs beyond the retention count are automatically deleted

## Configuration

Configure the system using environment variables:

- `LOG_MAX_SIZE` (default: `10M`): Maximum log file size before rotation
  - Examples: `50M`, `1G`, `500K`
- `LOG_KEEP_COUNT` (default: `5`): Number of rotated log files to keep
  - Range: 1-20
- `LOG_CHECK_INTERVAL` (default: `300`): Check interval in seconds
  - Range: 60-3600 (1 minute to 1 hour)

## Usage

### Automatic Operation
The log rotation daemon starts automatically when the server starts. No manual intervention is required.

### Manual Commands

Use the log management helper script:
```bash
# Check current status
./scripts/logmanager.sh status

# Manually rotate logs
./scripts/logmanager.sh rotate

# Show help
./scripts/logmanager.sh help
```

Or use the core rotation script directly:
```bash
# Check log status
./scripts/logrotate.sh status

# Perform rotation
./scripts/logrotate.sh rotate

# Run as daemon
./scripts/logrotate.sh daemon
```

## Examples

### High-Traffic Server
For a high-traffic server, you might want larger logs and more retention:
```bash
# Set in Pterodactyl panel or egg configuration
LOG_MAX_SIZE=100M
LOG_KEEP_COUNT=10
LOG_CHECK_INTERVAL=180
```

### Low-Disk Server
For servers with limited disk space:
```bash
LOG_MAX_SIZE=5M
LOG_KEEP_COUNT=3
LOG_CHECK_INTERVAL=300
```

## File Structure

After rotation, your logs directory will look like:
```
logs/
├── access.log          # Current log file
├── access.log.1        # Most recent rotation
├── access.log.2        # Second most recent
├── access.log.3        # Third most recent
├── access.log.4        # Fourth most recent
├── access.log.5        # Oldest rotation (will be deleted on next rotation)
├── error.log           # Current error log
├── error.log.1         # Most recent error log rotation
└── ...
```

## Benefits

1. **No Manual Maintenance**: Logs are automatically managed without user intervention
2. **Disk Space Protection**: Prevents logs from filling up disk space
3. **Service Continuity**: Rotation happens without interrupting web services
4. **Configurable**: Flexible configuration for different server needs
5. **No External Dependencies**: Works without logrotate or other external tools

## Troubleshooting

### Check if the daemon is running
```bash
ps aux | grep logrotate
```

### View daemon logs
The daemon outputs to stdout/stderr, which should be visible in the Pterodactyl console.

### Manual rotation test
```bash
./scripts/logmanager.sh rotate
```

### Check configuration
```bash
./scripts/logmanager.sh status
```

## Technical Details

- **Shell Compatibility**: Scripts use POSIX shell (`ash`) for Alpine Linux compatibility
- **Signal Handling**: Uses `USR1` signal to safely reload nginx and php-fpm log files
- **Error Handling**: Graceful handling of missing files, permission issues, and process failures
- **Resource Efficient**: Minimal CPU and memory usage during log checks