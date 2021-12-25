@isTest
public class bizibleIdUpdateFromInvocaCallLogTest
{
    Public static task t;
    Public static lead l;
    Public static INVOCA_FOR_SF__Invoca_Call_Log__c icl;
    public Static Profile adminProfile;
    
    public static void createSampleData(){
        
        Id recTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId(); 
        
        
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
        insert l;
        
        icl = new INVOCA_FOR_SF__Invoca_Call_Log__c();
        icl.INVOCA_FOR_SF__Lead__c = l.id;
        icl.INVOCA_FOR_SF__pool_referrer_param5_value__c = '12345';
        icl.INVOCA_FOR_SF__transaction_id__c = '123';
        insert icl;
        
        t = new Task();
        t.Subject = 'Invoca Call Log';
        //t.WhoId = l.Id;
        insert t;    
        
        Trigger_Custom_Setting__c tcs = new Trigger_Custom_Setting__c();
        tcs.Name = 'Default';
        tcs.Disable_bizibleIdUpdate__c = False;
        insert tcs;    
    }
    
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
    
    
    
    static testMethod void testMethod1()
    {
        Test.startTest();
            
            createSampleData();
            
            checkRecursive_bizibleIdUpdate.run = True;
            t.WhoId = l.Id;
            update t;  
            
        Test.stopTest();
    }
    
    

}