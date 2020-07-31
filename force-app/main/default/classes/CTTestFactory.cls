public with sharing class CTTestFactory {
    public static List<Person__c> getPeople(List<String> names) {
        List<Person__c> testRecords = new List<Person__c>();
        Integer i = 0;
        for (String name : names) {
            testRecords.add(new Person__c(Name = name, Mobile__c = '99889988' + i));
            i++;
        }
        insert testRecords;
        return testRecords;
    }

    public static People_Tracing__c getPeopleTrace(Id person1, Id person2, String type) {
        People_Tracing__c testRecord = new People_Tracing__c(Person_1__c = person1, Person_2__c = person2, Contact_Type__c = type, Contact_Date__c = Date.today());
        insert testRecord;
        return testRecord;
    }

    public static List<Location__c> getLocations(List<String> names) {
        List<Location__c> testRecords = new List<Location__c>();
        Integer i = 0;
        for (String name : names) {
            testRecords.add(new Location__c(Name = name, Pincode__c = '1011' + i, Address__c = '5th Avenue bld #' + i));
        }
        insert testRecords;
        return testRecords;
    }

    public static Location_Tracing__c getLocationTrace(Id person, Id location) {
        Location_Tracing__c testRecord = new Location_Tracing__c(Person__c = person, Location__c = location, Visit_Date__c = Date.today());
        insert testRecord;
        return testRecord;
    }

    public static List<Person__c> getPeople(Integer numberOfRecords) {
        List<Person__c> testRecords = new List<Person__c>();

        for (Integer i = 0; i < numberOfRecords; i++) {
            testRecords.add(new Person__c(Name = 'Test' + i, Mobile__c = '99889988' + i));
        }
        insert testRecords;
        return testRecords;
    }

    public static List<Location__c> getLocations(Integer numberOfRecords) {
        List<Location__c> testRecords = new List<Location__c>();

        for (Integer i = 0; i < numberOfRecords; i++) {
            testRecords.add(new Location__c(Name = 'Test' + i, Pincode__c = '1011' + i, Address__c = '5th Avenue bld #' + i));
        }
        insert testRecords;
        return testRecords;
    }
}
