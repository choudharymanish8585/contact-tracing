@isTest
public with sharing class CTHealthHeaderControllerTest {
    @TestSetup
    static void makeData() {
        List<Person__c> people = CTTestFactory.getPeople(new List<String>{ 'Aragorn', 'Gimli', 'Frodo', 'Samwise', 'Gandalf', 'Legolas', 'Merry' });
        List<Location__c> locations = CTTestFactory.getLocations(new List<String>{ 'Minas Tirith', 'Black Gate', 'Isengard', 'Bree', 'Helms Deep' });
    }

    @IsTest
    static void getPersonHealthStatusCountTest() {
        Test.startTest();
        Map<String, Integer> statusMap = CTHealthHeaderController.getPersonHealthStatusCount();
        Test.stopTest();
        System.assert(statusMap != null, 'Status map is null');
        System.assertEquals(7, statusMap.get('Green'), 'Incorrent Green health status count');
        System.assert(statusMap.get('Yellow') == null, 'Incorrent Yellow health status count');
        System.assert(statusMap.get('Orange') == null, 'Incorrent Orange health status count');
        System.assert(statusMap.get('Red') == null, 'Incorrent Red health status count');
    }

    @IsTest
    static void getLocationHealthStatusCountTest() {
        Test.startTest();
        Map<String, Integer> statusMap = CTHealthHeaderController.getLocationHealthStatusCount();
        Test.stopTest();
        System.assert(statusMap != null, 'Status map is null');
        System.assertEquals(5, statusMap.get('Green'), 'Incorrent Green health status count');
        System.assert(statusMap.get('Yellow') == null, 'Incorrent Yellow health status count');
        System.assert(statusMap.get('Orange') == null, 'Incorrent Orange health status count');
        System.assert(statusMap.get('Red') == null, 'Incorrent Red health status count');
    }
}
