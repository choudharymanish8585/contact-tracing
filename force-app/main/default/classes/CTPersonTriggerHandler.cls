/**
 * PersonTriggerHandler
 * Handler class for Person__c Trigger
 * @author Manish
 */
public with sharing class CTPersonTriggerHandler {
    // Before insert operation for Person__c object
    // make sure the health status is green
    // generate unique token for each record
    public static void beforeInsert(List<Person__c> newRecords) {
        for (Person__c person : newRecords) {
            // update person status to Green
            person.Health_Status__c = 'Green';
            // generate unique token
            person.Token__c = CTPersonController.getToken(person.Mobile__c);
        }
    }

    // Before update operation for Person__c object
    public static void beforeUpdate(List<Person__c> people, Map<Id, Person__c> oldValues) {
        for (Person__c person : people) {
            // check if the status changed in this transaction
            // also update Status_Update_Date__c
            if (person.Health_Status__c != oldValues.get(person.Id).Health_Status__c) {
                person.Status_Update_Date__c = Date.today();
            }
        }
    }

    // After update operation for Person__c object
    public static void afterUpdate(List<Person__c> people, Map<Id, Person__c> oldValues) {
        // person record to update
        List<Person__c> personRecordToUpdate = new List<Person__c>();
        // list of people with changed status
        Set<Id> statusChange = new Set<Id>();
        // list of people having red status
        Set<Id> redStatus = new Set<Id>();

        for (Person__c person : people) {
            // check if the status changed in this transaction
            if (person.Health_Status__c != oldValues.get(person.Id).Health_Status__c) {
                statusChange.add(person.Id);
            }
            // check if person health status is red
            // also check if the status changed in this transaction to avoid duplicate processing
            if (person.Health_Status__c == 'Red' && oldValues.get(person.Id).Health_Status__c != 'Red') {
                redStatus.add(person.Id);
            }
        }

        // Id of people to avoid duplicate processing
        Set<Id> processedRecords = new Set<Id>();
        processedRecords.addAll(redStatus);
        // list of people to update the status to Orange
        Set<Id> orangeStatus = new Set<Id>();
        // list of people to update the status to Yellow
        Set<Id> yellowStatus = new Set<Id>();

        // STEP 1 - GET ALL COHABITANTS TO MARK AS ORANGE - IGNORE ALREADY PROCESSSED RECORDS
        orangeStatus.addAll(CTPersonController.getCohabitants(redStatus, processedRecords));
        // STEP 2 - GET ALL PRIMARY CONTACTS TO MARK AS ORANGE - IGNORE ALREADY PROCESSSED RECORDS
        Set<Id> primaryContacts = CTPersonController.getPrimaryContacts(redStatus, processedRecords);
        orangeStatus.addAll(primaryContacts);
        // STEP 3 - GET ALL NEIGHBOURS TO MARK AS YELLOW - IGNORE ALREADY PROCESSSED RECORDS
        yellowStatus.addAll(CTPersonController.getNeighbours(redStatus, processedRecords));
        // STEP 4 - GET ALL SECONDARY CONTACTS TO MARK AS YELLOW - IGNORE ALREADY PROCESSSED RECORDS
        yellowStatus.addAll(CTPersonController.getSecondaryContacts(primaryContacts, processedRecords));

        // BUILD PERSON RECORDS FOR ORANGE STATUS
        for (Id personId : orangeStatus) {
            personRecordToUpdate.add(new Person__c(Id = personId, Health_Status__c = 'Orange'));
        }
        // BUILD PERSON RECORDS FOR YELLOW STATUS
        for (Id personId : yellowStatus) {
            personRecordToUpdate.add(new Person__c(Id = personId, Health_Status__c = 'Yellow'));
        }

        // STEP 5 - UPDATE RED SCORE OF LOCATIONS
        List<Location_Tracing__c> locations = CTLocationTracingController.getLocationsByPersonIds(statusChange);
        if (locations != null && locations.size() > 0) {
            Set<Id> locationIds = new Set<Id>();
            for (Location_Tracing__c trace : locations) {
                locationIds.add(trace.Location__c);
            }
            CTLocationController.updateRedScore(locationIds);
        }

        // update all records
        if (personRecordToUpdate.size() > 0) {
            update personRecordToUpdate;
        }
    }
}
