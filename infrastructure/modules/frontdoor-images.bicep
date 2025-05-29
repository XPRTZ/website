param frontDoorProfileName string
param storageAccountName string
param storageAccountResourceGroup string
param application string
param rootDomain string
param subDomain string

var frontDoorOriginName = 'afd-origin-images-${application}'
var frontDoorEndpointName = 'fde-images-${application}-${uniqueString(resourceGroup().id)}'
var frontDoorOriginGroupName = 'xprtz-images-${application}'
var frontDoorRouteName = 'images-route'
var customDomainHost = '${subDomain}.${rootDomain}'
var customDomainResourceName = replace('${customDomainHost}', '.', '-')

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' existing = {
  name: storageAccountName
  scope: resourceGroup(storageAccountResourceGroup)
}

resource frontDoorProfile 'Microsoft.Cdn/profiles@2024-02-01' existing = {
  name: frontDoorProfileName
}

resource frontDoorEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2024-02-01' = {
  name: frontDoorEndpointName
  parent: frontDoorProfile
  location: 'global'
  properties: {
    enabledState: 'Enabled'
  }
}

resource frontDoorOriginGroup 'Microsoft.Cdn/profiles/originGroups@2024-02-01' = {
  name: frontDoorOriginGroupName
  parent: frontDoorProfile
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
    }
    healthProbeSettings: {
      probePath: '/media/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Https'
      probeIntervalInSeconds: 100
    }
  }
}

resource frontDoorOrigin 'Microsoft.Cdn/profiles/originGroups/origins@2024-02-01' = {
  name: frontDoorOriginName
  parent: frontDoorOriginGroup
  properties: {
    hostName: split(storageAccount.properties.primaryEndpoints.blob, '/')[2]
    httpPort: 80
    httpsPort: 443
    originHostHeader: split(storageAccount.properties.primaryEndpoints.blob, '/')[2]
    priority: 1
    weight: 1000
  }
}

resource frontDoorRoute 'Microsoft.Cdn/profiles/afdEndpoints/routes@2024-02-01' = {
  name: frontDoorRouteName
  parent: frontDoorEndpoint
  dependsOn: [
    frontDoorOrigin
  ]
  properties: {
    customDomains: [
      {
        id: frontDoorCustomDomain.id
      }
    ]
    originGroup: {
      id: frontDoorOriginGroup.id
    }
    supportedProtocols: [
      'Http'
      'Https'
    ]
    patternsToMatch: [
      '/uploads/*'
    ]
    forwardingProtocol: 'HttpsOnly'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
    originPath: '/media'
  }
}

resource frontDoorCustomDomain 'Microsoft.Cdn/profiles/customDomains@2024-02-01' = {
  name: customDomainResourceName
  parent: frontDoorProfile
  properties: {
    hostName: customDomainHost
    tlsSettings: {
      certificateType: 'ManagedCertificate'
      minimumTlsVersion: 'TLS12'
    }
  }
}

output frontDoorCustomDomainValidationToken string = frontDoorCustomDomain.properties.validationProperties.validationToken
output frontDoorCustomDomainHost string = frontDoorEndpoint.properties.hostName
