@isTest
private class ctrl_ProofOfTimelyFillingTest{
    
    private Static testmethod void ctrl_ProofOfTimelyFilling(){
        
        awsBucket__c aws = new awsBucket__c();
        aws.accessKeyId__c =  'AKIAIKHBOKKMOFRNX5XQ';
        aws.secretAccessKey__c = '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';
        aws.Bucket__c = 'freepu';
        aws.Name = 'FREEPU';
        insert aws;
        
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
        insert c;
        
        Test.setCurrentPageReference(Page.page_ProofOfTimelyFillingPDF);

        System.currentPageReference().getParameters().put('id', c.id);
        ctrl_ProofOfTimelyFilling obj = new ctrl_ProofOfTimelyFilling();
    }
}