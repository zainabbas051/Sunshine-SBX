@IsTest
private class VitalsHistory_Test {
    public static testmethod void VitalsHistory_Test(){
        
        test.startTest();
        PrepareData();
        test.stopTest();
    }
    public static void PrepareData(){
        Client_Chart__c ClientID = new Client_Chart__c();
        ClientID.Name = 'Test Client';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
        Insert ClientID;
        
        ApexPages.currentPage().getParameters().put('ID', ClientID.Id);
        
        Recurring_Assessment__c ra = new Recurring_Assessment__c();
        ra.Status__c = 'Closed';
        ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId();
        ra.Client_Chart__c = ClientID.Id;
        insert ra;
        
        VitalsHistory vh = new VitalsHistory();
        
        
    }
}