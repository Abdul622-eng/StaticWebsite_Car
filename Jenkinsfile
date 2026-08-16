pipeline {
 
    agent any
 
    parameters {
        string(
            name: 'GIT_BRANCH',
            defaultValue: 'main',
            description: 'GitHub branch to clone'
        )
 
        string(
            name: 'CONTAINER_NAME',
            defaultValue: 'myapp',
            description: 'Docker container name'
        )
 
        string(
            name: 'HOST_PORT',
            defaultValue: '8080',
            description: 'EC2 host port'
        )
 
        string(
            name: 'CONTAINER_PORT',
            defaultValue: '3000',
            description: 'Application container port'
        )
    }
 
    environment {
        GIT_URL = 'https://github.com/Abdul622-eng/StaticWebsite_Car.git'
        IMAGE_NAME = 'myapp-image'
    }
 
    stages {
 
        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }
 
        stage('Clone Application') {
            steps {
                echo "Cloning GitHub application..."
 
                git branch: "${params.GIT_BRANCH}",
                    url: "${env.GIT_URL}"
            }
        }
 
        stage('Create Dockerfile') {
            steps {
                sh '''
                    cat > Dockerfile <<'EOF'
                    FROM node:20-alpine
 
                    WORKDIR /app
 
                    COPY package*.json ./
 
                    RUN npm install
 
                    COPY . .
 
                    EXPOSE 3000
 
                    CMD ["npm", "start"]
                    EOF
                '''
 
                sh 'cat Dockerfile'
            }
        }
 
        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build \
                    -t ${IMAGE_NAME}:latest .
                '''
            }
        }
 
        stage('Stop Old Container') {
            steps {
                sh '''
                    docker stop ${CONTAINER_NAME} || true
                '''
            }
        }
 
        stage('Remove Old Container') {
            steps {
                sh '''
                    docker rm ${CONTAINER_NAME} || true
                '''
            }
        }
 
        stage('Run New Container') {
            steps {
                sh '''
                    docker run -d \
                    --name ${CONTAINER_NAME} \
                    -p ${HOST_PORT}:${CONTAINER_PORT} \
                    ${IMAGE_NAME}:latest
                '''
            }
        }
 
        stage('Verify Container') {
            steps {
                sh '''
                    docker ps
                '''
 
                sh '''
                    docker logs ${CONTAINER_NAME} --tail 20
                '''
            }
        }
    }
 
    post {
 
        success {
            echo 'Application deployed successfully!'
            echo "Access application using: http://EC2-PUBLIC-IP:${params.HOST_PORT}"
        }
 
        failure {
            echo 'Pipeline failed. Please check the console output.'
        }
    }
}
