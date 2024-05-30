targetScope = 'subscription'

param suffix string

resource websiteResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  location: deployment().location
  name: 'rg-xprtzbv-website-${uniqueString(suffix)}'
}

module cloudStorageAccountModule 'modules/storageAccount.bicep' = {
  scope: websiteResourceGroup
  name: 'cloudStorageAccountDeploy'
  params: {
    app: 'cloud'
  }
}

module dotnetStorageAccountModule 'modules/storageAccount.bicep' = {
  scope: websiteResourceGroup
  name: 'dotnetStorageAccountDeploy'
  params: {
    app: 'dotnet'
  }
}

output cloudStorageAccountName string = cloudStorageAccountModule.outputs.storageAccountName
output dotnetStorageAccountName string = dotnetStorageAccountModule.outputs.storageAccountName
output resourceGroupName string = websiteResourceGroup.name
