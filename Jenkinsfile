pipeline {
    agent any

    tools {
        maven 'Maven3912'
        jdk 'JDK25'

    }

    environment {
        //PATH = "/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH}"
        PATH = "/usr/local/bin:/opt/homebrew/bin:${env.PATH}"
        DOCKERHUB_CREDENTIALS_ID = 'docker_hub'
        DOCKERHUB_REPO = 'tuusitalo/proj_course_2_week_6'
        DOCKER_IMAGE_TAG = 'latest'
    }

    stages {

        stage ('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/TuukkaUusitalo/proj_course_2_week_6'
            }
        }

        stage ('build'){
            steps {
                sh 'mvn clean install'
            }
        }

        stage ('Generate report') {
            steps {
                sh 'mvn jacoco:report'
            }
        }

        stage('Publish Test Results') {
            steps {
                junit '**/target/surefire-reports/*.xml'
            }
        }

        stage('Publish Coverage Report') {
            steps {
                jacoco()
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQubeServer') { // nimi Jenkins configista
                    sh 'mvn sonar:sonar'
                }
            }
        }

        stage("Quality Gate") {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Check Docker') {
            steps {
                sh 'echo PATH=$PATH'
                sh 'which docker || echo "docker not found"'
                sh 'docker info || echo "docker info failed"'
            }
        }

        stage('docker builder prune -f') {
            steps {
                sh 'docker builder prune -f'
            }
        }

        stage('Build Docker Image') {
            steps {
            script {
                    docker.build("${DOCKERHUB_REPO}:${DOCKER_IMAGE_TAG}")
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKERHUB_CREDENTIALS_ID,
                                                 usernameVariable: 'DOCKER_USER',
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        docker context use default
                        echo "\$DOCKER_PASS" | docker login -u "\$DOCKER_USER" --password-stdin
                        docker push ${DOCKERHUB_REPO}:${DOCKER_IMAGE_TAG}
                    """
                }
            }
        }
    }
}