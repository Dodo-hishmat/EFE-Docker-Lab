pipeline {
    // 1. Define where the pipeline will run
    agent any

    // 2. Set up environment variables for the pipeline
    environment {
        // Define the Docker image name.
        // IMPORTANT: Change 'nardeen' to your actual Docker Hub username!
        DOCKER_IMAGE_NAME = "nardeen/efe-docker-lab"
        // Define a unique name for the test container to avoid conflicts
        CONTAINER_NAME = "efe-node-app-${BUILD_NUMBER}"
    }

    // 3. Define the stages of the pipeline
    stages {
        

        // STAGE 2: Build the Docker image from the Dockerfile
        // This corresponds to the "Dockerization" requirement in your lab
        stage('Build Docker Image') {
            steps {
                echo "Building the Docker image..."
                // The '-t' flag tags the image with a name and the current build number
                sh "docker build -t ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }

        // STAGE 3: Run the container to make sure it works
        // This corresponds to the "Local Deployment" requirement
        stage('Run & Verify Container') {
            steps {
                echo "Running the container for verification..."
                // Run the container in detached mode (-d) and map the ports (-p)
                sh "docker run -d --name ${CONTAINER_NAME} -p 3000:3000 ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"

                echo "Waiting 15 seconds for the application to start..."
                sleep 15 // Give the Node.js app time to initialize

                echo "Verifying the application is responding..."
                // Use curl to check if the app is accessible on localhost:3000
                // The '-f' flag makes curl fail if it gets an HTTP error (like 404 or 500)
                sh "curl --fail http://localhost:3000"
            }
        }

        // STAGE 4: Push the successful build to a registry
        // This is the "pipeline way" of distributing the final product
        stage('Push to Docker Hub') {
            steps {
                echo "Logging in to Docker Hub and pushing the image..."
                // Use Jenkins credentials for Docker Hub.
                // NOTE: You must set this up in Jenkins first! (See instructions below)
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    // Login to Docker Hub using the stored credentials
                    sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                    // Push the tagged image to the repository
                    sh "docker push ${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
                }
            }
        }
    }

    // 4. Define post-build actions to clean up
    post {
        always {
            // This block runs at the end, regardless of whether the pipeline succeeded or failed
            echo "Cleaning up the test container..."
            // Stop and remove the container to keep the Jenkins server clean
            sh "docker stop ${CONTAINER_NAME} || true"
            sh "docker rm ${CONTAINER_NAME} || true"
        }
    }
}
