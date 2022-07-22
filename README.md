# Pterodactyl webhost egg

This is a repo where you can request a version with what ever PHP package you want! Make an issue saying what packages you want, and I will respond to the issue with a Docker image of what you want!
#### Please make sure no one else has requested for the same packages as you!

How to use:
1. Go to releases in the original repo and download the json file
2. Import the egg to your panel like you normally do
3. Add the Docker image url I sent you in the egg settings, where it says "Docker Images"
4. Create a new server, additionally you can enable wordpress, this will install wordpress for you
and you can also install composer packages, this can also be done after the install
5. Navigate to the given port and ip and you are good to go just add you files to the webroot folder
(when using wordpress go to http://ip:port/wp-admin)
Note: if you want it using a domain then create a reverse proxy on the host


To remove logs from console, open nginx/conf.d/default.conf and uncomment (remove #):

```
#access_log /home/container/naccess.log;
#error_log  /home/container/nerror.log error
```

Forked from https://github.com/finnie2006/ptero-eggs as a service to add more packages
Originally forked and edited from https://gitlab.com/tenten8401/pterodactyl-nginx

A sigma production
