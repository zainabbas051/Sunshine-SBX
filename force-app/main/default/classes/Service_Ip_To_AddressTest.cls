@isTest(seeAllData=True)
private class Service_Ip_To_AddressTest{
    
    Public static Lead l;
    
    public Static void createSampleData(){
        
        Id erpRecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId(); 
        
        l = New Lead();
        l.FirstName = 'Test';
        l.LastName = 'Test';
        l.LeadSource = 'Web Lead';
        l.Company = 'test';
        l.Subscriber_Last_Name__c = 'Test';
        l.Subscriber_First_Name__c = 'Test';
        l.Contact_First_Name__c = 'Test';
        l.Contact_Last_Name__c = 'Test';
        l.Subscriber_DOB_Text__c = '2014-01-12';
        l.Email='test@test.com';
        l.recordTypeId = erpRecTypeId ;
        l.Test_Class_Checkbox__c = True;
        insert l;
    }
    
    public Static testmethod void Service_Ip_To_AddressTest(){
        test.startTest();
        
        createSampleData();     
        l.IP_Address_Source__c = '10.10.10.10';
        l.Phone_Web__c = 'Web';
        update l;         
        Service_Ip_To_Address.ipToAdressAPICall(l.IP_Address_Source__c,l.Id);
        
        Service_Ip_To_Address.response_wrapper rw = new Service_Ip_To_Address.response_wrapper('68.34.253.80','c-68-34-253-80.hsd1.mi.comcast.net','Charter Township of Clinton','Michigan','US','42.5991,-82.9312','AS7922 Comcast Cable Communications, LLC','48038');
        
        test.StopTest();
    }
}