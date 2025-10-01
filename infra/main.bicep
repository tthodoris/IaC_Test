targetScope = 'subscription'

@description('Name of the Resource Group to create.')
param rgName string

@description('Azure region for the Resource Group and VNet (e.g., westeurope).')
param location string = 'westeurope'

@description('Tags applied to both the Resource Group and VNet.')
param tags object = {}

@description('Virtual Network name.')
param vnetName string = 'vnet-weu-01'

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

// Create the Resource Group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
  tags: tags
}

// Deploy the VNet (module) into the Resource Group created above
module vnet './vnet.bicep' = {
  name: 'vnetDeployment'
  scope: resourceGroup(rg.name)
  params: {
    vnetName: vnetName
    vnetAddressPrefix: vnetAddressPrefix
    subnet1Name: subnet1Name
    subnet1Prefix: subnet1Prefix
    subnet2Name: subnet2Name
    subnet2Prefix: subnet2Prefix
    location: location
    tags: tags
  }
}

output resourceGroupId string = rg.id
output vnetId string = vnet.outputs.vnetId
output subnet1Id string = vnet.outputs.subnet1Id
output subnet2Id string = vnet.outputs.subnet2Id
