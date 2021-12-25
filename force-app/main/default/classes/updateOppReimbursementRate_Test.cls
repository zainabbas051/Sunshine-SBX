@isTest
private class updateOppReimbursementRate_Test{
    Public static Account insProvider;
    Public static Account chapters;
    Public static Account monarch;
    Public static Account mountain;
    Public static Account willow;
    public static awsBucket__c aws;
    public static Trigger_Custom_Setting__c tcs;
    Public static Opportunity oms_cc;
    Public static Opportunity oms_ws;
    Public static Opportunity oms_msr;
    Public static Opportunity oms_ms;
    Public static Opportunity oms_cc_2;
    Public static User u_test;
    public Static Profile adminProfile;
    
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
     
     public Static void createSampleData(){
        
        insProvider = new Account();
        insProvider.Name = 'test account';
        insProvider.Type = 'Insurance Provider';
        insert insProvider;
        
        chapters = new Account();
        chapters.Name = 'Chapter Capistrano';
        chapters.Type = 'Internal Center';
        insert chapters;
        
        willow = new Account();
        willow.Name = 'Willow Springs Recovery';
        willow.Type = 'Internal Center';
        insert willow;
        
        mountain = new Account();
        mountain.Name = 'Mountain Springs Recovery';
        mountain.Type = 'Internal Center';
        insert mountain;
        
        monarch = new Account();
        monarch.Name = 'Monarch Shores';
        monarch.Type = 'Internal Center';
        insert monarch;
        
        aws = new awsBucket__c();
        aws.name = 'FREEPU';
        aws.accessKeyId__c = '1234';
        aws.Bucket__c = 'freepu';
        aws.secretAccessKey__c = '1234';
        insert aws;
        
        tcs = new Trigger_Custom_Setting__c();
        tcs.name = 'Default';
        tcs.Disable_updateOppReimbursementRate__c = False;
        insert tcs;
        
        oms_cc = new Opportunity();
        oms_cc.Name = 'test opp';
        oms_cc.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        oms_cc.Account = chapters;
        oms_cc.Sunshine_Center__c = chapters.id;
        oms_cc.Closing_Agent__c = userAdmin.id;
        oms_cc.Amount = 999;
        oms_cc.StageName = 'Discharged';
        oms_cc.CloseDate = date.Today();
        oms_cc.Test_Class_Checkbox__c = True;
        oms_cc.Insurance_Provider__c = insProvider.id;
        oms_cc.KIPU_MRN__c = 'CC_2020_01';
        oms_cc.Check_Out_Date__c = date.Today().addDays(5);
        oms_cc.Discharge_Type__c = 'Completed Treatment';
        insert oms_cc;
        
        oms_ws = new Opportunity();
        oms_ws.Name = 'test opp';
        oms_ws.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        oms_ws.Account = willow;
        oms_ws.Sunshine_Center__c = willow.id;
        oms_ws.Closing_Agent__c = userAdmin.id;
        oms_ws.Amount = 999;
        oms_ws.StageName = 'Discharged';
        oms_ws.CloseDate = date.Today();
        oms_ws.Test_Class_Checkbox__c = True;
        oms_ws.Insurance_Provider__c = insProvider.id;
        oms_ws.KIPU_MRN__c = 'WS_2020_01';
        oms_ws.Check_Out_Date__c = date.Today().addDays(5);
        oms_ws.Discharge_Type__c = 'Completed Treatment';
        insert oms_ws;
        
        oms_ms = new Opportunity();
        oms_ms.Name = 'test opp';
        oms_ms.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        oms_ms.Account = monarch;
        oms_ms.Sunshine_Center__c = monarch.id;
        oms_ms.Closing_Agent__c = userAdmin.id;
        oms_ms.Amount = 999;
        oms_ms.StageName = 'Discharged';
        oms_ms.CloseDate = date.Today();
        oms_ms.Test_Class_Checkbox__c = True;
        oms_ms.Insurance_Provider__c = insProvider.id;
        oms_ms.KIPU_MRN__c = 'MS_2020_01';
        oms_ms.Check_Out_Date__c = date.Today().addDays(5);
        oms_ms.Discharge_Type__c = 'Completed Treatment';
        insert oms_ms;
        
        oms_msr = new Opportunity();
        oms_msr.Name = 'test opp';
        oms_msr.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        oms_msr.Account = mountain;
        oms_msr.Sunshine_Center__c = mountain.id;
        oms_msr.Closing_Agent__c = userAdmin.id;
        oms_msr.Amount = 999;
        oms_msr.StageName = 'Discharged';
        oms_msr.CloseDate = date.Today();
        oms_msr.Test_Class_Checkbox__c = True;
        oms_msr.Insurance_Provider__c = insProvider.id;
        oms_msr.KIPU_MRN__c = 'MSR_2020_01';
        oms_msr.Check_Out_Date__c = date.Today().addDays(5);
        oms_msr.Discharge_Type__c = 'Completed Treatment';
        insert oms_msr;
        
        
        oms_cc_2 = new Opportunity();
        oms_cc_2.Name = 'test opp';
        oms_cc_2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        oms_cc_2.Account = chapters;
        oms_cc_2.Sunshine_Center__c = chapters.id;
        oms_cc_2.Closing_Agent__c = userAdmin.id;
        oms_cc_2.Amount = 999;
        oms_cc_2.StageName = 'Discharged';
        oms_cc_2.CloseDate = date.Today();
        oms_cc_2.Test_Class_Checkbox__c = True;
        oms_cc_2.Insurance_Provider__c = insProvider.id;
        oms_cc_2.Cash_Client__c = True;
        oms_cc_2.KIPU_MRN__c = 'CC_2020_02';
        oms_cc_2.Check_Out_Date__c = date.Today().addDays(5);
        oms_cc_2.Discharge_Type__c = 'Completed Treatment';
        insert oms_cc_2;
        
     } 
     
     public Static testmethod void updateOppReimbursementRate_Trigger_Test(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           insProvider.Chapters_Total_Billed_Amount__c = 1200.0;
           insProvider.Chapters_Total_Collected_Amount__c = 900.0;
           insProvider.Monarch_Total_Billed_Amount__c = 1500.0;
           insProvider.Monarch_Total_Collected_Amount__c = 900.0;
           insProvider.Mountain_Total_Billed_Amount__c = 1200.0;
           insProvider.Mountain_Total_Collected_Amount__c = 900.0;
           insProvider.Willow_Total_Billed_Amount__c = 1200.0;
           insProvider.Willow_Total_Collected_Amount__c = 900.0;
           insProvider.Reimbursement_Rate_Temp_Flag__c = True;
           update insProvider;
           
       }       
       test.StopTest();
             
      }
      
}