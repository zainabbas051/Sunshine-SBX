@isTest
private class updateOportunitySurveySchdTest {
 
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
         opp1.CloseDate=Date.Today();
         update opp1;
  }
 
 static testMethod void Ctrl_Client_Satisfaction_SurveyTest() {
 
 
 
     Test.startTest();
    
       
       updateOportunitySurveySchd  sh1 = new updateOportunitySurveySchd ();

    String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1); 
        
        
     Test.stopTest();
 
 }
 }