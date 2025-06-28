#!/bin/bash

# Скрипт за инсталиране на Docker на Jenkins server
# Изпълнете този скрипт като root или с sudo

set -e

echo "🐳 Инсталиране на Docker на Jenkins server..."
echo "============================================="

# Проверка дали Docker вече е инсталиран
if command -v docker &> /dev/null; then
    echo "✅ Docker вече е инсталиран!"
    docker --version
else
    echo "📦 Инсталиране на Docker..."
    
    # Обновяване на пакетния мениджър
    apt-get update
    
    # Инсталиране на необходими пакети
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    
    # Добавяне на Docker GPG ключ
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    # Добавяне на Docker repository
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Обновяване на пакетния мениджър
    apt-get update
    
    # Инсталиране на Docker
    apt-get install -y docker-ce docker-ce-cli containerd.io
    
    echo "✅ Docker е инсталиран успешно!"
fi

# Стартиране на Docker service
echo "🚀 Стартиране на Docker service..."
systemctl start docker
systemctl enable docker

# Проверка на Docker статуса
echo "📋 Проверка на Docker статуса..."
systemctl status docker --no-pager

# Добавяне на jenkins потребителя в docker групата
echo "👤 Добавяне на jenkins потребителя в docker групата..."
usermod -aG docker jenkins

# Проверка на групите на jenkins потребителя
echo "📋 Групи на jenkins потребителя:"
groups jenkins

# Тестване на Docker
echo "🧪 Тестване на Docker..."
docker --version
docker run hello-world

echo ""
echo "🎉 Docker е инсталиран и конфигуриран успешно!"
echo ""
echo "Следващи стъпки:"
echo "1. Рестартирайте Jenkins service: sudo systemctl restart jenkins"
echo "2. Проверете дали Jenkins може да използва Docker"
echo "3. Тествайте pipeline-а отново" 