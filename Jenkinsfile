
pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Env Validation') {
      parallel {
        stage('Maven version') {
          steps {
          script{
          def mvnHome = tool 'maven-3'
            sh "'${mvnHome}/bin/mvn' -v"
            }
          }
        }
        stage('Java version') {
          steps {
            sh 'java -version'
          }
        }
      }
    }

    stage('Build') {
      steps {
      script {
      def mvnHome = tool 'maven-3'
        sh "'${mvnHome}/bin/mvn' test cobertura:cobertura"
         } 
      }
    }      
    stage('Report') {
      parallel {
        stage('JUnit') {
          steps {
            junit '**/target/surefire-reports/TEST-*.xml'
          }
        }
        stage('Coverage') {
          steps {
            cobertura(coberturaReportFile: 'target/site/cobertura/coverage.xml')
          }
        }
      }
    }
    stage('SonarQube Code Analysis') {

      steps {
      script{
       
        withSonarQubeEnv('sonarscanner') {
        def mvnHome = tool 'maven-3'
       sh "'${mvnHome}/bin/mvn' org.sonarsource.scanner.maven:sonar-maven-plugin:3.3.0.603:sonar -f pom.xml -Dsonar.host.url=$SONAR_HOST_URL  -Dsonar.projectKey=${JOB_NAME} -Dsonar.projectName=${JOB_NAME} -Dsonar.language=java -Dsonar.sources=. -Dsonar.java.binaries=target/classes -Dsonar.tests=. -Dsonar.test.inclusions=**/*Test*/* -Dsonar.exclusions=target/**/*.class"
     }
     }

      }
    }

    stage('Package') {
      steps {
      script{
      def mvnHome = tool 'maven-3'
        sh "'${mvnHome}/bin/mvn' package"
        }
      }
    }
    stage('Store Artifact') {
      steps {
        archiveArtifacts(artifacts: '**/target/*.jar', fingerprint: true)
      }
    }
  }
  post { 
    always { 
      echo 'I will always say Hello again!'
      junit 'target/surefire-reports/*.xml'
    }
    success { 
      echo 'success!'
    }  
    failure { 
      echo 'failure!'
    }
  }    
}

