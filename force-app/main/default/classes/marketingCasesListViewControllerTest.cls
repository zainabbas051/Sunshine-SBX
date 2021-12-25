@isTest(seeAllData=True)
private class marketingCasesListViewControllerTest{
    
    public Static testmethod void test_marketingCasesListViewController(){
        test.startTest();
            
            Case c = new Case();
            c.Type = 'Problem';
            c.Subject = 'Test';
            c.Description = 'Test';
            c.Source_URL__c = 'www.google.com';
            c.Source_Website__c = 'Sunshine';
            c.SuppliedName = 'Naveen Chugh';
            c.SuppliedEmail = 'naveenc@sunshinebh.com';
            c.Status='Open';
            c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Marketing Support Case').getRecordTypeId();
            insert c;
            
            marketingCasesListViewController mclv = new marketingCasesListViewController();
            
            List<SelectOption> so1 = new List<SelectOption> ();
            so1 = mclv.getStatus();
            
            PageReference pr = mclv.caseDetailRedirect();
            mclv.redirectCaseId = c.id;
            PageReference pr2 = mclv.caseDetailRedirect();
            
        test.stopTest();
    }

}