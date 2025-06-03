import { validationTokenType } from '../types.bicep'

param frontDoorEndpointId string
param origin string
param validationToken validationTokenType
param deployApexRecord bool = true

var domain = validationToken.domain

resource dnsZone 'Microsoft.Network/dnsZones@2023-07-01-preview' existing = {
  name: domain.rootDomain
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

resource validationTxtRecordApex 'Microsoft.Network/dnsZones/TXT@2023-07-01-preview' = if (validationToken.domain.subDomain == '') {
  parent: dnsZone
  name: '_dnsauth'
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
}

resource cnameRecord 'Microsoft.Network/dnsZones/CNAME@2023-07-01-preview' = {
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
}

resource validationTxtRecordCname 'Microsoft.Network/dnsZones/TXT@2023-07-01-preview' = if (validationToken.domain.subDomain != '') {
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
}
