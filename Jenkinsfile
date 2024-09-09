pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://gitlab.com/YOUR-USERNAME/YOUR-REPO.git', branch: 'main', credentialsId: 'g1'
            }
        }
        
        stage('Set Up Python') {
            steps {
                // Install Python dependencies
                sh '''
                python3 -m venv venv  # Create virtual environment
                source venv/bin/activate  # Activate the virtual environment
                pip install -r requirements.txt  # Install dependencies
                '''
            }
        }
        
        stage('Run App') {
            steps {
                // Run the Python app
                sh '''
                source venv/bin/activate  # Activate the virtual environment
                python3 app.py  # Run the Python app
                '''
            }
        }
    }
}
