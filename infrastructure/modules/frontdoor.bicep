param frontDoorProfileName string
param frontDoorOriginHost string
param application string
param rootDomain string
param subDomain string

var frontDoorOriginName = 'afd-origin-${application}'
var frontDoorEndpointName = 'fde-${application}-${uniqueString(resourceGroup().id)}'
var frontDoorOriginGroupName = 'xprtz-website-${application}'
var frontDoorRouteName = 'inbound'
var customDomainHost = '${subDomain}.${rootDomain}'
var customDomainResourceName = replace('${customDomainHost}', '.', '-')

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

resource frontDoorRoute 'Microsoft.Cdn/profiles/afdEndpoints/routes@2024-02-01' = if (application != 'landing') {
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
      '/*'
    ]
    forwardingProtocol: 'HttpsOnly'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
  }
}

resource frontDoorRouteLandingSite 'Microsoft.Cdn/profiles/afdEndpoints/routes@2024-02-01' = if (application == 'landing') {
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
      {
        id: frontDoorCustomDomainWww.id
      }
      {
        id: frontDoorCustomDomainXprtzNl.id
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
      '/*'
    ]
    forwardingProtocol: 'HttpsOnly'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
  }
}

resource frontDoorCustomDomainWww 'Microsoft.Cdn/profiles/customDomains@2024-02-01' existing = {
  name: 'www-xprtz-nl-379c'
  parent: frontDoorProfile
}

resource frontDoorCustomDomainXprtzNl 'Microsoft.Cdn/profiles/customDomains@2024-02-01' existing = {
  name: 'xprtz-nl-5c4c'
  parent: frontDoorProfile
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
