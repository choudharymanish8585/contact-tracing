/**
 * CTLocationTabController
 * Main controller of CTLocationTab Aura Component
 * @author Manish
 */
public with sharing class CTLocationTabController {
    @AuraEnabled
    public static LocationInformation getLocationDetails(String recordId) {
        LocationInformation info = new LocationInformation();

        Location__c location = CTLocationController.getLocationById(recordId);
        if (location != null) {
            info.name = location.Name;
            info.pincode = location.Pincode__c;
            info.statusUpdateOn = location.Status_Update_Date__c;
            info.redScore = Integer.valueOf(location.Red_Score__c);
            info.status = location.Status__c;
        }

        List<Location_Tracing__c> visitors = CTLocationTracingController.getVisitors(recordId);
        if (visitors != null && visitors.size() > 0) {
            List<CloseContact> contacts = new List<CloseContact>();
            for (Location_Tracing__c visitor : visitors) {
                CloseContact cc = new CloseContact();
                cc.visitDate = visitor.Visit_Date__c;
                cc.status = visitor.Person__r.Health_Status__c;
                cc.token = visitor.Person__r.Token__c;
                cc.id = visitor.Person__c;
                contacts.add(cc);
            }
            info.contacts = contacts;
            info.contactsCount = contacts.size();
        }
        return info;
    }

    public class LocationInformation {
        @AuraEnabled
        public String name;
        @AuraEnabled
        public Integer redScore;
        @AuraEnabled
        public Date statusUpdateOn;
        @AuraEnabled
        public String pincode;
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
        public Date visitDate;
        @AuraEnabled
        public String status;
    }
}
