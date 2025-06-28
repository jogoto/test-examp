# Решаване на Docker проблеми в Jenkins

## Проблем: "docker: not found"

### Причина
Jenkins не може да намери Docker командата, защото:
1. Docker не е инсталиран на Jenkins server
2. Jenkins няма права за достъп до Docker
3. Docker не е в PATH на Jenkins

## Решения

### Решение 1: Инсталиране на Docker (Препоръчано)

#### Стъпка 1: Инсталиране на Docker
Изпълнете следните команди на Jenkins server като root или с sudo:

```bash
# Обновяване на пакетния мениджър
sudo apt-get update

# Инсталиране на необходими пакети
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Добавяне на Docker GPG ключ
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Добавяне на Docker repository
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Обновяване и инсталиране на Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
```

#### Стъпка 2: Стартиране на Docker service
```bash
# Стартиране на Docker
sudo systemctl start docker
sudo systemctl enable docker

# Проверка на статуса
sudo systemctl status docker
```

#### Стъпка 3: Настройка на права
```bash
# Добавяне на jenkins потребителя в docker групата
sudo usermod -aG docker jenkins

# Проверка на групите
groups jenkins
```

#### Стъпка 4: Рестартиране на Jenkins
```bash
# Рестартиране на Jenkins service
sudo systemctl restart jenkins
```

### Решение 2: Използване на Jenkinsfile без Docker

Ако не можете да инсталирате Docker, използвайте `Jenkinsfile.no-docker`:

1. В Jenkins job конфигурацията:
   - **Script Path**: `Jenkinsfile.no-docker`

2. Уверете се, че Jenkins агентът има инсталиран .NET 6.0:
   ```bash
   # Проверка на .NET версията
   dotnet --version
   ```

### Решение 3: Използване на Jenkinsfile.basic

За максимална съвместимост използвайте най-опростената версия:

1. В Jenkins job конфигурацията:
   - **Script Path**: `Jenkinsfile.basic`

## Проверка на инсталацията

### Проверка на Docker
```bash
# Проверка на Docker версията
docker --version

# Тестване на Docker
docker run hello-world

# Проверка на Docker daemon
sudo systemctl status docker
```

### Проверка на Jenkins права
```bash
# Проверка на групите на jenkins потребителя
groups jenkins

# Проверка на Docker socket права
ls -la /var/run/docker.sock
```

## Конфигурация на Jenkins

### Docker Cloud Configuration
1. Отидете в **Manage Jenkins** → **Configure System**
2. Намерете секцията **Cloud**
3. Добавете **Docker** cloud configuration
4. Конфигурирайте:
   - **Docker Host URI**: `unix:///var/run/docker.sock`
   - **Enabled**: ✅

### Тестване на Docker функционалност
Създайте тестов Pipeline job:

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

## Често срещани проблеми

### Проблем: "Permission denied"
```bash
# Решение 1: Добавяне в docker групата
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

# Решение 2: Временно даване на права (не се препоръчва)
sudo chmod 666 /var/run/docker.sock
```

### Проблем: "Cannot connect to the Docker daemon"
```bash
# Проверка на Docker service
sudo systemctl status docker

# Стартиране на Docker service
sudo systemctl start docker
sudo systemctl enable docker
```

### Проблем: "Docker daemon not running"
```bash
# Стартиране на Docker daemon
sudo systemctl start docker

# Проверка на логовете
sudo journalctl -u docker.service
```

## Препоръки

### За Production среда:
1. **Използвайте Docker** - по-изолирани и консистентни builds
2. **Настройте Docker security** - ограничете правата на контейнерите
3. **Мониторирайте ресурсите** - Docker може да използва много памет

### За Development среда:
1. **Използвайте Jenkinsfile.no-docker** - по-просто за настройка
2. **Инсталирайте .NET 6.0** на Jenkins агента
3. **Тествайте локално** преди да пуснете в Jenkins

## Следващи стъпки

След успешното решаване на Docker проблема:

1. **Тествайте pipeline-а** отново
2. **Конфигурирайте автоматично изпълнение** при push в main branch
3. **Настройте уведомления** за build резултати
4. **Мониторирайте performance** на pipeline-а

🎉 Успех с настройката! 