@isTest
public with sharing class CTRecentChangesControllerTest {
    @TestSetup
    static void makeData() {
        List<Person__c> people = CTTestFactory.getPeople(150);
        List<Location__c> locations = CTTestFactory.getLocations(150);
    }

    @IsTest
    static void getRecentPersonHealthChangesTest() {
        Person__c person = [SELECT Id FROM Person__c WHERE Name = 'Test0' LIMIT 1];
        CTPersonViewController.updateHealthStatus(person.Id);
        Test.startTest();
        List<Person__c> people = CTRecentChangesController.getRecentPersonHealthChanges();
        Test.stopTest();
        System.assertEquals(100, people.size(), 'More than 100 records retirved');
        System.assertEquals('Test0', people[0].Name);
    }

    @IsTest
    static void getRecentLocationHealthChangesTest() {
        Location__c location = [SELECT Id FROM Location__c WHERE Name = 'Test0' LIMIT 1];
        Test.startTest();
        List<Location__c> locations = CTRecentChangesController.getRecentLocationHealthChanges();
        Test.stopTest();
        System.assertEquals(100, locations.size(), 'More than 100 records retirved');
    }

    @IsTest
    static void searchPeopleTest() {
        Test.startTest();
        List<Person__c> people1 = CTRecentChangesController.searchPeople('Test');
        List<Person__c> people2 = CTRecentChangesController.searchPeople('Test0');
        List<Person__c> people3 = CTRecentChangesController.searchPeople('99889988');
        Test.stopTest();
        System.assertEquals(100, people1.size());
        System.assertEquals(1, people2.size());
        System.assertEquals(100, people3.size());
    }

    @IsTest
    static void searchLocationsTest() {
        Test.startTest();
        List<Location__c> people1 = CTRecentChangesController.searchLocations('Test');
        List<Location__c> people2 = CTRecentChangesController.searchLocations('Test0');
        List<Location__c> people3 = CTRecentChangesController.searchLocations('1011');
        Test.stopTest();
        System.assertEquals(100, people1.size());
        System.assertEquals(1, people2.size());
        System.assertEquals(100, people3.size());
    }
}
