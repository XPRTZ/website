@export()
type hostnameType = {
  dnsZoneName: string
  hostname: string
}

@export()
type validationTokenType = {
  hostname: hostnameType
  validationToken: string
}
