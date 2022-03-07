@isTest
public with sharing class PaymentCollectionCntr_Test {

    @TestSetup 
    static void createData() {
        
        Account a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Internal Center';
        insert a;

        Account a1 = new Account();
        a1.Name = 'Monarch Shores';
        a1.Type = 'Treatment Center';
        insert a1;
        
        Schema.DescribeSObjectResult opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Monarch Shores').getRecordTypeId(); 
        
        Employee__c emp = new Employee__c();
        emp.Name = 'Test Supervisor';
        emp.Sunshine_Center_Relation_To__c = a.id;
        emp.Sunshine_Center_Access__c = 'Monarch Shores';
        insert emp;

        Opportunity oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = recTypeIdOpp;
        oms.Account = a;
        oms.Selected_Treatment_Center__c = a1.id;
        oms.Closing_Agent__c = UserInfo.getUserId();
        oms.Amount = 999;
        oms.StageName = 'Working';
        oms.CloseDate = date.Today();
        oms.Test_Class_Checkbox__c = True;
        oms.Sunshine_Center__c = a.id;
        insert oms;
        
        Payment_Plan__c ppRecord = new Payment_Plan__c();
        ppRecord.Opportunity__c = oms.id;
        ppRecord.Start_Date__c = date.Today().addDays(-60);
        ppRecord.Total_Amount_To_Be_Collected__c = 1000;
        ppRecord.Payment_Plan_Type__c = 'Custom';
        insert ppRecord;
        
        Payment_Plan_Line_Items__c ppl = new Payment_Plan_Line_Items__c();
        ppl.Type_of_Collection__c = 'Housing';
        ppl.Payment_Plan__c = ppRecord.Id;
        ppl.Status__c = 'Open';
        ppl.Due_Date__c = Date.today().addDays(-30);
        insert ppl;
        
        Payment_Plan_Line_Items__c ppll = new Payment_Plan_Line_Items__c();
        ppll.Type_of_Collection__c = 'Housing';
        ppll.Payment_Plan__c = ppRecord.Id;
        ppll.Status__c = 'Open';
        ppll.Due_Date__c = Date.today().addDays(-30);
        insert ppll;
        
        Card_Information__c ci = new Card_Information__c();
        ci.Card_Number__c = '123';
        ci.Name_on_Card__c = 'Safia';
        ci.Payment_Plan__c = ppRecord.Id;
        ci.Expiration_Year__c = '2024';
        ci.Expiration_Month__c = '02';
        ci.Active__c = true;
        insert ci;
    }


    static testMethod void testMethod1(){
        Opportunity oppty = [Select id from opportunity limit 1];
        List<Payment_Plan_Line_Items__c> ppli = [Select id, Status__c,Payment_Plan__c, Amount_For_Collection__c, Sunshine_Center__c from Payment_Plan_Line_Items__c  where Status__c = 'Open' limit 1];
        Card_Information__c ci=[Select id,Card_Number__c,Name_on_Card__c,Payment_Plan__c,Expiration_Year__c,Expiration_Month__c from Card_Information__c where Payment_Plan__c =:ppli[0].Payment_Plan__c limit 1 ];
        Employee__c emp = [select id, Sunshine_Center_Relation_To__c, Sunshine_Center_Access__c from Employee__c ];
        PaymentCollection_Cntr.returnPaymentData(oppty.id);
        PaymentCollection_Cntr.returnPaymentLineItem(oppty.id);
        PaymentCollection_Cntr.saveCard(ppli[0].Payment_Plan__c, '4242424242424242', 'test', '12', '28', '111');
        PaymentCollection_Cntr.returnSelectedCard(ci.Card_Number__c, oppty.id);
        PaymentCollection_Cntr.processPayment(oppty.id, 'fileName', ci.Card_Number__c, '111', 100);
        PaymentCollection_Cntr.processPdf(new List<string> { ppli[0].Id });
        PaymentCollection_Cntr.retExsCardInfoList(oppty.id);
        //PaymentCollection_Cntr.createPaymentLineItem(oppty.id, 100);
        system.debug(ppli[0].Sunshine_Center__c);

    }
}