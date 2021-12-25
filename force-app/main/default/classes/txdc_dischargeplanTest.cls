@isTest
public class txdc_dischargeplanTest {
    
    static testMethod void TxdcDischargePlanTest(){
        
         test.startTest();
         Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         insert cl;
         
       
         Id dishchargeID = Schema.SObjectType.Tx_and_D_C_Plans__c.getRecordTypeInfosByName().get('Discharge Plan').getRecordTypeId();
         Id appointmentID = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get('Appointment').getRecordTypeId();
         Id supportMettingID = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get('Support Meeting').getRecordTypeId();
         Id programRefferalID  = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get('Program Referral').getRecordTypeId();
         
         Tx_and_D_C_Plans__c tx = new Tx_and_D_C_Plans__c();
         tx.Client_Chart__c = cl.ID;
         tx.RecordTypeID = dishchargeID;
         tx.Status__c = 'Open';
         insert tx;
         
         Appointment__c tx1 = new Appointment__c();
         tx1.Tx_and_D_C_Plans__c = tx.ID;
         tx1.Name__c = 'abc';
         tx1.RecordTypeID = appointmentID;
         insert tx1;
         
         tx1 = new Appointment__c();
         tx1.Tx_and_D_C_Plans__c = tx.ID;
          tx1.Name__c = 'abc';
         tx1.RecordTypeID = supportMettingID;
         insert tx1;
         
         tx1 = new Appointment__c();
         tx1.Tx_and_D_C_Plans__c = tx.ID;
          tx1.Name__c = 'abc';
         tx1.RecordTypeID = programRefferalID;
         insert tx1;
         
       
       
       
         
         awsBucket__c AmazonBucketValue = new awsBucket__c();
         AmazonBucketValue.Name ='FREEPU';
         AmazonBucketValue.accessKeyId__c = 'ABC';
         AmazonBucketValue.secretAccessKey__c ='XYZ';
         insert AmazonBucketValue;
         
         
         Test.setCurrentPageReference(new PageReference('/apex/TxDcDetailPage'));
         System.currentPageReference().getParameters().put('ID', cl.ID);
         System.currentPageReference().getParameters().put('txdcObj', tx.ID);
    
         txdc_dischargeplan txdcPlan = new txdc_dischargeplan();
         txdcPlan.AddAppointment();
         txdcPlan.AddProgramReferral();
         txdcPlan.AddSupportMeeting();
         txdcPlan.EditFullPage();
         txdcPlan.submit();
         
         
         
      
         
         txdcPlan.txdc.Status__c = 'Open';
         txdcPlan.SelectedSignedOption = 'Staff';
         txdcPlan.ImageUrlAddress = 'http/abc';
         txdcPlan.ActiveTXDxPlans();
         
         txdcPlan.txdc.Status__c = 'Open';
         txdcPlan.SelectedSignedOption = 'Patient';
         txdcPlan.ImageUrlAddress = 'http/abc';
         txdcPlan.ActiveTXDxPlans();
         
       
         
      
        
         
         test.stopTest();
        
    }
    
    
     static testMethod void TxdcDischargePlanTest_Intern(){
            
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
         User u2 = new User(Alias = 'newUser1', Email='newuser1@testorg.com',
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
         LocaleSidKey='en_US', ProfileId = p.Id,
         TimeZoneSidKey='America/Los_Angeles', UserName='newuse11r@testorg.com', User_Role__c = 'Intern');
         
         System.runAs(u2) {
             
              test.startTest();
         Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         insert cl;
         
       
       
         Id dishchargeID = Schema.SObjectType.Tx_and_D_C_Plans__c.getRecordTypeInfosByName().get('Discharge Plan').getRecordTypeId();
         Id appointmentID = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get('Appointment').getRecordTypeId();
         Id supportMettingID = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get('Support Meeting').getRecordTypeId();
         Id programRefferalID  = Schema.SObjectType.Appointment__c.getRecordTypeInfosByName().get('Program Referral').getRecordTypeId();
         
         Tx_and_D_C_Plans__c tx = new Tx_and_D_C_Plans__c();
         tx.Client_Chart__c = cl.ID;
         tx.RecordTypeID = dishchargeID;
         tx.Status__c = 'Open';
         insert tx;
         
         Appointment__c tx1 = new Appointment__c();
         tx1.Tx_and_D_C_Plans__c = tx.ID;
         tx1.RecordTypeID = appointmentID;
         insert tx1;
         
         tx1 = new Appointment__c();
         tx1.Tx_and_D_C_Plans__c = tx.ID;
         tx1.RecordTypeID = supportMettingID;
         insert tx1;
         
         tx1 = new Appointment__c();
         tx1.Tx_and_D_C_Plans__c = tx.ID;
         tx1.RecordTypeID = programRefferalID;
         insert tx1;
         
       
       
       
         
         awsBucket__c AmazonBucketValue = new awsBucket__c();
         AmazonBucketValue.Name ='FREEPU';
         AmazonBucketValue.accessKeyId__c = 'ABC';
         AmazonBucketValue.secretAccessKey__c ='XYZ';
         insert AmazonBucketValue;
         
         
         Test.setCurrentPageReference(new PageReference('/apex/TxDcDetailPage'));
         System.currentPageReference().getParameters().put('ID', cl.ID);
         System.currentPageReference().getParameters().put('txdcObj', tx.ID);
    
         txdc_dischargeplan txdcPlan = new txdc_dischargeplan();
         txdcPlan.AddAppointment();
         txdcPlan.AddProgramReferral();
         txdcPlan.AddSupportMeeting();
         txdcPlan.EditFullPage();
         txdcPlan.submit();
         
         
         
         txdcPlan.ActiveTXDxPlans();
         
         txdcPlan.txdc.Status__c = 'In Use';
         txdcPlan.SelectedSignedOption = 'Patient';
         txdcPlan.ImageUrlAddress = 'http/abc';
         txdcPlan.ActiveTXDxPlans();
         
         txdcPlan.txdc.Status__c = 'Open';
         txdcPlan.SelectedSignedOption = 'Staff';
         txdcPlan.ImageUrlAddress = 'http/abc';
         txdcPlan.ActiveTXDxPlans();
         
         txdcPlan.txdc.Status__c = 'Open';
         txdcPlan.SelectedSignedOption = 'Patient';
         txdcPlan.ImageUrlAddress = 'http/abc';
         txdcPlan.ActiveTXDxPlans();
         txdcPlan.ReadOnlyPage();
         
       
         
      
        
         
         test.stopTest();
            
        }
        
     }
        
    
    
    
}