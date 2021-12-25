/**
 * @description Batch class for deleting  SSU Session
 * @date 22.11.2020
 * @author Danish Farooq
 */

global class AlumniAppDetail_Batch implements Database.Batchable<SObject>,schedulable{

    /**
    * @description Batch class Start
    * @param batchableContext BatchableContext
    * @return list of records from query locator
    */
    global Database.QueryLocator start(Database.BatchableContext batchableContext) {

       
        return Database.getQueryLocator('select ID, Current_Checkin_Streak__c,Longest_Checkin__c,(SELECT ID FROM Alumni_App_Sobriety_Checkins__r WHERE Sobriety_Checkin_Date__c = YESTERDAY ) FROM Alumni_App_Detail__c');
    }
    /**
    * @description Batch class Execute
    * @param batchableContext BatchableContext
    * @param lstSession list of SSU Session
    */

    global void execute(Database.BatchableContext batchableContext, List< Alumni_App_Detail__c > lstAppDetail) {

        for(Alumni_App_Detail__c iApp : lstAppDetail){
            if(iApp.Alumni_App_Sobriety_Checkins__r.size() > 0){
                if(iApp.Current_Checkin_Streak__c == null){
                    iApp.Current_Checkin_Streak__c = 0;
                }
                iApp.Current_Checkin_Streak__c ++;
                continue;
            }
             if(iApp.Longest_Checkin__c < iApp.Current_Checkin_Streak__c){
                 iApp.Longest_Checkin__c = iApp.Current_Checkin_Streak__c;
                 iApp.Current_Checkin_Streak__c = 0;
             }
        }
        
        update lstAppDetail;
    }
    /**
   * @description Batch class Finish
   * @param batchableContext BatchableContext
   */
    global void finish(Database.BatchableContext batchableContext) {
    }

    /**
   * @description Schedule class Execute
   * @param SchedulableContext SchedulableContext
   */
    global void execute(SchedulableContext SchedulableContext) {
        database.executebatch(new AlumniAppDetail_Batch());
    }
}