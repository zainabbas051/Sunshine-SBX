@IsTest
private class ClientChartTrg_Test {
    public static testmethod void ClientChartTrg_Test()
    {
        Test.startTest();
        PrepareData();
        
        Test.stopTest();
    }
    public static void PrepareData(){
        
        Account acc = new Account();
        acc.Name = 'Monarch Shores';
        acc.Type = 'Internal Center';
        insert acc;
        
        
        Sunshine_Center_Id__c scid = new Sunshine_Center_Id__c();
        scid.Name = 'Monarch Shores';
        scid.Requires_Admit_Order__c = False;
        scid.Account_Id__c = acc.id;
        insert scid;
        
        Client_Chart__c ClientID = new Client_Chart__c();
        ClientID.Name = 'Test Client';
        ClientID.Diagnosis_Code__c = 'Test1;Test2;Test3';
        ClientID.Client_Status__c = 'Admitted';
        ClientID.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        ClientID.Admit_Date_Time__c = DateTime.now();
        Insert ClientID;   
        
        ClientID.Client_Status__c = '';
        ClientID.Related_Forms_Created_On_Admit__c = False;
        update ClientID;
        
        ClientID.Client_Status__c = 'Admitted';
        update ClientID;
    }
    
}