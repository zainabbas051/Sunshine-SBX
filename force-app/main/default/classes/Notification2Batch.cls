global class Notification2Batch implements Database.Batchable<sObject>{ 
    
     final String query;
     
     global Notification2Batch (){
         
         query = 'Select ID from Client_chart__c limit 1';
         
     }
     
      global Database.QueryLocator start(Database.BatchableContext BC){

        return Database.getQueryLocator(query);
    }
    
      global void execute(Database.BatchableContext BC, List<sObject> scope){
          
            Notification2 obj = new Notification2();
            obj.SendDynamicNotification();
            
      }
      
      global void finish(Database.BatchableContext BC){
    
    }

}