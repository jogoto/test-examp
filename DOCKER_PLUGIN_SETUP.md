# Инсталиране на Docker Plugin в Jenkins

## Стъпки за инсталиране

### 1. Отваряне на Plugin Manager
1. Влезте в Jenkins dashboard
2. Отидете в **Manage Jenkins** → **Manage Plugins**
3. Кликнете на таба **Available**

### 2. Търсене на Docker Plugins
В полето за търсене напишете "Docker" и инсталирайте следните plugins:

#### Основни Docker Plugins:
- ✅ **Docker Pipeline** (най-важен за Jenkinsfile)
- ✅ **Docker plugin** (основен Docker plugin)
- ✅ **Docker API Plugin**
- ✅ **docker-build-step**

### 3. Инсталиране
1. Поставете отметки в квадратчетата пред избраните plugins
2. Кликнете **Install without restart**
3. Изчакайте инсталирането да завърши

### 4. Рестартиране на Jenkins
1. Отидете в **Manage Jenkins** → **Manage Plugins**
2. Кликнете **Restart Jenkins when no jobs are running**
3. Изчакайте Jenkins да се рестартира

## Проверка на инсталацията

### 1. Проверка в System Information
1. Отидете в **Manage Jenkins** → **System Information**
2. Търсете за Docker-related информация
3. Проверете дали има Docker-related системни променливи

### 2. Проверка на Docker права
Изпълнете следните команди на Jenkins server:

```bash
# Проверка дали Docker е инсталиран
docker --version

# Проверка дали jenkins потребителят е в docker групата
groups jenkins

# Ако не е в групата, добавете го:
sudo usermod -aG docker jenkins

# Рестартиране на Jenkins service
sudo systemctl restart jenkins
```

## Конфигурация на Jenkins

### 1. Docker Cloud Configuration (опционално)
1. Отидете в **Manage Jenkins** → **Configure System**
2. Намерете секцията **Cloud**
3. Добавете **Docker** cloud configuration
4. Конфигурирайте Docker host URI (обикновено `unix:///var/run/docker.sock`)

### 2. Тестване на Docker функционалност
След инсталирането, можете да тествате дали Docker работи:

1. Създайте нов Pipeline job
2. Използвайте следния тестов код:

```groovy
pipeline {
    agent {
        docker {
            image 'hello-world'
        }
    }
    stages {
        stage('Test Docker') {
            steps {
                sh 'docker --version'
                sh 'echo "Docker работи успешно!"'
            }
        }
    }
}
```

## Използване на Jenkinsfile

След успешното инсталиране на Docker plugin, можете да използвате оригиналния Jenkinsfile:

```bash
# В Jenkins job конфигурацията:
Script Path: Jenkinsfile
```

## Troubleshooting

### Проблем: "Invalid agent type 'docker'"
**Решение:** Docker Pipeline plugin не е инсталиран

### Проблем: "Cannot connect to the Docker daemon"
**Решение:** 
1. Проверете дали Docker service работи: `sudo systemctl status docker`
2. Добавете jenkins потребителя в docker групата
3. Рестартирайте Jenkins

### Проблем: "Permission denied"
**Решение:**
```bash
# Дайте права на jenkins потребителя
sudo chmod 666 /var/run/docker.sock
# Или по-добре, добавете jenkins в docker групата
sudo usermod -aG docker jenkins
```

## Преимущества на Docker Agent

1. **Изолирани среди** - всеки build се изпълнява в чист контейнер
2. **Консистентност** - същата среда за всички builds
3. **Лесно управление** - няма нужда от инсталиране на .NET на Jenkins server
4. **Скалируемост** - можете да изпълнявате множество builds паралелно

## Следващи стъпки

След успешното инсталиране на Docker plugin:

1. Създайте нов Pipeline job в Jenkins
2. Конфигурирайте Git repository
3. Изберете `Jenkinsfile` като Script Path
4. Активирайте автоматично изпълнение при push в main branch
5. Тествайте pipeline-а

🎉 Успех с настройката! 