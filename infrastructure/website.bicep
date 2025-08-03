import { hostnameType } from './types.bicep'

targetScope = 'subscription'

@description('The suffix for the resource group, typically \'main\' for production or a specific identifier for non-production environments.')
param resourceGroupSuffix string
@description('The name of the application, used to prefix resource names.')
param application string
@description('List of hostnames to be configured for the website.')
param hostnames hostnameType[]
@description('Hostname for the images domain, used for static content.')
param imageHostname hostnameType

var isProd = endsWith(resourceGroupSuffix, 'main')


var sharedValues = json(loadTextContent('shared-values.json'))
var infrastructureResourceGroup = resourceGroup(
  sharedValues.subscriptionIds.xprtz,
  sharedValues.resourceGroups.infrastructure
)

var resourceGroupPrefix = 'rg-xprtzbv-website-${application}'
var resourceGroupName = isProd ? resourceGroupPrefix : '${resourceGroupPrefix}-${resourceGroupSuffix}'
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
    frontDoorProfileName: sharedValues.frontDoorProfileName
    application: application
    hostnames: hostnames
  }
}

@batchSize(1)
module dnsSettings 'modules/dns.bicep' = [for hostname in hostnames: if (isProd) {
  scope: infrastructureResourceGroup
    name: 'dnsSettingsDeploy-${hostname.hostname}-${hostname.dnsZoneName}-${application}'
    params: {
      hostname: hostname
      frontDoorEndpointId: frontDoorSettings.outputs.frontDoorEndpointId
      frontDoorHostname: frontDoorSettings.outputs.frontDoorHostname
      validationToken: filter(
        frontDoorSettings.outputs.frontDoorCustomDomainValidationTokens,
        validation => validation.hostname == hostname.hostname && validation.dnsZoneName == hostname.dnsZoneName
      )[0]
    }
  }
]

module imagesFrontDoorSettings 'modules/frontdoor-images.bicep' = if (isProd) {
  scope: infrastructureResourceGroup
  name: 'imagesFrontDoorSettingsDeploy-${application}'
  params: {
    storageAccountName: storageAccountModule.outputs.storageAccountName
    storageAccountResourceGroup: websiteResourceGroup.name
    frontDoorProfileName: sharedValues.frontDoorProfileName
    application: application
    rootDomain: imageHostname.dnsZoneName
    subDomain: imageHostname.hostname
  }
}

module imagesDnsSettings 'modules/dns.bicep' = if (isProd) {
  scope: infrastructureResourceGroup
  name: 'imagesDnsSettingsDeploy-${application}'
  params: {
    hostname: imageHostname
    frontDoorEndpointId: imagesFrontDoorSettings.outputs.frontDoorEndpointId
    frontDoorHostname: imagesFrontDoorSettings.outputs.frontDoorHostname
    validationToken: {
        dnsZoneName: imageHostname.dnsZoneName
        hostname: imageHostname.hostname
        validationToken: imagesFrontDoorSettings.outputs.frontDoorCustomDomainValidationToken
    }
  }
}

output storageAccountName string = storageAccountModule.outputs.storageAccountName
output resourceGroupName string = websiteResourceGroup.name
output applicationFqdn string = isProd ? 'https://${hostnames[0].dnsZoneName}/' : storageAccountModule.outputs.storageAccountFqdn
