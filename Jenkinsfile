pipeline {
    agent any
    stages {
        stage('Clone git') {
            steps {
                // Get some code from a GitHub repository
                git url: 'https://github.com/sarwandria/simple-java-maven-app.git', branch: 'master'
            }
        }
        stage('Build'){
            agent {
                docker {
                    reuseNode true
                    image 'maven:3.5.4-alpine'
                    args '-v /root/.m2:/root/.m2'
                }
            }
            stages('Build & test') {
                stage('Build App') {
                    steps {
                        sh 'mvn -B -DskipTests clean package'
                    }
                }
                stage('Test') {
                    steps {
                        sh 'mvn test'
                    }
                    post {
                        always {
                            junit 'target/surefire-reports/*.xml'
                        }
                    }
                }
                stage('Deliver') {
                    steps {
                        sh './jenkins/scripts/deliver.sh'
                    }
                }
            }
        }    
        
    }
