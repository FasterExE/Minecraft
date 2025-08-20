#!/bin/bash
# Minecraft Java Server Installer - By Ilyass
# يدعم Java 21 و systemd

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

# تنزيل آخر نسخة من Minecraft server (تأكد الرابط من MCJars)
sudo wget -O server.jar https://launcher.mojang.com/v1/objects/59353fb40c36d304f2035d51e7d6e6baa98dc05c/server.jar

# قبول EULA
echo "eula=true" | sudo tee /opt/minecraft/eula.txt

# إعداد server.properties
cat <<EOF | sudo tee /opt/minecraft/server.properties
motd=THIS IS ILYASS SERVER
enable-command-block=true
spawn-protection=0
view-distance=10
max-players=20
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

echo "✅ Minecraft Server installed and running as minecraft.service"
echo "Use 'screen -r mc' to attach to the server screen"
