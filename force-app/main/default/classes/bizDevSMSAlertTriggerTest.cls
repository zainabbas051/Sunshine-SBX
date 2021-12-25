@isTest
private class bizDevSMSAlertTriggerTest{
    
    Public static Lead l;
    Public static Lead l2;
    Public static Opportunity o;
    Public static Opportunity o2;
    Public static Account a;
    Public static Account a2;
    Public static Account a3;
    public Static Profile adminProfile;
    public static Trigger_Custom_Setting__c tcs;
    
    public static User userAdmin
    {
        get{
            if (userAdmin == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
                            email='test@key.net', MobilePhone = '+1 5863424795', communityNickname='test0101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id ,
                            LanguageLocaleKey='en_US');
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }
    
    public Static void createSampleData(){
        Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId();
        Id recTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        Group queue = [select id from Group where Name=:'Unassigned Queue' AND Type = 'Queue'];
        
        tcs = new Trigger_Custom_Setting__c();
        tcs.name = 'Default 2';
        tcs.Disable_bizDevSMSAlertTrigger__c = False;
        tcs.Disable_bizDevSMSAlertTriggerOpps__c = False;
        insert tcs;
        
        a = new Account();
        a.Name = 'test account';
        a.OwnerId = userAdmin.id;
        a.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Development').getRecordTypeId();
        a.Type = 'Hospital';
        insert a;
        
        a2 = new Account();
        a2.Name = 'test account';
        a2.Type = 'Insurance Provider';
        insert a2;
        
        a3 = new Account();
        a3.Name = 'test account';
        a3.Type = 'Treatment Center';
        insert a3;
        
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
        l.recordTypeId = leadRecordTypeId;
        l.ownerid = queue.Id;
        l.Test_Class_Checkbox__c = True;
        l.Text_Sent_Queues__c = queue.id;
        l.Invoca_State__c = 'MI';
        l.LeadSource = 'Invoca Call';
        l.Call_Routing__c = 'Monarch Shores';
        l.Inbound_Referral__c = a.id;
        insert l;
        
        l2 = New Lead();
        l2.FirstName = 'Test';
        l2.LastName = 'Test';
        l2.LeadSource = 'Insurance Form';
        l2.Company = 'test';
        l2.Contact_First_Name__c = 'Test';
        l2.Contact_Last_Name__c = 'Test';
        l2.Email='test@test.com';
        l2.recordTypeId = leadRecordTypeId;
        l2.ownerid = queue.Id;
        l2.Test_Class_Checkbox__c = True;
        l2.Text_Sent_Queues__c = queue.id;
        l2.Invoca_State__c = 'MI';
        l2.LeadSource = 'Invoca Call';
        l2.Call_Routing__c = 'Monarch Shores';
        l2.Biz_Dev_Access_Checkbox__c = True;
        insert l2;
        
        o = new Opportunity();
        o.Name = 'test opp';
        o.Account = a;
        o.Selected_Treatment_Center__c = a3.id;
        o.Closing_Agent__c = userAdmin.id;
        o.Amount = 999;
        o.StageName = 'Paid';
        o.CloseDate = date.Today();
        o.recordTypeId = recTypeIdOpp;
        o.Test_Class_Checkbox__c  = true;
        o.cash_client__c = True;//Making sure the opportunity is a Cash CLient, so that VOB is not initiated automatically
        o.Inbound_Referral__c = a.id;
        insert o;
        
        o2 = new Opportunity();
        o2.Name = 'test opp';
        o2.Account = a;
        o2.Selected_Treatment_Center__c = a3.id;
        o2.Closing_Agent__c = userAdmin.id;
        o2.Amount = 999;
        o2.StageName = 'Paid';
        o2.CloseDate = date.Today();
        o2.recordTypeId = recTypeIdOpp;
        o2.Test_Class_Checkbox__c  = true;
        o2.cash_client__c = True;//Making sure the opportunity is a Cash CLient, so that VOB is not initiated automatically
        insert o2;
        
    }
    
    public Static testmethod void bizDevSMSAlertTriggerTest(){
        test.startTest();
        
            createSampleData();          
            
            list<Lead> leadUpdateList = new List<Lead>();
            
            l.Status ='Qualified';
            l.Client_Calling__c = 'Yes';
            l.Heard_About_Us__c = 'NA';
            leadUpdateList.add(l);
            
            l2.Inbound_Referral__c = a.id;
            leadUpdateList.add(l2);
            
            update leadUpdateList;
            
            
                     
    
        test.StopTest();
    }
    
    public Static testmethod void bizDevSMSAlertTriggerOppsTest(){
        test.startTest();
        
            createSampleData();          
            
            list<Opportunity> oppUpdateList = new List<Opportunity>();
            
            o.StageName ='Internal Transfer';
            oppUpdateList.add(o);
            
            o2.Inbound_Referral__c = a.id;
            oppUpdateList.add(o2);
            
            update oppUpdateList;
            
            
                     
    
        test.StopTest();
    }
    
}