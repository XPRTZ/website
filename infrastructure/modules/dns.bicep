import { domainsType, validationTokenType } from '../types.bicep'

param frontDoorEndpointId string
param origin string
param domains domainsType[]
param validationTokens validationTokenType[]
param deployApexRecord bool = true

var cnames = filter(domains, domain => domain.subDomain != '')

resource dnsZone 'Microsoft.Network/dnsZones@2023-07-01-preview' existing = {
  name: domains[0].rootDomain
}

resource apexRecord 'Microsoft.Network/dnszones/A@2023-07-01-preview' = if(deployApexRecord) {
  parent: dnsZone
  name: '@'
  properties: {
    TTL: 3600
    targetResource: {
      id: frontDoorEndpointId
    }
  }
}

@batchSize(1)
resource cnameRecord 'Microsoft.Network/dnsZones/CNAME@2023-07-01-preview' = [for domain in cnames: {
  parent: dnsZone
  name: domain.subDomain
  properties: {
    TTL: 3600
    CNAMERecord: {
      cname: origin
    }
  }
  dependsOn: [
    apexRecord
  ]
}]

@batchSize(1)
resource validationTxtRecord 'Microsoft.Network/dnsZones/TXT@2023-07-01-preview' = [for validationToken in validationTokens: {
  parent: dnsZone
  name: '_dnsauth.${validationToken.domain.subDomain}'
  properties: {
    TTL: 3600
    TXTRecords: [
      {
        value: [
          validationToken.validationToken
        ]
      }
    ]
  }
}]
