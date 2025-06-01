import { domainsType } from '../types.bicep'

param frontDoorProfileName string
param frontDoorOriginHost string
param application string
param domains domainsType[]

var frontDoorOriginName = 'afd-origin-${application}'
var frontDoorEndpointName = 'fde-${application}-${uniqueString(resourceGroup().id)}'
var frontDoorOriginGroupName = 'xprtz-website-${application}'
var frontDoorRouteName = 'inbound'

resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: domains[0].rootDomain
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
      probePath: '/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Http'
      probeIntervalInSeconds: 100
    }
  }
}

resource frontDoorOrigin 'Microsoft.Cdn/profiles/originGroups/origins@2024-02-01' = {
  name: frontDoorOriginName
  parent: frontDoorOriginGroup
  properties: {
    hostName: frontDoorOriginHost
    httpPort: 80
    httpsPort: 443
    originHostHeader: frontDoorOriginHost
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
    customDomains: [for (domain, index) in domains: {
      id: frontDoorCustomDomains[index].id
    }]
    originGroup: {
      id: frontDoorOriginGroup.id
    }
    supportedProtocols: [
      'Http'
      'Https'
    ]
    patternsToMatch: [
      '/*'
    ]
    forwardingProtocol: 'HttpsOnly'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
  }
}

resource frontDoorCustomDomains 'Microsoft.Cdn/profiles/customDomains@2024-02-01' = [for (domain, index) in domains: {
  name: replace(domain.fullDomain, '.', '-')
  parent: frontDoorProfile
  properties: {
    hostName: domain.fullDomain
    tlsSettings: {
      certificateType: 'ManagedCertificate'
      minimumTlsVersion: 'TLS12'
    }
    azureDnsZone: {
        id: dnsZone.id
    }
  }
}]

output frontDoorCustomDomainValidationTokens array = [for (domain, index) in domains: {
  domain: domain
  validationToken: frontDoorCustomDomains[index].properties.validationProperties.validationToken
}]
output frontDoorCustomDomainHost string = frontDoorEndpoint.properties.hostName
output frontDoorEndpointId string = frontDoorEndpoint.id
