pipeline{
  agent any
  stages{
    stage ('Puppet Agent Installation'){
      agent any
      steps{
        sh '''wget https://apt.puppetlabs.com/puppet8-release-jammy.deb
              echo Welcome@123 | sudo -S dpkg -i puppet8-release-jammy.deb
              sudo apt-get update -y
              sudo apt-get install puppet-agent -y'''
      }
    } 
    stage ('Docker installation'){
      agent any
      steps{
        git 'https://github.com/myspace-ankit/DevOps_Project1.git'
        dir('.') {
          sh ' sudo ansible-playbook playbook.yml -i inventory.txt'
        }
      }       
    }
    stage("Building image and running container"){
      agent any 
      steps{
        git 'https://github.com/myspace-ankit/DevOps_Project1.git'
        //script {
        //    error ( ' Intentional failure')
        //}
        sshPublisher(publishers: [sshPublisherDesc(configName: 'Test Server', transfers: [
          sshTransfer(
            cleanRemote: false, 
            excludes: '', 
            execCommand: '''
              docker container stop project1_demo
              docker container rm -f project1_demo
              docker image rmi -f project1_demo
              cd /home/kslave1/docker
              docker image build -t project1_demo .
              ''',
            execTimeout: 120000, 
            flatten: false, 
            makeEmptyDirs: false, 
            noDefaultExcludes: false, 
            patternSeparator: '[, ]+', 
            remoteDirectory: '/docker', 
            remoteDirectorySDF: false, 
            removePrefix: '', 
            sourceFiles: '**/*'
          ),
          sshTransfer(
            cleanRemote: false, 
            excludes: '', 
            execCommand: 'docker container run -dit --name project1_demo -p 80:80 project1_demo', 
            execTimeout: 120000, 
            flatten: false, 
            makeEmptyDirs: false, 
            noDefaultExcludes: false, 
            patternSeparator: '[, ]+', 
            remoteDirectory: '', 
            remoteDirectorySDF: false, 
            removePrefix: '', 
            sourceFiles: ''
          )
        ], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
      }
    }
    stage("Delete Container"){
      agent any
      when{
        expression {
          currentBuild.result == 'FAILURE' ||
          currentBuild.result == 'UNSTABLE'
        }
      }
      steps{
        sshPublisher(publishers: [sshPublisherDesc(configName: 'Test Server', transfers: [
        sshTransfer(
          cleanRemote: false, 
          excludes: '', 
          execCommand: '''
            docker container stop project1_demo
            docker container rm -f project1_demo
          ''', 
          execTimeout: 120000, 
          flatten: false, 
          makeEmptyDirs: false, 
          noDefaultExcludes: false, 
          patternSeparator: '[, ]+', 
          remoteDirectory: '', 
          remoteDirectorySDF: false, 
          removePrefix: '', 
          sourceFiles: ''
        )
        ], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
      }
    }
  }
}
