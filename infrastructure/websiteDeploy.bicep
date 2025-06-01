import { domainsType } from './types.bicep'

targetScope = 'subscription'

param resourceGroupSuffix string = 'main'
param deployDns bool = true
param application string = 'dotnet'
param frontDoorProfileName string = 'afd-xprtzbv-websites'
param imagesDomain string = 'images'
param domains domainsType[] = [
  {
    rootDomain: 'xprtz.dev'
    subDomain: ''
    fullDomain: 'xprtz.dev'
  }
  {
    rootDomain: 'xprtz.dev'
    subDomain: 'www'
    fullDomain: 'www.xprtz.dev'
  }
  {
    rootDomain: 'xprtz.dev'
    subDomain: 'dotnet'
    fullDomain: 'dotnet.xprtz.dev'
  }
]

var rootDomain = domains[0].rootDomain

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

module frontDoorSettings 'modules/frontdoor.bicep' = {
  scope: infrastructureResourceGroup
    name: 'frontDoorSettingsDeploy-${application}'
  params: {
    frontDoorOriginHost: storageAccountModule.outputs.storageAccountHost
    frontDoorProfileName: frontDoorProfileName
    application: application
    domains: domains
  }
}

module dnsSettings 'modules/dns.bicep' = {
  scope: infrastructureResourceGroup
    name: 'dnsSettingsDeploy-${application}'
    params: {
    origin: frontDoorSettings.outputs.frontDoorCustomDomainHost
    frontDoorEndpointId: frontDoorSettings.outputs.frontDoorEndpointId
    domains: domains
    validationTokens: frontDoorSettings.outputs.frontDoorCustomDomainValidationTokens
  }
}

module imagesFrontDoorSettings 'modules/frontdoor-images.bicep' = {
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

module imagesDnsSettings 'modules/dns.bicep' = {
  scope: infrastructureResourceGroup
  name: 'imagesDnsSettingsDeploy-${application}'
  params: {
    origin: imagesFrontDoorSettings.outputs.frontDoorCustomDomainHost
    frontDoorEndpointId: imagesFrontDoorSettings.outputs.frontDoorEndpointId
    deployApexRecord: false
    domains: [
      {
        rootDomain: rootDomain
        subDomain: imagesDomain
        fullDomain: '${imagesDomain}.${rootDomain}'
      }
    ]
    validationTokens: [
      {
        domain: {
          rootDomain: rootDomain
          subDomain: imagesDomain
          fullDomain: '${imagesDomain}.${rootDomain}'
        }
        validationToken: imagesFrontDoorSettings.outputs.frontDoorCustomDomainValidationToken
      }
    ]
  }
}

output storageAccountName string = storageAccountModule.outputs.storageAccountName
output resourceGroupName string = websiteResourceGroup.name
output applicationFqdn string = deployDns
  ? 'https://${application}.${rootDomain}/'
  : storageAccountModule.outputs.storageAccountFqdn
