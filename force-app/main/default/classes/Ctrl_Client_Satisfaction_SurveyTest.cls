@isTest
private class Ctrl_Client_Satisfaction_SurveyTest {
 
  Public static Account sunshineCenter;
  Public static Account oppAccount;
  Public static Opportunity opp;
 
 static testMethod void Ctrl_Client_Satisfaction_SurveyTest() {
 
 
 
 Test.startTest();

    CreateSampleData();
    String[] myArray = new List<String>(2);
    myArray.add('Monarch Shores');
    myArray.add('Mountain Springs Recovery');
    Ctrl_Client_Satisfaction_Survey.SurveyLogin('test','test');
    Ctrl_Client_Satisfaction_Survey.createRecord(String.valueOf(opp.id));
    List<Client_Satisfaction_Survey__c > cssList= new List<Client_Satisfaction_Survey__c >();
    cssList=Ctrl_Client_Satisfaction_Survey.GetSurveyRecord(myArray);
    List<Opportunity> clientList= Ctrl_Client_Satisfaction_Survey.GetOpportunityRecord(myArray);
    Client_Satisfaction_Survey__c cssRec= new Client_Satisfaction_Survey__c();
    cssRec=Ctrl_Client_Satisfaction_Survey.GetLatestSurveyRecord(String.valueOf(opp.id));
     Client_Satisfaction_Survey__c cssRec2= new Client_Satisfaction_Survey__c();
     cssRec2=Ctrl_Client_Satisfaction_Survey.loadRecord(cssRec.id);
     Ctrl_Client_Satisfaction_Survey.saveRecord(cssRec2,opp.id);
        Client_Outcome_Survey__c cssRec3 = [Select id,Type__c from Client_Outcome_Survey__c limit 1];
     Ctrl_Client_Satisfaction_Survey.saveOutcomeSurveyRecord(cssRec3 ,opp.id);
     cssRec2.id = null;
     cssRec3.id = null;
     Ctrl_Client_Satisfaction_Survey.saveHybrideRecord(cssRec2,cssRec3,opp.id);    
    
    
    
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