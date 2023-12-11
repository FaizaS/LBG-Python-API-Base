pipeline {
    agent any
    stages {
        stage('Init') {
            steps {
                script {
			        if (env.GIT_BRANCH == 'origin/main') {
                        sh '''
                        ssh -i ~/.ssh/id_rsa jenkins@10.154.0.36 << EOF
                        docker stop flask-app || echo "flask-app is not running"
                        docker rm flask-app 
                        docker stop nginx || echo "nginx is not running"
                        docker rm nginx
                        docker rmi faizashahid/lbg_python_api || echo "Image does not exist"
                        docker rmi faizashahid/my-nginx || echo "Image does not exist"

                        docker network create project || true
                        '''
                    } else if (env.GIT_BRANCH == 'origin/dev') {
                        sh '''
                        // docker build -t eu.gcr.io/lbg-mea-14/piers-flask-demo:latest -t eu.gcr.io/lbg-mea-14/piers-flask-demo:v$BUILD_NUMBER .
                        ssh -i ~/.ssh/id_rsa jenkins@10.154.15.192 << EOF
                        docker stop flask-app || echo "flask-app is not running"
                        docker rm flask-app 
                        docker stop nginx || echo "nginx is not running"
                        docker rm nginx
                        docker rmi faizashahid/lbg_python_api || echo "Image does not exist"
                        docker rmi faizashahid/my-nginx || echo "Image does not exist"
                        docker network create project || true
                        '''
                    } else {
                        sh '''
                        echo "Unrecognised branch"
                        '''
                    }
                }
           }
        }
        stage('Build step') {
            steps {
                script {
			        if (env.GIT_BRANCH == 'origin/main') {
                        sh '''
                        // sh setup.sh
                        echo "Build not required in main"
                        '''
                    } else if (env.GIT_BRANCH == 'origin/dev') {
                        sh '''
                        // docker build -t eu.gcr.io/lbg-mea-14/piers-flask-demo:latest -t eu.gcr.io/lbg-mea-14/piers-flask-demo:v$BUILD_NUMBER .
                        docker build -t faizashahid/lbg_python_api -t faizashahid/lbg_python_api:v${BUILD_NUMBER} .
                        docker build -t faizashahid/my-nginx -t faizashahid/my-nginx:v${BUILD_NUMBER} ./nginx
                        '''
                    } else {
                        sh '''
                        echo "Unrecognised branch"
                        '''
                    }
		        }
           }
        }
        
        stage('Push') {
            steps {
                script {
			        if (env.GIT_BRANCH == 'origin/main') {
                        sh '''
                        echo "Push not required in main"
                        '''
                    } else if (env.GIT_BRANCH == 'origin/dev') {
                        sh '''                        
                        docker push faizashahid/lbg_python_api
                        docker push faizashahid/lbg_python_api:v${BUILD_NUMBER}
                        docker push faizashahid/my-nginx
                        docker push faizashahid/my-nginx:v${BUILD_NUMBER}
                        '''
                    } else {
                        sh '''
                        echo "Unrecognised branch"
                        '''
                    }
		        }
           }
        }

         stage('Deploy') {
            steps {
                script {
			        if (env.GIT_BRANCH == 'origin/main') {
                        sh '''
                        ssh -i ~/.ssh/id_rsa jenkins@10.154.0.36 << EOF
                        docker run -d --name flask-app --network project faizashahid/lbg_python_api
                        docker run -d -p 80:80 --name nginx --network project faizashahid/my-nginx
                        '''
                    } else if (env.GIT_BRANCH == 'origin/dev') {
                        sh '''
                        ssh -i ~/.ssh/id_rsa jenkins@10.154.15.192 << EOF
                        docker run -d --name flask-app --network project faizashahid/lbg_python_api
                        docker run -d -p 80:80 --name nginx --network project faizashahid/my-nginx
                        '''
                    } else {
                        sh '''
                        echo "Unrecognised branch"
                        '''
                    }
                }
           }
        }

        stage('Cleanup') {
            steps {
                script{
                    if (env.GIT_BRANCH == 'origin/dev') {
                        sh '''
                        docker rmi faizashahid/lbg_python_api:v${BUILD_NUMBER}
                        docker rmi faizashahid/my-nginx:v${BUILD_NUMBER}
                        '''
                    }
                }
                sh '''
                docker system prune -f 
                '''
            }
        }
    }  

}
