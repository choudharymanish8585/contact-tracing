@isTest
public with sharing class CTLocationTabControllerTest {
    @TestSetup
    static void makeData() {
        List<Person__c> people = CTTestFactory.getPeople(new List<String>{ 'Aragorn', 'Gimli', 'Frodo', 'Samwise', 'Gandalf', 'Legolas', 'Merry' });
        List<Location__c> locations = CTTestFactory.getLocations(new List<String>{ 'Minas Tirith', 'Black Gate', 'Isengard', 'Bree', 'Helms Deep' });
        // add location trace
        CTTestFactory.getLocationTrace(people[0].Id, locations[0].Id);
        CTTestFactory.getLocationTrace(people[2].Id, locations[0].Id);
        CTTestFactory.getLocationTrace(people[3].Id, locations[0].Id);
        CTTestFactory.getLocationTrace(people[0].Id, locations[1].Id);
    }

    @IsTest
    static void getLocationDetailsTest1() {
        Location__c location = [SELECT Id FROM Location__c WHERE Name = 'Minas Tirith' LIMIT 1];
        Test.startTest();
        CTLocationTabController.LocationInformation locInfo = CTLocationTabController.getLocationDetails(location.Id);
        Test.stopTest();
        System.assert(locInfo != null, 'Location info is null');
        System.assertEquals('Minas Tirith', locInfo.name, 'Location name does not match');
        System.assert(locInfo.contacts != null, 'No visitors found');
        System.assertEquals(3, locInfo.contactsCount, 'Number of visitor does not match');
    }

    @IsTest
    static void getLocationDetailsTest2() {
        Location__c location = [SELECT Id FROM Location__c WHERE Name = 'Isengard' LIMIT 1];
        Test.startTest();
        CTLocationTabController.LocationInformation locInfo = CTLocationTabController.getLocationDetails(location.Id);
        Test.stopTest();
        System.assert(locInfo != null, 'Location info is null');
        System.assertEquals('Isengard', locInfo.name, 'Location name does not match');
        System.assert(locInfo.contacts == null);
        System.assertEquals(0, locInfo.contactsCount, 'Number of visitor does not match');
    }
}
