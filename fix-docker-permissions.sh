#!/bin/bash

# Скрипт за решаване на Docker правата за Jenkins
# Изпълнете този скрипт като root или с sudo

set -e

echo "🔧 Решаване на Docker правата за Jenkins..."
echo "=========================================="

# Проверка на текущите групи на jenkins потребителя
echo "📋 Текущи групи на jenkins потребителя:"
groups jenkins

# Добавяне на jenkins потребителя в docker групата
echo "👤 Добавяне на jenkins потребителя в docker групата..."
usermod -aG docker jenkins

# Проверка на правата на Docker socket
echo "📋 Проверка на правата на Docker socket:"
ls -la /var/run/docker.sock

# Проверка на групите след промяната
echo "📋 Групи на jenkins потребителя след промяната:"
groups jenkins

# Рестартиране на Jenkins service
echo "🔄 Рестартиране на Jenkins service..."
systemctl restart jenkins

# Проверка на Jenkins статуса
echo "📋 Проверка на Jenkins статуса:"
systemctl status jenkins --no-pager

# Тестване на Docker правата
echo "🧪 Тестване на Docker правата..."
echo "Изпълнете следната команда като jenkins потребител:"
echo "sudo -u jenkins docker --version"

echo ""
echo "✅ Docker правата са настроени!"
echo ""
echo "Следващи стъпки:"
echo "1. Изчакайте Jenkins да се рестартира напълно"
echo "2. Тествайте pipeline-а отново"
echo "3. Ако все още има проблеми, проверете логовете на Jenkins" 