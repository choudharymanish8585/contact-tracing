@isTest
public with sharing class CTUserTabControllerTest {
    @TestSetup
    static void makeData() {
        List<Person__c> people = CTTestFactory.getPeople(new List<String>{ 'Aragorn', 'Gimli', 'Legolas', 'Frodo', 'Samwise', 'Gandalf', 'Merry' });
        // add location trace
        CTTestFactory.getPeopleTrace(people[0].Id, people[1].Id, 'Cohabitant');
        CTTestFactory.getPeopleTrace(people[0].Id, people[2].Id, 'Cohabitant');
        CTTestFactory.getPeopleTrace(people[0].Id, people[3].Id, 'Neighbour');
        CTTestFactory.getPeopleTrace(people[0].Id, people[4].Id, 'Other');
        CTTestFactory.getPeopleTrace(people[4].Id, people[6].Id, 'Other');
    }

    @IsTest
    static void getUserDetailsTest1() {
        Person__c person = [SELECT Id FROM Person__c WHERE Name = 'Aragorn' LIMIT 1];
        Test.startTest();
        CTUserTabController.UserInformation userInfo = CTUserTabController.getUserDetails(person.Id);
        Test.stopTest();
        System.assert(userInfo != null, 'User info is null');
        System.assertEquals('Aragorn', userInfo.name, 'User name does not match');
        System.assert(userInfo.contacts != null, 'No contacts found');
        System.assertEquals(4, userInfo.contactsCount, 'Number of contacts does not match');
    }

    @IsTest
    static void getUserDetailsTest2() {
        Person__c person = [SELECT Id FROM Person__c WHERE Name = 'Gandalf' LIMIT 1];
        Test.startTest();
        CTUserTabController.UserInformation userInfo = CTUserTabController.getUserDetails(person.Id);
        Test.stopTest();
        System.assert(userInfo != null, 'User info is null');
        System.assertEquals('Gandalf', userInfo.name, 'User name does not match');
        System.assert(userInfo.contacts == null);
        System.assertEquals(0, userInfo.contactsCount, 'Number of contacts does not match');
    }
}
