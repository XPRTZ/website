targetScope = 'subscription'

param resourceGroupSuffix string
param deployDns bool
param application string
param frontDoorProfileName string = 'afd-xprtzbv-websites'
param rootDomain string = 'xprtz.dev'

var resourceGroupPrefix = 'rg-xprtzbv-website-${application}'
var resourceGroupName = endsWith(resourceGroupSuffix, 'main')
  ? resourceGroupPrefix
  : '${resourceGroupPrefix}-${resourceGroupSuffix}'

var sharedValues = json(loadTextContent('shared-values.json'))
var managementResourceGroup = resourceGroup(sharedValues.subscriptionIds.xprtz, sharedValues.resourceGroups.management)
var infrastructureResourceGroup = resourceGroup(
  sharedValues.subscriptionIds.xprtz,
  sharedValues.resourceGroups.infrastructure
)

resource websiteResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  location: deployment().location
  name: resourceGroupName
}

module storageAccountModule 'modules/storageAccount.bicep' = {
  scope: websiteResourceGroup
  name: 'StorageAccountDeploy-${application}'
  params: {
    app: application
  }
}

module frontDoorSettings 'modules/frontdoor.bicep' = if (deployDns) {
  scope: infrastructureResourceGroup
  name: 'frontDoorSettingsDeploy-${application}'
  params: {
    frontDoorOriginHost: storageAccountModule.outputs.storageAccountHost
    frontDoorProfileName: frontDoorProfileName
    application: application
    rootDomain: rootDomain
    subDomain: application
  }
}

module dnsSettings 'modules/dns.bicep' = if (deployDns) {
  scope: managementResourceGroup
  name: 'dnsSettingsDeploy-${application}'
  params: {
    origin: frontDoorSettings.outputs.frontDoorCustomDomainHost
    rootDomain: rootDomain
    subDomain: application
    validationToken: frontDoorSettings.outputs.frontDoorCustomDomainValidationToken
  }
}

output storageAccountName string = storageAccountModule.outputs.storageAccountName
output resourceGroupName string = websiteResourceGroup.name
output applicationFqdn string = deployDns
  ? 'https://${application}.${rootDomain}/'
  : storageAccountModule.outputs.storageAccountFqdn
