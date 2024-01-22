targetScope = 'subscription'

param location string = 'westeurope'

var sharedValues = json(loadTextContent('shared-values.json'))
var subscriptionId = sharedValues.subscriptionIds.common
var acrResourceGroupName = sharedValues.resources.acr.resourceGroupName
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

module acrAndRoleAssignment 'modules/roleassignments.bicep' = {
  scope: az.resourceGroup(subscriptionId, acrResourceGroupName)
  name: 'Deploy-PullRoleAssignment'
  params: {
    principalId: userManagedIdentity.outputs.containerAppIdentityPrincipalId
    acrName: sharedValues.resources.acr.name
  }
}

module containerAppEnvironment 'modules/container-app-environment.bicep' = {
  scope: resourceGroup
  name: 'Deploy-Container-App-Environment'
  params: {
    location: location
  }
}

module frontDoor 'modules/front-door.bicep' = {
  scope: resourceGroup
  name: 'Deploy-FrontDoor'
  params: {
    hostname: 'ctap-xprtzbv-website-latest.ambitiousmoss-9ee74554.westeurope.azurecontainerapps.io'
  }
}
