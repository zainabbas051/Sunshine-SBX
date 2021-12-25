public without sharing class Ctrl_Client_Outcome_Survey {

@AuraEnabled
    public static void saveRecord (Client_Outcome_Survey__c ClientOutcomeSurveyParam,String oppID){
        
        try{
            System.debug('CreateCandidateRecord::createRecord::Param'+ClientOutcomeSurveyParam);
            
            if(ClientOutcomeSurveyParam != null){
              
             
              // ClientOutcomeSurveyParam.Outcome_Survey_Date__c= Date.Today();
               ClientOutcomeSurveyParam.Completed_Date_Time__c= DateTime.Now();
               ClientOutcomeSurveyParam.Status__c='Completed';
               ClientOutcomeSurveyParam.Related_Opportunity__c=Id.valueOf(oppID);
               
               // update ClientSatisfactionSurveyParam;
               
               Opportunity op= [select id, Is_Available_for_Survey__c,CloseDate,Check_Out_Date__c from Opportunity where id=:Id.valueOf(oppID)];
               
               if(ClientOutcomeSurveyParam.Type__c=='Admitted'){
                     ClientOutcomeSurveyParam.Outcome_Survey_Date__c= op.CloseDate;
               }
                 
               else if(ClientOutcomeSurveyParam.Type__c=='Bi-Weekly')
               {
                    integer daysDiff=op.CloseDate.daysBetween(Date.today());
                    Decimal noOfRecords=(daysDiff/14); // getting no. of bi-weekly records that shoud be due after an opportunity gets admitted till date
                    System.assertEquals(noOfRecords,noOfRecords.round(System.RoundingMode.DOWN));
                    
                    Decimal daysiInBetween=noOfRecords*14;
                    
                    // Date nextDueDate= oppty.CloseDate.addDays(daysiInBetween.intValue()); //getting next due date of bi-weekly record creation
                    Date dueDate = op.CloseDate.addDays(noOfRecords.intValue()*14); //getting next due date 
                    ClientOutcomeSurveyParam.Outcome_Survey_Date__c= dueDate;
                    op.Outcome_Survey_Completed__c=true;
                    System.debug(op);
                    update op;
               }
               else if (ClientOutcomeSurveyParam.Type__c=='Discharged'){
                    ClientOutcomeSurveyParam.Outcome_Survey_Date__c= op.Check_Out_Date__c;
               }
                   
               
               insert ClientOutcomeSurveyParam;
            }
            
        } catch (Exception ex){
            
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
       
       /*
       validOpportunity = [Select id,
                            Check_Out_Date__c, Name,CloseDate,Outcome_Survey_Completed__c,
                            StageName,Sunshine_Center_Name__c,
                            Last_Survey_date__c,Is_Available_for_Survey__c,
                            (Select Id,type__c  from Client_Outcome_Surveys__r where Type__c IN ('Discharged','Admitted') order by type__c )
                            from opportunity where 
                            stageName IN ('Admitted','Discharged') AND
                            Sunshine_Center_Name__c IN: bhtUser.Facility__c.split(';') order by Name];
       */ 
        validOpportunity = [Select id,
                            Check_Out_Date__c, Name,CloseDate,Outcome_Survey_Completed__c,
                            StageName,Sunshine_Center_Name__c,
                            Last_Survey_date__c,Is_Available_for_Survey__c,
                            (Select Id,type__c  from Client_Outcome_Surveys__r where Type__c IN ('Discharged','Admitted') order by type__c )
                            from opportunity where 
                            ((StageName='Admitted') OR 
                            (StageName = 'Discharged' AND 
                            Check_Out_Date__c = LAST_N_DAYS:2))  AND
                            Sunshine_Center_Name__c IN: bhtUser.Facility__c.split(';') order by Name];
        
                 
        Client_Outcome_Survey__c dischargedObj= new Client_Outcome_Survey__c();

        integer index = 0;
        for(Opportunity opp : validOpportunity)
        {
        
            //dischargedObj= [Select Id,Related_Opportunity__c from Client_Outcome_Survey__c where Type__c = 'Discharged' and Related_Opportunity__c=:opp.id limit 1];
        
            for(Client_Outcome_Survey__c iClientOutCome :  opp.Client_Outcome_Surveys__r){
            
                if(iClientOutCome.type__c == 'Discharged'){
                    validOpportunity.remove(index);
                   
                            continue;
                }
            }
                
                index++;
        }              
       
        /*if(dischargedObj!=null){
           for(Integer i = validOpportunity.size() - 1; i >= 0; i--) {
                if(validOpportunity[i].id == dischargedObj.Related_Opportunity__c) {
                    validOpportunity.remove(i);
                }
            }
       }*/
       return validOpportunity;
       
       
    } 
    
   
}