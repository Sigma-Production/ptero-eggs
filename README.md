# Sigma Productions – Pterodactyl & Pelican Eggs

This repository contains **Pterodactyl / Pelican eggs** maintained by **Sigma Productions**, providing preconfigured setups for **web hosting** (with WordPress support) and **internet radio streaming** (Icecast2 + Liquidsoap).  

---

## 📦 Available Eggs

### 1. 🌐 Pterodactyl Webhost Egg
Easily deploy a web server with optional WordPress support.

#### 🔧 How to Use:
1. Download the JSON egg file from the releases page.
2. Import the egg into your **Pterodactyl panel**.
3. Create a new server.  
   - Optionally, enable **WordPress** during setup for automatic installation.  
4. Install **Composer** packages either during setup or afterward.
5. Access your server via the assigned IP and port.  
   - For WordPress: `http://ip:port/wp-admin`  
6. (Optional) Use a custom domain by setting up a **reverse proxy** on the host.

#### 📝 Disable Logs from Console:
To remove access/error logs from console output:
- Open `nginx/conf.d/default.conf`
- Uncomment these lines:
  ```nginx
  #access_log /home/container/naccess.log;
  #error_log  /home/container/nerror.log error;
  ```

---

### 2. 🎧 Icecast2 + Liquidsoap Radio Egg
Run your own **internet radio station** with streaming and automation.

#### ✨ Features
- 🎵 Stream audio with **Icecast2**
- 🤖 Automate playback via **Liquidsoap**
- ⚙️ Easy setup inside **Pterodactyl** or **Pelican**
- 📂 Upload & stream your own media library

#### 🚀 Getting Started
1. Download the JSON egg file from the releases page.
2. Import the egg into your **Pterodactyl** or **Pelican** panel.
3. Deploy the server as usual.
4. Configure stream settings & upload music.
5. Customize your **Liquidsoap config**: [Liquidsoap Documentation](https://www.liquidsoap.info/doc-2.3.2/)

#### 📌 Requirements
- Pterodactyl (v1.0+) or Pelican Panel  
- Storage for your music files  
- Open ports for Icecast2 (default: `8000`)  

---

## 📄 License

- Webhost Egg originally forked & edited from [tenten8401/pterodactyl-nginx](https://gitlab.com/tenten8401/pterodactyl-nginx)  
- Provided under the [MIT License](LICENSE).  

© 2024–2025 **Sigma Productions**. All rights reserved.  