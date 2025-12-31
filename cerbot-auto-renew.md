### 第一步：安装 venv 模块


```bash
sudo apt update
sudo apt install python3-venv libaugeas0 -y
```

### 第二步：创建虚拟环境并安装 Certbot

```bash

# 创建存放证书工具的目录
sudo python3 -m venv /opt/certbot/

# 升级 pip 并安装插件
sudo /opt/certbot/bin/pip install --upgrade pip
sudo /opt/certbot/bin/pip install certbot certbot-dns-vultr

# 创建软链接，让你可以直接在任何地方使用 'certbot' 命令
sudo ln -s /opt/certbot/bin/certbot /usr/bin/certbot
```

### 第三步：配置 Vultr 凭证

创建配置文件：

```Bash

mkdir -p ~/.secrets/certbot/
nano ~/.secrets/certbot/vultr.ini
```

写入 API Key（通过 Vultr API设置获取）：

```
dns_vultr_key = 你的VULTR_API_TOKEN
```

安全权限设置：

```Bash

chmod 600 ~/.secrets/certbot/vultr.ini

```
### 第四步：一次性申请证书
执行以下命令申请泛域名证书：

``` Bash

sudo certbot certonly \
  --authenticator dns-vultr \
  --dns-vultr-credentials ~/.secrets/certbot/vultr.ini \
  --dns-vultr-propagation-seconds 120 \
  --agree-tos \
  --register-unsafely-without-email \
  -d "yourdomain.com" \
  -d "*.yourdomain.com"
```

### 第五步：设置真正的“自动续订”

crontab -e 在文件底部添加这一行（每天凌晨 3:15 执行检查）：

```bash
# 15 3 * * * /usr/bin/certbot renew --quiet --deploy-hook "mkdir -p /usr/local/etc/xray/cert && cp -rL /etc/letsencrypt/live/* /usr/local/etc/xray/cert/ && chown -R nobody:nogroup /usr/local/etc/xray/cert && systemctl restart xray"
```
