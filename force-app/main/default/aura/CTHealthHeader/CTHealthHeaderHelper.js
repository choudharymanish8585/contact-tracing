({
    fetchStatusCount: function (component) {
        const scope = component.get("v.scope");
        let action;
        if (scope === "person") {
            action = component.get("c.getPersonHealthStatusCount");
        } else {
            action = component.get("c.getLocationHealthStatusCount");
        }

        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const count = response.getReturnValue();
                component.set("v.count", count);
            }
        });
        $A.enqueueAction(action);
    }
});
