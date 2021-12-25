@isTest
private class createTaskTest{
    
    Public static INVOCA_FOR_SF__Invoca_Call_Log__c call;
    Public Static Account a;
    Public Static Contact c;
    Public Static Opportunity o;
    Public Static Lead l;
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
        
        Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId(); 
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        c = new Contact();
        c.AccountId = a.id;
        c.LastName = 'test';
        insert c;
        
        o = new Opportunity();
        o.Name = 'test opp';
        o.AccountId = a.id;
        o.Selected_Treatment_Center__c = a.id;
        o.Closing_Agent__c = userAdmin.id;
        o.Amount = 999;
        o.StageName = 'Paid';
        o.CloseDate = date.Today();
        o.recordTypeId = oppRecordTypeId;
        insert o;
        
        l= new Lead();
        l.LastName = 'Chugh';
        l.Phone = '5863424795';
        l.Email = '5863424795@invoca.net';
        l.Company = 'Chugh';
        l.LeadSource = 'Addiction Network';
        insert l;
        
        
    }
    
    public Static testmethod void callLogInsert(){
        test.startTest();
        
        createSampleData();     
            call = New INVOCA_FOR_SF__Invoca_Call_Log__c();
            call.INVOCA_FOR_SF__pool_referrer_param5_value__c = '123456';
            call.INVOCA_FOR_SF__Lead__c = l.id;
            call.INVOCA_FOR_SF__transaction_id__c = '123';
            insert call;           
    
        test.StopTest();
    }
    
    public Static testmethod void callLogUpdate(){
        test.startTest();
        
        createSampleData();     
            call = New INVOCA_FOR_SF__Invoca_Call_Log__c();
            call.INVOCA_FOR_SF__Lead__c = l.id;
            call.INVOCA_FOR_SF__transaction_id__c = '123';
            insert call;           
    
            call.INVOCA_FOR_SF__pool_referrer_param5_value__c = '123456';
            update call;
        test.StopTest();
    }
    
    public Static testmethod void callLogInsert2(){
        test.startTest();
        
        createSampleData();     
            call = New INVOCA_FOR_SF__Invoca_Call_Log__c();
            call.INVOCA_FOR_SF__pool_referrer_param5_value__c = '123456';
            call.INVOCA_FOR_SF__Lead__c = l.id;
            call.INVOCA_FOR_SF__Opportunity__c = o.id;
            call.INVOCA_FOR_SF__transaction_id__c = '123';
            insert call;           
    
        test.StopTest();
    }
    
    public Static testmethod void callLogUpdate2(){
        test.startTest();
        
        createSampleData();     
            call = New INVOCA_FOR_SF__Invoca_Call_Log__c();
            call.INVOCA_FOR_SF__Lead__c = l.id;
            call.INVOCA_FOR_SF__Opportunity__c = o.id;
            call.INVOCA_FOR_SF__transaction_id__c = '123';
            insert call;           
    
            call.INVOCA_FOR_SF__pool_referrer_param5_value__c = '123456';
            update call;
        test.StopTest();
    }
}