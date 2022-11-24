pipeline { 
 
     agent { label 'worker1' }

          environment {    

               APP_NAME = 'QA test'  

}  

options {    

       // Stop the build early in case of compile or test failures    
  
           skipStagesAfterUnstable()  

}

stages {

     stage('Detect build type') {

         steps {    
              script {      
           
                 if (env.BRANCH_NAME == 'staging' || env.CHANGE_TARGET == 'staging') {        
           
                    env.BUILD_TYPE = 'Debug'      

                  } else if (env.BRANCH_NAME == 'production' || env.CHANGE_TARGET == 'production') {        

                    env.BUILD_TYPE = 'Release'      
			 }    

        }  

    }

}


/*stage('Compile') {
  
  steps {    
      // Compile the app and its dependencies    
     
	  sh """ 
          echo \"sdk.dir=${ANDROID_SDK_ROOT}\" > local.properties
          chmod 600 local.properties
          """
         sh './gradlew compileDebugSources'  
        }
}*/
	
stage('Build') {  
   
      steps {    
          // Compile the app and its dependencies    
    
    sh './gradlew assembleDebug'    
    
    //sh './gradlew generatePomFileForLibraryPublication'  

   }
}

stage('Publish') {  

   steps {    

     // Archive the APKs so that they can be downloaded from Jenkins    
       
     archiveArtifacts "app/build/outputs/apk/debug/app-debug.apk"    

     // Archive the ARR and POM so that they can be downloaded from Jenkins
    

     // archiveArtifacts "**/${APP_NAME}-${BUILD_TYPE}.aar, **/*pom-   default.xml*"  
	 
	 }



     }
 
 
 }
 
 }
