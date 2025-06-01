@export()
type domainsType = {
  rootDomain: string
  subDomain: string
  fullDomain: string
}

@export()
type validationTokenType = {
  domain: domainsType
  validationToken: string
}
