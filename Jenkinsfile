pipeline {
    agent any
    stages {
        stage('Init') {
            steps {
                sh '''
                ssh -i ~/.ssh/id_rsa jenkins@10.154.0.36 << EOF

                docker stop flask-app || echo "flask-app is not running"
                docker stop nginx || echo "nginx is not running"
                docker rm -f $(docker ps -aq) || true
                docker rmi -f $(docker images) || true
                docker network create project-network || true
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
        
        stage('Push') {
            steps {
                sh '''
                docker push faizashahid/lbg_python_api:latest
                docker push faizashahid/lbg_python_api:v${BUILD_NUMBER}
                docker push faizashahid/nginx:latest
                docker push faizashahid/nginx:v${BUILD_NUMBER}
                '''
           }
        }

         stage('Deploy') {
            steps {
                sh '''
                ssh -i ~/.ssh/id_rsa jenkins@10.154.0.36 << EOF
                // docker run -d -p 80:5001 -e PORT=5001 --name flask-app faizashahid/lbg_python_api:latest
                docker run -d -p 80:5001 -e PORT=5001 --name lbg_python_api --network project-network faizashahid/lbg_python_api:latest
                docker run -d -p 80:80 --name lbg_nginx --network project-network faizashahid/lbg_nginx:latest
                '''
           }
        }
    }
}
