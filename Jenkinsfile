pipeline {
    agent any

    environment {
        ImageName = 'myapp'  // Docker image name
        EC2_IP = '52.90.221.176'
    }

    stages {

        stage("Pull Code from GitHub") {
            steps {
                script {
                    echo "Fetching latest code from GitHub..."
                    if (fileExists("To-do_CICD")) {
                        sh "cd To-do_CICD && git pull"
                    } else {
                        sh "git clone https://github.com/Siddhu0018/To-do_CICD.git"
                    }
                }
            }
        }

        stage("Set Date Tag") {
            steps {
                script {
                    env.DATE_TAG = sh(script: "date +%Y%m%d%H%M%S", returnStdout: true).trim()
                    echo "Generated Tag: ${env.DATE_TAG}"
                }
            }
        }

        stage("Build Docker Image") {
            steps {
                script {
                    echo "Building Docker Image with tag ${env.DATE_TAG}..."
                    sh """
                    docker build -t ${ImageName}:${env.DATE_TAG} To-do_CICD
                    """
                }
            }
        }

        stage("Save and Transfer Image to EC2") {
            steps {
                script {
                    echo "Saving Docker Image..."
                    sh "docker save -o ${ImageName}_${env.DATE_TAG}.tar ${ImageName}:${env.DATE_TAG}"

                    echo "Transferring Image to EC2..."
                    sshagent(['ubuntu']) {
                        sh """
                        scp -o StrictHostKeyChecking=no ${ImageName}_${env.DATE_TAG}.tar ubuntu@${EC2_IP}:/home/ubuntu/
                        """
                    }
                }
            }
        }

        stage("Deploy on EC2") {
            steps {
                script {
                    echo "Deploying Docker Container on EC2..."
                    sshagent(['ubuntu']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} "
                            echo 'Stopping old container...'
                            docker stop myapp-container || true
                            
                            echo 'Removing old container...'
                            docker rm myapp-container || true

                            echo 'Loading Docker Image...'
                            docker load -i /home/ubuntu/${ImageName}_${env.DATE_TAG}.tar

                            echo 'Running New Container...'
                            docker run -d -p 80:80 --name myapp-container ${ImageName}:${env.DATE_TAG}
                        "
                        """
                    }
                }
            }
        }
    }
}
