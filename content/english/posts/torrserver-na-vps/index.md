---
title: "TorrServer on a VPS: A Secure Remote Streaming Setup"
date: 2026-02-05T06:08:46+03:00
lastmod: 2026-08-17T12:00:00+03:00
author: Rianvy
avatar: /img/avatar.jpg
cover: Cover.png
images:
  - Cover.png
categories:
  - Guides
tags:
  - TorrServer
  - VPS
  - Linux
  - streaming
  - torrents
  - Lampa
  - Docker
  - Termius
  - selfhosted
  - server
description: "An up-to-date TorrServer VPS guide covering the official installer, systemd, authentication, UFW, HTTPS, Lampa, Docker, and safe updates."
---

A complete guide to installing TorrServer on a remote VPS, from choosing a server to connecting Lampa securely.

<!--more-->

## How TorrServer works on a VPS

TorrServer retrieves pieces from the BitTorrent network, keeps a buffer in RAM, and sends the video stream to a client over HTTP or HTTPS. Moving it to a VPS shifts peer-to-peer traffic to the server, but your home connection is still used to receive the finished video stream.

Benefits of this setup include:

- access from your TV, phone, and laptop outside your home network;
- 24/7 operation without leaving a home computer running;
- a fast data-center connection independent of your home upload speed;
- one server for several personal devices.

The trade-offs are the monthly VPS cost, outbound traffic, and the need to secure and maintain a public server.

## What you need

### VPS requirements

These are guidelines rather than hard requirements. Actual load depends on the media bitrate, viewer count, cache size, and whether transcoding is enabled.

| Resource | Starting point | Comfortable setup |
|----------|----------------|-------------------|
| CPU | 1 vCPU for standard proxying | 2+ vCPU; more for GStreamer transcoding |
| RAM | 1 GB | 2 GB for a larger cache or multiple streams |
| Disk | 5 GB | 10 GB with room for the OS, logs, and metadata |
| Network | media bitrate plus 30–50% headroom | a 200 Mbps or faster port |
| OS | a modern glibc-based Linux | Ubuntu 22.04/24.04 or Debian 12/13 |

TorrServer's main streaming cache lives in RAM, so you do not need 10–20 GB of disk specifically for the cache. Old distributions and musl-based systems may not run the current binary. The official installer checks the CPU architecture, operating system, and glibc version.

There is no universal rule that every 4K stream needs exactly 100 Mbps. A typical 1080p file may use 10–40 Mbps, while a high-bitrate 4K remux can peak above 100 Mbps. Use the file's actual bitrate and leave extra headroom.

### Choosing a VPS provider

Plans change frequently. Before paying, check the current price, port speed, outbound traffic allowance, and whether BitTorrent is permitted by the provider's terms.

| Provider | What to verify | Link |
|----------|----------------|------|
| **Aéza** | available regions, plan type, and traffic policy | [aeza.net](https://aeza.net/?ref=533501) |
| **Xorek Cloud** | port speed, traffic allowance, and selected region | [xorek.cloud](https://xorek.cloud/?from=34730) |

For the standard build without transcoding, network capacity and RAM matter most. CPU performance also matters when using the `-gst` GStreamer build for remuxing or transcoding.

### SSH client

The examples use [Termius](https://termius.com), but any SSH client will work. Termius Starter includes SSH, SFTP, and command autocomplete. Cloud synchronization between mobile and desktop devices is a Pro feature.

## Step 1: Prepare the server

Order a VPS with Ubuntu 22.04/24.04 or Debian 12/13. The provider will give you an IP address, a username, and either a password or an SSH key.

On the first connection, compare the server's SSH fingerprint with the value shown in the provider panel when one is available. Do not blindly accept an unexpected fingerprint.

Connect to the server and update the operating system:

```bash
apt update && apt upgrade -y
apt install -y curl ca-certificates
```

If you are not logged in as `root`, add `sudo` before administrative commands.

## Step 2: Install TorrServer

### Recommended method: the official installer

Download the installer as a file, inspect it if you wish, and run it interactively:

```bash
curl -fsSL https://raw.githubusercontent.com/YouROK/TorrServer/master/installTorrServerLinux.sh \
  -o installTorrServerLinux.sh
chmod 755 installTorrServerLinux.sh
sudo bash ./installTorrServerLinux.sh
```

Choose the latest release in the menu. The standard build is suitable for direct streaming. Use the `-gst` build only when you need GStreamer features; it may require more CPU.

The installer:

- detects the architecture and checks glibc compatibility;
- installs the binary in `/opt/torrserver`;
- creates a dedicated `torrserver` system user;
- creates and enables `torrserver.service` in systemd;
- can configure logging and HTTP Basic Auth;
- supports future updates and reconfiguration.

Enable HTTP authentication during installation and choose a unique username and a long password. Credentials are stored in `/opt/torrserver/accs.db`, while the `--httpauth` flag enables their validation.

Check the service:

```bash
systemctl status torrserver --no-pager
journalctl -u torrserver -n 50 --no-pager
```

Service management commands:

```bash
systemctl restart torrserver
systemctl stop torrserver
systemctl start torrserver
```

### How authentication works

TorrServer does not accept a username and password as the value of `-a`. The `-a` or `--httpauth` option is a boolean switch. Users are stored in `accs.db` next to `config.db`:

```json
{
  "admin": "REPLACE_WITH_A_LONG_UNIQUE_PASSWORD"
}
```

The regular web settings do not provide a separate, reliable way to create these credentials. To change authentication, run the official installer again:

```bash
sudo bash ./installTorrServerLinux.sh --reconfigure
```

## Step 3: Test it safely

Do not expose `8090/tcp` to the entire internet just to test the installation. Create an SSH tunnel from your computer:

```bash
ssh -L 8090:127.0.0.1:8090 root@SERVER_IP
```

While the SSH session remains open, visit `http://127.0.0.1:8090` in your browser and enter the TorrServer username and password.

Basic Auth encodes a password but does not encrypt it. Public access over plain `http://IP:8090` is therefore unsafe even with authentication enabled. Use HTTPS or a private VPN for permanent remote access.

## Step 4: Configure the firewall

Allow the server's real SSH port first. If the server uses OpenSSH on the standard port 22:

```bash
apt install -y ufw
ufw allow OpenSSH
ufw enable
ufw status verbose
```

If SSH uses a custom port, allow that port before enabling UFW.

For the recommended Nginx setup, do not create a public rule for port 8090. We will allow HTTP and HTTPS after installing Nginx, when the `Nginx Full` profile is available.

If you need a temporary direct-access test, restrict it to your device's current public IP:

```bash
ufw allow from YOUR_PUBLIC_IP to any port 8090 proto tcp
```

Remove that rule after testing with `ufw status numbered`, followed by `ufw delete RULE_NUMBER`.

## Step 5: Add HTTPS with Nginx

This step requires a domain with an A or AAAA record pointing to the VPS.

Install Nginx and Certbot, then allow web traffic:

```bash
apt install -y nginx certbot python3-certbot-nginx
ufw allow 'Nginx Full'
ufw status verbose
```

Create the virtual host:

```bash
nano /etc/nginx/sites-available/torrserver
```

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name torr.example.com;

    location / {
        proxy_pass http://127.0.0.1:8090;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Authorization $http_authorization;

        proxy_buffering off;
        proxy_request_buffering off;
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
    }
}
```

Replace `torr.example.com` with your domain, enable the site, and validate the configuration:

```bash
ln -s /etc/nginx/sites-available/torrserver /etc/nginx/sites-enabled/torrserver
nginx -t
systemctl reload nginx
certbot --nginx -d torr.example.com
```

Use `https://torr.example.com` after Certbot issues the certificate. Make sure port 8090 is not exposed by UFW or the provider's cloud firewall.

If you do not have a domain, connecting the VPS and your devices through WireGuard, Tailscale, or another private VPN is safer than publishing TorrServer over HTTP.

## Step 6: Connect Lampa

The exact menu location depends on the client version, but it is usually under **Settings → TorrServer**.

1. Open the TorrServer settings in Lampa.
2. Enter the protected address, such as `https://torr.example.com`.
3. Save it and run the connection test.
4. Test playback with a torrent containing content you are legally allowed to watch.

Basic Auth support varies between Lampa builds. If your client provides separate username and password fields, use them. Do not assume that a URL such as `https://user:password@torr.example.com` will work: web builds often reject embedded credentials or requests to an insecure HTTP resource. In that case, use a VPN or a client/plugin with explicit authentication support instead of disabling server protection.

## Alternative: Docker

Install Docker by following the [official Docker Engine guide](https://docs.docker.com/engine/install/). The example below assumes Nginx runs on the same VPS, so it publishes TorrServer only on the loopback interface.

Create the persistent directory and authentication file:

```bash
install -d -m 700 /var/lib/torrserver/config
nano /var/lib/torrserver/config/accs.db
chmod 600 /var/lib/torrserver/config/accs.db
```

Contents of `accs.db`:

```json
{
  "admin": "REPLACE_WITH_A_LONG_UNIQUE_PASSWORD"
}
```

Start the container:

```bash
docker run -d \
  --name torrserver \
  --restart unless-stopped \
  -p 127.0.0.1:8090:8090 \
  -e TS_HTTPAUTH=1 \
  -v /var/lib/torrserver:/opt/ts \
  ghcr.io/yourok/torrserver:latest
```

The persistent data directory in the official image is `/opt/ts`, not `/data`. With the default `TS_CONF_PATH`, the authentication file must be available as `/opt/ts/config/accs.db` inside the container.

Useful commands:

```bash
docker logs -f torrserver
docker restart torrserver
docker stop torrserver
docker start torrserver
```

To update, pull the new image, recreate the container with the same command, and keep `/var/lib/torrserver`:

```bash
docker pull ghcr.io/yourok/torrserver:latest
docker rm -f torrserver
# Run the docker run command above again.
```

## Performance settings

The current TorrServer defaults are a safe starting point. Change them only after testing a representative file.

| Setting | Default | Guideline for a VPS with 1–2 GB RAM |
|---------|---------|--------------------------------------|
| **Cache size** | 64 MB | 128–256 MB when enough RAM is available |
| **Preload cache** | 50% | 50–75% for inconsistent swarms |
| **Connections limit** | 25 | 25–50 |
| **Upload rate limit** | 0 — unlimited | limit only when outbound traffic is metered |

The upload rate value is expressed in KiB/s: `1024` is approximately 1 MiB/s and `5120` is approximately 5 MiB/s. Setting it too low may reduce your contribution to the swarm. Check the provider's outbound traffic policy and billing first.

## Troubleshooting

### The service does not start

```bash
systemctl status torrserver --no-pager
journalctl -u torrserver -n 100 --no-pager
```

Check permissions under `/opt/torrserver`, validate the JSON in `accs.db`, and make sure the binary matches the VPS architecture.

### Nginx returns 502 Bad Gateway

```bash
ss -tlnp | grep 8090
curl -I http://127.0.0.1:8090
nginx -t
journalctl -u nginx -n 50 --no-pager
```

When a reverse proxy is in use, listening on `127.0.0.1:8090` is normal and safer. The service does not need to be publicly reachable on `0.0.0.0:8090`.

### Lampa cannot connect

1. Open the TorrServer address in a browser on the same device.
2. Check the certificate and use `https://` after configuring Certbot.
3. Confirm that your Lampa build supports Basic Auth.
4. For a web client, check the browser console for mixed-content and CORS errors.
5. Inspect `journalctl -u torrserver -f` or `docker logs -f torrserver`.

### The stream keeps buffering

1. Compare the file bitrate with both the VPS and home download speeds.
2. Select a torrent with enough reachable peers.
3. Increase the cache gradually and monitor RAM with `free -h`.
4. Check packet loss and the route between the device and the VPS.
5. If transcoding is enabled, inspect CPU usage with `top`.

## Updating TorrServer

Do not use an update script that stops the service before a new binary has downloaded successfully. The official installer already provides a safe update command:

```bash
curl -fsSL https://raw.githubusercontent.com/YouROK/TorrServer/master/installTorrServerLinux.sh \
  -o installTorrServerLinux.sh
chmod 755 installTorrServerLinux.sh
sudo bash ./installTorrServerLinux.sh --update --silent
```

Check the service and the path of the running binary afterwards:

```bash
systemctl status torrserver --no-pager
systemctl show torrserver -p ExecStart --no-pager
```

The binary name depends on the CPU architecture and whether you selected the standard or `-gst` build. List installed files with `ls -1 /opt/torrserver/TorrServer-*`.

## Pros and cons

| Pros | Cons |
|------|------|
| Access from personal devices away from home | Monthly VPS cost |
| Runs 24/7 | Requires security updates and maintenance |
| Fast data-center connection | Your home downlink is still used for viewing |
| Peer traffic moves to the VPS | The provider may limit or prohibit BitTorrent |
| No always-on home computer required | Multiple streams require more resources |

## Conclusion

TorrServer on a VPS is useful when you want a personal server for several devices and remote access outside your home network. A modest VPS with 1–2 GB of RAM is usually enough for standard proxying, but choose the plan based on actual media bitrate, outbound traffic limits, and the provider's rules.

Most importantly, never expose port 8090 without protection. Use a dedicated system user, built-in authentication, HTTPS or a private VPN, and the official update mechanism.

## Useful links

| Resource | Link |
|----------|------|
| **TorrServer** repository and documentation | [github.com/YouROK/TorrServer](https://github.com/YouROK/TorrServer) |
| **TorrServer releases** | [github.com/YouROK/TorrServer/releases](https://github.com/YouROK/TorrServer/releases) |
| **Lampa** | [github.com/lampa-app/LAMPA](https://github.com/lampa-app/LAMPA) |
| **Docker Engine** | [docs.docker.com/engine/install](https://docs.docker.com/engine/install/) |
| **Termius** | [termius.com](https://termius.com) |
| **Previous Lampa article** | [0x69.ru](/posts/kak-smotret-filmy-4k-lampa-torrserver/) |

{{< donate_button
    "https://pay.cloudtips.ru/p/b59e1765"
    "https://t.me/tribute/app?startapp=dE4k"
    "Cloudtips"
    "Tribute"
    "Support the project"
>}}
