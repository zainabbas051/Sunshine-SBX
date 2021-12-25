@isTest(seeAllData=true)
private class MarketingSupportCaseNotificationTest{

    Public static Case caseRec;
   
    Public Static testmethod void OutboundSMSOnCasesTest(){
        test.startTest();
           
            caseRec= new Case();
            caseRec.RecordTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Marketing Support Case').getRecordTypeId(); 
            caseRec.SuppliedName = 'Naveen Chugh';  
            insert caseRec; 

        test.StopTest();
    }          
}