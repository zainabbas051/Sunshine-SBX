@isTest
private class PaymentLineItemCreationBatch_Test {
    
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
        
        KIPU_Chart_Audit__c kipu = new KIPU_Chart_Audit__c();
        kipu.Opportunity__c = oms.Id;
        insert kipu;

        Level_of_Care_History__c levelOfCare = new Level_of_Care_History__c();
        levelOfCare.End_Date__c = Date.Today().addDays(10);
        levelOfCare.Start_Date__c = Date.Today().addDays(-1);
        levelOfCare.Number_of_Days_in_PHP_IOP__c = 60;
        levelOfCare.Level_of_Care__c = 'PHP';
        levelOfCare.KIPU_Chart_Audit__c = kipu.Id;
        insert levelOfCare;

        Payment_Plan__c  ppRecord = new Payment_Plan__c();
        ppRecord.Opportunity__c = oms.id;
        ppRecord.Start_Date__c = date.Today();
        ppRecord.Total_Amount_To_Be_Collected__c = 1000;
        ppRecord.Payment_Plan_Type__c = 'Custom';
        insert ppRecord;
        
        Payment_Plan_Line_Items__c ppli = new Payment_Plan_Line_Items__c();
        ppli.Payment_Plan__c = ppRecord.id;
        ppli.Collection_Reference_ID__c = '123';
        ppli.Type_of_Collection__c = 'Housing';
        ppli.Email_Address_of_Person_Responsible__c = 'test@abc.com';
        ppli.Status__c = 'Open';
        ppli.KIPU_Chart_Audit__c = kipu.Id;
        insert ppli;

        Sunshine_Center_Id__c sunshineCs = new Sunshine_Center_Id__c();
        sunshineCs.Name = 'Monarch Shores';
        sunshineCs.SendPaymentNotificationSMS__c = true;
        sunshineCs.SendPaymentNotificationEmail__c = true;
        insert sunshineCs;
    }

    public Static testmethod void testMethod1(){
        test.startTest();

        PaymentLineItemCreation_Batch b = new PaymentLineItemCreation_Batch('contact.admissions@sunshinebh.com');
        Database.executeBatch(b);
        test.stopTest();
    }

    public Static testmethod void testMethod2(){
        test.startTest();

        String sch = '0 0 2 * * ?'; 
        PaymentLineItemCreation_Schd sh1 = new PaymentLineItemCreation_Schd ();
        system.schedule('PaymentLineItemCreation_Schd', sch, sh1); 
        
        test.stopTest();
    }

    public Static testmethod void testMethod3(){
        test.startTest();
        delete [SELECT ID FROM Payment_Plan_Line_Items__c];
        PaymentLineItemCreation_Batch b = new PaymentLineItemCreation_Batch('contact.admissions@sunshinebh.com');
        Database.executeBatch(b);
        test.stopTest();
    }

    public Static testmethod void testMethod4(){
        test.startTest();
        delete [SELECT ID FROM Payment_Plan_Line_Items__c];
        delete [SELECT ID FROM Payment_Plan__c];
        PaymentLineItemCreation_Batch b = new PaymentLineItemCreation_Batch('contact.admissions@sunshinebh.com');
        Database.executeBatch(b);
        test.stopTest();
    }

}