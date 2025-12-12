import { hostnameType, validationTokenType } from '../types.bicep'

@description('The name of the Front Door profile to use for the CDN.')
param frontDoorProfileName string
@description('The hostname of the origin for the Front Door.')
param frontDoorOriginHost string
@description('The name of the application, used to prefix resource names.')
param application string
@description('List of hostnames to be configured for the Front Door.')
param hostnames hostnameType[]

var frontDoorOriginName = 'afd-origin-${application}'
var frontDoorEndpointName = 'fde-${application}-${uniqueString(resourceGroup().id)}'
var frontDoorOriginGroupName = 'xprtz-website-${application}'
var frontDoorRouteName = 'inbound'

resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: hostnames[0].dnsZoneName
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

var domainNames = [for hostname in hostnames: empty(hostname.hostname) ? hostname.dnsZoneName : '${hostname.hostname}.${hostname.dnsZoneName}']

// Gebruik de berekende waarden in de resource
@batchSize(1)
resource frontDoorCustomDomains 'Microsoft.Cdn/profiles/customDomains@2024-02-01' = [for domainName in domainNames: {
  name: replace(domainName, '.', '-')
  parent: frontDoorProfile
  properties: {
    hostName: domainName
    tlsSettings: {
      certificateType: 'ManagedCertificate'
      minimumTlsVersion: 'TLS12'
    }
    azureDnsZone: {
      id: dnsZone.id
    }
  }
}]

resource frontDoorRoute 'Microsoft.Cdn/profiles/afdEndpoints/routes@2024-02-01' = {
  name: frontDoorRouteName
  parent: frontDoorEndpoint
  dependsOn: [
    frontDoorOrigin
  ]
  properties: {
    customDomains: [for (hostname, index) in hostnames: {
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

output frontDoorCustomDomainValidationTokens validationTokenType[] = [for (hostname, index) in hostnames: {
  dnsZoneName: hostname.dnsZoneName
  hostname: hostname.hostname
  validationToken: frontDoorCustomDomains[index].properties.validationProperties.validationToken
}]
output frontDoorHostname string = frontDoorEndpoint.properties.hostName
output frontDoorEndpointId string = frontDoorEndpoint.id
