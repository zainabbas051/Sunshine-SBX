@isTest(seeAllData=True)
private class claimInvocaCallByQCTest{
    
    Public static INVOCA_FOR_SF__Invoca_Call_Log__c call;
    public Static ApexPages.StandardController claimCallByQCController;
    public Static claimInvocaCallByQC callClass;
    
    public Static void createSampleData(){
        
        call = New INVOCA_FOR_SF__Invoca_Call_Log__c();
        call.INVOCA_FOR_SF__transaction_id__c = 'abcdefgh';
        insert call;
    }
    
    public Static testmethod void claimInvocaCallByQCTest(){
        test.startTest();
        
        createSampleData();
        
        User u = [select id, Name from User Where (Profile.Name=:'Custom - CSR' OR Profile.Name=:'Custom - Monarch Shores - CSR') AND isActive=: True LIMIT 1];
        
        claimCallByQCController = new ApexPages.StandardController(call);
        callClass = new claimInvocaCallByQC(claimCallByQCController); 
        ApexPages.currentPage().getParameters().put('Id', call.id);
        
        List<SelectOption> so = new List<SelectOption>();
        so = callClass.getItems();
        
        callClass.setClosingAgent(u.id);
        
        callClass.claimCallQC();
        callClass.cancel1();          
        
        test.StopTest();
    }
}