targetScope= 'resourceGroup'

param systemTopicName string
param subscriptionid string 
param resourcegroup string
param configurationStoreName string
param functionAppName string 
param functionName string 
param location string = resourceGroup().location

var configurationStoreId = '/subscriptions/${subscriptionid}/resourceGroups/${resourcegroup}/providers/Microsoft.AppConfiguration/configurationStores/${configurationStoreName}'
var functionAppId = '/subscriptions/${subscriptionid}/resourceGroups/${resourcegroup}/providers/Microsoft.Web/sites/${functionAppName}'
var functionAppResourceId = '${functionAppId}/functions/${functionName}'

resource systemTopicResource 'Microsoft.EventGrid/systemTopics@2022-06-15' = {
  name: systemTopicName
  location: location
  properties: {
    source: configurationStoreId
    topicType: 'Microsoft.AppConfiguration.ConfigurationStores'
  }
}

resource systemTopicSubscription 'Microsoft.EventGrid/systemTopics/eventSubscriptions@2022-06-15' = {
  parent: systemTopicResource
  name: 'eventgrid-function-subscription'
  properties: {
    destination: {
      properties: {
        resourceId: resourceId(functionAppResourceId, '2021-02-01-preview')
        maxEventsPerBatch: 1
        preferredBatchSizeInKilobytes: 64
      }
      endpointType: 'AzureFunction'
    }
    filter: {
      includedEventTypes: [
        'Microsoft.AppConfiguration.KeyValueModified'
        'Microsoft.AppConfiguration.KeyValueDeleted'
      ]
      enableAdvancedFilteringOnArrays: true
    }
    labels: []
    eventDeliverySchema: 'EventGridSchema'
    retryPolicy: {
      maxDeliveryAttempts: 30
      eventTimeToLiveInMinutes: 1440
    }
  }
}
