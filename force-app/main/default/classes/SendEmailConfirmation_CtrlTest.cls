@isTest
private class SendEmailConfirmation_CtrlTest{

    @testSetup static void createData() {
    
        Account a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
         Account a1 = new Account();
        a1.Name = 'test account1';
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
        oms.StageName = 'Working';
        oms.CloseDate = date.Today();
        oms.Test_Class_Checkbox__c = True;
        oms.Sunshine_Center__c = a1.Id;
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
        ppli.Type_of_Collection__c = 'Housing';
        ppli.Email_Address_of_Person_Responsible__c = 'test@abc.com';
        //ppli.Status__c = 'Closed';
        
        insert ppli;
        
        Task t = new Task();
        t.Status = 'Open';
        t.Payment_Plan_Line_Items__c = ppli.Id;
        insert t;
        
        ppli.Status__c = 'Closed';
        update ppli;
        
        
 
    }

    public Static testmethod void testMethod1(){
         test.startTest();
         Payment_Plan_Line_Items__c ppli = [Select id from Payment_Plan_Line_Items__c limit 1];
         ApexPages.currentPage().getParameters().put('id',ppli.Id);
         SendEmailConfirmation_Ctrl s  = new SendEmailConfirmation_Ctrl();
          s.updateRecord();
          SendEmailConfirmation_PdfCtrl spdf= new SendEmailConfirmation_PdfCtrl();
         spdf.showRecord();
        
         test.stopTest();
   }
}