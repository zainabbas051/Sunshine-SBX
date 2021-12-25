@isTest
public class ClinicalNotesDetailCtrlTest {
     
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
     
     static testMethod void ClinicalNotesTest(){
            
         test.startTest();
         
         TabViews__c tv = new TabViews__c();
         tv.Name = 'ClinicalNotes';
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
         
         Clinical_Note__c clNotes = new Clinical_Note__c();
         clNotes.RecordTypeID = Schema.SObjectType.Clinical_Note__c.getRecordTypeInfosByName().get('Group Session Notes').getRecordTypeId();
         clNotes.Client_Chart__c = cl.ID;
         clNotes.Date__c = Date.Today().AddDays(-2);
         clNotes.Status__c = 'Open';
       
         
         insert clNotes;
         
         awsBucket__c AmazonBucketValue = new awsBucket__c();
         AmazonBucketValue.Name ='FREEPU';
         AmazonBucketValue.accessKeyId__c = 'ABC';
         AmazonBucketValue.secretAccessKey__c ='XYZ';
         insert AmazonBucketValue;
         
         system.runAs(userAdmin){
         
             Test.setCurrentPageReference(new PageReference('/apex/ClinicalNotesDetail'));
             System.currentPageReference().getParameters().put('ID', cl.ID);
             System.currentPageReference().getParameters().put('clNID', clNotes.ID);
             
             ClinicalNotesDetailCtrl clCtrl = new ClinicalNotesDetailCtrl();
             clCtrl.SelectedSignedOption = 'Staff';
             clCtrl.ChangeInProgress();
             clCtrl.CloseClinicalNotes();
             clCtrl.getAttachment();
             
             
             clinicalnotes_nursingprogressnotes clNursingProgressNotes = new clinicalnotes_nursingprogressnotes();
             clNursingProgressNotes.submit();
             
             
             clinicalnotes_progressnotes clProgressNotes  = new clinicalnotes_progressnotes();
             clProgressNotes.submit();
             List<SelectOption> options = clProgressNotes.getProgressNoted();
             
             clinicalnotes_acupunturemassage acupMessage = new clinicalnotes_acupunturemassage();
             acupMessage.submit();
             
             Boolean Flag = clNursingProgressNotes.buttonAccessType;
             Boolean Flag2 = clProgressNotes.buttonAccessType;
             Boolean Flag3 = acupMessage.buttonAccessType;
         }
         test.stopTest();
         
         
     }
     
      static testMethod void ClinicalNotesTest_Intern(){
         
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
         User u2 = new User(Alias = 'newUser1', Email='newuser1@testorg.com',
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
         LocaleSidKey='en_US', ProfileId = p.Id,
         TimeZoneSidKey='America/Los_Angeles', UserName='newuse11r@testorg.com', User_Role__c = 'Intern',Acess_Type__c='Admin');
         
           System.runAs(u2) {
              test.startTest();
             
             TabViews__c tv = new TabViews__c();
             tv.Name = 'ClinicalNotes';
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
             
             Clinical_Note__c clNotes = new Clinical_Note__c();
             clNotes.RecordTypeID = Schema.SObjectType.Clinical_Note__c.getRecordTypeInfosByName().get('Group Session Notes').getRecordTypeId();
             clNotes.Client_Chart__c = cl.ID;
             clNotes.Date__c = Date.Today().AddDays(-2);
             clNotes.Status__c = 'Open';
           
             
             insert clNotes;
             
             awsBucket__c AmazonBucketValue = new awsBucket__c();
             AmazonBucketValue.Name ='FREEPU';
             AmazonBucketValue.accessKeyId__c = 'ABC';
             AmazonBucketValue.secretAccessKey__c ='XYZ';
             insert AmazonBucketValue;
             
             Test.setCurrentPageReference(new PageReference('/apex/ClinicalNotesDetail'));
             System.currentPageReference().getParameters().put('ID', cl.ID);
             System.currentPageReference().getParameters().put('clNID', clNotes.ID);
             
             ClinicalNotesDetailCtrl clCtrl = new ClinicalNotesDetailCtrl();
             clCtrl.SelectedSignedOption = 'Staff';
             clCtrl.ChangeInProgress();
             clCtrl.CloseClinicalNotes();
             test.stopTest();
             
             Boolean Flag = clCtrl.buttonAccessType;
           }
         
         
     }
}