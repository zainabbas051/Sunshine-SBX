@isTest
public class IntakePageDetailCtrl_Test {
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
        
        
          System.runAs(userAdmin) {

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
         intake.RecordTypeID = Schema.SObjectType.Intake_Forms__c.getRecordTypeInfosByName().get('Client Personal Items - Cell Phone And Other Valuables Lock-Up').getRecordTypeId();
         insert intake;
         
         UtlizationReviewOrder__c util = new UtlizationReviewOrder__c();
         util.Locker_Status__c = 'Open';
         util.Intake_Form__c = intake.ID;
         insert util;
         
         intake.Locker_Number_L__c = util.ID;
         update intake;
            
         awsBucket__c AmazonBucketValue = new awsBucket__c();
         AmazonBucketValue.Name ='FREEPU';
         AmazonBucketValue.accessKeyId__c = 'ABC';
         AmazonBucketValue.secretAccessKey__c ='XYZ';
         insert AmazonBucketValue;
         
          Test.setCurrentPageReference(new PageReference('/apex/IntakePageDetail'));
         System.currentPageReference().getParameters().put('ID', cl.ID);
           System.currentPageReference().getParameters().put('Intake', intake.ID);
         
         IntakePageDetailCtrl intakeHome = new IntakePageDetailCtrl();
         intakeHome.getOpenLockers();
         intakeHome.admitDate = '24-10-2017';
         intakeHome.getAttachment();
         
         intakeHome.changeStatus();
         intakeHome.SaveData();
         intakeHome.AddIntakeDevices();
         intakeHome.CloneRecord();
         intakeHome.SelectedSignedOption = 'Staff';
         intakeHome.CloseIntakeForms();
          intakeHome.SelectedSignedOption = 'Patient';
         intakeHome.CloseIntakeForms();
         intakeHome.ChangeStatusToInActive();
         
         intakeHome.RemoveFromList();
         
         Boolean Flag = intakeHome.buttonAccessType;
         //intakeHome.CreateAttachmentFileName();
         
         test.stopTest();
         
          }
          
      }
      
        static testMethod void IntakePageTest_IntakeAgreement(){
        
        
          System.runAs(userAdmin) {

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
         intake.RecordTypeID = Schema.SObjectType.Intake_Forms__c.getRecordTypeInfosByName().get('Admit Agreement').getRecordTypeId();
         insert intake;
         
         UtlizationReviewOrder__c util = new UtlizationReviewOrder__c();
         util.Locker_Status__c = 'Open';
         util.Intake_Form__c = intake.ID;
         insert util;
         
         intake.Locker_Number_L__c = util.ID;
         update intake;
            
         awsBucket__c AmazonBucketValue = new awsBucket__c();
         AmazonBucketValue.Name ='FREEPU';
         AmazonBucketValue.accessKeyId__c = 'ABC';
         AmazonBucketValue.secretAccessKey__c ='XYZ';
         insert AmazonBucketValue;
         
          Test.setCurrentPageReference(new PageReference('/apex/IntakePageDetail'));
         System.currentPageReference().getParameters().put('ID', cl.ID);
           System.currentPageReference().getParameters().put('Intake', intake.ID);
         
         IntakePageDetailCtrl intakeHome = new IntakePageDetailCtrl();
         intakeHome.getOpenLockers();
         intakeHome.admitDate = '24-10-2017';
         intakeHome.getAttachment();
         
         intakeHome.changeStatus();
         intakeHome.SaveData();
         intakeHome.AddIntakeDevices();
         intakeHome.CloneRecord();
         intakeHome.SelectedSignedOption = 'Staff';
         intakeHome.CloseIntakeForms();
          intakeHome.SelectedSignedOption = 'Patient';
         intakeHome.CloseIntakeForms();
         intakeHome.ChangeStatusToInActive();
         
         intakeHome.RemoveFromList();
         
         Boolean Flag = intakeHome.buttonAccessType;
         //intakeHome.CreateAttachmentFileName();
         
         test.stopTest();
         
          }
          
      }
}