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
public with sharing class CTLocationTracingDataCleanupBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id FROM Location_Tracing__c WHERE Visit_Date__c < LAST_N_DAYS : 30');
     }
     
     public void execute(
                  Database.BatchableContext BC, 
                  List<Location_Tracing__c> scope){
        delete scope;
     }
   
    public void finish(Database.BatchableContext BC){

    }
}
