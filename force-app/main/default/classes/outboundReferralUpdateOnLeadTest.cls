@isTest
private class outboundReferralUpdateOnLeadTest{
    
    Public static Lead l;
    Public static Opportunity o_erp;
    Public static Account a;
    Public static Account a2;
    public Static Profile adminProfile;
    PUBLIC static Trigger_Custom_Setting__c tcs;

    public Static void createSampleData(){
        
        Id recTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId(); 
        
        Id recTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
        Id recTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Development').getRecordTypeId(); 
        
        Group queue = [select id from Group where Name=:'Unassigned Queue' AND Type = 'Queue'];
        
        tcs = new Trigger_Custom_Setting__c();
        tcs.Name = 'Default';
        tcs.Disable_msInsuranceCaseOwnerUpdate__c = False;
        tcs.Disable_attachInsurance__c = False;
        tcs.Disable_updateCaseOwner__c = False;
        tcs.Disable_OpportunityupdateFirstBilledTrig__c  = false;
        tcs.Disable_outboundReferralUpdateOnLead__c  = false;
        insert tcs;
        
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
        l.ownerid = queue.Id;
        l.Test_Class_Checkbox__c = True;
        l.Text_Sent_Queues__c = queue.id;
        l.Invoca_State__c = 'MI';
        l.LeadSource = 'Invoca Call';
        l.Call_Routing__c = 'Monarch Shores';
        insert l;
        
        a2 = new Account();
        a2.Name = 'test account';
        a2.Type = 'Mental Health';
        a2.RecordTypeId= recTypeIdAcc;
        insert a2;
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        o_erp = new Opportunity();
        o_erp.Name = 'test opp';
        o_erp.Account = a;
        o_erp.Selected_Treatment_Center__c = a.id;
        o_erp.Closing_Agent__c = userAdmin.id;
        o_erp.Amount = 999;
        o_erp.StageName = 'Paid';
        o_erp.CloseDate = date.Today();
        o_erp.recordTypeId = recTypeIdOpp;
        o_erp.Test_Class_Checkbox__c  = true;
        o_erp.Cash_Client__c = False;
        o_erp.Insurance_Providers__c= 'Spectra';
        o_erp.Lead_Id__c = l.id;
        insert o_erp;
        
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

    
    public Static testmethod void outboundInboundReferralUpdateTest(){
        test.startTest();
        
        createSampleData();          
            o_erp.Outbound_Referral__c = a2.id;
            o_erp.Inbound_Referral__c = a2.id;
            update o_erp; 
            
            
        test.StopTest();
    }
    
    public Static testmethod void inboundReferralUpdateTest(){
        test.startTest();
        
        createSampleData();          
            
            o_erp.Inbound_Referral__c = a2.id;
            update o_erp;           
    
        test.StopTest();
    }
}