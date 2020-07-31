/**
 * PeopleTracingTrigger
 * Trigger on People_Tracing__c object
 * @author Manish
 */
trigger CTPeopleTracingTrigger on People_Tracing__c(before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    // Invoke necessary code/class based on current operation type
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            // check duplicates and make decision
            CTPeopleTracingTriggerHandler.beforeInsert(Trigger.new);
        }
    }
}
