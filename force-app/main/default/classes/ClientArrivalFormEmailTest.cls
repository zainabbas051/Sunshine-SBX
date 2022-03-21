@isTest
private class ClientArrivalFormEmailTest{
    
    Public static Account a;
    Public Static Account sunshineCenter;
    Public static Opportunity o;
    public Static Profile adminProfile;
    public Static Client_Arrival_Form_Emails__c cafe;
    
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
        
        Id recTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId(); 
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;

        account acc = new Account();
        acc.Name = 'test account';
        acc.Type = 'Customer';
        insert acc;
        
        sunshineCenter = new Account();
        sunshineCenter.Name = 'Monarch Shores';
        sunshineCenter.Type = 'Internal Center';
        insert sunshineCenter;
        
        o = new Opportunity();
        o.Name = 'test opp';
        o.Accountid = acc.id;
        o.email__c = 't@t.com';
        o.Sunshine_Center__c = sunshineCenter.id;
        o.Selected_Treatment_Center__c = a.id;
        o.Closing_Agent__c = userAdmin.id;
        o.Amount = 999;
        o.StageName = 'Paid';
        o.LeadSource='Biz Dev';
        o.CloseDate = date.Today();
        o.RecordTypeId = recTypeIdOpp;
        o.Reason_not_admitted_to_Sunshine_Center__c = 'Acuity- Medical';
        o.Arrival_Date_Time__c = dateTime.Now();
        insert o;
        
        cafe = new Client_Arrival_Form_Emails__c();
        cafe.Name = 'test@test.com';
        cafe.Sunshine_Center__c = 'Monarch Shores';
        insert cafe;


    }

    public Static void createSampleData2(){
        
        Id recTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId(); 
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;

        account acc = new Account();
        acc.Name = 'test account';
        acc.Type = 'Customer';
        insert acc;
        
        sunshineCenter = new Account();
        sunshineCenter.Name = 'Monarch Shores';
        sunshineCenter.Type = 'Internal Center';
        insert sunshineCenter;
        
        o = new Opportunity();
        o.Name = 'test opp';
        o.Accountid = acc.id;
        o.email__c = 't@t.com';
        o.Sunshine_Center__c = sunshineCenter.id;
        o.Selected_Treatment_Center__c = a.id;
        o.Closing_Agent__c = userAdmin.id;
        o.Amount = 999;
        o.StageName = 'Paid';
        o.LeadSource='Biz Dev';
        o.CloseDate = date.Today();
        o.RecordTypeId = recTypeIdOpp;
        o.Reason_not_admitted_to_Sunshine_Center__c = 'Acuity- Medical';
        o.Arrival_Date_Time__c = dateTime.Now();
        insert o;
        
        cafe = new Client_Arrival_Form_Emails__c();
        cafe.Name = 'test@test.com';
        cafe.Sunshine_Center__c = 'Monarch Shores';
        insert cafe;

        Alumni_App_Detail__c appDetToCreate = new Alumni_App_Detail__c();
        appDetToCreate.Username__c = o.email__c;
        appDetToCreate.User_Email__c = o.email__c;
        appDetToCreate.Password__c = 'Pa$$word';
        appDetToCreate.Account__c = o.AccountId;
        appDetToCreate.Current_Opportunity_Closed_Date__c = o.CloseDate;
        insert appDetToCreate;


    }
    
     public Static testmethod void claimInvocaCallByQCTest(){
        test.startTest();
        
        createSampleData();
        
        String returnString = ClientArrivalFormEmail.ClientArrivalFormEmail(o.id);
        test.StopTest();
    }

    public Static testmethod void claimInvocaCallByQCTest2(){
        test.startTest();
        
        createSampleData2();
        
        String returnString = ClientArrivalFormEmail.ClientArrivalFormEmail(o.id);
        test.StopTest();
    }
}