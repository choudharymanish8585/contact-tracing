({
    fetchRecentHealthChanges: function (component) {
        const scope = component.get("v.scope");
        let action;
        if (scope === "person") {
            action = component.get("c.getRecentPersonHealthChanges");
        } else {
            action = component.get("c.getRecentLocationHealthChanges");
        }

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                const data = response.getReturnValue();
                component.set("v.data", data);
                component.set("v.recentChanges", data);
            }
        });
        $A.enqueueAction(action);
    },

    searchItem: function (component, queryTerm) {
        //Method definition goes here
        const scope = component.get("v.scope");
        let action;
        if (scope === "person") {
            action = component.get("c.searchPeople");
        } else {
            action = component.get("c.searchLocations");
        }
        action.setParams({
            searchTerm: queryTerm
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                const data = response.getReturnValue();
                if (data && data.length) {
                    component.set("v.data", data);
                }
            }
            component.set("v.issearching", false);
        });
        $A.enqueueAction(action);
    },

    firePersonSelectEvent: function (recordId, status) {
        //Method definition goes here
        const appEvent = $A.get("e.c:PersonSelectEvent");
        appEvent.setParams({
            recordId,
            status
        });
        appEvent.fire();
    },

    fireLocationSelectEvent: function (recordId, status) {
        //Method definition goes here
        const appEvent = $A.get("e.c:LocationSelectEvent");
        appEvent.setParams({
            recordId,
            status
        });
        appEvent.fire();
    }
});
