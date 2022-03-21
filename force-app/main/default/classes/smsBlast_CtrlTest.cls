@isTest
private class smsBlast_CtrlTest{

    @testSetup static void createData() {
    
        Account a = new Account();
        a.Name = 'test account';
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
        oms.Phone__c = '123';
        insert oms;
 
    }

    public Static testmethod void testMethod1(){
         test.startTest();
        
         List<smsBlast_Ctrl.recipientObj> smsBlast =  smsBlast_Ctrl.getOppList('Monarch Shores');
         smsBlast_Ctrl.SendSMS('test',JSON.serialize(smsBlast));
         SMSBlast_Batch sh1 = new SMSBlast_Batch();
         String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1);
         test.stopTest();
   }
}