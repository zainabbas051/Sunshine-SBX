global class VOBOpportunityUpdateBatch implements Database.Batchable<sObject>, Database.Stateful{
    string query;
    String VOBStatus= 'Complete';
    String OppVOBStatus= 'Completed';
   
    global VOBOpportunityUpdateBatch (){
    
    query='SELECT Id, Opportunity__c, Name, VOB_Request_Status__c,Opportunity__r.VOB_Status__c FROM VOB_Request__c where( Opportunity__r.VOB_Status__c!=\''+OppVOBStatus+'\' AND VOB_Request_Status__c =\''+VOBStatus+'\')';   

        
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('query :::'+query);
        return Database.getQueryLocator(query);
    }
    
     global void execute(Database.BatchableContext BC, List<sObject> scope){
         List<VOB_Request__c> VOBLst= new list<VOB_Request__c>( [SELECT Id,Opportunity__c FROM VOB_Request__c where (Opportunity__r.VOB_Status__c!='Completed' AND VOB_Request_Status__c ='Complete')] );
       system.debug('VOBLstData:::::'+VOBLst);
        Set<string> VOBsetID = new Set<string>();
    for(VOB_Request__c VobIns: VOBLst){
      VOBsetID.add(VobIns.Opportunity__c ) ;
    }
    system.debug('VOBSetData:::::'+VOBsetID);
    list<opportunity> lstOpp = [select id,Latest_VOB_Request__c from opportunity where Latest_VOB_Request__c=:VOBLst];
    
    VOBOpportunityUpdateProcess.UpdateOpportunities(lstOpp ,(list<VOB_Request__c>) scope);
    }
        
     
     
     global void finish(Database.BatchableContext BC){
         
        
     }



}