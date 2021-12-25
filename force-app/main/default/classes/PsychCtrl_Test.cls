@isTest
private class PsychCtrl_Test{

   @testSetup static void setup() {
   
         Account a;
        

        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        Schema.DescribeSObjectResult opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Monarch Shores').getRecordTypeId(); 
        
        Opportunity oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = recTypeIdOpp;
        oms.Account = a;
        oms.Selected_Treatment_Center__c = a.id;
        oms.Closing_Agent__c = Userinfo.getUserId();
        oms.Amount = 999;
        oms.StageName = 'Working';
        oms.CloseDate = date.Today();
        oms.Test_Class_Checkbox__c = True;
        insert oms;
   }
   
   Static testmethod void ProcessTest(){
   
       test.startTest();
       Opportunity opptyId = [Select Id from Opportunity limit 1];
       PageReference pageRef = Page.PreAdmission_Medical_Vf;
       pageRef.getParameters().put('id', opptyId.Id);
       Test.setCurrentPage(pageRef);
       ApexPages.StandardController sc = new ApexPages.StandardController(opptyId);
       Psych_Ctrl psychObj = new Psych_Ctrl(sc);
       psychObj.saveRecord();
       psychObj.editRecord();
       test.stopTest();
   }

}