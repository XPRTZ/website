targetScope = 'subscription'

param location string = 'westeurope'

var sharedValues = json(loadTextContent('shared-values.json'))
var subscriptionId = sharedValues.subscriptionIds.common
var resourceGroupName = 'rg-xprtzbv-website'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: resourceGroupName
}

module containerAppEnvironment 'modules/container-app-environment.bicep' = {
  scope: resourceGroup
  name: 'Deploy-Container-App-Environment'
  params: {
    location: location
  }
}

module dns 'modules/dns.bicep' = {
  name: 'Deploy-Dns-Entries'
  scope: az.resourceGroup(subscriptionId, 'xprtz-mgmt')
  params: {
    containerName: 'ctap-xprtzbv-website-latest'
    subdomain: 'maarten'
    defaultDomain: containerAppEnvironment.outputs.defaultDomain
    customDomainVerificationId: containerAppEnvironment.outputs.customDomainVerificationId
  }
}

module certificates 'modules/certificates.bicep' = {
  name: 'Deploy-Certificates'
  scope: resourceGroup
  params: {
    location: location
    subdomain: dns.outputs.subdomain
  }
}
