/**
 * CTLocationTriggerHandler
 * Handler class for Location__c Trigger
 * @author Manish
 */
public with sharing class CTLocationTriggerHandler {
    // Before insert operation for Location__c object
    // make sure the health status is green
    public static void beforeInsert(List<Location__c> newRecords) {
        for (Location__c location : newRecords) {
            // update location status to Green
            location.Status__c = 'Green';
        }
    }

    // Before update operation for Location__c object
    public static void beforeUpdate(List<Location__c> locations, Map<Id, Location__c> oldValues) {
        for (Location__c location : locations) {
            // check if the status changed in this transaction
            // also update Status_Update_Date__c
            if (location.Status__c != oldValues.get(location.Id).Status__c) {
                location.Status_Update_Date__c = Date.today();
            }
        }
    }

    // After update operation for Location__c object
    public static void afterUpdate(List<Location__c> locations, Map<Id, Location__c> oldValues) {
        // list of location with changed status
        Set<Id> statusChange = new Set<Id>();
        for (Location__c location : locations) {
            // check if the status changed in this transaction
            // also update Status_Update_Date__c
            if (location.Status__c == 'Red' && location.Status__c != oldValues.get(location.Id).Status__c) {
                statusChange.add(location.Id);
            }
        }
        // get location traces
        List<Location_Tracing__c> locationTraces = CTLocationTracingController.getLocationsByLocationIds(statusChange);
        // get people list
        List<Person__c> peopleToUpdate = new List<Person__c>();
        Set<Id> personIds = new Set<Id>();
        for (Location_Tracing__c trace : locationTraces) {
            personIds.add(trace.Person__c);
        }

        for (Id personId : personIds) {
            peopleToUpdate.add(new Person__c(Id = personId, Health_Status__c = 'Yellow'));
        }

        update peopleToUpdate;
    }
}
