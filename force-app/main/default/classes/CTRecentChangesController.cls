/**
 * CTRecentChangesController
 * Main controller of CTRecentChanges Aura Component
 * @author Manish
 */
public with sharing class CTRecentChangesController {
    @AuraEnabled
    public static List<Person__c> getRecentPersonHealthChanges() {
        return CTPersonController.getRecentHealthChanges();
    }

    @AuraEnabled
    public static List<Location__c> getRecentLocationHealthChanges() {
        return CTLocationController.getRecentStatusChanges();
    }

    @AuraEnabled
    public static List<Person__c> searchPeople(String searchTerm) {
        searchTerm = String.escapeSingleQuotes(searchTerm);
        return CTPersonController.searchPeople(searchTerm);
    }

    @AuraEnabled
    public static List<Location__c> searchLocations(String searchTerm) {
        searchTerm = String.escapeSingleQuotes(searchTerm);
        return CTLocationController.searchLocations(searchTerm);
    }
}
