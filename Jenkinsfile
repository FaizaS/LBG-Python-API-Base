pipeline {
    agent any
    stages {
    DOCKER_IMAGE="lbg_python_api"
    PORT=5001
        stage('Init') {
            steps {
                sh '''
                ssh -i ~/.ssh/id_rsa jenkins@10.154.0.3 << EOF

                docker stop flask-app || echo "flask-app is not running"
                docker rm -f $(docker ps -aq) || true
                docker rmi -f $(docker images) || true
                echo "Cleanup done."
                '''
           }
        }
        stage('Build step') {
            steps {
                sh '''
                sh setup.sh
                '''
           }
        }

         stage('Deploy') {
            steps {
                sh '''
                ssh -i ~/.ssh/id_rsa jenkins@10.154.0.3 << EOF
                docker run -d -p 80:$PORT -e PORT=$PORT --name flask-app faizashahid/$DOCKER_IMAGE
                '''
           }
        }
    }
}
