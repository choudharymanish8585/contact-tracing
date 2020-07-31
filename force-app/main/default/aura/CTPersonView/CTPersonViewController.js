({
    personSelect: function (component, event, helper) {
        const recordId = event.getParam("recordId");
        const status = event.getParam("status");
        component.set("v.recordId", recordId);
        component.set("v.status", status);
    },

    updateStatus: function (component, event, helper) {
        //Method definition goes here
        helper.updateStatus(component);
    }
});
