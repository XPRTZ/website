targetScope = 'subscription'

param location string = 'westeurope'
param imageTag string = 'latest'

var sharedValues = json(loadTextContent('shared-values.json'))
var subscriptionId = sharedValues.subscriptionIds.common
var resourceGroupName = 'rg-xprtzbv-website'
var containerAppIdentityName = 'id-xprtzbv-website'
var containerAppEnvironmentName = 'me-xprtzbv-website'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: resourceGroupName
}

resource containerAppIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  scope: resourceGroup
  name: containerAppIdentityName
}

resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2023-08-01-preview' existing = {
  name: containerAppEnvironmentName
  scope: resourceGroup
}

module containerAppWebsite 'modules/container-app-website.bicep' = {
  scope: resourceGroup
  name: 'Deploy-Container-App-Website'
  params: {
    location: location
    containerAppUserAssignedIdentityResourceId: containerAppIdentity.id
    containerAppUserAssignedIdentityClientId: containerAppIdentity.properties.clientId
    imageTag: imageTag
  }
}

module dns 'modules/dns.bicep' = if (imageTag != 'latest') {
  name: 'Deploy-Dns-Entries'
  scope: az.resourceGroup(subscriptionId, 'xprtz-mgmt')
  params: {
    containerName: 'ctap-xprtzbv-website-${imageTag}'
    subdomain: imageTag
    defaultDomain: containerAppEnvironment.properties.defaultDomain
    customDomainVerificationId: containerAppEnvironment.properties.customDomainConfiguration.customDomainVerificationId
  }
}

module certificates 'modules/certificates.bicep' = if (imageTag != 'latest') {
  name: 'Deploy-Certificates'
  scope: resourceGroup
  params: {
    location: location
    subdomain: dns.outputs.subdomain
  }
}
