param location string = 'westeurope'
param subdomain string

var containerAppEnvironmentName = 'me-xprtzbv-website'

resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2022-11-01-preview' existing = {
  name: containerAppEnvironmentName

  resource managedCertificate 'managedCertificates' = {
    name: '${subdomain}.xprtz.dev'
    location: location
    properties: {
      subjectName: subdomain
      domainControlValidation: 'TXT'
    }
  }
}

