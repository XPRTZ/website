param location string
param containerAppUserAssignedIdentityResourceId string
param containerAppUserAssignedIdentityClientId string
param containerAppEnvironmentResourceId string

resource containerApp 'Microsoft.App/containerApps@2023-08-01-preview' = {
  name: 'ctap-xprtzbv-website'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${containerAppUserAssignedIdentityResourceId}': {}
    }
  }
  properties: {
    environmentId: containerAppEnvironmentResourceId
    configuration: {
      registries: [
        {
          server: 'xprtzbv.azurecr.io'
          identity: containerAppUserAssignedIdentityResourceId
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'xprtzbv-website'
          image: 'xprtzbv.azurecr.io/website:latest'
          resources: {
            cpu: 1
            memory: '2Gi'
          }
          env: [
            {
              name: 'AZURE_CLIENT_ID'
              value: containerAppUserAssignedIdentityClientId
            }
          ]
        }
      ]
    }
  }
}
