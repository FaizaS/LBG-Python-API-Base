#!/bin/bash

# Exit script if any command fails
set -e

# Define Docker image name
DOCKER_IMAGE1="lbg_python_api"
DOCKER_IMAGE2="nginx"
# cleanup() {
#     echo "Cleaning up previous build artifacts..."
#     sleep 3
#     #ssh -i ~/.ssh/id_rsa jenkins@10.154.0.36 << EOF
#     # Add commands to clean up previous build artifacts
#     docker stop flask-app || echo "flask-app is not running"
#     docker rm -f $(docker ps -aq) || true
#     docker rmi -f $(docker images) || true
#     echo "Cleanup done."
# }

# Function to build the Docker image
build_docker() {
    echo "Building the Docker image..."
    sleep 3
    docker build -t faizashahid/$DOCKER_IMAGE1:latest -t faizashahid/$DOCKER_IMAGE1:v${BUILD_NUMBER} .
    docker build -t faizashahid/nginx:latest -t faizashahid/nginx:v${BUILD_NUMBER} ./nginx
}

#push_docker () {
#     echo "Pushing the docker image..."
#     sleep 3
#     docker push faizashahid/$DOCKER_IMAGE
#     docker push faizashahid/$DOCKER_IMAGE:v${BUILD_NUMBER}
# }

# Function to modify the application
modify_app() {
    echo "Modifying the application..."
    sleep 3
    export PORT=5001
    echo "Modifications done. Port is now set to $PORT"
}

# Function to run the Docker container
# run_docker() {
#     echo "Running Docker container..."
#     sleep 3
#     #ssh -i ~/.ssh/id_rsa jenkins@10.154.0.36
#     docker run -d -p 80:$PORT -e PORT=$PORT --name flask-app faizashahid/$DOCKER_IMAGE
# }

# Main script execution
echo "Starting build process..."
sleep 3
#cleanup
build_docker
modify_app
#push_docker
build_docker
#run_docker

echo "Build process completed successfully."