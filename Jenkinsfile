node {
    withEnv(['GET_COMMIT_HASH = get_commit_hash()',
            'ECR_PROTOCOL = https://',
            'ECR_URL = registry.gitlab.com',
            'ECR_CREDENTIAL = gitlab_user_pass'
    ]) {
        stage('Clone app git') {
            // Get some code from a GitHub repository
            git url: 'https://github.com/sarwandria/simple-java-maven-app.git', branch: 'master'
        }
        stage('Clone config git') {
            // Get some code from a GitHub repository
            sh 'mkdir -p config'
            dir('config') {
                git branch: 'main',
                url: 'https://github.com/sarwandria/IAC.git'
            }
        }
        stage('Copy Config file'){
        sh '''
                cp config/app/simple-java-maven-app/* .
                rm -rf config
                '''
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
        }
        stage('Push image') {
            // build image and pust to registry
            docker.build("registry.gitlab.com/sarwandria/simple-java-maven-app:${BUILD_NUMBER}", "-f Dockerfile .")
            docker.withRegistry("https://registry.gitlab.com","gitlab_user_pass") {
                docker.image("registry.gitlab.com/sarwandria/simple-java-maven-app:${BUILD_NUMBER}").push("${BUILD_NUMBER}")
            }
        }
        stage('Manual Approval'){
            input(message: "Lanjutkan ke tahap Deploy?")
        }
        stage('Deploy') {

            // Deploy to docker swarm cluster
        sh '''
                export DOCKER_TLS_VERIFY=
                docker -H tcp://54.169.69.77:62376 stack deploy spring-boot-prod -c docker-compose.yml --with-registry-auth --resolve-image=always
            '''
         sleep(60)
        }
    }
 }