//TestClass: OutcomeSurveySchdTest
global class createBlankOutcomeSurveyBatch implements Database.Batchable<sObject>{

     
       
        // Start Method
        global Database.QueryLocator start(Database.BatchableContext BC){
         return Database.getQueryLocator([Select id, stageName,CloseDate, Outcome_Survey_Completed__c,Check_Out_Date__c,
                                         (Select ID,Status__c,Type__c,CreatedDate,Number_of_Bi_Weekly__c FROM Client_Outcome_Surveys__r WHERE 
                                           Type__c IN ('Admitted','Bi-Weekly','Discharged')
                                          ORDER BY CreatedDate DESC) from Opportunity where stageName IN ('Admitted','Discharged')
                                          ]);
        }
      
      // Execute Logic
       global void execute(Database.BatchableContext BC, List<sObject>scope){
              // Logic to be Executed batch wise    
              List<Client_Outcome_Survey__c> surveyList= new List<Client_Outcome_Survey__c>();
              List<Client_Outcome_Survey__c> AdmittedOutcomeSurvey= new List<Client_Outcome_Survey__c>();
              List<Client_Outcome_Survey__c> BWsurveyList= new List<Client_Outcome_Survey__c>();
              List<Client_Outcome_Survey__c> DischargedOutcomeSurvey = new List<Client_Outcome_Survey__c>();
              for(sObject iObj : scope){
                   
                   Opportunity oppty = (Opportunity)iObj;
                   // no addmitted record found
                   // more than 3 days passed, create the record 
                   if(oppty.stageName == 'Admitted'){
                       if(oppty.Client_Outcome_Surveys__r.size() == 0 && Date.today() >= oppty.CloseDate.addDays(3)){
    
    
                           //oppty.Outcome_Survey_Completed__c = false;
                           AdmittedOutcomeSurvey.add(new Client_Outcome_Survey__c(Status__c = 'Incomplete',Type__c = 'Admitted',Outcome_Survey_Date__c=oppty.CloseDate,
                                                                       Related_Opportunity__c = oppty.Id));
                           
                           
                           
                      
                            
                       }
                       
                       /////////////////////// Bi-Weekly Record Creation Logic //////////////////////////
                       
                      // List<Client_Outcome_Survey__c> biWeeklysurveyList= [Select id, Related_Opportunity__c,Type__c,Status__c,CreatedDate 
                        //                                                   from Client_Outcome_Survey__c where Type__c='Bi-Weekly' Order by Outcome_Survey_Date__c Desc]; // Getting list of bi-weekly surveys
                       
                      
                       List<Client_Outcome_Survey__c> biWeeklysurveyList= new List<Client_Outcome_Survey__c>();
                       for(Client_Outcome_Survey__c cos : oppty.Client_Outcome_Surveys__r)
                       {
                           if(cos.Type__c=='Bi-Weekly'){
                           biWeeklysurveyList.add(cos);
                           
                           }
                       }
                       integer daysDiff=oppty.CloseDate.daysBetween(Date.today());
                       Decimal noOfRecords=(daysDiff/14); // getting no. of bi-weekly records that shoud be due after an opportunity gets admitted till date
                       System.assertEquals(noOfRecords,noOfRecords.round(System.RoundingMode.DOWN));
                       
                       Decimal daysiInBetween=noOfRecords*14;
                       
                      // Date nextDueDate= oppty.CloseDate.addDays(daysiInBetween.intValue()); //getting next due date of bi-weekly record creation
                       Date dueDate = oppty.CloseDate.addDays(noOfRecords.intValue()*14); //getting next due date 
                       //checking if there is no bi-weekly records present for already admitted opportunity or old opportunities
                       
                       if(noOfRecords>0 && biWeeklysurveyList.isEmpty() == true){ 
                       
                       //creating all the due bi-weekly records of old opportunities 
                       for(integer i=1;i<=noOfRecords;i++)
                       {
                       Date surveyDate = oppty.CloseDate.addDays(i*14);
                      
                      if(Date.today() >= surveyDate.addDays(3))
                       BWsurveyList.add(new Client_Outcome_Survey__c(Status__c = 'Incomplete',Type__c = 'Bi-Weekly',Outcome_Survey_Date__c=surveyDate,
                                                                       Related_Opportunity__c = oppty.Id));
                        oppty.Outcome_Survey_Completed__c=false;
                       
                       }
                       
                       
                       }
                       //if there are bi-weekly surveys present then execute below logic
                       else if (noOfRecords>0 && biWeeklysurveyList.isEmpty() == false){
                       
                      
                      
                       Client_Outcome_Survey__c outComeSurvey = biWeeklysurveyList[0]; //get the last bi-weekly record;
                       
                       //check if the last bi-weekly record is older than the curent due date and if user has not created new bi-weekly till duedate + 3days
                       if(outComeSurvey.CreatedDate.date()< dueDate && Date.today() >= dueDate.addDays(3)){
                       
                       BWsurveyList.add(new Client_Outcome_Survey__c(Status__c = 'Incomplete',Type__c = 'Bi-Weekly',Outcome_Survey_Date__c=dueDate,
                                                                       Related_Opportunity__c = oppty.Id));
                         oppty.Outcome_Survey_Completed__c=false;
                                                                       }
                       }
                       
                       if(Date.today() == dueDate)
                       oppty.Outcome_Survey_Completed__c=false;
                       
                       
                       ////////////////end of Bi-Weekly Creation logic////////////////////
                      
                    }
                    
                    ////////////////Logic for REcord creation of Discharged Opportunities/////////////
                    
                    else {
                        
                       // List<Client_Outcome_Survey__c> dischargedSurveyList= [Select id, Related_Opportunity__c,Type__c,Status__c 
                         //                                                  from Client_Outcome_Survey__c where Type__c='Discharged' and Related_Opportunity__c=:oppty.Id];
                        
                        List<Client_Outcome_Survey__c> dischargedSurveyList= new List<Client_Outcome_Survey__c>();
                        for(Client_Outcome_Survey__c cos : oppty.Client_Outcome_Surveys__r)
                       {
                           if(cos.Type__c=='Discharged'){
                           dischargedSurveyList.add(cos);
                           
                           }
                       }
                        Date dueDate = oppty.Check_Out_Date__c; 
                                                                           
                         if(dischargedSurveyList.isEmpty() == true && Date.today() >= oppty.Check_Out_Date__c.addDays(3)){
    
    
                           //oppty.Outcome_Survey_Completed__c = false;
                           DischargedOutcomeSurvey.add( new Client_Outcome_Survey__c(Status__c = 'Incomplete',Type__c = 'Discharged',Outcome_Survey_Date__c=oppty.Check_Out_Date__c,
                                                                       Related_Opportunity__c = oppty.Id));
                           
                           continue;
                            
                       }
                    }

              }
                
              surveyList.addAll(AdmittedOutcomeSurvey);
              surveyList.addAll(BWsurveyList);
              surveyList.addAll(DischargedOutcomeSurvey);
              
              if(surveyList.isEmpty() == false){
                  insert surveyList;
              }
          
              
              update scope;
            
     
       }
     
       global void finish(Database.BatchableContext BC){
            // Logic to be Executed at finish
       }
    }