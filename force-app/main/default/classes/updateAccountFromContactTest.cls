@isTest
private class updateAccountFromContactTest{
    
    Public static INVOCA_FOR_SF__Invoca_Call_Log__c call;
    Public Static Account a;
    Public Static Contact c;
    Public Static Opportunity o;
    Public Static Opportunity oms;
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
        
        Id erpRecTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId(); 
        Id msRecTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
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
        o.recordTypeId = erpRecTypeIdOpp;
        insert o;
        
        oms = new Opportunity();
        oms.Name = 'test opp';
        oms.AccountId = a.id;
        oms.Selected_Treatment_Center__c = a.id;
        oms.Closing_Agent__c = userAdmin.id;
        o.Amount = 999;
        oms.StageName = 'Paid';
        oms.CloseDate = date.Today();
        oms.recordTypeId = msRecTypeIdOpp;
        insert oms;
        
        call = New INVOCA_FOR_SF__Invoca_Call_Log__c();
        call.INVOCA_FOR_SF__transaction_id__c = '123456';
        //call.INVOCA_FOR_SF__Contact__c = c.id;
        insert call;
    }
    
    public Static testmethod void ClaimInvocaCallTest(){
        test.startTest();
        
        createSampleData();     
        call.INVOCA_FOR_SF__Contact__c = c.id;
        call.INVOCA_FOR_SF__advertiser_name__c = 'Monarch Shores';
        update call; 
        
        call.INVOCA_FOR_SF__Contact__c = c.id;
        call.INVOCA_FOR_SF__advertiser_name__c = 'Elite Rehab Placement';
        update call;   
        
        checkRecursive_updateAccountFromContact.runOnce();           
    
        test.StopTest();
    }
}