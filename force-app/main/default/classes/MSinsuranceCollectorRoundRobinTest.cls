@isTest()

private class MSinsuranceCollectorRoundRobinTest{
    public Static ApexPages.StandardController opportunityController;
    Public static Opportunity o_erp;
    Public static Account a;
    public Static Profile adminProfile;
    public static Trigger_Custom_Setting__c tcs;

public Static testmethod void test_insuranceCollectorRoundRobinUserUpdate_Trigger(){
       test.startTest();
    
       system.runAs(userAdmin){
           
           createSampleData();

           o_erp.StageName = 'Admitted';
           update o_erp;
           
    
       }
         test.StopTest();
             
}
public Static void createSampleData(){
        
       
        Schema.DescribeSObjectResult d_opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = d_opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Monarch Shores').getRecordTypeId(); 
         
        tcs = new Trigger_Custom_Setting__c();
        tcs.Name = 'Default';
        tcs.Disable_TrgOpportunity__c = False;
        Insert tcs; 
         
        adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
        List<user> user1 = [SELECT id FROM user where isActive=:True and ProfileId =: adminProfile.Id LIMIT 2];
        Insurance_Collector_Round_Robin_User__c insColl1 = new Insurance_Collector_Round_Robin_User__c();
        insColl1.User_Id__c = user1[0].id;
        insColl1.Last_Assigned_To__c = true;
        insColl1.Name = 'test1';
        insert insColl1;

        Insurance_Collector_Round_Robin_User__c insColl2 = new Insurance_Collector_Round_Robin_User__c();
        insColl2.User_Id__c = user1[1].id;
        insColl2.Last_Assigned_To__c = False;
        insColl2.name = 'test2';
        insert insColl2;
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        o_erp = new Opportunity();
        o_erp.Name = 'test opp';
        o_erp.Account = a;
        o_erp.Selected_Treatment_Center__c = a.id;
        o_erp.Closing_Agent__c = userAdmin.id;
        o_erp.Amount = 999;
        o_erp.StageName = 'Paid';
        o_erp.CloseDate = date.Today();
        o_erp.recordTypeId = recTypeIdOpp;
        o_erp.Test_Class_Checkbox__c  = true;
        o_erp.Cash_Client__c = False;
        o_erp.Insurance_Providers__c= 'Spectra';
        o_erp.Insurance_Collector__c =null;
        o_erp.KIPU_MRN__c = 'CC2020-001';
        insert o_erp;
        
}
     
public static User userAdmin
    {
        get{
            if (userAdmin == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
                            email='test@key.net', communityNickname='test0101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id ,
                            LanguageLocaleKey='en_US');
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }
}