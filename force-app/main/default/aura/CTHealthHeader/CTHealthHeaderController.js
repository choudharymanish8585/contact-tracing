({
    doInit: function (component, event, helper) {
        helper.fetchStatusCount(component);
    },

    fetchCount: function (component, event, helper) {
        //Method definition goes here
        helper.fetchStatusCount(component);
    },

    registerHandler: function (component, event, helper) {
        //Method definition goes here
        const createRecordEvent = $A.get("e.force:createRecord");
        const scope = component.get("v.scope");

        if (scope === "person") {
            createRecordEvent.setParams({
                entityApiName: "Person__c"
            });
        } else {
            createRecordEvent.setParams({
                entityApiName: "Location__c"
            });
        }
        createRecordEvent.fire();
    }
});
