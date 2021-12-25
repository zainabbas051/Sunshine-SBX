@isTest
private class OutcomeSurveySchdTest {
 
  Public static Account sunshineCenter;
  Public static Account oppAccount;
  Public static Opportunity opp;
  
  @testSetup static void setup() {
          
          sunshineCenter= new Account();
         sunshineCenter.Name='Monarch Shores';
         sunshineCenter.Type='Internal Center';
         insert sunshineCenter;
 
         oppAccount= new Account();
         oppAccount.Name='testAc';
         insert oppAccount;
         
         opp= new Opportunity();
         opp.Name='SafiaO';
         opp.Sunshine_Center__c=sunshineCenter.id;
         opp.StageName='Working';
        opp.CloseDate=Date.Today();
        opp.KIPU_MRN__c='Test';
         insert opp;     
         
         Payment_Plan__c pp = new Payment_Plan__c();
         pp.Opportunity__c=opp.id;
         insert pp;
         
         Opportunity opp1= [select id,StageName,CloseDate from Opportunity where id=:opp.id] ;
         opp1.StageName='Admitted';
         opp1.CloseDate=Date.Today().addDays(-50);
         update opp1;

         
        Client_Outcome_Survey__c ce= new Client_Outcome_Survey__c();
        ce.Type__c ='Bi-Weekly';
        ce.Related_Opportunity__c = opp1.id;
        insert ce;
  }
 
 static testMethod void Ctrl_Client_Satisfaction_SurveyTest() {
 
 
 
     Test.startTest();
    
       
       updateOportunityforOutcomeSurveySchd  sh1 = new updateOportunityforOutcomeSurveySchd ();
       createBlankOutcomeSurveySchd sh2= new createBlankOutcomeSurveySchd();

    String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1);
     String sch3 = '0 0 22 * * ?'; system.schedule('Test Territory Check1', sch3, sh2); 
        
        
     Test.stopTest();
 
 }

 static testMethod void Ctrl_Client_Satisfaction_SurveyTest1() {
 
 
 
     Test.startTest();
    
    Client_Outcome_Survey__c ce= [Select id,Type__c from Client_Outcome_Survey__c limit 1 ];
    ce.Type__c = 'Admitted';
    update ce;
       
       updateOportunityforOutcomeSurveySchd  sh1 = new updateOportunityforOutcomeSurveySchd ();
       createBlankOutcomeSurveySchd sh2= new createBlankOutcomeSurveySchd();

    String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1);
     String sch3 = '0 0 22 * * ?'; system.schedule('Test Territory Check1', sch3, sh2); 
        
        
     Test.stopTest();
 
 }

 static testMethod void Ctrl_Client_Satisfaction_SurveyTest2() {
 
 
 
     Test.startTest();
    
   Opportunity opp1= [select id,StageName,CloseDate from Opportunity limit 1] ;
         opp1.StageName='Discharged';
         opp1.Discharge_Type__c = 'Administrative';
         opp1.Check_Out_Date__c = Date.Today();
         opp1.CloseDate=Date.Today().addDays(50);
         update opp1;
       
       updateOportunityforOutcomeSurveySchd  sh1 = new updateOportunityforOutcomeSurveySchd ();
       createBlankOutcomeSurveySchd sh2= new createBlankOutcomeSurveySchd();

    String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1);
     String sch3 = '0 0 22 * * ?'; system.schedule('Test Territory Check1', sch3, sh2); 
        
        
     Test.stopTest();
 
 }
 }