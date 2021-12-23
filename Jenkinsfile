def zones = [
	[ cluster_name: '1', storage_class: '2' ],
    [ cluster_name: '3', storage_class: '4' ],
    [ cluster_name: '5', storage_class: '6' ]
]

def runs = [:]

pipeline {
    agent { node { label 'test' } }

    environment {
        NAMESPACE = 'apidoc'
        DEPLOY_IMAGE = 'IMAGE'
    }

    stages {
        stage('Prepear stages') {
            steps {
                script {
                    zones.eachWithIndex { v, i ->
                        runs[i] = deploy(v)
                    }
                    parallel runs
                }
            }
        }
    }

    post {
        always {
            sh "rm -rf ./* ./.git"
        }
    }
}

def deploy(Map m) {
    return {
        try{
            stage ('Deploy ' + m.cluster_name) {
                withCredentials([file(credentialsId: "${m.cluster_name}", variable: 'FILE' )]) {
                    sh 'cp $FILE $PWD'
                }

                sh "docker run -i --rm -u 11160:11160 -v ${WORKSPACE}:${WORKSPACE} -w ${WORKSPACE} ${DEPLOY_IMAGE} \
                    helm upgrade ${NAMESPACE}-elasticdb ../jenkinsfile \
                    --install \
                    --history-max 5 \
                    --namespace ${NAMESPACE} \
                    --timeout 5m0s \
                    --kubeconfig=${WORKSPACE}/${m.cluster_name} \
                    --set clusterName=${m.cluster_name}.enabled=true"
            }
        } catch(e) {
            echo e.toString()
        }
    }
}

