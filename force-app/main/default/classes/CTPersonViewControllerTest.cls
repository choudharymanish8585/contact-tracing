@isTest
public with sharing class CTPersonViewControllerTest {
    @TestSetup
    static void makeData() {
        List<Person__c> people = CTTestFactory.getPeople(new List<String>{ 'Aragorn', 'Gimli', 'Legolas', 'Frodo', 'Samwise', 'Gandalf', 'Merry' });
        List<Location__c> locations = CTTestFactory.getLocations(new List<String>{ 'Minas Tirith', 'Black Gate', 'Isengard', 'Bree', 'Helms Deep' });
        // add location trace
        CTTestFactory.getLocationTrace(people[0].Id, locations[0].Id);
        CTTestFactory.getLocationTrace(people[2].Id, locations[0].Id);
        CTTestFactory.getLocationTrace(people[3].Id, locations[0].Id);
        CTTestFactory.getLocationTrace(people[0].Id, locations[1].Id);
        // add location trace
        CTTestFactory.getPeopleTrace(people[0].Id, people[1].Id, 'Cohabitant');
        CTTestFactory.getPeopleTrace(people[0].Id, people[2].Id, 'Cohabitant');
        CTTestFactory.getPeopleTrace(people[0].Id, people[3].Id, 'Neighbour');
        CTTestFactory.getPeopleTrace(people[0].Id, people[4].Id, 'Other');
        CTTestFactory.getPeopleTrace(people[4].Id, people[6].Id, 'Other');
    }

    @IsTest
    static void updateHealthStatusTest1() {
        Person__c person = [SELECT Id FROM Person__c WHERE Name = 'Aragorn' LIMIT 1];
        Test.startTest();
        CTPersonViewController.updateHealthStatus(person.Id);
        Test.stopTest();
        Map<String, Integer> statusMapPeople = CTHealthHeaderController.getPersonHealthStatusCount();
        System.assert(statusMapPeople != null);
        System.assertEquals(1, statusMapPeople.get('Red'));
        System.assertEquals(3, statusMapPeople.get('Orange'));
        System.assertEquals(2, statusMapPeople.get('Yellow'));
        System.assertEquals(1, statusMapPeople.get('Green'));

        Map<String, Integer> statusMapLocations = CTHealthHeaderController.getLocationHealthStatusCount();
        System.assert(statusMapLocations != null);
        System.assert(statusMapLocations.get('Red') == null);
        System.assert(statusMapLocations.get('Orange') == null);
        System.assertEquals(2, statusMapLocations.get('Yellow'));
        System.assertEquals(3, statusMapLocations.get('Green'));
    }

    @IsTest
    static void updateHealthStatusTest2() {
        Location__c location = [SELECT Id FROM Location__c WHERE Name = 'Minas Tirith' LIMIT 1];
        location.Status__c = 'Red';
        Test.startTest();
        update location;
        Test.stopTest();
        location = [SELECT Id, Status__c FROM Location__c WHERE Name = 'Minas Tirith' LIMIT 1];
        System.assertEquals('Red', location.Status__c);
    }
}
