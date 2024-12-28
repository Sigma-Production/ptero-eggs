# Pterodactyl Webhost Egg

### How to Use:
1. Download the JSON file from the releases page.
2. Import the egg into your Pterodactyl panel.
3. Create a new server. Optionally, enable WordPress during setup for automatic installation.
4. You can also install Composer packages, either during the initial setup or afterward.
5. Visit the provided IP and port to access the server. For WordPress, go to `http://ip:port/wp-admin`.
6. To use a custom domain, create a reverse proxy on the host.

### Disable Logs from Console:
To remove access and error logs from the console, edit the Nginx configuration:
- Navigate to `nginx/conf.d/default.conf`
- Uncomment (remove the `#`) the following lines:

```
#access_log /home/container/naccess.log;
#error_log  /home/container/nerror.log error;
```

---

Originally forked and edited from [https://gitlab.com/tenten8401/pterodactyl-nginx](https://gitlab.com/tenten8401/pterodactyl-nginx)

© Sigma Productions 2024
