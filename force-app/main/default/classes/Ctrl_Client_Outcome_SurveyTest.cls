@isTest
private class Ctrl_Client_Outcome_SurveyTest {
 



  @testSetup static void setup(){

      CreateSampleData();
  }


 static testMethod void Ctrl_Client_Outcome_SurveyTestMethod() {
 
 
 
 Test.startTest();

  
    String[] myArray = new List<String>(2);
    myArray.add('Monarch Shores');
    myArray.add('Mountain Springs Recovery');
  
    

    List<Opportunity> clientList= Ctrl_Client_Outcome_Survey.GetOpportunityRecord(myArray);
   //Client_Outcome_Survey__c cssRec= new Client_Outcome_Survey__c();
  //  cssRec.Client_Name__c='Test123';
    Opportunity oppty = [Select id from Opportunity limit 1];
    Client_Outcome_Survey__c cssRec = [Select id,Type__c from Client_Outcome_Survey__c limit 1];
    cssRec.Type__c = 'Bi-Weekly';
    Ctrl_Client_Outcome_Survey.saveRecord(cssRec,oppty.id);

    cssRec.Type__c = 'Discharged';
    Ctrl_Client_Outcome_Survey.saveRecord(cssRec,oppty.id);

    cssRec.Type__c = 'Admitted';
    Ctrl_Client_Outcome_Survey.saveRecord(cssRec,oppty.id);
    
    
    
 Test.stopTest();
 
 }
 public static void CreateSampleData(){
 
 Account sunshineCenter;
   Account oppAccount;
   Opportunity opp;

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

Client_Outcome_Survey__c ce= new Client_Outcome_Survey__c();
ce.Status__c='Incomplete';

insert ce;

Opportunity opp1= [select id,StageName,CloseDate from Opportunity where id=:opp.id] ;
opp1.StageName='Admitted';
opp1.CloseDate=Date.Today();
opp1.Is_Available_for_Survey__c=true;
update opp1;
 }
}