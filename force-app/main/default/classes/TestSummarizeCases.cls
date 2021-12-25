@isTest
private class TestSummarizeCases{
    
    private Static testmethod void testSummarizeBatch(){
       /* Account a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        Opportunity o = new Opportunity();
        o.Name = 'test opp';
        o.Account = a;
        o.Selected_Treatment_Center__c = a.id;        
        o.Amount = 999;
        o.StageName = 'Working';
        o.CloseDate = date.Today();
        o.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        insert o;
        
        Case c = new Case();
        c.Opportunity__c = o.id;
        c.Origin = 'Email';
        c.Billed_Amount__c = 100;
        c.Collected_Amount__c = 100;
        c.Deductible_Amount__c = 100;
        c.Co_Pay_Amount__c  = 100;
        insert c;*/
        
        Test.startTest();
        
      //  SummarizeCases  b = new SummarizeCases ();
     //   database.executebatch(b);
        
        Test.stopTest();
       
    }
    
    private Static testmethod void testSummarizeSchd(){
        awsBucket__c AmazonBucketValue = new awsBucket__c();
        AmazonBucketValue.name = 'FREEPU';
        AmazonBucketValue.accessKeyId__c = '1234';
        AmazonBucketValue.secretAccessKey__c= '1234';
        insert AmazonBucketValue;
       
       Account a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        Opportunity o = new Opportunity();
        o.Name = 'test opp';
        o.Account = a;
        o.Selected_Treatment_Center__c = a.id;        
        o.Amount = 999;
        o.StageName = 'Working';
        o.CloseDate = date.Today();
        o.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        insert o;
        
        Case c = new Case();
        c.Opportunity__c = o.id;
        c.Origin = 'Email';
        c.Billed_Amount__c = 100;
        c.Collected_Amount__c = 100;
        c.Deductible_Amount__c = 100;
        c.Co_Pay_Amount__c  = 100;
        C.Status = 'Closed';
        c.Level_of_Care__c = 'Detox';
        c.Bill_To_Date__c = Date.Today().AddDays(2);
        c.Bill_From_Date__c =  Date.Today();
        
        insert c;
        
        c = new Case();
        c.Opportunity__c = o.id;
        c.Origin = 'Email';
        c.Billed_Amount__c = 100;
        c.Collected_Amount__c = 100;
        c.Deductible_Amount__c = 100;
        c.Co_Pay_Amount__c  = 100;
        C.Status = 'Closed';
        c.Level_of_Care__c = 'Residential';
         c.Bill_To_Date__c = Date.Today().AddDays(5);
        c.Bill_From_Date__c =  Date.Today().AddDays(2);
        
        insert c;
        
        c = new Case();
        c.Opportunity__c = o.id;
        c.Origin = 'Email';
        c.Billed_Amount__c = 100;
        c.Collected_Amount__c = 100;
        c.Deductible_Amount__c = 100;
        c.Co_Pay_Amount__c  = 100;
        C.Status = 'Closed';
        c.Level_of_Care__c = 'PHP';
         c.Bill_To_Date__c = Date.Today().AddDays(9);
        c.Bill_From_Date__c =  Date.Today().AddDays(5);
        
        insert c;
        
        c = new Case();
        c.Opportunity__c = o.id;
        c.Origin = 'Email';
        c.Billed_Amount__c = 100;
        c.Collected_Amount__c = 100;
        c.Deductible_Amount__c = 100;
        c.Co_Pay_Amount__c  = 100;
        C.Status = 'Closed';
        c.Level_of_Care__c = 'IOP';
         c.Bill_To_Date__c = Date.Today().AddDays(12);
        c.Bill_From_Date__c =  Date.Today().AddDays(9);
        
        insert c;
        
         c = new Case();
        c.Opportunity__c = o.id;
        c.Origin = 'Email';
        c.Billed_Amount__c = 100;
        c.Collected_Amount__c = 100;
        c.Deductible_Amount__c = 100;
        c.Co_Pay_Amount__c  = 100;
        C.Status = 'Closed';
        c.Level_of_Care__c = 'OP';
         c.Bill_To_Date__c = Date.Today().AddDays(15);
        c.Bill_From_Date__c =  Date.Today().AddDays(12);
        
   
        insert c;
        
        c = new Case();
        c.Opportunity__c = o.id;
        c.Origin = 'Email';
        c.Billed_Amount__c = 100;
        c.Collected_Amount__c = 100;
        c.Deductible_Amount__c = 100;
        c.Co_Pay_Amount__c  = 100;
        C.Status = 'Closed';
        c.Level_of_Care__c = 'Detox';
        c.Bill_To_Date__c = Date.Today().AddDays(16);
        c.Bill_From_Date__c =  Date.Today().AddDays(16);
        
        insert c;
        
        c = new Case();
        c.Opportunity__c = o.id;
        c.Origin = 'Email';
        c.Billed_Amount__c = 100;
        c.Collected_Amount__c = 100;
        c.Deductible_Amount__c = 100;
        c.Co_Pay_Amount__c  = 100;
        C.Status = 'Closed';
        c.Level_of_Care__c = 'Residential';
         c.Bill_To_Date__c = Date.Today().AddDays(17);
        c.Bill_From_Date__c =  Date.Today().AddDays(17);
        
        insert c;
        
        c = new Case();
        c.Opportunity__c = o.id;
        c.Origin = 'Email';
        c.Billed_Amount__c = 100;
        c.Collected_Amount__c = 100;
        c.Deductible_Amount__c = 100;
        c.Co_Pay_Amount__c  = 100;
        C.Status = 'Closed';
        c.Level_of_Care__c = 'PHP';
         c.Bill_To_Date__c = Date.Today().AddDays(18);
        c.Bill_From_Date__c =  Date.Today().AddDays(18);
        
        insert c;
        
        c = new Case();
        c.Opportunity__c = o.id;
        c.Origin = 'Email';
        c.Billed_Amount__c = 100;
        c.Collected_Amount__c = 100;
        c.Deductible_Amount__c = 100;
        c.Co_Pay_Amount__c  = 100;
        C.Status = 'Closed';
        c.Level_of_Care__c = 'IOP';
         c.Bill_To_Date__c = Date.Today().AddDays(19);
        c.Bill_From_Date__c =  Date.Today().AddDays(19);
        
        insert c;
        
         c = new Case();
        c.Opportunity__c = o.id;
        c.Origin = 'Email';
        c.Billed_Amount__c = 100;
        c.Collected_Amount__c = 100;
        c.Deductible_Amount__c = 100;
        c.Co_Pay_Amount__c  = 100;
        C.Status = 'Closed';
        c.Level_of_Care__c = 'OP';
         c.Bill_To_Date__c = Date.Today().AddDays(20);
        c.Bill_From_Date__c =  Date.Today().AddDays(20);
        
   
        insert c;
        
        Test.startTest();
        
        summarizeCasesSchd b = new summarizeCasesSchd  ();
        b.execute(null);
        
        Test.stopTest();
       
    }
}