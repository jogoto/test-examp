#!/bin/bash

# Скрипт за инсталиране на .NET 6.0 за Jenkins потребителя
echo "🔧 Инсталиране на .NET 6.0 за Jenkins..."

# Създаване на директория за Jenkins .NET
sudo mkdir -p /var/lib/jenkins/.dotnet

# Изтегляне на .NET 6.0 runtime
echo "📥 Изтегляне на .NET 6.0 runtime..."
wget https://builds.dotnet.microsoft.com/dotnet/Runtime/6.0.25/dotnet-runtime-6.0.25-linux-x64.tar.gz -O /tmp/dotnet-runtime-6.0.25-linux-x64.tar.gz

# Извличане на архива
echo "📦 Извличане на .NET 6.0..."
sudo tar -xzf /tmp/dotnet-runtime-6.0.25-linux-x64.tar.gz -C /var/lib/jenkins/.dotnet

# Задаване на правилни права
echo "🔐 Задаване на права..."
sudo chown -R jenkins:jenkins /var/lib/jenkins/.dotnet
sudo chmod -R 755 /var/lib/jenkins/.dotnet

# Добавяне на .NET към PATH за Jenkins
echo "🔧 Конфигуриране на PATH..."
if ! grep -q "export PATH=\"/var/lib/jenkins/.dotnet:\$PATH\"" /var/lib/jenkins/.bashrc; then
    echo 'export PATH="/var/lib/jenkins/.dotnet:$PATH"' | sudo tee -a /var/lib/jenkins/.bashrc
fi

# Създаване на символична връзка в /usr/local/bin
echo "🔗 Създаване на символична връзка..."
sudo ln -sf /var/lib/jenkins/.dotnet/dotnet /usr/local/bin/dotnet

# Почистване на временните файлове
rm -f /tmp/dotnet-runtime-6.0.25-linux-x64.tar.gz

echo "✅ .NET 6.0 е инсталиран успешно за Jenkins!"
echo "🔄 Рестартирайте Jenkins за да се приложат промените:"
echo "   sudo systemctl restart jenkins" 