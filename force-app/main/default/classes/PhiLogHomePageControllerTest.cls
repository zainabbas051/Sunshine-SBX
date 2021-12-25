@isTest
public class PhiLogHomePageControllerTest{
    
      static testMethod void PHILogTest(){
      
         test.startTest();
         Account a = new Account();
         a.Name = 'Monarch Shores';
         a.Type = 'Internal Center';
         insert a;
         
         Contact con = new Contact();
         con.LastName = 'test';
         con.RecordTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Client Chart Contact').getRecordTypeId();
         insert con;
         
         Contact conAuth = new Contact();
         conAuth.LastName = 'test 1';
         conAuth.RecordTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Client Chart Contact').getRecordTypeId();
         conAuth.status__c = 'PHI Authorized';
         insert conAuth;
         
         Client_Chart__c cl = new Client_Chart__c();
         cl.Treatment_Center__c = a.ID;
         cl.Primary_Therapist__c = UserINFO.getUserID();
         cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
         insert cl;
         
         
         List<PHI_Log__c> lstPhiLog = new List<PHI_Log__c>();
         
         PHI_Log__c pLog = new PHI_Log__c();
         pLog.Client_Chart__c = cl.ID;
         PLog.status__c = 'Active';
         PLog.RecordTypeID = Schema.SObjectType.PHI_Log__c.getRecordTypeInfosByName().get('Authorization for Release of Confidential Information').getRecordTypeId();
         PLog.Contact__c = con.ID;
         lstPhiLog.add(pLog);
         
         pLog = new PHI_Log__c();
         pLog.Client_Chart__c = cl.ID;
         PLog.status__c = 'Open';
         PLog.RecordTypeID = Schema.SObjectType.PHI_Log__c.getRecordTypeInfosByName().get('PHI Entry').getRecordTypeId();
         PLog.Contact__c = con.ID;
         lstPhiLog.add(pLog);
         
         pLog = new PHI_Log__c();
         pLog.Client_Chart__c = cl.ID;
         PLog.status__c = 'In Active';
         PLog.RecordTypeID = Schema.SObjectType.PHI_Log__c.getRecordTypeInfosByName().get('Authorization for Release of Confidential Information').getRecordTypeId();
         PLog.Contact__c = con.ID;
         lstPhiLog.add(pLog);
         
         insert lstPhiLog;
         
         
         Test.setCurrentPageReference(new PageReference('/apex/PHILogHomePage'));
         System.currentPageReference().getParameters().put('ID', cl.ID);
    
         PhiLogHomePageController p = new PhiLogHomePageController();
         p.SelectedOption = con.ID+',';
         p.SaveNewLogs();
         p.RedirectSamePage();
         
         
         
         
         
         
         
         
         
       
         test.stopTest();
      }
}