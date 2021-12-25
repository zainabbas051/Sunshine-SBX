@isTest
private class Ctrl_Client_Exit_SurveyTest {
 
  Public static Account sunshineCenter;
  Public static Account oppAccount;
  Public static Opportunity opp;
 
 static testMethod void Ctrl_Client_Exit_SurveyTest() {
 
 
 
 Test.startTest();

    CreateSampleData();
    String[] myArray = new List<String>(2);
    myArray.add('Monarch Shores');
    myArray.add('Mountain Springs Recovery');
  
    

    List<Opportunity> clientList= Ctrl_Client_Exit_Survey.GetOpportunityRecord(myArray);
    Client_Exit_Surveys__c cssRec= new Client_Exit_Surveys__c();
    cssRec.Client_Name__c='Test123';
 //   Ctrl_Client_Exit_Survey.saveRecord(cssRec,opp.id);
    Client_Outcome_Survey__c coRec= new Client_Outcome_Survey__c();
    coRec.Type__c='Discharged';
    Ctrl_Client_Exit_Survey.saveHybrideRecord(cssRec,coRec,opp.id);
    
    
    
    
    
 Test.stopTest();
 
 }
 public static void CreateSampleData(){
 

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
opp1.Is_Available_for_Survey__c=true;
opp1.Check_Out_Date__c=System.today();
update opp1;

Client_Exit_Surveys__c ce= new Client_Exit_Surveys__c();
ce.Status__c='Incomplete';
//ce.Related_Opportunity__c=opp1.id;
insert ce;

Client_Outcome_Survey__c co= new Client_Outcome_Survey__c();
co.Status__c='Incomplete';
co.Related_Opportunity__c=opp1.id;
insert co;


 }
}