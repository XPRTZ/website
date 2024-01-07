targetScope = 'resourceGroup'

param principalId string
param acrName string

var buildinRoles = json(loadTextContent('../buildin-roles.json'))
var acrPullRoleDefinitionId = buildinRoles.acr.pull

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' existing = {
  name: acrName
}

resource acrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: resourceGroup()
  name: guid(principalId, acrPullRoleDefinitionId, containerRegistry.id)
  properties: {
    principalId: principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', acrPullRoleDefinitionId)
  }
}
