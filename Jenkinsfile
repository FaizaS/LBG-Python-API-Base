pipeline {
    agent any
    stages {
        stage('Init') {
            steps {
                sh '''
                ssh -i ~/.ssh/id_rsa jenkins@10.154.0.36 << EOF

                docker stop flask-app || echo "flask-app is not running"
                docker rm flask-app 


                docker stop nginx || echo "nginx is not running"
                docker rm nginx

                docker rmi faizashahid/lbg_python_api || echo "Image does not exist"
                docker rmi faizashahid/my-nginx || echo "Image does not exist"

                // docker rm -f 
                // docker rm -f $(docker ps -aq) || true
                // docker rmi -f $(docker images) || true

                docker network create project || true
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
                docker push faizashahid/lbg_python_api
                docker push faizashahid/lbg_python_api:v${BUILD_NUMBER}
                docker push faizashahid/my-nginx
                docker push faizashahid/my-nginx:v${BUILD_NUMBER}
                '''
           }
        }

         stage('Deploy') {
            steps {
                sh '''
                ssh -i ~/.ssh/id_rsa jenkins@10.154.0.36 << EOF

                docker run -d --name flask-app --network project faizashahid/lbg_python_api
                docker run -d -p 80:80 --name nginx --network project faizashahid/my-nginx
                '''
           }
        }

        stage('Cleanup') {
            steps {
                sh '''
                docker system prune -f 
                docker rmi faizashahid/lbg_python_api:v${BUILD_NUMBER}
                docker rmi faizashahid/my-nginx:v${BUILD_NUMBER}
                '''
           }
    }
 }

}
