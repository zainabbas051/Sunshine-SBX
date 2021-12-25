@isTest(seeAllData=True)
private class marketingCasesControllerTest{
    
    public Static testmethod void test_marketingCasesController(){
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
            
            
            apexPages.currentPage().getParameters().put('id',c.id);
            marketingCasesController mcc = new marketingCasesController();
            
            List<SelectOption> so1 = new List<SelectOption> ();
            List<SelectOption> so2 = new List<SelectOption> ();
            List<SelectOption> so3 = new List<SelectOption> ();
            so1 = mcc.getStatuses();
            so2 = mcc.getTypes();
            so3 = mcc.getReasons();
            
            mcc.editCase();
            mcc.editCaseSave();
            mcc.closeCase();
            mcc.closeCaseSave();
            
            
        test.stopTest();
    }

}