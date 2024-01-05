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

module containers 'modules/containers.bicep' = {
  scope: resourceGroup
  name: 'Deploy-ContainerApp'
  params: {
    location: location
    // containerAppUserAssignedIdentityResourceId: userManagedIdentity.outputs.containerAppIdentityResourceId
    // containerAppUserAssignedIdentityClientId: userManagedIdentity.outputs.containerAppIdentityClientId
  }
  dependsOn: [
    acrAndRoleAssignment
  ]
}
