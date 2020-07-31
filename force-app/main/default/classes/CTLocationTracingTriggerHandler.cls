/**
 * CTLocationTracingTriggerHandler
 * Handler class for Location_Tracing__c Trigger
 * @author Manish
 */
public with sharing class CTLocationTracingTriggerHandler {
    // Before insert operation for Location_Tracing__c object
    // populate contact data and check duplicates
    public static void beforeInsert(List<Location_Tracing__c> newRecords) {
        // check duplicates and make decision
        List<Location_Tracing__c> duplicates = CTLocationTracingController.checkDuplicates(newRecords);

        // Add error on duplicates
        for (Location_Tracing__c trace : duplicates) {
            trace.addError('Duplicate record found. Location:' + trace.Location__c + ' Person:' + trace.Person__c);
        }
    }
}
