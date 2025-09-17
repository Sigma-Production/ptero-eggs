# Pterodactyl Webhost Egg

### How to Use:
1. Download the JSON file from the releases page.
2. Import the egg into your Pterodactyl panel.
3. Create a new server. Optionally, enable WordPress during setup for automatic installation.
4. You can also install Composer packages, either during the initial setup or afterward.
5. Visit the provided IP and port to access the server. For WordPress, go to `http://ip:port/wp-admin`.
6. To use a custom domain, create a reverse proxy on the host.

### Log Management:
This egg includes built-in log rotation to prevent logs from growing indefinitely. By default:
- Log files are automatically rotated when they reach 10MB
- 5 rotated log copies are kept
- Log size is checked every 5 minutes

#### Customizing Log Management:
You can customize the log rotation behavior using these environment variables:
- **LOG_MAX_SIZE**: Maximum log file size before rotation (e.g., `50M`, `1G`). Default: `10M`
- **LOG_KEEP_COUNT**: Number of rotated log files to keep (1-20). Default: `5`
- **LOG_CHECK_INTERVAL**: Check interval in seconds (60-3600). Default: `300`

#### Manual Log Management:
You can manually manage logs using the included log rotation script:
```bash
# Check current log status
./scripts/logrotate.sh status

# Manually rotate logs now
./scripts/logrotate.sh rotate

# Show help
./scripts/logrotate.sh
```

#### Easy Log Management Helper:
For easier log management, use the included helper script:
```bash
# Show log status and configuration
./scripts/logmanager.sh status

# Manually rotate logs
./scripts/logmanager.sh rotate

# Show all available options
./scripts/logmanager.sh help
```

### Disable Logs from Console:
To remove access and error logs from the console, edit the Nginx configuration:
- Navigate to `nginx/conf.d/default.conf`
- Uncomment (remove the `#`) the following lines:

```
#access_log /home/container/naccess.log;
#error_log  /home/container/nerror.log error;
```

**Note**: These additional log files will also be automatically rotated by the log management system.

---

Originally forked and edited from [https://gitlab.com/tenten8401/pterodactyl-nginx](https://gitlab.com/tenten8401/pterodactyl-nginx)

© Sigma Productions 2024
