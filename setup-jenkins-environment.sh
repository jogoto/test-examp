#!/bin/bash

# Скрипт за пълна настройка на Jenkins средата за .NET 6.0 проект
echo "🚀 Настройка на Jenkins средата за .NET 6.0 проект..."

# 1. Инсталиране на Docker (ако не е инсталиран)
echo "🐳 Проверка на Docker..."
if ! command -v docker &> /dev/null; then
    echo "📥 Инсталиране на Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker jenkins
    rm get-docker.sh
else
    echo "✅ Docker вече е инсталиран"
fi

# 2. Инсталиране на .NET 6.0 Runtime
echo "🔧 Инсталиране на .NET 6.0 Runtime..."
if [ ! -d "/var/lib/jenkins/.dotnet" ]; then
    sudo mkdir -p /var/lib/jenkins/.dotnet
fi

# Изтегляне и инсталиране на .NET 6.0 Runtime
wget https://builds.dotnet.microsoft.com/dotnet/Runtime/6.0.25/dotnet-runtime-6.0.25-linux-x64.tar.gz -O /tmp/dotnet-runtime-6.0.25-linux-x64.tar.gz
sudo tar -xzf /tmp/dotnet-runtime-6.0.25-linux-x64.tar.gz -C /var/lib/jenkins/.dotnet

# 3. Инсталиране на .NET 6.0 SDK
echo "🔧 Инсталиране на .NET 6.0 SDK..."
wget https://builds.dotnet.microsoft.com/dotnet/Sdk/6.0.419/dotnet-sdk-6.0.419-linux-x64.tar.gz -O /tmp/dotnet-sdk-6.0.419-linux-x64.tar.gz
sudo tar -xzf /tmp/dotnet-sdk-6.0.419-linux-x64.tar.gz -C /var/lib/jenkins/.dotnet

# 4. Задаване на права
echo "🔐 Задаване на права..."
sudo chown -R jenkins:jenkins /var/lib/jenkins/.dotnet
sudo chmod -R 755 /var/lib/jenkins/.dotnet

# 5. Създаване на символична връзка
echo "🔗 Създаване на символична връзка..."
sudo ln -sf /var/lib/jenkins/.dotnet/dotnet /usr/local/bin/dotnet

# 6. Почистване на временните файлове
echo "🧹 Почистване на временните файлове..."
rm -f /tmp/dotnet-runtime-6.0.25-linux-x64.tar.gz
rm -f /tmp/dotnet-sdk-6.0.419-linux-x64.tar.gz

# 7. Проверка на инсталацията
echo "✅ Проверка на инсталацията..."
sudo -u jenkins /var/lib/jenkins/.dotnet/dotnet --version
sudo -u jenkins /var/lib/jenkins/.dotnet/dotnet --list-sdks
sudo -u jenkins /var/lib/jenkins/.dotnet/dotnet --list-runtimes

# 8. Рестартиране на Jenkins
echo "🔄 Рестартиране на Jenkins..."
sudo systemctl restart jenkins

echo "🎉 Настройката завърши успешно!"
echo "📋 Следващи стъпки:"
echo "   1. Отворете Jenkins UI: http://localhost:8080"
echo "   2. Създайте нов pipeline job"
echo "   3. Използвайте Jenkinsfile.simple като Pipeline script"
echo "   4. Стартирайте build-а" 