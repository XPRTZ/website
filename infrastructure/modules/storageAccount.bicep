@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param sku string = 'Standard_LRS'
param app string

resource websiteStorageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' = {
  name: 'st${app}${uniqueString(resourceGroup().id)}'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: sku
  }
  properties: {
    supportsHttpsTrafficOnly: true
    accessTier: 'Hot'
    allowBlobPublicAccess: true
    minimumTlsVersion: 'TLS1_2'
  }
}
output storageAccountName string = websiteStorageAccount.name
output storageAccountFqdn string = websiteStorageAccount.properties.primaryEndpoints.web
output storageAccountHost string = split(websiteStorageAccount.properties.primaryEndpoints.web, '/')[2]

resource websiteStorageBlobServices 'Microsoft.Storage/storageAccounts/blobServices@2023-04-01' existing = {
  parent: websiteStorageAccount
  name: 'default'
}

resource websiteStorageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-04-01' = {
  parent: websiteStorageBlobServices
  name: '$web'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
}
