targetScope = 'subscription'

param resourceSuffix string

resource websiteResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  location: deployment().location
  name: 'rg-xprtzbv-website-${resourceSuffix}'
}

module storageAccountModule 'modules/storageAccount.bicep' = {
  scope: websiteResourceGroup
  name: 'storageAccountDeploy'
  params: {
    resourceSuffix: resourceSuffix
  }
}
