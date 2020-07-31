/**
 * CTPeopleTracingTriggerHandler
 * Handler class for People_Tracing__c Trigger
 * @author Manish
 */
public with sharing class CTPeopleTracingTriggerHandler {
    // Before insert operation for People_Tracing__c object
    // check duplicates and make decision
    public static void beforeInsert(List<People_Tracing__c> newRecords) {
        // unique records ids
        Set<Id> recordIds = new Set<Id>();
        for (People_Tracing__c trace : newRecords) {
            recordIds.add(trace.Person_1__c);
            recordIds.add(trace.Person_2__c);
        }

        // Check for duplicates
        List<People_Tracing__c> duplicates = CTPeopleTracingController.checkDuplicates(newRecords, recordIds);

        // Add error on duplicates
        for (People_Tracing__c trace : duplicates) {
            trace.addError('Duplicate record found. Person 1:' + trace.Person_1__c + ' Person 2:' + trace.Person_2__c);
        }
    }
}
