node {
    stage('Clone git') {
        // Get some code from a GitHub repository
        git url: 'https://github.com/sarwandria/simple-java-maven-app.git', branch: 'master'
    }
    docker.image('maven:3.5.4-alpine').inside('-v /root/.m2:/root/.m2'){
        stage('Build'){
            sh 'mvn -B -DskipTests clean package'
        }
        stage('Test') {
            try {
                sh 'mvn test'
            }
            finally {
                junit 'target/surefire-reports/*.xml'
            }
        }
        stage('Deliver') {
            sh './jenkins/scripts/deliver.sh'
        }
    }
 }