@isTest
private class LeadHelperBatchTest{
    
    Public static Lead l;
    Public static Lead_Helper__c lh;
    
    public Static void createSampleData(){
        
        Id recTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId(); 
        
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
        l.Test_Class_Checkbox__c = True;
        l.Invoca_State__c = 'MI';
        l.LeadSource = 'Invoca Call';
        l.Call_Routing__c = 'Monarch Shores';
        insert l;
        
        lh = new Lead_Helper__c();
        lh.Lead_Id__c = l.id;
        lh.Time_Lead_Qualified__c = dateTime.now().addMinutes(-7);
        insert lh;
    }
    
    
    
    public Static testmethod void ClaimLeadOwnershipTest(){
        test.startTest();
        
        createSampleData();          
        String returnString = ClaimLeadOwnership_HandoverAssignment.ClaimLeadOwnership_HandoverAssignment(l.id);
        
        LeadHelperBatch obj1 = new LeadHelperBatch();
        DataBase.executeBatch(obj1);
        
        test.StopTest();
    }
    
    public Static testmethod void leadHelperBatch_IntakeQueueOwnershipTest(){
        test.startTest();
        
        createSampleData();          
        l.OwnerId = label.Intake_Queue_ID;
        update l;
        
        for(Lead_Helper__c lh2 : [Select id, Time_Lead_Assigned_To_Intake_Queue__c, Intake_Queue_Lead_Flag__c from Lead_Helper__c where Lead_Id__c =: l.id]){
            lh2.Time_Lead_Assigned_To_Intake_Queue__c = dateTime.now().addMinutes(-7);
            lh2.Intake_Queue_Lead_Flag__c = True;
            update lh2;
        }
        
        
        LeadHelperBatch obj1 = new LeadHelperBatch();
        DataBase.executeBatch(obj1);
        
        test.StopTest();
    }
    
    public Static testmethod void leadHelperBatch_UnassignedQueueOwnershipTest(){
        test.startTest();
        
        createSampleData();
        l.OwnerId = label.Unassigned_Queue_ID;
        update l;          
        
        for(Lead_Helper__c lh2 : [Select id, Time_Unassigned_ERP_Queue_Lead_Created__c, Unassigned_or_ERP_Queue_Lead__c from Lead_Helper__c where Lead_Id__c =: l.id]){
            lh2.Time_Unassigned_ERP_Queue_Lead_Created__c = dateTime.now().addMinutes(-7);
            lh2.Unassigned_or_ERP_Queue_Lead__c = True;
            update lh2;
        }
        
        LeadHelperBatch obj1 = new LeadHelperBatch();
        DataBase.executeBatch(obj1);
        
        test.StopTest();
    }
}