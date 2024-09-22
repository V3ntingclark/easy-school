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
        sonar-scanner -v  # Check if sonar-scanner is available
        '''
      }
    }

    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv('sonar-scanner') {
          sh '''
          sonar-scanner             -Dsonar.projectKey=cmu-capstone             -Dsonar.sources=.             -Dsonar.host.url=http://18.118.11.97:9000             -Dsonar.login=sqp_71da05a49a08673899dba24f9c46b120cb904b2c
          '''
        }

      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          sh '''
docker build -t $APP_IMAGE .  # Build Docker image
'''
        }

      }
    }

    stage('Run App') {
      steps {
        sh '''
          docker run -d -p 8000:8000 $APP_IMAGE  # Run the application in a container
        '''
      }
    }

    stage('SBOM with Syft') {
      steps {
        sh '''
          docker run --rm -v $(pwd):/project anchore/syft:latest /project -o cyclonedx-json > sbom.json
        '''
      }
    }

    stage('Vulnerability Scan with Grype') {
      steps {
        sh '''
          docker run --rm -v $(pwd):/project anchore/grype:latest sbom:/project/sbom.json
        '''
      }
    }

  }
  environment {
    SONAR_SERVER = 'MySonarQube'
    SONAR_PROJECT_KEY = 'cmu-capstone'
    APP_IMAGE = 'my-app:latest'
  }
  post {
    always {
      archiveArtifacts(artifacts: 'sbom.json', allowEmptyArchive: true)
    }

  }
}
