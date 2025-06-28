# Jenkins Pipeline Setup за HouseRentingSystem

Този документ описва как да настроите Jenkins pipeline за автоматично build и test на .NET приложението.

## Предварителни изисквания

### 1. Jenkins Server
- Jenkins 2.387+ инсталиран
- Следните Jenkins plugins:
  - Git plugin
  - Pipeline plugin
  - Test Results Analyzer plugin
  - Cobertura Plugin (за code coverage отчети)

### 2. Jenkins Agent/Node
Имате два варианта за Jenkins агент:

#### Вариант A: Docker Agent (Препоръчан)
- Docker инсталиран на Jenkins server
- Jenkins има права за изпълнение на Docker команди

#### Вариант B: Стандартен Agent
- .NET 6.0 SDK инсталиран
- Git инсталиран
- Достатъчно disk space за build артефакти

## Настройка на Jenkins Pipeline

### 1. Създаване на нов Pipeline Job

1. Отворете Jenkins dashboard
2. Кликнете "New Item"
3. Изберете "Pipeline"
4. Въведете име: `HouseRentingSystem-Pipeline`
5. Кликнете "OK"

### 2. Конфигурация на Pipeline

В секцията "Pipeline", изберете:
- **Definition**: Pipeline script from SCM
- **SCM**: Git
- **Repository URL**: URL на вашия Git repository
- **Credentials**: Добавете credentials за достъп до repository
- **Branch Specifier**: `*/main`
- **Script Path**: `Jenkinsfile` (за Docker версия) или `Jenkinsfile.simple` (за стандартен агент)

### 3. Настройка на Triggers

В секцията "Build Triggers":
- ✅ **Poll SCM**: `H/5 * * * *` (проверява за промени на всеки 5 минути)
- ✅ **GitHub hook trigger for GITScm polling** (ако използвате GitHub)

### 4. Настройка на Post-build Actions

В секцията "Post-build Actions":
- ✅ **Publish test results report**: `**/*.trx`
- ✅ **Publish Cobertura Coverage Report**: `coverage/**/cobertura-coverage.xml`

## Използване на Pipeline Files

### Jenkinsfile (Docker версия)
Използвайте този файл, ако искате да използвате Docker контейнер с .NET 6.0:

```bash
# В Jenkins конфигурацията:
Script Path: Jenkinsfile
```

### Jenkinsfile.simple (Стандартна версия)
Използвайте този файл, ако имате Jenkins агент с предварително инсталиран .NET:

```bash
# В Jenkins конфигурацията:
Script Path: Jenkinsfile.simple
```

## Стъпки в Pipeline

### 1. Checkout
- Извлича кода от Git repository
- Проверява дали сте в main branch

### 2. Restore Dependencies
- Възстановява NuGet пакетите

### 3. Build
- Компилира решението в Release конфигурация
- Архивира build артефакти

### 4. Test (Docker версия)
- **Unit Tests**: Изпълнява HouseRentingSystem.UnitTests
- **Integration Tests**: Изпълнява HouseRentingSystem.Tests
- Тестовете се изпълняват паралелно за по-бързо време

### 5. Run All Tests (Проста версия)
- Изпълнява всички тестове последователно

### 6. Code Coverage
- Генерира отчети за покритие на кода
- Използва Cobertura формат

## Конфигурационни файлове

### CodeCoverage.runsettings
Тези файлове конфигурират code coverage за тестовете:
- `HouseRentingSystem.UnitTests/CodeCoverage.runsettings`
- `HouseRentingSystem.Tests/CodeCoverage.runsettings`

Конфигурациите:
- Изключват Program.cs, Startup.cs и Migration файлове
- Използват Cobertura формат за отчети
- Включват SourceLink за по-добра навигация

## Мониторинг и отчети

### Test Results
- Резултатите се показват в Jenkins dashboard
- Можете да видите детайлни отчети за всеки test

### Code Coverage
- Отчетите се показват в Jenkins dashboard
- Покритието се измерва за всички проекти

### Build Artifacts
- DLL и EXE файлове се архивират
- Coverage отчети се запазват

## Troubleshooting

### Често срещани проблеми

1. **Docker не е достъпен**
   - Проверете дали Jenkins има права за Docker
   - Използвайте Jenkinsfile.simple вместо Jenkinsfile

2. **.NET не е намерен**
   - Инсталирайте .NET 6.0 SDK на Jenkins агента
   - Проверете PATH променливите

3. **Тестове провалват**
   - Проверете логовете на тестовете
   - Уверете се, че всички зависимости са инсталирани

4. **Code Coverage не се генерира**
   - Проверете дали coverlet.collector пакетът е инсталиран
   - Уверете се, че runsettings файловете са правилно конфигурирани

## Автоматизация

За да активирате автоматично изпълнение при push в main branch:

1. В GitHub repository settings:
   - Отидете в Settings > Webhooks
   - Добавете Jenkins URL: `http://your-jenkins-url/github-webhook/`

2. В Jenkins job конфигурация:
   - Включете "GitHub hook trigger for GITScm polling"

Сега pipeline ще се изпълнява автоматично при всеки push в main branch! 