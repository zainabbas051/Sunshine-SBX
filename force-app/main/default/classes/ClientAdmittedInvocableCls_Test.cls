@isTest
public without sharing class ClientAdmittedInvocableCls_Test {
    
    @isTest
    public static void InvocableMethod_Success(){
        Id recTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId(); 
        
        Account a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;

        account acc = new Account();
        acc.Name = 'test account';
        acc.Type = 'Customer';
        insert acc;
        
        Account sunshineCenter = new Account();
        sunshineCenter.Name = 'Monarch Shores';
        sunshineCenter.Type = 'Internal Center';
        insert sunshineCenter;
        
        Opportunity o = new Opportunity();
        o.Name = 'test opp';
        o.Accountid = acc.id;
        o.email__c = 't@t.com';
        o.Sunshine_Center__c = sunshineCenter.id;
        o.Selected_Treatment_Center__c = a.id;
        o.Closing_Agent__c = UserInfo.getUserId();
        o.Amount = 999;
        o.StageName = 'Paid';
        o.LeadSource='Biz Dev';
        o.CloseDate = date.Today();
        o.RecordTypeId = recTypeIdOpp;
        o.Reason_not_admitted_to_Sunshine_Center__c = 'Acuity- Medical';
        o.Arrival_Date_Time__c = dateTime.Now();
        insert o;
        
        Client_Arrival_Form_Emails__c cafe = new Client_Arrival_Form_Emails__c();
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

        App_Detail_History__c appHisToCreate = new App_Detail_History__c();
        appHisToCreate.Opportunity__c = o.Id;
        appHisToCreate.Alumni_App_Detail__c = appDetToCreate.id;

        insert appHisToCreate;

        ClientAdmittedInvocableCls.ActionRequest request = new ClientAdmittedInvocableCls.ActionRequest();
        request.accId = o.accountId;
        request.oppId = o.id;

        ClientAdmittedInvocableCls.invokeService(new List<ClientAdmittedInvocableCls.ActionRequest> {request});
    }
}
