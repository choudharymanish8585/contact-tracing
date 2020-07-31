({
    doInit: function (component, event, helper) {
        const columns = [
            { label: "Token", fieldName: "token", type: "text" },
            { label: "Contact Status", fieldName: "status", type: "text" },
            { label: "Contact Date", fieldName: "contactDate", type: "date" }
        ];
        component.set("v.columns", columns);
    },

    userSearchHandler: function (component, event, helper) {
        //Method definition goes here
        helper.fetchUserInformation(component);
    }
});
