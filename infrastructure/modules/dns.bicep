param origin string
param rootDomain string
param subDomain string
param validationToken string

resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: rootDomain
}

resource cnameRecord 'Microsoft.Network/dnsZones/CNAME@2018-05-01' = {
  parent: dnsZone
  name: subDomain
  properties: {
    TTL: 3600
    CNAMERecord: {
      cname: origin
    }
  }
}

resource validationTxtRecord 'Microsoft.Network/dnsZones/TXT@2018-05-01' = {
  parent: dnsZone
  name: '_dnsauth.${subDomain}'
  properties: {
    TTL: 3600
    TXTRecords: [
      {
        value: [
          validationToken
        ]
      }
    ]
  }
}
