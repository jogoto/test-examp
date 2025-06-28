pipeline {
    agent {
        docker {
            image 'mcr.microsoft.com/dotnet/sdk:6.0'
            args '-u root'
        }
    }
    
    environment {
        DOTNET_VERSION = '6.0'
        SOLUTION_FILE = 'HouseRentingSystem.sln'
        TEST_PROJECTS = 'HouseRentingSystem.Tests,HouseRentingSystem.UnitTests'
        COVERAGE_DIR = 'coverage'
        TEST_RESULTS_DIR = 'test-results'
    }
    
    stages {
        stage('Checkout') {
            steps {
                script {
                    // Извличане на кода от Git
                    checkout scm
                    
                    // Решаване на Git ownership проблема
                    sh '''
                        # Конфигуриране на Git за безопасна директория
                        git config --global --add safe.directory /var/jenkins_home/workspace/${JOB_NAME}
                        
                        # Проверка на текущия branch
                        git rev-parse --abbrev-ref HEAD
                    '''
                    
                    // Проверка дали сме в main branch
                    def currentBranch = sh(
                        script: 'git rev-parse --abbrev-ref HEAD',
                        returnStdout: true
                    ).trim()
                    
                    echo "Текущият branch е: ${currentBranch}"
                    
                    // Проверка дали сме в main branch
                    if (currentBranch != 'main') {
                        error "❌ Pipeline може да се изпълнява само в main branch! Текущият branch е: ${currentBranch}"
                    }
                    
                    echo "✅ Изпълняване в main branch - продължаваме..."
                }
            }
        }
        
        stage('Restore Dependencies') {
            steps {
                script {
                    echo 'Възстановяване на NuGet зависимости...'
                    sh 'dotnet restore ${SOLUTION_FILE}'
                }
            }
        }
        
        stage('Build') {
            steps {
                script {
                    echo 'Компилиране на решението...'
                    sh 'dotnet build ${SOLUTION_FILE} --configuration Release --no-restore'
                }
            }
            post {
                always {
                    // Архивиране на build артефакти
                    archiveArtifacts artifacts: '**/bin/Release/**/*.dll', fingerprint: true
                    archiveArtifacts artifacts: '**/bin/Release/**/*.exe', fingerprint: true
                }
            }
        }
        
        stage('Test') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        script {
                            echo 'Изпълняване на Unit тестове...'
                            sh '''
                                dotnet test HouseRentingSystem.UnitTests/HouseRentingSystem.UnitTests.csproj \
                                    --configuration Release \
                                    --no-build \
                                    --logger "trx;LogFileName=unit-tests.trx" \
                                    --results-directory ${TEST_RESULTS_DIR} \
                                    --collect:"XPlat Code Coverage" \
                                    --settings HouseRentingSystem.UnitTests/CodeCoverage.runsettings
                            '''
                        }
                    }
                    post {
                        always {
                            // Архивиране на unit test резултати
                            publishTestResults testResultsPattern: '${TEST_RESULTS_DIR}/**/*.trx'
                        }
                    }
                }
                
                stage('Integration Tests') {
                    steps {
                        script {
                            echo 'Изпълняване на Integration тестове...'
                            sh '''
                                dotnet test HouseRentingSystem.Tests/HouseRentingSystem.Tests.csproj \
                                    --configuration Release \
                                    --no-build \
                                    --logger "trx;LogFileName=integration-tests.trx" \
                                    --results-directory ${TEST_RESULTS_DIR} \
                                    --collect:"XPlat Code Coverage" \
                                    --settings HouseRentingSystem.Tests/CodeCoverage.runsettings
                            '''
                        }
                    }
                    post {
                        always {
                            // Архивиране на integration test резултати
                            publishTestResults testResultsPattern: '${TEST_RESULTS_DIR}/**/*.trx'
                        }
                    }
                }
            }
        }
        
        stage('Code Coverage') {
            steps {
                script {
                    echo 'Генериране на отчет за покритие на кода...'
                    sh '''
                        # Създаване на директория за покритие
                        mkdir -p ${COVERAGE_DIR}
                        
                        # Генериране на отчет за покритие
                        dotnet test ${SOLUTION_FILE} \
                            --configuration Release \
                            --no-build \
                            --collect:"XPlat Code Coverage" \
                            --results-directory ${COVERAGE_DIR}
                    '''
                }
            }
            post {
                always {
                    // Архивиране на coverage резултати
                    archiveArtifacts artifacts: '${COVERAGE_DIR}/**/*', fingerprint: true
                }
            }
        }
        
        stage('Publish Test Results') {
            steps {
                script {
                    echo 'Публикуване на резултати от тестовете...'
                    // Публикуване на всички test резултати
                    publishTestResults testResultsPattern: '**/*.trx'
                }
            }
        }
    }
    
    post {
        always {
            script {
                echo 'Pipeline завърши с резултат: ' + currentBuild.result
                
                // Изчистване на workspace
                cleanWs()
            }
        }
        success {
            script {
                echo '✅ Pipeline завърши успешно!'
                echo '�� Тестовете са изпълнени успешно'
                echo '📈 Отчетите за покритие на кода са генерирани'
            }
        }
        failure {
            script {
                echo '❌ Pipeline завърши с грешка!'
                echo '🔍 Проверете логовете за повече информация'
            }
        }
        unstable {
            script {
                echo '⚠️ Pipeline завърши неуспешно (тестове провалени)'
                echo '🔍 Проверете резултатите от тестовете'
            }
        }
    }
} 