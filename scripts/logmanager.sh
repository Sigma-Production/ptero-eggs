#!/bin/ash
# Log Management Helper Script for Pterodactyl Web Host Egg

# Colors for output
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
RESET="\033[0m"

echo -e "${BLUE}=== Pterodactyl Web Host Egg - Log Management Tool ===${RESET}"
echo ""

case "${1:-}" in
    "status"|"info")
        echo -e "${BLUE}Current Log Configuration:${RESET}"
        echo "  Max log size: ${LOG_MAX_SIZE:-10M}"
        echo "  Logs to keep: ${LOG_KEEP_COUNT:-5}"
        echo "  Check interval: ${LOG_CHECK_INTERVAL:-300} seconds"
        echo ""
        
        ./scripts/logrotate.sh status
        ;;
    "rotate"|"cleanup")
        echo -e "${YELLOW}Performing manual log rotation...${RESET}"
        ./scripts/logrotate.sh rotate
        echo ""
        echo -e "${GREEN}Log rotation completed!${RESET}"
        ;;
    "daemon")
        echo -e "${GREEN}Starting log rotation daemon...${RESET}"
        ./scripts/logrotate.sh daemon
        ;;
    "help"|*)
        echo -e "${GREEN}Available commands:${RESET}"
        echo "  ${0} status    - Show current log status and configuration"
        echo "  ${0} rotate    - Manually rotate logs now"
        echo "  ${0} daemon    - Start log rotation daemon (background process)"
        echo "  ${0} help      - Show this help message"
        echo ""
        echo -e "${BLUE}Environment Variables:${RESET}"
        echo "  LOG_MAX_SIZE        - Maximum log size before rotation (default: 10M)"
        echo "  LOG_KEEP_COUNT      - Number of rotated logs to keep (default: 5)"
        echo "  LOG_CHECK_INTERVAL  - Check interval in seconds (default: 300)"
        echo ""
        echo -e "${BLUE}Examples:${RESET}"
        echo "  LOG_MAX_SIZE=50M ${0} status"
        echo "  ${0} rotate"
        echo "  nohup ${0} daemon > /dev/null 2>&1 &"
        ;;
esac