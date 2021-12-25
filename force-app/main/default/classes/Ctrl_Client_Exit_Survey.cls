public without sharing class Ctrl_Client_Exit_Survey {

/*@AuraEnabled
    public static void saveRecord (Client_Exit_Surveys__c ClientExitSurveyParam,String oppID){
        
        try{
            System.debug('CreateCandidateRecord::createRecord::Param'+ClientExitSurveyParam);
            
            if(ClientExitSurveyParam != null){
               
              //delete incomplete survey
             List <Client_Exit_Surveys__c> incompleteSurvey=[select id,Status__c from Client_Exit_Surveys__c  where Status__c='Incomplete' and Related_Opportunity__c=: Id.valueOf(oppID)];
              if(incompleteSurvey!=null && !incompleteSurvey.isEmpty())
              delete incompleteSurvey;
               ClientExitSurveyParam.Exit_Survey_Date__c= Date.Today();
               ClientExitSurveyParam.Completed_Date_Time__c= DateTime.Now();
               ClientExitSurveyParam.Status__c='Completed';
               ClientExitSurveyParam.Related_Opportunity__c=Id.valueOf(oppID);
               
               // update ClientSatisfactionSurveyParam;
               insert ClientExitSurveyParam;
               Opportunity op= [select id, Is_Available_for_Survey__c from Opportunity where id=:Id.valueOf(oppID)];
               op.Exit_Survey_Completed__c=true;
               System.debug(op);
               update op;
            }
            
        } catch (Exception ex){
            
        }
        
    }  */
    
    @AuraEnabled
    public static void saveHybrideRecord (Client_Exit_Surveys__c ClientExitSurveyParam, Client_Outcome_Survey__c ClientOutcomeSurveyParam,String oppID){
        
      
            System.debug('CreateCandidateRecord::createRecord::Param'+ClientExitSurveyParam);
            Opportunity op= [select id, Is_Available_for_Survey__c,CloseDate,Check_Out_Date__c from Opportunity where id=:Id.valueOf(oppID)];
            if(ClientExitSurveyParam != null){
               
              //delete incomplete survey
             List <Client_Exit_Surveys__c> incompleteSurvey=[select id,Status__c from Client_Exit_Surveys__c  where Status__c='Incomplete' and Related_Opportunity__c=: Id.valueOf(oppID)];
              if(incompleteSurvey!=null && !incompleteSurvey.isEmpty())
              delete incompleteSurvey;
               ClientExitSurveyParam.Exit_Survey_Date__c= Date.Today();
               ClientExitSurveyParam.Completed_Date_Time__c= DateTime.Now();
               ClientExitSurveyParam.Status__c='Completed';
               ClientExitSurveyParam.Related_Opportunity__c=Id.valueOf(oppID);
               
               // update ClientSatisfactionSurveyParam;
               insert ClientExitSurveyParam;
               
                if(ClientOutcomeSurveyParam!=null){
                List <Client_Outcome_Survey__c> incompleteOutcomeSurvey=[select id,Status__c from Client_Outcome_Survey__c  where Status__c='Incomplete' and Type__c='Discharged' and Related_Opportunity__c=: Id.valueOf(oppID)];
                if(incompleteOutcomeSurvey!=null && !incompleteOutcomeSurvey.isEmpty())
                delete incompleteOutcomeSurvey;
               ClientOutcomeSurveyParam.Completed_Date_Time__c= DateTime.Now();
               ClientOutcomeSurveyParam.Status__c='Completed';
               ClientOutcomeSurveyParam.Related_Opportunity__c=Id.valueOf(oppID);
               ClientOutcomeSurveyParam.Type__c='Discharged';
              ClientOutcomeSurveyParam.Outcome_Survey_Date__c= op.Check_Out_Date__c;
                    insert ClientOutcomeSurveyParam;
                    
               
               }
               
               
               op.Exit_Survey_Completed__c=true;
               System.debug(op);
               update op;
            
            
       
    }  
    }
   
   
     @AuraEnabled
    public static List<Opportunity> GetOpportunityRecord(string[] sunShineCenter){
    
      id userid= UserInfo.getUserId();
      User bhtUser=[select id,Facility__c from User where id=:userid];
     
       List<Opportunity> validOpportunity= new List<Opportunity>();
       List<Opportunity> dischargedOpportunity= new List<Opportunity>();
       List<Opportunity> allOpportunities= new List<Opportunity>();
     /*  allOpportunities= [Select id,Name,CloseDate,StageName,Sunshine_Center_Name__c,Last_Survey_date__c from
                opportunity where StageName='Admitted' and Sunshine_Center_Name__c IN: bhtUser.Facility__c.split(';')  order by Name];
       

                
       For(Opportunity opp :  allOpportunities){
              AggregateResult latestSurveys= [Select Count(id) from Client_Satisfaction_Survey__c where Related_Opportunity__r.Sunshine_Center__r.Name IN:bhtUser.Facility__c.split(';') and 
                       Is_Latest_Survey__c=true and Related_Opportunity__c=:opp.id ];
              if(latestSurveys.get('expr0')==0)
              validOpportunity.add(opp);
       
       }
       
       */
       
       validOpportunity = [Select id,
                               Check_Out_Date__c, Name,CloseDate,Email__c,Phone__c,
                               StageName,Sunshine_Center_Name__c,
                               Last_Survey_date__c,Is_Available_for_Survey__c 
                               from opportunity where 
                               ((StageName='Admitted') OR 
                               (StageName = 'Discharged' AND 
                               Check_Out_Date__c = LAST_N_DAYS:2)) AND
                               Exit_Survey_Completed__c = FALSE AND
                               Sunshine_Center_Name__c IN: bhtUser.Facility__c.split(';') order by Name];
                               
       
       return validOpportunity;
       
       
    } 
    
   
}