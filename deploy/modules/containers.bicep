param location string
param containerAppUserAssignedIdentityResourceId string
param containerAppUserAssignedIdentityClientId string

module containerAppEnvironment 'container-app-environment.bicep' = {
  name: 'Deploy-Container-App-Environment'
  params: {
    location: location
  }
}

// module containerAppWebsite 'container-app-website.bicep' = {
//   name: 'Deploy-Container-App-Website'
//   params: {
//     location: location
//     containerAppEnvironmentResourceId: containerAppEnvironment.outputs.containerAppEnvironmentId
//     containerAppUserAssignedIdentityResourceId: containerAppUserAssignedIdentityResourceId
//     containerAppUserAssignedIdentityClientId: containerAppUserAssignedIdentityClientId
//   }
// }
