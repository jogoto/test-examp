#!/bin/bash

# Скрипт за тестване на Jenkins pipeline стъпките локално
# Използвайте този скрипт за да проверите дали всичко работи преди да настроите Jenkins

set -e  # Спиране при грешка

echo "🏗️  Тестване на Jenkins Pipeline стъпките..."
echo "=========================================="

# Проверка на .NET версията
echo "📋 Проверка на .NET версията..."
dotnet --version

# Проверка на Git
echo "📋 Проверка на Git..."
git --version

# Проверка на текущия branch
echo "📋 Проверка на текущия branch..."
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "Текущият branch е: $CURRENT_BRANCH"

if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "⚠️  Внимание: Не сте в main branch!"
    echo "Pipeline ще работи, но се уверете, че сте в правилния branch за production"
fi

echo ""
echo "🔄 Стъпка 1: Възстановяване на зависимости..."
dotnet restore HouseRentingSystem.sln

echo ""
echo "🔨 Стъпка 2: Компилиране на решението..."
dotnet build HouseRentingSystem.sln --configuration Release --no-restore

echo ""
echo "🧪 Стъпка 3: Изпълняване на Unit тестове..."
dotnet test HouseRentingSystem.UnitTests/HouseRentingSystem.UnitTests.csproj \
    --configuration Release \
    --no-build \
    --logger "console;verbosity=normal"

echo ""
echo "🧪 Стъпка 4: Изпълняване на Integration тестове..."
dotnet test HouseRentingSystem.Tests/HouseRentingSystem.Tests.csproj \
    --configuration Release \
    --no-build \
    --logger "console;verbosity=normal"

echo ""
echo "📊 Стъпка 5: Генериране на Code Coverage отчет..."
mkdir -p coverage

dotnet test HouseRentingSystem.sln \
    --configuration Release \
    --no-build \
    --collect:"XPlat Code Coverage" \
    --results-directory coverage

echo ""
echo "✅ Всички стъпки завършиха успешно!"
echo "📁 Coverage отчетите са в директорията: coverage/"
echo ""
echo "🎉 Вашият проект е готов за Jenkins pipeline!"
echo ""
echo "Следващи стъпки:"
echo "1. Настройте Jenkins server"
echo "2. Създайте нов Pipeline job"
echo "3. Конфигурирайте Git repository"
echo "4. Изберете Jenkinsfile или Jenkinsfile.simple"
echo "5. Активирайте автоматично изпълнение при push в main branch" 