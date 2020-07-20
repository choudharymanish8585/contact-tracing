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
        // query location tracing records for all locations
        // retrive person health status as well
        List<Location_Tracing__c> locationTraces = [
            SELECT Id, Person__r.Health_Status__c, Location__c
            FROM Location_Tracing__c
            WHERE Location__c IN :locationIds
        ];
        if (locationIds != null && locationIds.size() > 0) {
            // create a map of location id and count of red score
            Map<Id, Integer> redScoreMap = new Map<Id, Integer>();

            String key;
            Integer count;
            // iterate over location traces
            for (Location_Tracing__c locationTrace : locationTraces) {
                // get current location id
                key = locationTrace.Location__c;
                // if redScoreMap does not have this key
                // then add this location (as key) with zero count
                if (!redScoreMap.containsKey(key)) {
                    redScoreMap.put(key, 0);
                }

                // get current red score count
                count = redScoreMap.get(key);
                // increment red score by 1
                redScoreMap.put(key, ++count);
            }

            // Map is ready, now create instance of all location records from ids
            List<Location__c> locations = new List<Location__c>();
            for (Id locationId : redScoreMap.keySet()) {
                // get red score
                Integer redScore = redScoreMap.get(locationId);
                Location__c loc = new Location__c(
                    Id = locationId,
                    Red_Score__c = redScore,
                    Status__c = getStatus(redScore)
                );
                locations.add(loc);
            }

            // Update these location records
            if (locations != null && locations.size() > 0) {
                update locations;
                return locations;
            }
            return null;
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
