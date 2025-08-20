#!/bin/bash
# Minecraft Java Server Installer vFinal - By Ilyass
# Java 21 + 1.21.8 + Offline mode for TLauncher

# تحديث النظام وتثبيت المتطلبات
sudo apt update && sudo apt upgrade -y
sudo apt install -y wget screen curl

# تثبيت OpenJDK 21
sudo apt install -y openjdk-21-jdk
java -version

# إنشاء مستخدم للسيرفر
sudo useradd -r -m -U -d /opt/minecraft -s /bin/bash minecraft || true

# إنشاء مجلد السيرفر
sudo mkdir -p /opt/minecraft
cd /opt/minecraft

# أخذ نسخة احتياطية إذا كان السيرفر موجود
if [ -f server.jar ]; then
    mv server.jar server.jar.bak
    echo "Backup old server.jar to server.jar.bak"
fi

# تنزيل آخر نسخة Minecraft 1.21.8
sudo wget -O server.jar https://launcher.mojang.com/v1/objects/f3f7e9c8f43a9e6e5d2c1b8e4a9c5d07a7f9f71f/server.jar

# قبول EULA
echo "eula=true" | sudo tee /opt/minecraft/eula.txt

# إعداد server.properties مع offline-mode
cat <<EOF | sudo tee /opt/minecraft/server.properties
motd=THIS IS ILYASS SERVER
enable-command-block=true
spawn-protection=0
view-distance=10
max-players=20
online-mode=false
EOF

# تغيير ملكية الملفات للمستخدم minecraft
sudo chown -R minecraft:minecraft /opt/minecraft

# إنشاء خدمة systemd
sudo tee /etc/systemd/system/minecraft.service > /dev/null <<EOL
[Unit]
Description=Minecraft Server (THIS IS ILYASS SERVER)
After=network.target

[Service]
WorkingDirectory=/opt/minecraft
User=minecraft
ExecStart=/usr/bin/java -Xmx2G -Xms1G -jar server.jar nogui
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOL

# تفعيل وتشغيل الخدمة
sudo systemctl daemon-reload
sudo systemctl enable minecraft.service
sudo systemctl start minecraft.service

echo "✅ Minecraft 1.21.8 Server installed, offline-mode enabled for TLauncher"
echo "Use 'screen -S mc java -Xmx2G -Xms2G -jar server.jar nogui' to run manually in screen"
