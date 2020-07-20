/**
 * CTPeopleTracingController
 * Main controller of People_Tracing__c  object
 * @author Manish
 */
public with sharing class CTPeopleTracingController {
    /**
     * Check duplicate People Tracing records
     * for multiple combinations
     * @param token1 token of first user
     * @param token2 token of 2nd user
     * @return boolean
     */
    public static boolean isDuplicate(String token1, String token2) {
        List<People_Tracing__c> people = [
            SELECT Id
            FROM People_Tracing__c
            WHERE
                (Person_1__r.Token__c = :token1
                AND Person_2__r.Token__c = :token2)
                OR (Person_1__r.Token__c = :token2
                AND Person_2__r.Token__c = :token1)
        ];
        return people != null && people.size() > 0 ? true : false;
    }
}
