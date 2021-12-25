@isTest(seeAllData=True)
private class ClaimLeadOwnershipTest{
    
    Public static Lead l;
    
    public Static void createSampleData(){
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Lead;
        Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recTypeId = rtMapByName.get('Elite Rehab Placement').getRecordTypeId(); 
        
        Group queue = [select id from Group where Name=:'Unassigned Queue' AND Type = 'Queue'];
        
        l = New Lead();
        l.FirstName = 'Test';
        l.LastName = 'Test';
        l.LeadSource = 'Insurance Form';
        l.Company = 'test';
        l.Subscriber_Last_Name__c = 'Test';
        l.Subscriber_First_Name__c = 'Test';
        l.Contact_First_Name__c = 'Test';
        l.Contact_Last_Name__c = 'Test';
        l.Subscriber_DOB_Text__c = '2014-01-12';
        l.Email='test@test.com';
        l.recordTypeId = recTypeId;
        l.ownerid = queue.Id;
        l.Test_Class_Checkbox__c = True;
        l.Text_Sent_Queues__c = queue.id;
        l.Invoca_State__c = 'MI';
        l.LeadSource = 'Invoca Call';
        l.Call_Routing__c = 'Monarch Shores';
        insert l;
    }
    
    public Static testmethod void ClaimLeadOwnershipTest(){
        test.startTest();
        
        createSampleData();          
        String returnString = ClaimLeadOwnership.ClaimLeadOwnership(l.id);
        
        String returnString2 = ClaimLeadOwnership.ClaimLeadOwnership(l.id);            
    
        test.StopTest();
    }
}