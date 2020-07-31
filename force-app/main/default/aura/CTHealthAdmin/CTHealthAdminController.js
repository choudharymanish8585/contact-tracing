({
    doInit: function (component, event, helper) {
        //Method definition goes here
        helper.setPersonTableColumn(component);
        helper.setlocationTableColumn(component);
    },

    tabSelectHandler: function (component, event, helper) {
        const tab = event.getParam("id");
        // set scope
        component.set("v.scope", tab);
        // set header title
        if (tab === "person") {
            component.set("v.headerTitle", "Person View");
        } else {
            component.set("v.headerTitle", "Location View");
        }

        // call fetch method in healthheader component
        const healthHeaderComp = component.find("health-header");
        healthHeaderComp.fetchCount();
    }
});
