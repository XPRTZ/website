param subdomain string
param containerName string
param defaultDomain string
param customDomainVerificationId string

resource dnsZone 'Microsoft.Network/dnsZones@2023-07-01-preview' existing = {
  name: 'xprtz.dev'
}

resource cname 'Microsoft.Network/dnsZones/CNAME@2023-07-01-preview' = {
  name: subdomain
  parent: dnsZone
  properties: {
    TTL: 3600
    CNAMERecord: {
      cname: '${containerName}.${defaultDomain}'
    }
  }
}

resource verification 'Microsoft.Network/dnsZones/TXT@2023-07-01-preview' = {
  name: 'asuid.${subdomain}'
  parent: dnsZone
  properties: {
    TTL: 3600
    TXTRecords: [
      {
        value: [ customDomainVerificationId ]
      }
    ]
  }
}

output subdomain string = cname.name
