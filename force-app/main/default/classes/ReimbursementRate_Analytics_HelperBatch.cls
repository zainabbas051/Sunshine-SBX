//Test Class : ReimbursementRate_Batches_Test
global class ReimbursementRate_Analytics_HelperBatch implements Database.Batchable<sObject>{
    
    string query;
    
    global ReimbursementRate_Analytics_HelperBatch(){
        query = 'select id from Account where Reimbursement_Rate_Temp_Flag__c = True';
        if(Test.isRunningTest())
            query += ' limit 200';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('test');
        
        List<Account> accUpdateList = new List<Account>();
        
        for(Account acc : (list<Account>) scope){
            Account a = new Account(id=acc.id, Reimbursement_Rate_Temp_Flag__c = False);
            accUpdateList.add(a); 
        }
        
        if(accUpdateList.size()>0)
            update accUpdateList;
    
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}