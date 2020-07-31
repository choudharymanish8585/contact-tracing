/**
 * CTUserTabController
 * Main controller of CTUserTab Aura Component
 * @author Manish
 */
public with sharing class CTUserTabController {
    @AuraEnabled
    public static UserInformation getUserDetails(String recordId) {
        UserInformation info = new UserInformation();

        Person__c person = CTPersonController.getPersonById(recordId);
        if (person != null) {
            info.name = person.Name;
            info.token = person.Token__c;
            info.statusUpdateOn = person.Status_Update_Date__c;
            info.phone = person.Mobile__c;
            info.status = person.Health_Status__c;
        }

        List<People_Tracing__c> traces = CTPeopleTracingController.getTraces(recordId);
        if (traces != null && traces.size() > 0) {
            List<CloseContact> contacts = new List<CloseContact>();
            Set<String> uniqueIds = new Set<String>();
            uniqueIds.add(recordId);

            for (People_Tracing__c trace : traces) {
                if (!uniqueIds.contains(trace.Person_1__c)) {
                    CloseContact cc = new CloseContact();
                    cc.contactDate = trace.Contact_Date__c;
                    cc.status = trace.Person_1__r.Health_Status__c;
                    cc.token = trace.Person_1__r.Token__c;
                    cc.id = trace.Person_1__c;
                    contacts.add(cc);
                    uniqueIds.add(trace.Person_1__c);
                }
                if (!uniqueIds.contains(trace.Person_2__c)) {
                    CloseContact cc = new CloseContact();
                    cc.contactDate = trace.Contact_Date__c;
                    cc.status = trace.Person_2__r.Health_Status__c;
                    cc.token = trace.Person_2__r.Token__c;
                    cc.id = trace.Person_2__c;
                    contacts.add(cc);
                    uniqueIds.add(trace.Person_2__c);
                }
            }
            info.contacts = contacts;
            info.contactsCount = contacts.size();
        }
        return info;
    }

    public class UserInformation {
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String token;
        @AuraEnabled
        public Date statusUpdateOn;
        @AuraEnabled
        public String phone;
        @AuraEnabled
        public String status;
        @AuraEnabled
        public Integer contactsCount = 0;
        @AuraEnabled
        public List<CloseContact> contacts;
    }

    public class CloseContact {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String token;
        @AuraEnabled
        public Date contactDate;
        @AuraEnabled
        public String status;
    }
}
