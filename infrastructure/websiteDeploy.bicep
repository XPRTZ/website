targetScope = 'subscription'

param resourceGroupSuffix string = 'main'
param deployDns bool = true
param application string = 'dotnet'
param frontDoorProfileName string = 'afd-xprtzbv-websites'
param imagesDomain string = 'images'
param rootDomain string = 'xprtz.dev'
param domains array = [
  {
    rootDomain: 'xprtz.dev'
    subDomain: ''
  }
  {
    rootDomain: 'xprtz.dev'
    subDomain: 'www'
  }
]

var resourceGroupPrefix = 'rg-xprtzbv-website-${application}'
var resourceGroupName = endsWith(resourceGroupSuffix, 'main')
  ? resourceGroupPrefix
  : '${resourceGroupPrefix}-${resourceGroupSuffix}'

var sharedValues = json(loadTextContent('shared-values.json'))
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

@batchSize(1)
module frontDoorSettings 'modules/frontdoor.bicep' = [for domain in domains: if (deployDns) {
  scope: infrastructureResourceGroup
    name: 'frontDoorSettingsDeploy-${application}-${domain.subDomain == '' ? 'root' : domain.subDomain}'
  params: {
    frontDoorOriginHost: storageAccountModule.outputs.storageAccountHost
    frontDoorProfileName: frontDoorProfileName
    application: application
    rootDomain: domain.rootDomain
    subDomain: domain.subDomain
  }
}]

@batchSize(1)
module dnsSettings 'modules/dns.bicep' = [for (domain, i) in domains: if (deployDns) {
  scope: infrastructureResourceGroup
    name: 'dnsSettingsDeploy-${application}-${domain.subDomain == '' ? 'root' : domain.subDomain}'
    params: {
    origin: frontDoorSettings[i].outputs.frontDoorCustomDomainHost
    rootDomain: domain.rootDomain
    subDomain: domain.subDomain
    validationToken: frontDoorSettings[i].outputs.frontDoorCustomDomainValidationToken
  }
}]

module imagesFrontDoorSettings 'modules/frontdoor-images.bicep' = if (deployDns) {
  scope: infrastructureResourceGroup
  name: 'imagesFrontDoorSettingsDeploy-${application}'
  params: {
    storageAccountName: storageAccountModule.outputs.storageAccountName
    storageAccountResourceGroup: websiteResourceGroup.name
    frontDoorProfileName: frontDoorProfileName
    application: application
    rootDomain: rootDomain
    subDomain: imagesDomain
  }
}

module imagesDnsSettings 'modules/dns.bicep' = if (deployDns) {
  scope: infrastructureResourceGroup
  name: 'imagesDnsSettingsDeploy-${application}'
  params: {
    origin: imagesFrontDoorSettings.outputs.frontDoorCustomDomainHost
    rootDomain: rootDomain
    subDomain: imagesDomain
    validationToken: imagesFrontDoorSettings.outputs.frontDoorCustomDomainValidationToken
  }
}

output storageAccountName string = storageAccountModule.outputs.storageAccountName
output resourceGroupName string = websiteResourceGroup.name
output applicationFqdn string = deployDns
  ? 'https://${application}.${rootDomain}/'
  : storageAccountModule.outputs.storageAccountFqdn
