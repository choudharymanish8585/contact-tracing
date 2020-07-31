/**
 * PersonTrigger
 * Trigger on Person__c object
 * @author Manish
 */
trigger CTPersonTrigger on Person__c(before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    // Invoke necessary code/class based on current operation type
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            // generate unique token for person
            CTPersonTriggerHandler.beforeInsert(Trigger.new);
        }
        when BEFORE_UPDATE {
            // update health status update date
            CTPersonTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        when AFTER_UPDATE {
            // Mark all “Cohabitants” *Orange* -* *Except the Red and Orange ones*
            // Mark all “Neighbours” *Yellow* -* *Except the Red, Orange and Yellow ones*
            // Mark all people *Orange* who they come in contact with in last 10 days - [let’s call these contacts primary contacts] -* *Except the Red and Orange ones*
            // Mark all people *Yellow* who made a contact with primary contacts in last 10 days - [let’s call these contacts secondary contacts] - * *Except the Red and Orange ones*
            // Update the *Red Score* and *Status* of all the locations they visited in last 10 days
            CTPersonTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
