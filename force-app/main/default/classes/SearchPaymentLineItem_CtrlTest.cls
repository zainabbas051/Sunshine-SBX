@isTest
private class SearchPaymentLineItem_CtrlTest{

    @testSetup static void createData() {
    
        Account a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        Schema.DescribeSObjectResult acc = Schema.SObjectType.Account;
        Map<String, Schema.RecordTypeInfo> rtMapByNameAcc = acc.getRecordTypeInfosByName();
        Id accRecType = rtMapByNameAcc.get('Business Development').getRecordTypeId(); 
        
        Account sunShine = new Account();
        sunShine.Name = 'Monarch Shores';
        sunShine.RecordTypeId = accRecType;
        sunShine.Type = 'Internal Center';
        insert sunShine;
        
        
        Schema.DescribeSObjectResult opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Monarch Shores').getRecordTypeId(); 
        
        Opportunity oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = recTypeIdOpp;
        oms.Account = a;
        oms.Selected_Treatment_Center__c = a.id;
        oms.Closing_Agent__c = UserInfo.getUserId();
        oms.Amount = 999;
        oms.StageName = 'Working';
        oms.CloseDate = date.Today();
        oms.Test_Class_Checkbox__c = True;
        oms.Sunshine_Center__c = sunShine.Id;
        insert oms;
        
        Payment_Plan__c  ppRecord = new Payment_Plan__c();
        ppRecord.Opportunity__c = oms.id;
        ppRecord.Start_Date__c = date.Today();
        ppRecord.Total_Amount_To_Be_Collected__c = 1000;
        ppRecord.Payment_Plan_Type__c = 'Custom';
        insert ppRecord;
        
         Payment_Plan_Line_Items__c ppli = new Payment_Plan_Line_Items__c();
        ppli.Payment_Plan__c = ppRecord.id;
        ppli.Collection_Reference_ID__c = '123';
        ppli.Status__c = 'Cash Collected';
        ppli.Actual_Mode_of_Collection__c = 'Cash';
        
        insert ppli;
 
    }

    public Static testmethod void testMethod1(){
         test.startTest();
         SearchPaymentLineItem_Ctrl.fetchUser();
         SearchPaymentLineItem_Ctrl.PaymentLineWrapper ppli = SearchPaymentLineItem_Ctrl.getPaymentLineItem('123','Monarch Shores')[0];
         string jsonStr = JSON.serialize(ppli);
         SearchPaymentLineItem_Ctrl.saveRecord(jsonStr);
         test.stopTest();
   }
}