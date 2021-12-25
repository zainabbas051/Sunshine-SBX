public without sharing class Ctrl_Client_Satisfaction_Survey {


@AuraEnabled
    public static void saveOutcomeSurveyRecord (Client_Outcome_Survey__c ClientOutcomeSurveyParam,String oppID){
        
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
    public static void saveRecord (Client_Satisfaction_Survey__c ClientSatisfactionSurveyParam,String oppID){
        
        try{
            System.debug('CreateCandidateRecord::createRecord::Param'+ClientSatisfactionSurveyParam);
            
            if(ClientSatisfactionSurveyParam != null){
               
               ClientSatisfactionSurveyParam.Survey_Date__c= Date.Today();
               ClientSatisfactionSurveyParam.Completed_Date_Time__c= DateTime.Now();
               ClientSatisfactionSurveyParam.Status__c='Completed';
               ClientSatisfactionSurveyParam.Related_Opportunity__c=Id.valueOf(oppID);
               
               // update ClientSatisfactionSurveyParam;
               insert ClientSatisfactionSurveyParam;
               Opportunity op= [select id, Is_Available_for_Survey__c from Opportunity where id=:Id.valueOf(oppID)];
               op.Survey_Completed__c=true;
               System.debug(op);
               update op;
            }
            
        } catch (Exception ex){
            
        }
        
    }  
    
    
    @AuraEnabled
    public static void saveHybrideRecord (Client_Satisfaction_Survey__c ClientSatisfactionSurveyParam,Client_Outcome_Survey__c ClientOutcomeSurveyParam,String oppID){
        
        system.debug('ooo'+ClientOutcomeSurveyParam);
        
            System.debug('CreateCandidateRecord::createRecord::Param'+ClientSatisfactionSurveyParam);
            Opportunity op= [select id,CloseDate, Is_Available_for_Survey__c from Opportunity where id=:Id.valueOf(oppID)];
            if(ClientSatisfactionSurveyParam != null){
               
               ClientSatisfactionSurveyParam.Survey_Date__c= Date.Today();
               ClientSatisfactionSurveyParam.Completed_Date_Time__c= DateTime.Now();
               ClientSatisfactionSurveyParam.Status__c='Completed';
               ClientSatisfactionSurveyParam.Related_Opportunity__c=Id.valueOf(oppID);
               
               // update ClientSatisfactionSurveyParam;
               insert ClientSatisfactionSurveyParam;
               }
               
               if(ClientOutcomeSurveyParam!=null){
               ClientOutcomeSurveyParam.Completed_Date_Time__c= DateTime.Now();
               ClientOutcomeSurveyParam.Status__c='Completed';
               ClientOutcomeSurveyParam.Related_Opportunity__c=Id.valueOf(oppID);
               ClientOutcomeSurveyParam.Type__c='Bi-Weekly';
               
               integer daysDiff=op.CloseDate.daysBetween(Date.today());
                    Decimal noOfRecords=(daysDiff/14); // getting no. of bi-weekly records that shoud be due after an opportunity gets admitted till date
                    noOfRecords= noOfRecords.round(System.RoundingMode.DOWN);
                    
                    Decimal daysiInBetween=noOfRecords*14;            
                    Date dueDate = op.CloseDate.addDays(noOfRecords.intValue()*14); //getting next due date 
                    ClientOutcomeSurveyParam.Outcome_Survey_Date__c= dueDate;
                    insert ClientOutcomeSurveyParam;
                    
               
               }
               
               
               op.Survey_Completed__c=true;
               op.Outcome_Survey_Completed__c=true;
               System.debug(op);
               update op;
            
            
        
        
    }  
    
    @AuraEnabled
    public static void createRecord (string OpportunityID){
        Client_Satisfaction_Survey__c css= new Client_Satisfaction_Survey__c();
        Id oppID = Id.valueOf(OpportunityID);
        
        try{        
               css.Survey_Date__c= Date.Today();
               css.Completed_Date_Time__c= DateTime.Now();
               css.Status__c='Completed';
               css.Related_Opportunity__c=oppID;
               css.Survey_Date__c= Date.Today();
               css.Completed_Date_Time__c= DateTime.Now();
               css.Status__c='Open';
               css.Related_Opportunity__c=oppID;
               insert css;
            
            
            
        } 
        
        catch (Exception ex){
            
        }
        
    }  
    
    
    
    @AuraEnabled
    public static Client_Satisfaction_Survey__c loadRecord (id recID){
        
        
        return [Select id,Satisfied_With_my_Primary_Therapist__c,Satisfied_With_my_Case_Manager__c,Interactions_With_BHT_s_are_Positive__c,
                 Making_Progress_In_Recovery__c,Physical_Environment_is_Comfortable__c,Medical_Needs_are_being_Met__c,Enjoy_the_Food_Provided__c,
                 Group_Sessions_are_Engaging__c,I_feel_Safe__c,Overall_Satisfied_with_Experience__c,Clients_Primary_Therapist__c,Clients_Case_Manager__c,
                 Additional_Notes__c,Related_Opportunity__r.Sunshine_Center__r.Name,Sunshine_Center__c,Related_Opportunity__c,Status__c from Client_Satisfaction_Survey__c where id=:recID];
        
    }  
    
    
    @AuraEnabled
    public static List<Client_Satisfaction_Survey__c > GetSurveyRecord(string[] sunShineCenter){
    
        
        return [Select id, Name,Survey_Date__c, Completed_Date_Time__c, Status__c,Related_Opportunity__c,Related_Opportunity__r.Name,Related_Opportunity__r.Sunshine_Center__r.Name from
                Client_Satisfaction_Survey__c where Related_Opportunity__r.Sunshine_Center__r.Name IN:sunShineCenter and Is_Latest_Survey__c=true order by createdDate];
                
    }  
    
    
        
    @AuraEnabled
    public static string SurveyLogin(string Username, string Password){
    
    List<Sunshine_Center_Id__c> listSunshineDetail = Sunshine_Center_Id__c.getall().values();
    
    for(Sunshine_Center_Id__c iSun : listSunshineDetail ){
        
            if(iSun.Username__c == Username && iSun.Password__c == Password)
                return iSun.Name;
            
            
        }
      return null;  
    }  
    
     @AuraEnabled
    public static List<Opportunity> GetOpportunityRecord(string[] sunShineCenter){
    
      id userid= UserInfo.getUserId();
      User bhtUser=[select id,Facility__c from User where id=:userid];
     
       List<Opportunity> validOpportunity= new List<Opportunity>();
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
       validOpportunity=[Select id,Name,CloseDate,StageName,Sunshine_Center_Name__c,Last_Survey_date__c,Is_Available_for_Survey__c,(select id from Client_Satisfaction_Surveys__r) from
                        opportunity where StageName='Admitted' and Survey_Completed__c= false and Sunshine_Center_Name__c IN: bhtUser.Facility__c.split(';')  order by Name];
       
       return validOpportunity;
       
       
    } 
    
    @AuraEnabled
    public static Client_Satisfaction_Survey__c GetLatestSurveyRecord(string opportunityID){
    
        
        return [Select id,Name,Status__c from Client_Satisfaction_Survey__c where Related_Opportunity__c=:opportunityID  order by createdDate desc limit 1];
    }  
    
}