pipeline {
    // 1. Define where the pipeline will run
    agent any

    // 2. Set up environment variables
    environment {
        // Define the Docker image name.
        // Change 'nardeen' to your Docker Hub username or any other name.
        DOCKER_IMAGE_NAME = "nardeen/efe-docker-lab"
        // Define a unique name for the test container
        CONTAINER_NAME = "efe-node-app-${BUILD_NUMBER}"
    }

    // 3. Define the stages of the pipeline
    stages {
        // STAGE 1: Get the source code
        stage('Checkout from GitHub') {
            steps {
                echo "Cloning the repository..."
                git 'https://github.com/Dodo-hishmat/EFE-Docker-Lab.git'
            }
        }

        // STAGE 2: Build the Docker image from the Dockerfile
        // Fulfills the "Dockerization" requirement 
        stage('Build Docker Image') {
            steps {
                echo "Building the Docker image..."
                sh "docker build -t ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }

        // STAGE 3: Run the container to make sure it works
        // Fulfills the "Local Deployment" requirement 
        stage('Run & Verify Container') {
            steps {
                echo "Running the container for verification..."
                sh "docker run -d --name ${CONTAINER_NAME} -p 3000:3000 ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"

                echo "Waiting 15 seconds for the application to start..."
                sleep 15 // Give the Node.js app time to initialize

                echo "Verifying the application is responding..."
                // Use curl to check if the app is accessible on localhost:3000
                sh "curl --fail http://localhost:3000"
            }
        }
    }

    // 4. Define post-build actions to clean up
    post {
        always {
            // This block always runs at the end to clean up the test container
            echo "Cleaning up the test container..."
            sh "docker stop ${CONTAINER_NAME} || true"
            sh "docker rm ${CONTAINER_NAME} || true"
        }
    }
}
