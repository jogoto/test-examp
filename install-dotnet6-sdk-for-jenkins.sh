#!/bin/bash

# Скрипт за инсталиране на .NET 6.0 SDK за Jenkins
echo "🔧 Инсталиране на .NET 6.0 SDK за Jenkins..."

# Изтегляне на .NET 6.0 SDK
echo "📥 Изтегляне на .NET 6.0 SDK..."
wget https://builds.dotnet.microsoft.com/dotnet/Sdk/6.0.419/dotnet-sdk-6.0.419-linux-x64.tar.gz -O /tmp/dotnet-sdk-6.0.419-linux-x64.tar.gz

# Извличане на архива в Jenkins .dotnet директорията
echo "📦 Извличане на .NET 6.0 SDK..."
sudo tar -xzf /tmp/dotnet-sdk-6.0.419-linux-x64.tar.gz -C /var/lib/jenkins/.dotnet

# Задаване на правилни права
echo "🔐 Задаване на права..."
sudo chown -R jenkins:jenkins /var/lib/jenkins/.dotnet
sudo chmod -R 755 /var/lib/jenkins/.dotnet

# Създаване на символична връзка в /usr/local/bin (ако не съществува)
echo "🔗 Създаване на символична връзка..."
sudo ln -sf /var/lib/jenkins/.dotnet/dotnet /usr/local/bin/dotnet

# Почистване на временните файлове
rm -f /tmp/dotnet-sdk-6.0.419-linux-x64.tar.gz

echo "✅ .NET 6.0 SDK е инсталиран успешно за Jenkins!"
echo "🔄 Рестартирайте Jenkins за да се приложат промените:"
echo "   sudo systemctl restart jenkins" 