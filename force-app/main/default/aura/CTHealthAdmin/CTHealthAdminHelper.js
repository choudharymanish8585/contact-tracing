({
    setPersonTableColumn: function (component, event, helper) {
        //Method definition goes here
        const columns = [
            { label: "Name", fieldName: "Name", type: "text" },
            { label: "Phone", fieldName: "Mobile__c", type: "phone" },
            { label: "Token", fieldName: "Token__c", type: "text" },
            { label: "Status", fieldName: "Health_Status__c", type: "text" },
            {
                label: "Status Update Date",
                fieldName: "Status_Update_Date__c",
                type: "date"
            },
            {
                label: "View",
                type: "button",
                initialWidth: 135,
                typeAttributes: {
                    label: "View/Update",
                    name: "view_details",
                    title: "Click to View Details"
                }
            }
        ];
        component.set("v.personTableColumn", columns);
    },

    setlocationTableColumn: function (component, event, helper) {
        //Method definition goes here
        const columns = [
            { label: "Name", fieldName: "Name", type: "text" },
            { label: "Status", fieldName: "Status__c", type: "text" },
            { label: "Red Score", fieldName: "Red_Score__c", type: "number" },
            { label: "Pincode", fieldName: "Pincode__c", type: "text" },
            { label: "Address", fieldName: "Address__c", type: "text" },
            {
                label: "Status Update Date",
                fieldName: "Status_Update_Date__c",
                type: "date"
            },
            {
                label: "View",
                type: "button",
                initialWidth: 135,
                typeAttributes: {
                    label: "View/Update",
                    name: "view_details",
                    title: "Click to View Details"
                }
            }
        ];
        component.set("v.locationTableColumn", columns);
    }
});
