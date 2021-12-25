@isTest(seeAllData=True)
private class marketingCasesNewCaseControllerTest{
    
    public Static testmethod void test_marketingCasesNewCaseController(){
        test.startTest();
            marketingCasesNewCaseController mcnc = new marketingCasesNewCaseController();
            mcnc.createCase();
            
            mcnc.caseSubject = 'Test';
            mcnc.caseDescription = 'Test';
            mcnc.caseSourceURL = 'Test';
            mcnc.caseReportedBy = 'Test';
            mcnc.caseReportedByEmail = 'Test';
            mcnc.caseReportedByPhone = 'Test';
            
            mcnc.createCase();
            
            mcnc.caseReportedByEmail = 'test@gmail.com';
            mcnc.createCase();
            
            List<SelectOption> so1 = new List<SelectOption> ();
            List<SelectOption> so2 = new List<SelectOption> ();
            so1 = mcnc.getWebsites();
            so2 = mcnc.getTypes();
            
        test.stopTest();
    }

}