pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        git(url: 'https://github.com/V3ntingclark/easy-school', branch: 'master', credentialsId: 'g1')
      }
    }

    stage('Set Up Python') {
      steps {
        sh '''
                python3 -m venv venv  # Create virtual environment
                source venv/bin/activate  # Activate the virtual environment
                pip install -r requirements.txt  # Install dependencies
                '''
      }
    }

    stage('Run App') {
      steps {
        sh '''
                source venv/bin/activate  # Activate the virtual environment
                python3 app.py  # Run the Python app
                '''
      }
    }

  }
}