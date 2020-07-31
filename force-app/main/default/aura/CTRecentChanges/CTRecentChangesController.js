({
    doInit: function (component, event, helper) {
        //fetch 100 recent helth changes
        helper.fetchRecentHealthChanges(component);
    },

    handleRowAction: function (component, event, helper) {
        const action = event.getParam("action");
        const row = event.getParam("row");
        const scope = component.get("v.scope");

        switch (action.name) {
            case "view_details":
                if (scope === "person") {
                    helper.firePersonSelectEvent(row.Id, row.Health_Status__c);
                } else {
                    helper.fireLocationSelectEvent(row.Id, row.Status__c);
                }
                break;
        }
    },

    searchHandler: function (component, event, helper) {
        //Method definition goes here
        const isEnterKey = event.keyCode === 13;
        const queryTerm = component.find("enter-search").get("v.value");
        if (!queryTerm) {
            component.set("v.data", component.get("v.recentChanges"));
        }
        if (isEnterKey) {
            component.set("v.issearching", true);
            helper.searchItem(component, queryTerm);
        }
    }
});
