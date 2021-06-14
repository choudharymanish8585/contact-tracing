/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-15-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   06-14-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class CTUpdateLocationStatusBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext BC){
        List<String> healthStatus = new List<String> {'Red', 'Orange', 'Yellow'};
        Date now = Date.today();
        Date fourteenDaysBefore = now-14;
        return Database.getQueryLocator('SELECT Id, Status__c FROM Location__c WHERE Status_Update_Date__c = :fourteenDaysBefore AND Status__c IN :healthStatus');
     }
     
     public void execute(
                  Database.BatchableContext BC, 
                  List<Location__c> scope){
        for(Location__c location : scope){
            location.Status__c = 'Green';
        }
        update scope;
     }
   
    public void finish(Database.BatchableContext BC){

    }
}
