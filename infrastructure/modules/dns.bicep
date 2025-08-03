import { hostnameType, validationTokenType } from '../types.bicep'

@description('The dns record details')
param hostname hostnameType
@description('The ID of the Front Door endpoint to link the DNS records to.')
param frontDoorEndpointId string
@description('The validation token for DNS verification.')
param validationToken validationTokenType

resource dnsZone 'Microsoft.Network/dnsZones@2023-07-01-preview' existing = {
  name: hostname.dnsZoneName
}

resource apexRecord 'Microsoft.Network/dnszones/A@2023-07-01-preview' = if (empty(hostname.hostname)) {
  parent: dnsZone
  name: '@'
  properties: {
    TTL: 3600
    targetResource: {
      id: frontDoorEndpointId
    }
  }
}

resource cnameRecord 'Microsoft.Network/dnsZones/CNAME@2023-07-01-preview' = if (!empty(hostname.hostname)) {
  parent: dnsZone
  name: hostname.hostname
  properties: {
    TTL: 3600
    CNAMERecord: {
      cname: hostname.dnsZoneName
    }
  }
}

resource validationTxtRecordApex 'Microsoft.Network/dnsZones/TXT@2023-07-01-preview' = {
  parent: dnsZone
  name: empty(hostname.hostname) ? '_dnsauth' : '_dnsauth.${hostname.hostname}'
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
