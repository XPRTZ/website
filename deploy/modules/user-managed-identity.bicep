param location string

resource containerAppIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  location: location
  name: 'id-xprtzbv-website'
}

output containerAppIdentityPrincipalId string = containerAppIdentity.properties.principalId
output containerAppIdentityResourceId string = containerAppIdentity.id
output containerAppIdentityClientId string = containerAppIdentity.properties.clientId
