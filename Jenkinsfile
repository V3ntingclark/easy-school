pipeline {
  agent any
  environment {
    SONAR_SERVER = 'Remote SonarQube'  // SonarQube configuration in Jenkins
    SONAR_PROJECT_KEY = 'cmu-capstone'
    APP_IMAGE = 'eseantatum/myapp'
    SONAR_SCANNER_PATH = '/opt/sonar-scanner-4.6.2.2472-linux/bin'
    PATH = "${SONAR_SCANNER_PATH}:${PATH}"  // Ensure sonar-scanner is in the PATH
  }
  stages {
    stage('Checkout') {
      steps {
        git(url: 'https://github.com/V3ntingclark/easy-school.git', branch: 'master', credentialsId: 'g2')
      }
    }

    stage('Set Up Python') {
      steps {
        sh '''
          python3 -m venv venv  # Create virtual environment
          . venv/bin/activate  # Activate the virtual environment
          pip install -r requirements.txt  # Install dependencies
        '''
      }
    }

    stage('Verify SonarQube Scanner') {
      steps {
        sh '''
          echo "PATH: $PATH"
          which sonar-scanner || echo "sonar-scanner not found in PATH"  # Check sonar-scanner in PATH
          sonar-scanner -v  # Verify sonar-scanner installation
        '''
      }
    }

//    stage('SonarQube Analysis') {
//      steps {
//        withSonarQubeEnv('Remote SonarQube') {  // Matches the SonarQube server config
//          sh '''
//            sonar-scanner \
//              -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
//              -Dsonar.sources=. \
//              -Dsonar.host.url=http://18.118.11.97:9000 \
//              -Dsonar.login=sqp_71da05a49a08673899dba24f9c46b120cb904b2c
//          '''
//        }
//      }
//    }

//    stage('Build Docker Image') {
//      steps {
//        script {
//          sh '''
//            docker build -t $APP_IMAGE .  # Build Docker image
//          '''
//        }
//      }
//    }

    stage('Build Docker Image') {
      steps{
        sh '''
          #!/bin/bash
          docker build -t $APP_IMAGE:${BUILD_NUMBER} .
          '''
      }
    }

    stage('Run App') {
      steps {
        sh '''
          docker run -d -p 8000:8000 $APP_IMAGE:${BUILD_NUMBER}  # Run the application in a container
        '''
      }
    }

    stage('SBOM with Syft') {
      steps {
        sh '''
          docker run --rm -v $(pwd):/project anchore/syft:latest /project -o cyclonedx-json > sbom.json  # Generate SBOM
        '''
      }
    }

    stage('Vulnerability Scan with Grype') {
      steps {
        sh '''
          docker run --rm -v $(pwd):/project anchore/grype:latest sbom:/project/sbom.json  # Scan SBOM for vulnerabilities
        '''
      }
    }

    stage('Push Docker Image to Container Registry'){
      environment {
        DOCKER_CREDENTIALS = credentials('docker-credentials')
      }
      steps {
        sh '''
          echo $DOCKER_CREDENTIALS_PSW | docker login -u $DOCKER_CREDENTIALS_USR --password-stdin
          docker tag $APP_IMAGE:${BUILD_NUMBER} $APP_IMAGE:${BUILD_NUMBER}
          docker push $APP_IMAGE:${BUILD_NUMBER}
        '''
      }
    }

    stage('Deploy to Kubernetes'){
      environment{
        KUBE_CONFIG = credentials('kubeconfig')
      }
      steps{
        sh '''
          #!/bin/bash
          export KUBECONFIG=$KUBE_CONFIG
          kubectl set image deployment/myapp-deployment myapp-container=$APP_IMAGE:${BUILD_NUMBER} --record
          '''
      }
    }

    stage('clean') {
      steps {
        sh '''
          docker stop $(docker ps -a -q)
        '''
      }
    }
  }

  

  post {
    always {
      archiveArtifacts(artifacts: 'sbom.json', allowEmptyArchive: true)  // Archive SBOM regardless of the outcome
    }
  }
}
