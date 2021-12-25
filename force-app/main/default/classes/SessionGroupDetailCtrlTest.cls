@isTest
public class SessionGroupDetailCtrlTest {
    
     static testMethod void GroupSession_Test(){
         
          test.startTest();
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
         
             Group_Therapy_Session__c grpSession = new Group_Therapy_Session__c();
         grpSession.Date__c = Date.Today();
         grpSession.Status__c = 'Open';
         grpSession.SignedBy__c = 'None';
         grpSession.Start_Time__c = '08:00 AM';
         grpSession.End_Time__c = '09:00 AM';
         insert grpSession;
         
         Group_Client__c grpClient = new Group_Client__c();
         grpClient.Group_Schedule__c = grpSession.ID;
         grpClient.Client_Chart__c = cl.ID;
         grpClient.Status__c = 'Yes';
         insert grpClient;
         
           awsBucket__c AmazonBucketValue = new awsBucket__c();
         AmazonBucketValue.Name ='FREEPU';
         AmazonBucketValue.accessKeyId__c = 'ABC';
         AmazonBucketValue.secretAccessKey__c ='XYZ';
         insert AmazonBucketValue;
         
        
         
         
           Test.setCurrentPageReference(new PageReference('/apex/SessionGroupDetail'));
         System.currentPageReference().getParameters().put('ID',grpSession.ID);
         SessionGroupDetailCtrl session = new SessionGroupDetailCtrl();
         session.selectedOption = cl.ID+',';
         session.AddGroupClient();
         session.ClientUpdateEvent();
         session.CloseClientEvent();
         session.IndexToDelete = 0;
         session.deleteRecordID = grpClient.ID;
         session.DeleteGroupClient();
         
         
   test.stopTest();
         
         
     }
    
    
}