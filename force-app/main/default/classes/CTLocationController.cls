/**
 * CTLocationController
 * Main controller of Location__c object
 * @author Manish
 */
public with sharing class CTLocationController {
    /**
     * Update redScore of locations
     * Red score is updated based on the number of
     * red health status person visited the location
     * @param locationIds
     * @return locations
     */
    public static List<Location__c> updateRedScore(Set<Id> locationIds) {
        // location record to update
        List<Location__c> locationRecordToUpdate = new List<Location__c>();
        AggregateResult[] redPeoplePerLocation = [
            SELECT Location__c, Count(Id) total
            FROM Location_Tracing__c
            WHERE Person__r.Health_Status__c = 'Red' AND Location__c IN :locationIds AND Visit_Date__c = LAST_N_DAYS:10
            GROUP BY Location__c
        ];
        for (AggregateResult ar : redPeoplePerLocation) {
            String locationId = String.valueOf(ar.get('Location__c'));
            Integer redScore = Integer.valueOf(ar.get('total'));
            String status = CTLocationController.getStatus(redScore);
            locationRecordToUpdate.add(new Location__c(Id = locationId, Red_Score__c = redScore, Status__c = status));
        }
        // update all lcoations
        if (locationRecordToUpdate.size() > 0) {
            update locationRecordToUpdate;
        }
        return locationRecordToUpdate;
    }

    /**
     * Get 100 location with recent status change
     * @return List<Location__c>
     */
    @AuraEnabled
    public static List<Location__c> getRecentStatusChanges() {
        return [SELECT Id, Name, Status__c, Address__c, Pincode__c, Status_Update_Date__c, Red_Score__c FROM Location__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
    }

    /**
     * Get count of locations in each status
     * @return Map<String, Integer>
     */
    @AuraEnabled
    public static Map<String, Integer> getStatusCount() {
        AggregateResult[] statusCount = [SELECT Status__c, COUNT(Id) total FROM Location__c GROUP BY Status__c];

        if (statusCount != null && statusCount.size() > 0) {
            Map<String, Integer> statusCountMap = new Map<String, Integer>();
            for (AggregateResult ar : statusCount) {
                String status = String.valueOf(ar.get('Status__c'));
                Integer count = Integer.valueOf(ar.get('total'));
                statusCountMap.put(status, count);
            }
            return statusCountMap;
        }
        return null;
    }

    /**
     * Search a location by name, zipcode or address
     * @return List<Person__c>
     */
    public static List<Location__c> searchLocations(String searchTerm) {
        String likeTerm = searchTerm + '%';
        return [
            SELECT Id, Name, Status__c, Address__c, Pincode__c, Status_Update_Date__c, Red_Score__c
            FROM Location__c
            WHERE Name LIKE :likeTerm OR Pincode__c LIKE :likeTerm OR Address__c LIKE :likeTerm
            ORDER BY Status_Update_Date__c DESC NULLS LAST
            LIMIT 100
        ];
    }

    /**
     * Search a location by id
     * @return Location__c
     */
    public static Location__c getLocationById(String locationId) {
        List<Location__c> locations = [
            SELECT Id, Name, Status__c, Address__c, Pincode__c, Status_Update_Date__c, Red_Score__c
            FROM Location__c
            WHERE Id = :locationId
            ORDER BY Status_Update_Date__c DESC NULLS LAST
        ];
        if (locations != null && locations.size() > 0) {
            return locations[0];
        }
        return null;
    }

    /**
     * get status of location based on red score
     * Red - If there are more than 10 people (Red Score) who visited the location in last 10 days are in red status
     * Orange - If there are more than 5 people (Red Score) who visited the location in last 10 days are in red status
     * Yellow - If there are more than 1 people (Red Score) who visited the location in last 10 days are in red status
     * Green - Safe
     * @param redScore
     * @return string status
     */
    public static String getStatus(Integer redScore) {
        if (redScore == 0) {
            return 'Green';
        } else if (redScore <= 5) {
            return 'Yellow';
        } else if (redScore <= 10) {
            return 'Orange';
        } else {
            return 'Red';
        }
    }
}
