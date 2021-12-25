@isTest
private class ClaimLeadOwnership_HandoverAssignTest{
    
    Public static Lead l;
    Public static profile acProfile;
    
    public static User userAC
    {
        get{
            if (userAC == null)
            {
                acProfile = [Select Id, Name From Profile where name = 'Custom - Monarch Shores - Standard User' limit 1];
                userAC  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
                            email='test@key.net', communityNickname='test0101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=acProfile.Id ,
                            LanguageLocaleKey='en_US');
                insert userAC;             
             }
             return userAC;
            }
        set;
    }

    
    public Static void createSampleData(){
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Lead;
        Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recTypeId = rtMapByName.get('Elite Rehab Placement').getRecordTypeId(); 
        
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
        l.ownerid = userAC.id;
        l.Test_Class_Checkbox__c = True;
        l.Invoca_State__c = 'MI';
        l.LeadSource = 'Invoca Call';
        l.Call_Routing__c = 'Monarch Shores';
        insert l;
    }
    
    
    
    public Static testmethod void ClaimLeadOwnershipTest(){
        test.startTest();
        
        createSampleData();          
        String returnString = ClaimLeadOwnership_HandoverAssignment.ClaimLeadOwnership_HandoverAssignment(l.id);
        
        l.OwnerId = userAC.id;
        update l;
        system.runAs(userAC){
            String returnString2 = ClaimLeadOwnership_HandoverAssignment.ClaimLeadOwnership_HandoverAssignment(l.id);  
            
            String returnString3 = ClaimLeadOwnership_HandoverAssignment.ClaimLeadOwnership_HandoverAssignment(l.id);          
        }
        test.StopTest();
    }
}