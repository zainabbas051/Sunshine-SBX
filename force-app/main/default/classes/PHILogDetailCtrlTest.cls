@isTest
public class PHILogDetailCtrlTest{
    
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
    
     static testMethod void PHILogTest(){
         
          test.startTest();
         system.runAs(userAdmin){
             Account a = new Account();
             a.Name = 'Monarch Shores';
             a.Type = 'Internal Center';
             insert a;
             
             TabViews__c tv = new TabViews__c();
             tv.Name = 'PHILog';
             tv.Button_Access_Type__c = 'Admin';
             insert tv;
             
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
             
             insert lstPhiLog;
             
             awsBucket__c AmazonBucketValue = new awsBucket__c();
            AmazonBucketValue.name='FREEPU';
            AmazonBucketValue.accessKeyId__c='testAcess';
            AmazonBucketValue.secretAccessKey__c='secretKey';
            AmazonBucketValue.Bucket__c='freepu';
            insert AmazonBucketValue;
               
             Test.setCurrentPageReference(new PageReference('/apex/PHILogDetail'));
             System.currentPageReference().getParameters().put('ID', cl.ID);
             System.currentPageReference().getParameters().put('PHIID', lstPhiLog[0].ID);
        
             PHILogDetailCtrl p = new PHILogDetailCtrl();
             p.SelectedSignedOption = 'staff';
             p.Cloning();
             p.submit();
             p.ActivePHILog();
             p.SelectedSignedOption = 'Patient';
             p.ActivePHILog();
             p.InActive();
             Boolean Flag = p.buttonAccessType;
             PageReference pr = p.AddAttachment();
             
             cl.Client_Status__c = 'Discharged';
             update cl;
             
             PHILogDetailCtrl p2 = new PHILogDetailCtrl();
         }
         test.stopTest();
         
     }
}