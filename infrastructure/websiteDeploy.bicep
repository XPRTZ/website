import { domainsType } from './types.bicep'

targetScope = 'subscription'

param resourceGroupSuffix string
param application string = 'dotnet'

var isProd = endsWith(resourceGroupSuffix, 'main')
param previewDomains domainsType[] = [
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
param prodDomains domainsType[] = [
  {
    rootDomain: 'xprtz.nl'
    subDomain: ''
    fullDomain: 'xprtz.nl'
  }
  {
    rootDomain: 'xprtz.nl'
    subDomain: 'www'
    fullDomain: 'www.xprtz.nl'
  }
  {
    rootDomain: 'xprtz.net'
    subDomain: ''
    fullDomain: 'xprtz.net'
  }
  {
    rootDomain: 'xprtz.cloud'
    subDomain: ''
    fullDomain: 'xprtz.cloud'
  }
]

var domains = isProd ? prodDomains : previewDomains
var rootDomain = domains[0].rootDomain
var resourceGroupPrefix = 'rg-xprtzbv-website-${application}'
var resourceGroupName = isProd
  ? resourceGroupPrefix
  : '${resourceGroupPrefix}-${resourceGroupSuffix}'

var sharedValues = json(loadTextContent('shared-values.json'))
var infrastructureResourceGroup = resourceGroup(
  sharedValues.subscriptionIds.xprtz,
  sharedValues.resourceGroups.infrastructure
)

var frontDoorProfileName = 'afd-xprtzbv-websites'
var imagesDomain = 'images'

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

module frontDoorSettings 'modules/frontdoor.bicep' = if (isProd) {
  scope: infrastructureResourceGroup
    name: 'frontDoorSettingsDeploy-${application}'
  params: {
    frontDoorOriginHost: storageAccountModule.outputs.storageAccountHost
    frontDoorProfileName: frontDoorProfileName
    application: application
    domains: domains
  }
}

module dnsSettings 'modules/dns.bicep' = if (isProd) {
  scope: infrastructureResourceGroup
    name: 'dnsSettingsDeploy-${application}'
    params: {
    origin: frontDoorSettings.outputs.frontDoorCustomDomainHost
    frontDoorEndpointId: frontDoorSettings.outputs.frontDoorEndpointId
    domains: domains
    validationTokens: frontDoorSettings.outputs.frontDoorCustomDomainValidationTokens
  }
}

module imagesFrontDoorSettings 'modules/frontdoor-images.bicep' = if (isProd) {
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

module imagesDnsSettings 'modules/dns.bicep' = if (isProd) {
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
output applicationFqdn string = isProd
  ? 'https://${rootDomain}/'
  : storageAccountModule.outputs.storageAccountFqdn
