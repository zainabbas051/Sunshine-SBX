//TestClass: updateOportunitySurveySchdTest
global class updateOportunitySurveyBatch implements Database.Batchable<sObject>{

     
       
        // Start Method
        global Database.QueryLocator start(Database.BatchableContext BC){
         return Database.getQueryLocator([Select id, Survey_Completed__c,(select id from Client_Satisfaction_Surveys__r) from Opportunity where stageName='Admitted']);
        }
      
      // Execute Logic
       global void execute(Database.BatchableContext BC, List<sObject>scope){
              // Logic to be Executed batch wise    
              List<Client_Satisfaction_Survey__c> survyeList= new List<Client_Satisfaction_Survey__c>();
              List<Client_Outcome_Survey__c> OutcomeSurvyeList= new List<Client_Outcome_Survey__c>();
              boolean isEven=false;
              integer noOfSurveys;
              for(sObject iObj : scope){
                   
                   Opportunity oppty = (Opportunity)iObj;
                   noOfSurveys=oppty.Client_Satisfaction_Surveys__r.Size()+1;
                    if(math.mod(noOfSurveys,2) == 0){
                    isEven=true;
                        }
                        else{
                   isEven=false;
                        }
                        
                   if(oppty.Survey_Completed__c == false)
                   {
                   Client_Satisfaction_Survey__c InCompleteSurvey=new Client_Satisfaction_Survey__c();
                   InCompleteSurvey.Status__c = 'Incomplete';
                   InCompleteSurvey.Related_Opportunity__c = oppty.ID;
                   InCompleteSurvey.Survey_Date__c = Date.Today();
                   survyeList.add(InCompleteSurvey);
                   if(isEven){
                   Client_Outcome_Survey__c InCompleteOutcomeSurvey=new Client_Outcome_Survey__c();
                   InCompleteOutcomeSurvey.Status__c = 'Incomplete';
                   InCompleteOutcomeSurvey.Related_Opportunity__c = oppty.ID; 
                   InCompleteOutcomeSurvey.Outcome_Survey_Date__c= Date.Today();
                   InCompleteOutcomeSurvey.Type__c='Bi-Weekly';
                   OutcomeSurvyeList.add(InCompleteOutcomeSurvey);
                   
                   
                   
                   }
                   
                   }
                   
                   
                 
                   oppty.Survey_Completed__c = false;
              }  
              
              update scope;
              insert survyeList;
              insert OutcomeSurvyeList;
     
       }
     
       global void finish(Database.BatchableContext BC){
            // Logic to be Executed at finish
       }
    }