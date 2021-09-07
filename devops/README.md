### Solution for Question 1

Azure DevOps pipeline to support CI/CD deployment. Please have a look on ci-cd.yaml for more details. I do not have any app ready by I considered following structure of our app for this pipeline

```
- app
  app/webproject
  app/apiproject
  app/tstproject

```


Features - 
- YAML based pipeline prepared to utilise all its features and can be stored in repo(not classic)
- There are CI and CD stages in this pipeline 
- In CI Stage All projects are being build indivisually 
- In CD Stage Azure DevOps Environment is used to provide control



1) The build should trigger as soon as anyone in the dev team checks in code to master branch.

```
trigger: none
  branches:
    include:
      - master
```

2) There will be test projects which will create and maintained in the solution along the Web and API. The trigger should build all the 3 projects - Web, API and test. The build should not be successful if any test fails.

two options - either build all of them at once using solution or build indivisually, choice is yours
By default any of task fails then Azure DevOps stage will fail as well. 

```
    - task: MSBuild@1
      displayName: Build Solution
      inputs:
        solution: '$(solution)'
        msbuildArchitecture: 'x64'
        platform: '$(buildPlatform)'
        configuration: '$(buildConfiguration)'
        msbuildArguments: '/p:OutputPath=$(Build.ArtifactStagingDirectory)/app /p:Configuration=$(buildConfiguration)'
        
```

3) The deployment of code and artifacts should be automated to Dev environment.
Azure DevOps deployment is used to utilise concept of Azure DevOps Environments. The Dev Stage will proceed once build is successful.

```
- stage: Deployment
  condition: and(eq(variables.isMainBranch, true), eq('${{ parameters.DeployApp }}', 'True'))
  jobs :
  - deployment: App_Deployment
    displayName: Deploy Application
    pool:
      name: MS-POOL
    environment: 'DEV'
    workspace:
         clean: all
    strategy:
       # simplest deployment strategy I am using
        runOnce:
          deploy:

```

4) Upon successful deployment to the Dev environment, deployment should be easily promoted to QA and Prod through automated process.

As similar to above Azure DevOps environment and deployment is used for further deployment. 


5) The deployments to QA and Prod should be enabled with Approvals from approvers only

Azure DevOps environment and deployment is used for further deployment. But using Azure DevOps environment you can control the approval process and other required checks. Those checks are not part of YAML pipeline and need to be configured using Azure DevOps UI.