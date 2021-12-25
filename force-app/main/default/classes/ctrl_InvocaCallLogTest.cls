@isTest
public class ctrl_InvocaCallLogTest
{
    
     static testMethod void testMethod1()
    {
        Test.startTest();
            
            Id recTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId(); 
        
        
        Lead l = New Lead();
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
        insert l;
        
        INVOCA_FOR_SF__Invoca_Call_Log__c icl = new INVOCA_FOR_SF__Invoca_Call_Log__c();
        icl.INVOCA_FOR_SF__Lead__c = l.id;
        icl.INVOCA_FOR_SF__pool_referrer_param5_value__c = '12345';
        icl.INVOCA_FOR_SF__transaction_id__c = '123';
        icl.INVOCA_FOR_SF__recording__c = 'http:www.google.com';
        insert icl;
        Profile prof = [select id from profile where name LIKE '%Custom - Digital Marketing User%'];
        User user = new User();
        user.firstName = 'test1';
        user.lastName = 'test2';
        user.profileId = prof.id;
        user.username = 'testSafia@test.com';
        user.email = 'test@test.com';
        user.alias = 'FLast';
        user.TimeZoneSidKey='America/New_York';
        user.LocaleSidKey='en_US';
        user.EmailEncodingKey='ISO-8859-1'; 
                            user.LanguageLocaleKey='en_US'; 
                            user.User_Role__c = NULL;
        insert user;
        
        Test.setCurrentPageReference(new PageReference('Page.CallLog_Vfp')); 
        System.currentPageReference().getParameters().put('callLogId', icl.Id); 
        system.runAs(user){
        ctrl_InvocaCallLog ct = new ctrl_InvocaCallLog();
        ct.Redirect();
        }
            
        Test.stopTest();
    }
}