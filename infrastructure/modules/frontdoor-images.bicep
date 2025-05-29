param frontDoorProfileName string
param storageAccountName string
param storageAccountResourceGroup string
param application string
param rootDomain string
param subDomain string

var frontDoorOriginName = 'afd-origin-images-${application}'
var frontDoorEndpointName = 'fde-images-${application}-${uniqueString(resourceGroup().id)}'
var frontDoorOriginGroupName = 'xprtz-images-${application}'
var frontDoorRouteName = 'images-route'
var customDomainHost = '${subDomain}.${rootDomain}'
var customDomainResourceName = replace('${customDomainHost}', '.', '-')
var ruleSetName = 'images-headers-${application}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' existing = {
  name: storageAccountName
  scope: resourceGroup(storageAccountResourceGroup)
}

resource frontDoorProfile 'Microsoft.Cdn/profiles@2024-02-01' existing = {
  name: frontDoorProfileName
}

resource frontDoorEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2024-02-01' = {
  name: frontDoorEndpointName
  parent: frontDoorProfile
  location: 'global'
  properties: {
    enabledState: 'Enabled'
  }
}

resource frontDoorRuleSet 'Microsoft.Cdn/profiles/ruleSets@2024-02-01' = {
  name: ruleSetName
  parent: frontDoorProfile
}

resource jpegRule 'Microsoft.Cdn/profiles/ruleSets/rules@2024-02-01' = {
  name: 'jpeg-content-type'
  parent: frontDoorRuleSet
  properties: {
    order: 1
    conditions: [
      {
        name: 'UrlFileExtension'
        parameters: {
          typeName: 'DeliveryRuleUrlFileExtensionMatchConditionParameters'
          operator: 'Equal'
          negateCondition: false
          matchValues: [
            'jpg'
            'jpeg'
          ]
          transforms: [
            'Lowercase'
          ]
        }
      }
    ]
    actions: [
      {
        name: 'ModifyResponseHeader'
        parameters: {
          typeName: 'DeliveryRuleHeaderActionParameters'
          headerAction: 'Overwrite'
          headerName: 'Content-Type'
          value: 'image/jpeg'
        }
      }
    ]
  }
}

resource pngRule 'Microsoft.Cdn/profiles/ruleSets/rules@2024-02-01' = {
  name: 'png-content-type'
  parent: frontDoorRuleSet
  properties: {
    order: 2
    conditions: [
      {
        name: 'UrlFileExtension'
        parameters: {
          typeName: 'DeliveryRuleUrlFileExtensionMatchConditionParameters'
          operator: 'Equal'
          negateCondition: false
          matchValues: [
            'png'
          ]
          transforms: [
            'Lowercase'
          ]
        }
      }
    ]
    actions: [
      {
        name: 'ModifyResponseHeader'
        parameters: {
          typeName: 'DeliveryRuleHeaderActionParameters'
          headerAction: 'Overwrite'
          headerName: 'Content-Type'
          value: 'image/png'
        }
      }
    ]
  }
}

resource svgRule 'Microsoft.Cdn/profiles/ruleSets/rules@2024-02-01' = {
  name: 'svg-content-type'
  parent: frontDoorRuleSet
  properties: {
    order: 3
    conditions: [
      {
        name: 'UrlFileExtension'
        parameters: {
          typeName: 'DeliveryRuleUrlFileExtensionMatchConditionParameters'
          operator: 'Equal'
          negateCondition: false
          matchValues: [
            'svg'
          ]
          transforms: [
            'Lowercase'
          ]
        }
      }
    ]
    actions: [
      {
        name: 'ModifyResponseHeader'
        parameters: {
          typeName: 'DeliveryRuleHeaderActionParameters'
          headerAction: 'Overwrite'
          headerName: 'Content-Type'
          value: 'image/svg+xml'
        }
      }
    ]
  }
}

resource gifRule 'Microsoft.Cdn/profiles/ruleSets/rules@2024-02-01' = {
  name: 'gif-content-type'
  parent: frontDoorRuleSet
  properties: {
    order: 4
    conditions: [
      {
        name: 'UrlFileExtension'
        parameters: {
          typeName: 'DeliveryRuleUrlFileExtensionMatchConditionParameters'
          operator: 'Equal'
          negateCondition: false
          matchValues: [
            'gif'
          ]
          transforms: [
            'Lowercase'
          ]
        }
      }
    ]
    actions: [
      {
        name: 'ModifyResponseHeader'
        parameters: {
          typeName: 'DeliveryRuleHeaderActionParameters'
          headerAction: 'Overwrite'
          headerName: 'Content-Type'
          value: 'image/gif'
        }
      }
    ]
  }
}

resource webpRule 'Microsoft.Cdn/profiles/ruleSets/rules@2024-02-01' = {
  name: 'webp-content-type'
  parent: frontDoorRuleSet
  properties: {
    order: 5
    conditions: [
      {
        name: 'UrlFileExtension'
        parameters: {
          typeName: 'DeliveryRuleUrlFileExtensionMatchConditionParameters'
          operator: 'Equal'
          negateCondition: false
          matchValues: [
            'webp'
          ]
          transforms: [
            'Lowercase'
          ]
        }
      }
    ]
    actions: [
      {
        name: 'ModifyResponseHeader'
        parameters: {
          typeName: 'DeliveryRuleHeaderActionParameters'
          headerAction: 'Overwrite'
          headerName: 'Content-Type'
          value: 'image/webp'
        }
      }
    ]
  }
}

resource frontDoorOriginGroup 'Microsoft.Cdn/profiles/originGroups@2024-02-01' = {
  name: frontDoorOriginGroupName
  parent: frontDoorProfile
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
    }
    healthProbeSettings: {
      probePath: '/media/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Https'
      probeIntervalInSeconds: 100
    }
  }
}

resource frontDoorOrigin 'Microsoft.Cdn/profiles/originGroups/origins@2024-02-01' = {
  name: frontDoorOriginName
  parent: frontDoorOriginGroup
  properties: {
    hostName: split(storageAccount.properties.primaryEndpoints.blob, '/')[2]
    httpPort: 80
    httpsPort: 443
    originHostHeader: split(storageAccount.properties.primaryEndpoints.blob, '/')[2]
    priority: 1
    weight: 1000
  }
}

resource frontDoorRoute 'Microsoft.Cdn/profiles/afdEndpoints/routes@2024-02-01' = {
  name: frontDoorRouteName
  parent: frontDoorEndpoint
  dependsOn: [
    frontDoorOrigin
  ]
  properties: {
    customDomains: [
      {
        id: frontDoorCustomDomain.id
      }
    ]
    originGroup: {
      id: frontDoorOriginGroup.id
    }
    ruleSets: [
      {
        id: frontDoorRuleSet.id
      }
    ]
    supportedProtocols: [
      'Http'
      'Https'
    ]
    patternsToMatch: [
      '/uploads/*'
    ]
    forwardingProtocol: 'HttpsOnly'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
    originPath: '/media'
  }
}

resource frontDoorCustomDomain 'Microsoft.Cdn/profiles/customDomains@2024-02-01' = {
  name: customDomainResourceName
  parent: frontDoorProfile
  properties: {
    hostName: customDomainHost
    tlsSettings: {
      certificateType: 'ManagedCertificate'
      minimumTlsVersion: 'TLS12'
    }
  }
}

output frontDoorCustomDomainValidationToken string = frontDoorCustomDomain.properties.validationProperties.validationToken
output frontDoorCustomDomainHost string = frontDoorEndpoint.properties.hostName
