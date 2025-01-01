targetScope = 'subscription'

param resourceGroupSuffix string
param deployDns bool
param frontDoorProfileName string = 'afd-xprtzbv-websites'
param rootDomain string = 'xprtz.dev'

var resourceGroupPrefix = 'rg-xprtzbv-website'
var resourceGroupName = endsWith(resourceGroupSuffix, 'main')
  ? resourceGroupPrefix
  : '${resourceGroupPrefix}-${resourceGroupSuffix}'
var dotnetApplicationName = 'dotnet'
var cloudApplicationName = 'cloud'
var landingApplicationName = 'landing'

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

module cloudStorageAccountModule 'modules/storageAccount.bicep' = {
  scope: websiteResourceGroup
  name: 'cloudStorageAccountDeploy'
  params: {
    app: cloudApplicationName
  }
}

module cloudFrontDoorSettings 'modules/frontdoor.bicep' = if (deployDns) {
  scope: infrastructureResourceGroup
  name: 'cloudFrontDoorSettingsDeploy'
  params: {
    frontDoorOriginHost: cloudStorageAccountModule.outputs.storageAccountHost
    frontDoorProfileName: frontDoorProfileName
    application: cloudApplicationName
    rootDomain: rootDomain
    subDomain: cloudApplicationName
  }
}

module cloudDnsSettings 'modules/dns.bicep' = if (deployDns) {
  scope: managementResourceGroup
  name: 'cloudDnsSettingsDeploy'
  params: {
    origin: cloudFrontDoorSettings.outputs.frontDoorCustomDomainHost
    rootDomain: rootDomain
    subDomain: cloudApplicationName
    validationToken: cloudFrontDoorSettings.outputs.frontDoorCustomDomainValidationToken
  }
}

module dotnetStorageAccountModule 'modules/storageAccount.bicep' = {
  scope: websiteResourceGroup
  name: 'dotnetStorageAccountDeploy'
  params: {
    app: dotnetApplicationName
  }
}

module dotnetFrontDoorSettings 'modules/frontdoor.bicep' = if (deployDns) {
  scope: infrastructureResourceGroup
  name: 'dotnetFrontDoorSettingsDeploy'
  params: {
    frontDoorOriginHost: dotnetStorageAccountModule.outputs.storageAccountHost
    frontDoorProfileName: frontDoorProfileName
    application: dotnetApplicationName
    rootDomain: rootDomain
    subDomain: dotnetApplicationName
  }
}

module dotnetDnsSettings 'modules/dns.bicep' = if (deployDns) {
  scope: managementResourceGroup
  name: 'dotnetDnsSettingsDeploy'
  params: {
    origin: dotnetFrontDoorSettings.outputs.frontDoorCustomDomainHost
    rootDomain: rootDomain
    subDomain: dotnetApplicationName
    validationToken: dotnetFrontDoorSettings.outputs.frontDoorCustomDomainValidationToken
  }
}

module landingStorageAccountModule 'modules/storageAccount.bicep' = {
  scope: websiteResourceGroup
  name: 'landingStorageAccountDeploy'
  params: {
    app: landingApplicationName
  }
}

module landingFrontDoorSettings 'modules/frontdoor.bicep' = if (deployDns) {
  scope: infrastructureResourceGroup
  name: 'landingFrontDoorSettingsDeploy'
  params: {
    frontDoorOriginHost: landingStorageAccountModule.outputs.storageAccountHost
    frontDoorProfileName: frontDoorProfileName
    application: landingApplicationName
    rootDomain: rootDomain
    subDomain: landingApplicationName
  }
}

module landingDnsSettings 'modules/dns.bicep' = if (deployDns) {
  scope: managementResourceGroup
  name: 'landingDnsSettingsDeploy'
  params: {
    origin: landingFrontDoorSettings.outputs.frontDoorCustomDomainHost
    rootDomain: rootDomain
    subDomain: landingApplicationName
    validationToken: landingFrontDoorSettings.outputs.frontDoorCustomDomainValidationToken
  }
}

output cloudStorageAccountName string = cloudStorageAccountModule.outputs.storageAccountName
output dotnetStorageAccountName string = dotnetStorageAccountModule.outputs.storageAccountName
output landingStorageAccountName string = landingStorageAccountModule.outputs.storageAccountName
output resourceGroupName string = websiteResourceGroup.name
output cloudFqdn string = deployDns
  ? 'https://${cloudApplicationName}.${rootDomain}/'
  : cloudStorageAccountModule.outputs.storageAccountFqdn
output dotnetFqdn string = deployDns
  ? 'https://${dotnetApplicationName}.${rootDomain}/'
  : dotnetStorageAccountModule.outputs.storageAccountFqdn
output landingFqdn string = deployDns
  ? 'https://${landingApplicationName}.${rootDomain}/'
  : landingStorageAccountModule.outputs.storageAccountFqdn
