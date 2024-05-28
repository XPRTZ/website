targetScope = 'subscription'

param location string = 'westeurope'
param imageTag string = 'latest'
param isProduction bool = false

var resourceGroupName = 'rg-xprtzbv-website'
var containerAppIdentityName = 'id-xprtzbv-website'
var frontDoorEndpointName = 'fde-xprtzbv-website'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: resourceGroupName
}

resource containerAppIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  scope: resourceGroup
  name: containerAppIdentityName
}

module containerAppWebsite 'modules/container-app-website.bicep' = {
  scope: resourceGroup
  name: 'Deploy-Container-App-Website'
  params: {
    location: location
    containerAppUserAssignedIdentityResourceId: containerAppIdentity.id
    containerAppUserAssignedIdentityClientId: containerAppIdentity.properties.clientId
    imageTag: imageTag
    isProduction: isProduction
  }
}

module frontDoor 'modules/front-door.bicep' = {
  scope: resourceGroup
  name: 'Deploy-Front-Door'
  params: {
    frontDoorEndpointName: frontDoorEndpointName
    originHostname: containerAppWebsite.outputs.containerAppUrl
  }
}

output containerAppUrl string = containerAppWebsite.outputs.containerAppUrl
