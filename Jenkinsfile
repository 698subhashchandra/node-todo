@Library('Shared') _
pipeline {
    agent any

    environment {
        SONAR_HOME = tool "Sonar"
    }

    parameters {
        string(name: 'FRONTEND_DOCKER_TAG', defaultValue: '', description: 'Setting docker image for latest push')
    }

    stages {
        stage("Validate Parameters") {
            steps {
                script {
                    if (params.FRONTEND_DOCKER_TAG == '') {
                        error("FRONTEND_DOCKER_TAG must be provided.")
                    }
                }
            }
        }

        stage("Workspace cleanup") {
            steps {
                cleanWs()
            }
        }

        stage('Git: Code Checkout') {
            steps {
                script {
                    code_checkout("https://github.com/698subhashchandra/node-todo.git", "main")
                }
            }
        }

        stage("Trivy: Filesystem scan") {
            steps {
                script {
                    trivy_scan()
                }
            }
        }

        stage("OWASP: Dependency check") {
            steps {
                script {
                    owasp_dependency()
                }
            }
        }

        stage("SonarQube: Code Analysis") {
            steps {
                script {
                    sonarqube_analysis("Sonar", "wanderlust", "wanderlust")
                }
            }
        }

        stage("SonarQube: Code Quality Gates") {
            steps {
                script {
                    sonarqube_code_quality()
                }
            }
        }

        stage("Frontend env setup") {  // Merged stage
            steps {
                script {
                    dir("Automations") {
                        sh "bash updatefrontendnew.sh"
                    }
                }
            }
        }

        stage("Docker: Build Images") {
            steps {
                script {
                    dir('frontend') {
                        docker_build("wanderlust-frontend-beta", "${params.FRONTEND_DOCKER_TAG}", "698subhashchandra")
                    }
                }
            }
        }

        stage("Docker: Push to DockerHub") {
            steps {
                script {
                    docker_push("wanderlust-frontend-beta", "${params.FRONTEND_DOCKER_TAG}", "698subhashchandra")
                }
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: '*.xml', followSymlinks: false
            build job: "Wanderlust-CD", parameters: [
                string(name: 'FRONTEND_DOCKER_TAG', value: "${params.FRONTEND_DOCKER_TAG}")
            ]
        }
    }
}
