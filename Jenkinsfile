pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        git(url: 'https://github.com/V3ntingclark/easy-school.git', branch: 'master', credentialsId: 'g1')
      }
    }

    stage('Set Up Python') {
      steps {
        sh '''
          #!/bin/bash
          python3 -m venv venv  # Create virtual environment
          . venv/bin/activate  # Activate the virtual environment
          pip install -r requirements.txt  # Install dependencies
        '''
      }
    }

    stage('Install Docker') {
      steps {
        sh '''
          sudo apt update
          sudo apt install -y docker.io
        '''
      }
    }

/**
    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv('MySonarQube') {
          sh '''#!/bin/bash

        # Correct path to SonarQube scanner executable
        ${SONAR_SCANNER_HOME}/var/jenkins_home/tools/hudson.plugins.sonar.SonarRunnerInstallation/SonarQubeScanner/
          -Dsonar.projectKey=${SONAR_PROJECT_KEY} \\
          -Dsonar.sources=. \\
          -Dsonar.python.version=3.x
        '''
        }

      }
    }

    stage('Run App') {
      steps {
        sh '''
          #!/bin/bash
          source venv/bin/activate  # Activate the virtual environment
          python3 app.py  # Run the Python app
        '''
      }
    }

    stage('SBOM with Syft') {
      steps {
        sh '''
          #!/bin/bash
          docker run --rm -v $(pwd):/project anchore/syft:latest /project -o cyclonedx-json > sbom.json
        '''
      }
    }

    stage('Vulnerability Scan with Grype') {
      steps {
        sh '''
          #!/bin/bash
          docker run --rm -v $(pwd):/project anchore/grype:latest sbom:/project/sbom.json
        '''
      }
    }
**/
    stage('Test Docker Login') {
    steps {
        sh '''
            echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
        '''
    }
}


    stage('Build Docker Image') {
      steps{
        sh '''
          #!/bin/bash
          docker build -t myapp:${BUILD_NUMBER} .
          '''
      }
    }

    stage('Test Kubernetes Access') {
      steps {
        sh '''
            export KUBECONFIG=$KUBE_CONFIG
            kubectl get nodes
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
          docker tag myapp:${BUILD_NUMBER} ${DOCKER_CREDENTIALS_USR}/myapp:${BUILD_NUMBER}
          docker push ${DOCKER_CREDENTIALS_USR}/myapp:${BUILD_NUMBER}
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
          kubectl set image deployment/myapp-deployment myapp-container=${DOCKER_IMAGE} --record
          '''
      }
    }

  }
  environment {
    SONAR_SERVER = 'MySonarQube'
    SONAR_PROJECT_KEY = 'cmu-capstone'
    SONAR_SCANNER_HOME = 'SonarQubeScanner'
    DOCKER_CREDENTIALS = credentials('docker-credentials')
  }
  post {
    always {
      archiveArtifacts(artifacts: 'sbom.json', allowEmptyArchive: true)
    }

  }
}