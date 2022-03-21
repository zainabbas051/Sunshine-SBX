@isTest
private class OpportunitySelector_Test {
    @TestSetup 
    static void createData() {
      
        Account a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Treatment Center';
        insert a;
        
        Account a1 = new Account();
        a1.Name = 'Monarch Shores';
        a1.Type = 'Internal Center';
        insert a1;
        
        Contact con = new Contact();
        con.Email = 'test@abc.com';
        con.AccountId = a.Id;
        con.LastName = 'test';
        insert con;
        
        Schema.DescribeSObjectResult opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Monarch Shores').getRecordTypeId(); 
        
        Opportunity oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = recTypeIdOpp;
        oms.AccountId = a.id;
        oms.Selected_Treatment_Center__c = a.id;
        oms.Closing_Agent__c = UserInfo.getUserId();
        oms.Amount = 999;
        oms.StageName = 'Admitted';
        oms.CloseDate = date.Today();
        oms.Test_Class_Checkbox__c = True;
        oms.Sunshine_Center__c = a1.Id;
        oms.Email__c = 'test@abc.com';
        insert oms;
    
    }

    public Static testmethod void testMethod1(){
        test.startTest();

        OpportunitySelector.getOpportunities();
        OpportunitySelector.getOpportunitiesWithPaymentPlan(new Set<Id>());
        test.stopTest();
    }
}