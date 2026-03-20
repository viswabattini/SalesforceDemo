pipeline {
    agent any

    options {
        skipDefaultCheckout()
    }

    parameters {
        string(name: 'BRANCH_NAME', defaultValue: 'main', description: 'Git branch to build from')
        string(name: 'ORG_ALIAS', defaultValue: 'SFDEMO', description: 'Salesforce org alias')
        choice(name: 'INSTANCE_URL', choices: ['https://login.salesforce.com', 'https://test.salesforce.com'], description: 'Salesforce login URL')
    }

    environment {
        SF_USERNAME     = credentials('sf-username')       // Salesforce username credential
        SF_CONSUMER_KEY = credentials('sf-consumerkey')    // Connected App consumer key
        SF_CLI = 'C:/Program Files/sf/bin/sf.cmd'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: "${params.BRANCH_NAME}",
                    url: 'https://github.com/viswabattini/SalesforceDemo.git'
            }
        }

        stage('Authenticate Salesforce') {
            steps {
                withCredentials([file(credentialsId: 'jwt_key', variable: 'JWT_KEY_FILE')]) {
                    bat """
                    sf org login jwt ^
                    --client-id %SF_CONSUMER_KEY% ^
                    --jwt-key-file %JWT_KEY_FILE% ^
                    --username %SF_USERNAME% ^
                    --instance-url ${params.INSTANCE_URL} ^
                    --alias ${params.ORG_ALIAS}
                    """
                }
            }
        }

        stage('Deploy to Org') {
            steps {
                bat """
                sf project deploy start ^
                --source-dir force-app ^
                --target-org ${params.ORG_ALIAS} ^
                --wait 10
                """
            }
        }

        stage('Run Tests') {
            steps {
                bat """
                sf apex run test ^
                --target-org ${params.ORG_ALIAS} ^
                --wait 10 ^
                --result-format human
                """
            }
        }

        stage('Post-Build Summary') {
            steps {
                echo "Deployment and tests completed for org alias: ${params.ORG_ALIAS}, branch: ${params.BRANCH_NAME}"
            }
        }
    }
}
