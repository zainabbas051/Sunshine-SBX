@isTest
public class IntakePageCtrlTest {
      
    public Static Profile adminProfile;
    public static User userAdmin
    {
        get{
            if (userAdmin == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
                            email='test@key.net', communityNickname='test0101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id ,
                            LanguageLocaleKey='en_US', Acess_Type__c='Admin');
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }
      
      static testMethod void IntakePageTest(){
          
          test.startTest();
         
         TabViews__c tv = new TabViews__c();
         tv.Name = 'Consents';
         tv.Button_Access_Type__c = 'Admin';
         insert tv;
         
         Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
             
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.Admit_Date_Time__c = DateTime.Now().AddDays(-5);
         cl.Discharge_Date_Time__c = DateTime.Now();
         cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         insert cl;
         
         
         Intake_Forms__c intake = new Intake_Forms__c();
         intake.Client_Chart__c = cl.ID;
         intake.Status__c = 'Open';
         insert intake;
         
         system.runAs(userAdmin){
         
             Test.setCurrentPageReference(new PageReference('/apex/IntakeHomePage'));
             System.currentPageReference().getParameters().put('ID', cl.ID);
             
             intakeHomePageController intakeHome = new intakeHomePageController();
             intakeHome.createClientHandBookRecord();
             
             Boolean Flag = intakeHome.buttonAccessType;
         }
         test.stopTest();
          
      }
}