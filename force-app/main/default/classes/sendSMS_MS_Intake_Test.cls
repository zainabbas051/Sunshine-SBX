@isTest
private class sendSMS_MS_Intake_Test{
    
    Public static Lead l;
    Public static User u_test;
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
                            LanguageLocaleKey='en_US');
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }
     
     public Static void createSampleData(){
        
        Id recTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
        l = New Lead();
        l.FirstName = 'Test';
        l.LastName = 'Test';
        l.LeadSource = 'Insurance Form';
        l.Company = 'test';
        l.Subscriber_Last_Name__c = 'Test';
        l.Subscriber_First_Name__c = 'Test';
        l.Contact_First_Name__c = 'Test';
        l.Contact_Last_Name__c = 'Test';
        l.Subscriber_DOB_Text__c = '2014-01-12';
        l.Email='test@test.com';
        l.recordTypeId = recTypeId;
        //l.ownerid = '00GU0000001M4VD';
        insert l;
        
        
        
     } 
    
     public Static testmethod void testsendSMStoLeadQueueMembers(){
         test.startTest();       
         system.runAs(userAdmin){                         
            
             createSampleData();
           
             l.OwnerId = label.Intake_Queue_ID;
             TriggerContextUtility.firstRun = true;
             l.Status = 'Open';
             l.Test_Class_Checkbox__c = true;
            
             update l;
        }
        test.stopTest();
    }
}