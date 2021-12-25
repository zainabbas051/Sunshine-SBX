@isTest(seeAllData=True)
private class ClaimInvocaCallTest{
    
    Public static INVOCA_FOR_SF__Invoca_Call_Log__c call;
    Public static Lead l;
    
    public Static void createSampleData(){
       
        Id recTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId(); 
        
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
        insert l;
        
        call = New INVOCA_FOR_SF__Invoca_Call_Log__c();
        call.INVOCA_FOR_SF__transaction_id__c = 'abcdefgh';
        call.INVOCA_FOR_SF__Lead__c = l.id;
        insert call;
    }
    
    public Static testmethod void ClaimInvocaCallTest(){
        test.startTest();
        
        createSampleData();          
        String returnString = ClaimInvocaCall.ClaimInvocaCall(call.id);
        
        String returnString2 = ClaimInvocaCall.ClaimInvocaCall(call.id);            
    
        test.StopTest();
    }
}