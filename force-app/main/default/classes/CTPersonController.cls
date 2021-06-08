/**
 * CTPersonController
 * Main controller of Person__c object
 * @author Manish
 */
public with sharing class CTPersonController {
    /**
     * generate unique token using mobile number
     * use MD5 algorithm to generate one-way hash
     * @param mobile
     * @return string token
     */
    public static String getToken(String mobile) {
        // generate unique hash using md5 algorithm
        Blob value = Blob.valueOf(mobile);
        Blob hash = Crypto.generateDigest('MD5', value);
        // return encoded string
        return EncodingUtil.base64Encode(hash);
    }

    /**
     * Get 100 contacts with recent health status change
     * @return List<Person__c>
     */
    public static List<Person__c> getRecentHealthChanges() {
        return [SELECT Id, Name, Mobile__c, Token__c, Health_Status__c, Status_Update_Date__c FROM Person__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
    }

    /**
     * Search a person by name, token or mobile
     * @return List<Person__c>
     */
    public static List<Person__c> searchPeople(String searchTerm) {
        String likeTerm = searchTerm + '%';
        return [
            SELECT Id, Name, Mobile__c, Token__c, Health_Status__c, Status_Update_Date__c
            FROM Person__c
            WHERE Name LIKE :likeTerm OR Mobile__c LIKE :likeTerm OR Token__c LIKE :likeTerm
            ORDER BY Status_Update_Date__c DESC NULLS LAST
            LIMIT 100
        ];
    }

    /**
     * Search a person by id
     * @return Person__c
     */
    public static Person__c getPersonById(String personId) {
        List<Person__c> people = [SELECT Id, Name, Mobile__c, Token__c, Health_Status__c, Status_Update_Date__c FROM Person__c WHERE Id = :personId ORDER BY Status_Update_Date__c DESC NULLS LAST];
        if (people != null && people.size() > 0) {
            return people[0];
        }
        return null;
    }

    /**
     * Get count of people in each health status
     * @return Map<String, Integer>
     */
    @AuraEnabled
    public static Map<String, Integer> getHealthStatusCount() {
        AggregateResult[] healthStatusCount = [SELECT Health_Status__c, COUNT(Id) total FROM Person__c GROUP BY Health_Status__c];

        if (healthStatusCount != null && healthStatusCount.size() > 0) {
            Map<String, Integer> healthCountMap = new Map<String, Integer>();
            for (AggregateResult ar : healthStatusCount) {
                String status = String.valueOf(ar.get('Health_Status__c'));
                Integer count = Integer.valueOf(ar.get('total'));
                healthCountMap.put(status, count);
            }
            return healthCountMap;
        }
        return null;
    }

    /**
     * Get list of all cohabitants
     * Only include people in "Green" and "Yellow" health status
     * @param positivePeople
     * @return people
     */
    public static Set<Id> getCohabitants(Set<Id> positivePeople, Set<Id> idsToIgnore) {
        // list of all status to find
        List<String> healthStatuses = new List<String>{ 'Yellow', 'Green' };
        List<People_Tracing__c> peopleTraces = [
            SELECT Person_1__c, Person_2__c
            FROM People_Tracing__c
            WHERE
                (Person_1__c IN :positivePeople
                OR Person_2__c IN :positivePeople)
                AND Contact_Type__c = 'Cohabitant'
                AND (Person_1__r.Health_Status__c IN :healthStatuses
                OR Person_2__r.Health_Status__c IN :healthStatuses)
        ];

        // Ids of all cohabitants
        Set<Id> cohabitants = new Set<Id>();
        for (People_Tracing__c pt : peopleTraces) {
            // if both person 1 and person 2 already exist in positive people list, do nothing
            // else add the person to cohabitants
            if (!idsToIgnore.contains(pt.Person_1__c)) {
                // add person 1
                cohabitants.add(pt.Person_1__c);
                idsToIgnore.add(pt.Person_1__c);
            } else if (idsToIgnore.contains(pt.Person_1__c)) {
                // add person 2
                cohabitants.add(pt.Person_2__c);
                idsToIgnore.add(pt.Person_2__c);
            }
        }
        return cohabitants;
    }

    /**
     * Get list of all neighbours
     * Only include people in Green status
     * @param positivePeople
     * @return people
     */
    public static Set<Id> getNeighbours(Set<Id> positivePeople, Set<Id> idsToIgnore) {
        List<People_Tracing__c> peopleTraces = [
            SELECT Person_1__c, Person_2__c
            FROM People_Tracing__c
            WHERE
                (Person_1__c IN :positivePeople
                OR Person_2__c IN :positivePeople)
                AND Contact_Type__c = 'Neighbour'
                AND (Person_1__r.Health_Status__c = 'Green'
                OR Person_2__r.Health_Status__c = 'Green')
        ];

        // Ids of all neighbours
        Set<Id> neighbours = new Set<Id>();
        for (People_Tracing__c pt : peopleTraces) {
            // if both person 1 and person 2 already exist in positive people list, do nothing
            // else add the person to neighbours
            if (!idsToIgnore.contains(pt.Person_1__c)) {
                // add person 1
                neighbours.add(pt.Person_1__c);
                idsToIgnore.add(pt.Person_1__c);
            } else if (idsToIgnore.contains(pt.Person_1__c)) {
                // add person 2
                neighbours.add(pt.Person_2__c);
                idsToIgnore.add(pt.Person_2__c);
            }
        }
        return neighbours;
    }

    /**
     * Get list of primary contacts
     * Only include people in "Green" and "Yellow" health status
     * @param positivePeople
     * @return people
     */
    public static Set<Id> getPrimaryContacts(Set<Id> positivePeople, Set<Id> idsToIgnore) {
        // list of all status to find
        List<String> healthStatuses = new List<String>{ 'Yellow', 'Green' };
        List<People_Tracing__c> peopleTraces = [
            SELECT Person_1__c, Person_2__c
            FROM People_Tracing__c
            WHERE
                (Person_1__c IN :positivePeople
                OR Person_2__c IN :positivePeople)
                AND Contact_Type__c = 'Other'
                AND Contact_Date__c = LAST_N_DAYS:10
                AND (Person_1__r.Health_Status__c IN :healthStatuses
                OR Person_2__r.Health_Status__c IN :healthStatuses)
        ];

        // Ids of all primary contacts
        Set<Id> primaryContacts = new Set<Id>();
        for (People_Tracing__c pt : peopleTraces) {
            // if both person 1 and person 2 already exist in already processed list, do nothing
            // else add the person to primary contacts set
            if (!idsToIgnore.contains(pt.Person_1__c)) {
                // add person 1
                primaryContacts.add(pt.Person_1__c);
                idsToIgnore.add(pt.Person_1__c);
            } else if (idsToIgnore.contains(pt.Person_1__c)) {
                // add person 2
                primaryContacts.add(pt.Person_2__c);
                idsToIgnore.add(pt.Person_2__c);
            }
        }
        return primaryContacts;
    }

    /**
     * Get list of all secondary contacts
     * Only include people in Green status
     * @param primaryContacts
     * @return people
     */
    public static Set<Id> getSecondaryContacts(Set<Id> primaryContacts, Set<Id> idsToIgnore) {
        List<People_Tracing__c> peopleTraces = [
            SELECT Person_1__c, Person_2__c
            FROM People_Tracing__c
            WHERE
                (Person_1__c IN :primaryContacts
                OR Person_2__c IN :primaryContacts)
                AND Contact_Type__c = 'Other'
                AND Contact_Date__c = LAST_N_DAYS:10
                AND (Person_1__r.Health_Status__c = 'Green'
                OR Person_2__r.Health_Status__c = 'Green')
        ];

        // Ids of all secondary contacts
        Set<Id> secondaryContacts = new Set<Id>();
        for (People_Tracing__c pt : peopleTraces) {
            // if both person 1 and person 2 already exist in already processed list, do nothing
            // else add the person to secondary contacts set
            if (!idsToIgnore.contains(pt.Person_1__c)) {
                // add person 1
                secondaryContacts.add(pt.Person_1__c);
                idsToIgnore.add(pt.Person_1__c);
            } else if (idsToIgnore.contains(pt.Person_1__c)) {
                // add person 2
                secondaryContacts.add(pt.Person_2__c);
                idsToIgnore.add(pt.Person_2__c);
            }
        }
        return secondaryContacts;
    }
}
