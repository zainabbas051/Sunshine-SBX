@isTest
private class updateGCLID_OnLeadsTest{
    
    Public static INVOCA_FOR_SF__Invoca_Call_Log__c call;
    Public static INVOCA_FOR_SF__Invoca_Call_Log__c call2;
    Public Static Lead l;
    Public static Account a;
    Public Static Opportunity oms;
    
    public Static Profile adminProfile;
    public Static Trigger_Custom_Setting__c tcs;
    
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
        
        tcs = new Trigger_Custom_Setting__c();
        tcs.Name = 'Default';
        tcs.Disable_updateGCLID_OnLeads__c  = false;
        insert tcs;
        
        Id msRecTypeIdOpp = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
        Group queue = [select id from Group where Name=:'Unassigned Queue' AND Type = 'Queue'];
        
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
        l.recordTypeId = msRecTypeIdOpp;
        l.ownerid = queue.Id;
        l.Test_Class_Checkbox__c = True;
        l.Text_Sent_Queues__c = queue.id;
        l.Invoca_State__c = 'MI';
        l.LeadSource = 'Invoca Call';
        l.Call_Routing__c = 'Monarch Shores';
        insert l;
        
         a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        
        Schema.DescribeSObjectResult opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Monarch Shores').getRecordTypeId(); 
        
        oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = recTypeIdOpp;
        oms.Account = a;
        oms.Selected_Treatment_Center__c = a.id;
        oms.Closing_Agent__c = userAdmin.id;
        oms.Amount = 999;
        oms.StageName = 'Working';
        oms.CloseDate = date.Today();
        oms.Test_Class_Checkbox__c = True;
        insert oms;
        
        call = New INVOCA_FOR_SF__Invoca_Call_Log__c();
        call.INVOCA_FOR_SF__transaction_id__c = '1234';
        call.INVOCA_FOR_SF__Lead__c = l.id;
        call.INVOCA_FOR_SF__Customer_String_Name_4__c = 'gclid';
        call.INVOCA_FOR_SF__Customer_String_Value_4__c = '12345';
        call.INVOCA_FOR_SF__Customer_Business_Object_Name_4__c ='shortcode_type';
        insert call;
        
        call2 = New INVOCA_FOR_SF__Invoca_Call_Log__c();
        call2.INVOCA_FOR_SF__transaction_id__c = '12345';
        insert call2;
    }
    
    public Static testmethod void updateGCLID_OnLeads(){
        test.startTest();
        
        createSampleData();     
        call2.INVOCA_FOR_SF__Lead__c = l.id;
       
        call2.INVOCA_FOR_SF__Customer_String_Name_4__c = 'gclid';
        call2.INVOCA_FOR_SF__Customer_Business_Object_Name_4__c ='shortcode_type';
        call2.INVOCA_FOR_SF__Customer_String_Value_4__c = '12345';
        update call2; 
        
        call2.INVOCA_FOR_SF__Opportunity__c = oms.id;
        call2.INVOCA_FOR_SF__Customer_Business_Object_Name_4__c ='shortcode_type';
        call2.INVOCA_FOR_SF__Customer_Business_Object_Value_4__c='test123';
        update call2;
        
        test.StopTest();
    }
}