//Test Class : AuditWeeklyLineItemCreateBatch_Test
global class AuditWeeklyLineItemCreateBatch implements Database.Batchable<sObject>{
    
    string query;
    
    global AuditWeeklyLineItemCreateBatch(){
        query = 'select id from KIPU_Chart_Audit__c where F_Opportunity_Stage__c = \'Admitted\'';
        if(Test.isRunningTest())
            query += ' limit 200';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('test');
        list<KIPU_Audit_Week_Line_Item__c> wliInsertList = new list<KIPU_Audit_Week_Line_Item__c>();
        
        for(KIPU_Chart_Audit__c aud : (list<KIPU_Chart_Audit__c>) scope){
            
            KIPU_Audit_Week_Line_Item__c wli = new KIPU_Audit_Week_Line_Item__c();
            wli.KIPU_Chart_Audit__c = aud.id;
            wli.Week_Start_Date__c = date.Today();
            wli.Week_End_Date__c = date.Today().addDays(6);
            wli.Number_of_Clinical_Progress_Note__c = 0;
            wli.Number_of_Medical_Progress_Note__c = 0;
            wli.Number_of_Outside_Contact__c = 0; 
            wliInsertList.add(wli);              
        }
        
        if(wliInsertList.size()>0)
            insert wliInsertList;
    
    }
    
    global void finish(Database.BatchableContext BC){

    }
}