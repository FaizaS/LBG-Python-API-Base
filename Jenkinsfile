pipeline {
    agent any
    stages {
        stage('Init') {
            steps {
                script {
			        if (env.GIT_BRANCH == 'origin/main') {
                        sh '''
                        kubectl create ns prod || echo "Prod Namespace Already Exists"
                        '''
                    } else if (env.GIT_BRANCH == 'origin/dev') {
                        sh '''
                        kubectl create ns dev || echo "Dev Namespace Already Exists"
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
                        docker build -t faizashahid/project-flask-api -t faizashahid/project-flask-api:prod-v${BUILD_NUMBER} .
                        '''
                    } else if (env.GIT_BRANCH == 'origin/dev') {
                        sh '''
                        docker build -t faizashahid/project-flask-api -t faizashahid/project-flask-api:dev-v${BUILD_NUMBER} .
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
                        docker push faizashahid/project-flask-api
                        docker push faizashahid/project-flask-api:prod-v${BUILD_NUMBER}
                        '''
                    } else if (env.GIT_BRANCH == 'origin/dev') {
                        sh '''                        
                        docker push faizashahid/project-flask-api
                        docker push faizashahid/project-flask-api:dev-v${BUILD_NUMBER}
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
                        kubectl apply -n prod -f ./kubernetes
                        kubectl set image deployment/flask-api-deployment flast-container=faizashahid/project-flask-api:prod-v${BUILD_NUMBER} -n prod
                        '''
                    } else if (env.GIT_BRANCH == 'origin/dev') {
                        sh '''
                        kubectl apply -n prod -f ./kubernetes
                        kubectl set image deployment/flask-api-deployment flast-container=faizashahid/project-flask-api:dev-v${BUILD_NUMBER} -n dev
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
                    if (env.GIT_BRANCH == 'origin/main') {
                        sh '''
                        docker rmi faizashahid/project-flask-api:prod-v${BUILD_NUMBER}
                        '''
                    } else if (env.GIT_BRANCH == 'origin/dev') {
                        sh '''
                        docker rmi faizashahid/project-flask-api:dev-v${BUILD_NUMBER}
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
