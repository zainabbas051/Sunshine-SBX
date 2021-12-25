@isTest(seeAllData = True)
private class Utilities_AnalyticsOpenClaimsTest{
    Public static Account a;
    Public static Account a2;
    Public static Account a3;
    Public static Opportunity oms;
    Public static Case c1;
    Public static Case c2;
    Public static Case c3;
    Public static Case c4;
    Public static Case c5;
    Public static Case c6;
    Public static Case c7;
    Public static Case c8;
    Public static Case c9;
    Public static Case c10;
    Public static Case c11;
    Public static Case c12;
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
        
        a2 = new Account();
        a2.Name = 'test account';
        a2.Type = 'Insurance Provider';
        insert a2;
        
        a3 = new Account();
        a3.Name = 'test account 2';
        a3.Type = 'Insurance Provider';
        insert a3;
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        
        oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        oms.Account = a;
        oms.Selected_Treatment_Center__c = a.id;
        oms.Closing_Agent__c = userAdmin.id;
        oms.Amount = 999;
        oms.StageName = 'Working';
        oms.CloseDate = date.Today();
        oms.Test_Class_Checkbox__c = True;
        oms.Insurance_Provider__c = a2.id;
        insert oms;
        
        c1 = new Case();
        c1.Opportunity__c = oms.id;
        c1.Bill_Date__c = date.today().addDays(-5);
        c1.Bill_From_Date__c = date.today().addDays(-5);
        c1.Bill_To_Date__c = date.today();
        c1.Billed_Amount__c = 1500;
        c1.Status = 'Processing';
        c1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        insert c1;
        
        c2 = new Case();
        c2.Opportunity__c = oms.id;
        c2.Bill_Date__c = date.today().addDays(-40);
        c2.Bill_From_Date__c = date.today().addDays(-5);
        c2.Bill_To_Date__c = date.today();
        c2.Billed_Amount__c = 1500;
        c2.Status = 'Processing';
        c2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        insert c2;
        
        c3 = new Case();
        c3.Opportunity__c = oms.id;
        c3.Bill_Date__c = date.today().addDays(-70);
        c3.Bill_From_Date__c = date.today().addDays(-5);
        c3.Bill_To_Date__c = date.today();
        c3.Billed_Amount__c = 1500;
        c3.Status = 'Processing';
        c3.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        insert c3;
        
        c4 = new Case();
        c4.Opportunity__c = oms.id;
        c4.Bill_Date__c = date.today().addDays(-100);
        c4.Bill_From_Date__c = date.today().addDays(-5);
        c4.Bill_To_Date__c = date.today();
        c4.Billed_Amount__c = 1500;
        c4.Status = 'Processing';
        c4.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        insert c4;
        
        c5 = new Case();
        c5.Opportunity__c = oms.id;
        c5.Bill_Date__c = date.today().addDays(-130);
        c5.Bill_From_Date__c = date.today().addDays(-5);
        c5.Bill_To_Date__c = date.today();
        c5.Billed_Amount__c = 1500;
        c5.Status = 'Processing';
        c5.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        insert c5;
        
        c6 = new Case();
        c6.Opportunity__c = oms.id;
        c6.Bill_Date__c = date.today().addDays(-160);
        c6.Bill_From_Date__c = date.today().addDays(-5);
        c6.Bill_To_Date__c = date.today();
        c6.Billed_Amount__c = 1500;
        c6.Status = 'Processing';
        c6.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        insert c6;
        
        c7 = new Case();
        c7.Opportunity__c = oms.id;
        c7.Bill_Date__c = date.today().addDays(-190);
        c7.Bill_From_Date__c = date.today().addDays(-5);
        c7.Bill_To_Date__c = date.today();
        c7.Billed_Amount__c = 1500;
        c7.Status = 'Processing';
        c7.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        insert c7;
        
        c8 = new Case();
        c8.Opportunity__c = oms.id;
        c8.Bill_Date__c = date.today().addDays(-220);
        c8.Bill_From_Date__c = date.today().addDays(-5);
        c8.Bill_To_Date__c = date.today();
        c8.Billed_Amount__c = 1500;
        c8.Status = 'Processing';
        c8.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        insert c8;
        
        c9 = new Case();
        c9.Opportunity__c = oms.id;
        c9.Bill_Date__c = date.today().addDays(-250);
        c9.Bill_From_Date__c = date.today().addDays(-5);
        c9.Bill_To_Date__c = date.today();
        c9.Billed_Amount__c = 1500;
        c9.Status = 'Processing';
        c9.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        insert c9;
        
        c10 = new Case();
        c10.Opportunity__c = oms.id;
        c10.Bill_Date__c = date.today().addDays(-280);
        c10.Bill_From_Date__c = date.today().addDays(-5);
        c10.Bill_To_Date__c = date.today();
        c10.Billed_Amount__c = 1500;
        c10.Status = 'Processing';
        c10.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        insert c10;
        
        c11 = new Case();
        c11.Opportunity__c = oms.id;
        c11.Bill_Date__c = date.today().addDays(-310);
        c11.Bill_From_Date__c = date.today().addDays(-5);
        c11.Bill_To_Date__c = date.today();
        c11.Billed_Amount__c = 1500;
        c11.Status = 'Processing';
        c11.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        insert c11;
        
        c12 = new Case();
        c12.Opportunity__c = oms.id;
        c12.Bill_Date__c = date.today().addDays(-340);
        c12.Bill_From_Date__c = date.today().addDays(-5);
        c12.Bill_To_Date__c = date.today();
        c12.Billed_Amount__c = 1500;
        c12.Status = 'Processing';
        c12.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        insert c12;
        
        
        
     } 
     
     public Static testmethod void Utilities_AnalyticsOpenClaims(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           Utilities_AnalyticsOpenClaims.openClaimsCalculations();
           
           
           
           
       }       
       test.StopTest();
             
      }
      
      
}