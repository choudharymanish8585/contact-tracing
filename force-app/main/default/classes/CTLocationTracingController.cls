/**
 * CTLocationTracingController
 * Main controller of Location_Tracing__c object
 * @author Manish
 */
public with sharing class CTLocationTracingController {
    /**
     * Check duplicate Location Tracing records
     * NOTE: THIS METHOD IS NOT OPTIMIZED FOR BULK OPERATIONS
     * @param locationId location id
     * @param token token of visitor
     * @return boolean
     */
    /*public static boolean isDuplicate(String locationId, String token) {
        List<Location_Tracing__c> people = [
            SELECT Id
            FROM Location_Tracing__c
            WHERE Location__c = :locationId AND Person__r.Token__c = :token
        ];
        return people != null && people.size() > 0 ? true : false;
    }*/

    /**
     * Check duplicate Location Tracing records
     * for multiple combinations
     * NOTE: THIS METHOD IS OPTIMIZED FOR BULK OPERATIONS
     * @param token1 token of first user
     * @param token2 token of 2nd user
     * @return boolean
     */
    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> locationTraces) {
        //list of duplicate records
        List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();
        // map of existing records to match
        Map<Id, Set<Id>> mapOfExistingRecord = new Map<Id, Set<Id>>();
        // set of location id
        Set<Id> locationIds = new Set<Id>();
        // set of person ids
        Set<Id> personIds = new Set<Id>();
        for (Location_Tracing__c trace : locationTraces) {
            locationIds.add(trace.Location__c);
            personIds.add(trace.Person__c);
        }
        //get existing records with for same location and person
        List<Location_Tracing__c> existingRecords = [SELECT Id, Location__c, Person__c FROM Location_Tracing__c WHERE Person__c IN :personIds OR Location__c IN :locationIds];

        if (existingRecords != null && existingRecords.size() > 0) {
            for (Location_Tracing__c trace : existingRecords) {
                // build map for person 1
                if (!mapOfExistingRecord.containsKey(trace.Location__c)) {
                    mapOfExistingRecord.put(trace.Location__c, new Set<Id>());
                }
                mapOfExistingRecord.get(trace.Location__c).add(trace.Person__c);
            }

            // loop over all the records to find duplicate
            for (Location_Tracing__c trace : locationTraces) {
                // check if record is duplicate
                if ((mapOfExistingRecord.containsKey(trace.Location__c) && mapOfExistingRecord.get(trace.Location__c).contains(trace.Person__c))) {
                    duplicates.add(trace);
                }
            }
        }
        return duplicates;
    }

    /**
     * Get last 30 days visitors
     * @param locationId
     * @return List<Location_Tracing__c>
     */
    public static List<Location_Tracing__c> getVisitors(String locationId) {
        return [
            SELECT Id, Visit_Date__c, Location__c, Person__c, Person__r.Token__c, Person__r.Health_Status__c
            FROM Location_Tracing__c
            WHERE Location__c = :locationId
            ORDER BY Visit_Date__c DESC NULLS LAST
        ];
    }

    /**
     * Get all location ids for visitors
     * @param personIds
     * @return List<Location_Tracing__c>
     */
    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds) {
        return [SELECT Id, Location__c, Person__c FROM Location_Tracing__c WHERE Person__c IN :personIds AND Visit_Date__c = LAST_N_DAYS:10];
    }

    /**
     * Get all visitor ids for locations
     * @param locationIds
     * @return List<Location_Tracing__c>
     */
    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds) {
        return [SELECT Id, Location__c, Person__c FROM Location_Tracing__c WHERE Location__c IN :locationIds AND Person__r.Health_Status__c = 'Green' AND Visit_Date__c = LAST_N_DAYS:10];
    }
}
