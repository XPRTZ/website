param location string
param containerAppUserAssignedIdentityResourceId string
param containerAppUserAssignedIdentityClientId string
param imageTag string = 'latest'

var name = take('ctap-xprtzbv-website-${imageTag}', 32)


var acrServer = 'xprtzbv.azurecr.io'
var imageName = '${acrServer}/website:${imageTag}'
var containerAppEnvironmentName = 'me-xprtzbv-website'

resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2022-11-01-preview' existing = {
  name: containerAppEnvironmentName
}

resource containerApp 'Microsoft.App/containerApps@2023-08-01-preview' = {
  name: name
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${containerAppUserAssignedIdentityResourceId}': {}
    }
  }
  properties: {
    environmentId: containerAppEnvironment.id
    configuration: {
      registries: [
        {
          server: acrServer
          identity: containerAppUserAssignedIdentityResourceId
        }
      ]
      ingress: {
        external: true
        targetPort: 3000
      }
    }
    template: {
      containers: [
        {
          name: name
          image: imageName
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
      scale: {
       minReplicas: 1
       maxReplicas: 10
      }
    }
  }
}

output containerAppUrl string = containerApp.properties.latestRevisionFqdn
