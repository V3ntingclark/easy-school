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

    stage('SonarQube Analysis') {
      steps {
        sh '''
#!/bin/bash
java -version
sonar-scanner \\ 
  -Dsonar.projectKey=cmu-capstone \\
  -Dsonar.sources=. \\
  -Dsonar.host.url=http://18.118.11.97:9000 \\
  -Dsonar.token=sqp_0a5b77d7309822c8f096282430dc48c91ecfea3c
'''
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

  }
  environment {
    SONAR_SERVER = 'MySonarQube'
    SONAR_PROJECT_KEY = 'cmu-capstone'
    SONAR_SCANNER_HOME = 'SonarQubeScanner'
  }
  post {
    always {
      archiveArtifacts(artifacts: 'sbom.json', allowEmptyArchive: true)
    }

  }
}