/**
 * CTLocationTrigger
 * Trigger on Location__c object
 * @author Manish
 */
trigger CTLocationTrigger on Location__c(before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    // Invoke necessary code/class based on current operation type
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            // Update health status to green
            CTLocationTriggerHandler.beforeInsert(Trigger.new);
        }
        when BEFORE_UPDATE {
            // update health status update date
            CTLocationTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        when AFTER_UPDATE {
            // Mark all people *Yellow* -* *Except the Red and Orange ones*
            CTLocationTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
