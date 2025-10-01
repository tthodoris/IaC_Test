targetScope = 'resourceGroup'

@description('Virtual Network name.')
param vnetName string

@description('VNet address space in CIDR.')
param vnetAddressPrefix string = '10.10.0.0/16'

@description('First subnet name.')
param subnet1Name string = 'snet-app'

@description('First subnet address prefix.')
param subnet1Prefix string = '10.10.1.0/24'

@description('Second subnet name.')
param subnet2Name string = 'snet-data'

@description('Second subnet address prefix.')
param subnet2Prefix string = '10.10.2.0/24'

@description('Resource location; defaults to the resource group location.')
param location string = resourceGroup().location

@description('Tags applied to the VNet.')
param tags object = {}

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: subnet1Prefix
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2Prefix
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output subnet1Id string = '${vnet.id}/subnets/${subnet1Name}'
output subnet2Id string = '${vnet.id}/subnets/${subnet2Name}'
