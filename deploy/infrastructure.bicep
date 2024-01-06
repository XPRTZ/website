targetScope = 'subscription'

param location string = 'westeurope'

var resourceGroupName = 'rg-xprtzbv-website'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module userManagedIdentity 'modules/user-managed-identity.bicep' = {
  scope: resourceGroup
  name: 'Deploy-UserManagedIdentity'
  params: {
    location: location
  }
}

module acrAndRoleAssignment 'modules/acr-roleassignment.bicep' = {
  scope: resourceGroup
  name: 'Deploy-Acr-And-PullRoleAssignment'
  params: {
    location: location
    principalId: userManagedIdentity.outputs.containerAppIdentityPrincipalId
  }
}

module containerAppEnvironment 'modules/container-app-environment.bicep' = {
  scope: resourceGroup
  name: 'Deploy-Container-App-Environment'
  params: {
    location: location
  }
}
