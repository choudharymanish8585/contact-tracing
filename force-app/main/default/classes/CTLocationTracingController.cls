/**
 * CTLocationTracingController
 * Main controller of Location_Tracing__c object
 * @author Manish
 */
public with sharing class CTLocationTracingController {
    /**
     * Check duplicate Location Tracing records
     * @param locationId location id
     * @param token token of visitor
     * @return boolean
     */
    public static boolean isDuplicate(String locationId, String token) {
        List<Location_Tracing__c> people = [
            SELECT Id
            FROM Location_Tracing__c
            WHERE Location__c = :locationId AND Person__r.Token__c = :token
        ];
        return people != null && people.size() > 0 ? true : false;
    }
}
