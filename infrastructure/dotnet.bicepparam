using './website.bicep'

param resourceGroupSuffix = 'main'
param application = 'dotnet'
param hostnames = [
  {
    dnsZoneName: 'xprtz.nl'
    hostname: ''
  }
  {
    dnsZoneName: 'xprtz.nl'
    hostname: 'www'
  }
  {
    dnsZoneName: 'xprtz.cloud'
    hostname: ''
  }
  {
    dnsZoneName: 'xprtz.cloud'
    hostname: 'www'
  }
  {
    dnsZoneName: 'xprtz.net'
    hostname: ''
  }
  {
    dnsZoneName: 'xprtz.net'
    hostname: 'www'
  }
]
param imageHostname = {
  dnsZoneName: 'xprtz.nl'
  hostname: 'images'
}
