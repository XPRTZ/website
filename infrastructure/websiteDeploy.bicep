targetScope = 'subscription'

param resourceGroupSuffix string
param frontDoorProfileName string = 'afd-xprtzbv-websites'
param rootDomain string = 'xprtz.dev'
param dotnetSubDomain string
param cloudSubDomain string

var resourceGroupPrefix = 'rg-xprtzbv-website'
var resourceGroupName = endsWith(resourceGroupSuffix, 'main')
  ? resourceGroupPrefix
  : '${resourceGroupPrefix}-${resourceGroupSuffix}'
var dotnetApplicationName = 'dotnet'
var cloudApplicationName = 'cloud'

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
    app: 'cloud'
  }
}

module cloudFrontDoorSettings 'modules/frontdoor.bicep' = {
  scope: infrastructureResourceGroup
  name: 'cloudFrontDoorSettingsDeploy'
  params: {
    frontDoorOriginHost: cloudStorageAccountModule.outputs.storageAccountHost
    frontDoorProfileName: frontDoorProfileName
    application: cloudApplicationName
    rootDomain: rootDomain
    subDomain: cloudSubDomain
  }
}

module cloudDnsSettings 'modules/dns.bicep' = {
  scope: managementResourceGroup
  name: 'cloudDnsSettingsDeploy'
  params: {
    origin: cloudFrontDoorSettings.outputs.frontDoorCustomDomainHost
    rootDomain: rootDomain
    subDomain: cloudSubDomain
    validationToken: cloudFrontDoorSettings.outputs.frontDoorCustomDomainValidationToken
  }
}

module dotnetStorageAccountModule 'modules/storageAccount.bicep' = {
  scope: websiteResourceGroup
  name: 'dotnetStorageAccountDeploy'
  params: {
    app: 'dotnet'
  }
}

module dotnetFrontDoorSettings 'modules/frontdoor.bicep' = {
  scope: infrastructureResourceGroup
  name: 'dotnetFrontDoorSettingsDeploy'
  params: {
    frontDoorOriginHost: dotnetStorageAccountModule.outputs.storageAccountHost
    frontDoorProfileName: frontDoorProfileName
    application: dotnetApplicationName
    rootDomain: rootDomain
    subDomain: dotnetSubDomain
  }
}

module dotnetDnsSettings 'modules/dns.bicep' = {
  scope: managementResourceGroup
  name: 'dotnetDnsSettingsDeploy'
  params: {
    origin: dotnetFrontDoorSettings.outputs.frontDoorCustomDomainHost
    rootDomain: rootDomain
    subDomain: dotnetSubDomain
    validationToken: dotnetFrontDoorSettings.outputs.frontDoorCustomDomainValidationToken
  }
}

output cloudStorageAccountName string = cloudStorageAccountModule.outputs.storageAccountName
output dotnetStorageAccountName string = dotnetStorageAccountModule.outputs.storageAccountName
output resourceGroupName string = websiteResourceGroup.name
output cloudFqdn string = 'https://${cloudSubDomain}.${rootDomain}/'
output dotnetFqdn string = 'https://${dotnetSubDomain}.${rootDomain}/'
