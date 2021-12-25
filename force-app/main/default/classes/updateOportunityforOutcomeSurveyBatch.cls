//TestClass: OutcomeSurveySchdTest
global class updateOportunityforOutcomeSurveyBatch implements Database.Batchable<sObject>{

     
       
        // Start Method
        global Database.QueryLocator start(Database.BatchableContext BC){
         return Database.getQueryLocator([Select id, Outcome_Survey_Completed__c from Opportunity where stageName='Admitted']);
        }
      
      // Execute Logic
       global void execute(Database.BatchableContext BC, List<sObject>scope){
              // Logic to be Executed batch wise    

              for(sObject iObj : scope){
                   
                 Opportunity oppty = (Opportunity)iObj;
                 oppty.Outcome_Survey_Completed__c = false;
              }  
              
              update scope;
           
     
       }
     
       global void finish(Database.BatchableContext BC){
            // Logic to be Executed at finish
       }
    }