pipeline {
    
	agent any
	
	tools {
        maven "MAVEN3"
        jdk "OracleJDK8"
    }
    
	
    environment {        
        registry = "krushna97/vprofileapp"
        registryCredential = "dockerhub"
    }
	stages{
            stage('Fetch Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Krushna8/cicd-kube-docker.git'
            }
            }
        
        stage('BUILD'){
            steps {
                sh 'mvn clean install -DskipTests'
            }
            post {
                success {
                    echo 'Now Archiving...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }

        stage('UNIT TEST'){
                steps {
                    sh 'mvn test'
                }
            }

        stage('INTEGRATION TEST'){
                steps {
                    sh 'mvn verify -DskipUnitTests'
                }
            }
		
        stage ('CODE ANALYSIS WITH CHECKSTYLE'){
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
            post {
                success {
                    echo 'Generated Analysis Result'
                }
            }
        }

        stage('CODE ANALYSIS with SONARQUBE') {
          
		  environment {
             scannerHome = tool 'sonar4'
          }

          steps {
            withSonarQubeEnv('sonar-pro') {
               sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                   -Dsonar.projectName=vprofile-repo \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
            }

            timeout(time: 5, unit: 'MINUTES') {
               waitForQualityGate abortPipeline: true
            }
          }
        }
        stage('Build App Image') {
            steps {
                script {
                    dockerImage = docker.build registry + ":v$BUILD_NUMBER"
                }                                
            }
        }
        stage('Upload Image') {
            steps {
                script {
                    docker.withRegistry('', registryCredential) {
                        dockerImage.push("v$BUILD_NUMBER")
                        dockerImage.push("latest")
                    }
                }
            }
        }
        stage('Remove Unused Docker Image') {
            steps {
                sh "docker rmi $registry:v$BUILD_NUMBER"
            }
        }
        stage('Kubenates Deploy') {
            agent {label 'KOPS'}
            steps {
                sh "helm upgrade --install --force vprofile-stack /home/ubuntu/cicd-kube-docker/helm/vprofilecharts --set appimage=${registry}:v${BUILD_NUMBER} --namespace prod"

            }
        }

    }
}