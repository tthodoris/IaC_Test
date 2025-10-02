// main.bicep
targetScope = 'resourceGroup'

@description('Virtual network name.')
param vnetName string

@description('VNet address space (one or more CIDR prefixes).')
param vnetAddressPrefixes array

@description('Subnets to create. Example item: { name: "snet-app", addressPrefix: "10.10.1.0/24" }')
param subnets array

@description('Location (defaults to RG location).')
param location string = resourceGroup().location

@description('Optional tags.')
param tags object = {}

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressPrefixes
    }
    subnets: [for sn in subnets: {
      name: sn.name
      properties: {
        // For multiple prefixes per subnet, replace with: addressPrefixes: sn.addressPrefixes
        addressPrefix: sn.addressPrefix
      }
    }]
  }
}

output vnetId string = vnet.id
