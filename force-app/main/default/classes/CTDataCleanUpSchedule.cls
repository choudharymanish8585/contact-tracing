/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-14-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   06-14-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class CTDataCleanUpSchedule implements Schedulable{
    public static final String CRON = '0 0 2 * * ?';
    
    public void execute(SchedulableContext sc){
        CTPeopleTracingDataCleanupBatch peopleTracingDataCleanupBatch = new CTPeopleTracingDataCleanupBatch();
        Database.executeBatch(peopleTracingDataCleanupBatch, 2000);
        
        CTLocationTracingDataCleanupBatch locationTracingDataCleanupBatch = new CTLocationTracingDataCleanupBatch();
        Database.executeBatch(locationTracingDataCleanupBatch, 2000);        
    }
}
