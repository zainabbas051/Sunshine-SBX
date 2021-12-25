@isTest(seeAllData = True)
private class Utilities_AnalyticsTest{
    Public static Account a;
    Public static Account a2;
    public Static ApexPages.StandardController accountController;
    public Static Utilities_AnalyticsPage u_ap;
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
    Public static Case c13;
    Public static Case c14;
    Public static Case c15;
    Public static Case c16;
    Public static Case c17;
    Public static Case c18;
    Public static Case c19;
    Public static Case c20;
    Public static Case c22;
    Public static Case c21;
    Public static Case c23;
    Public static Case c24;
    Public static Collection_Line_Item__c cli1;
    Public static Collection_Line_Item__c cli2;
    Public static Collection_Line_Item__c cli3;
    Public static Collection_Line_Item__c cli4;
    Public static Collection_Line_Item__c cli5;
    Public static Collection_Line_Item__c cli6;
    Public static Collection_Line_Item__c cli7;
    Public static Collection_Line_Item__c cli8;
    Public static Collection_Line_Item__c cli9;
    Public static Collection_Line_Item__c cli10;
    Public static Collection_Line_Item__c cli11;
    Public static Collection_Line_Item__c cli12;
    Public static Collection_Line_Item__c cli13;
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
        
        List<Case> caseList = new List<Case>();
        
        c1 = new Case();
        c1.Opportunity__c = oms.id;
        c1.Bill_Date__c = date.today();
        c1.Bill_From_Date__c = date.today().addDays(-5);
        c1.Bill_To_Date__c = date.today();
        c1.Billed_Amount__c = 1500;
        c1.Status = 'Closed';
        //c1.ClosedDate = date.today();
        c1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c1);
        //insert c1;
        
        c2 = new Case();
        c2.Opportunity__c = oms.id;
        c2.Bill_Date__c = date.today();
        c2.Bill_From_Date__c = date.today().addDays(-5);
        c2.Bill_To_Date__c = date.today();
        c2.Billed_Amount__c = 1500;
        c2.Status = 'Closed';
        //c2.ClosedDate = date.today().addDays(40);
        c2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c2);
        //insert c2;
        
        c3 = new Case();
        c3.Opportunity__c = oms.id;
        c3.Bill_Date__c = date.today();
        c3.Bill_From_Date__c = date.today().addDays(-5);
        c3.Bill_To_Date__c = date.today();
        c3.Billed_Amount__c = 1500;
        c3.Status = 'Closed';
        //c3.ClosedDate = date.today().addDays(70);
        c3.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c3);
        //insert c3;
        
        c4 = new Case();
        c4.Opportunity__c = oms.id;
        c4.Bill_Date__c = date.today();
        c4.Bill_From_Date__c = date.today().addDays(-5);
        c4.Bill_To_Date__c = date.today();
        c4.Billed_Amount__c = 1500;
        c4.Status = 'Closed';
        //c4.ClosedDate = date.today().addDays(100);
        c4.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c4);
        //insert c4;
        
        c5 = new Case();
        c5.Opportunity__c = oms.id;
        c5.Bill_Date__c = date.today();
        c5.Bill_From_Date__c = date.today().addDays(-5);
        c5.Bill_To_Date__c = date.today();
        c5.Billed_Amount__c = 1500;
        c5.Status = 'Closed';
        //c5.ClosedDate = date.today().addDays(130);
        c5.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c5);
        //insert c5;
        
        c6 = new Case();
        c6.Opportunity__c = oms.id;
        c6.Bill_Date__c = date.today();
        c6.Bill_From_Date__c = date.today().addDays(-5);
        c6.Bill_To_Date__c = date.today();
        c6.Billed_Amount__c = 1500;
        c6.Status = 'Closed';
        //c6.ClosedDate = date.today().addDays(160);
        c6.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c6);
        //insert c6;
        
        c7 = new Case();
        c7.Opportunity__c = oms.id;
        c7.Bill_Date__c = date.today();
        c7.Bill_From_Date__c = date.today().addDays(-5);
        c7.Bill_To_Date__c = date.today();
        c7.Billed_Amount__c = 1500;
        c7.Status = 'Closed';
        //c7.ClosedDate = date.today().addDays(190);
        c7.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c7);
        //insert c7;
        
        c8 = new Case();
        c8.Opportunity__c = oms.id;
        c8.Bill_Date__c = date.today();
        c8.Bill_From_Date__c = date.today().addDays(-5);
        c8.Bill_To_Date__c = date.today();
        c8.Billed_Amount__c = 1500;
        c8.Status = 'Closed';
        //c8.ClosedDate = date.today().addDays(220);
        c8.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c8);
        //insert c8;
        
        c9 = new Case();
        c9.Opportunity__c = oms.id;
        c9.Bill_Date__c = date.today();
        c9.Bill_From_Date__c = date.today().addDays(-5);
        c9.Bill_To_Date__c = date.today();
        c9.Billed_Amount__c = 1500;
        c9.Status = 'Closed';
        //c9.ClosedDate = date.today().addDays(250);
        c9.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c9);
        //insert c9;
        
        c10 = new Case();
        c10.Opportunity__c = oms.id;
        c10.Bill_Date__c = date.today();
        c10.Bill_From_Date__c = date.today().addDays(-5);
        c10.Bill_To_Date__c = date.today();
        c10.Billed_Amount__c = 1500;
        c10.Status = 'Closed';
        //c10.ClosedDate = date.today().addDays(280);
        c10.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c10);
        //insert c10;
        
        c11 = new Case();
        c11.Opportunity__c = oms.id;
        c11.Bill_Date__c = date.today();
        c11.Bill_From_Date__c = date.today().addDays(-5);
        c11.Bill_To_Date__c = date.today();
        c11.Billed_Amount__c = 1500;
        c11.Status = 'Closed';
        //c11.ClosedDate = date.today().addDays(310);
        c11.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c11);
        //insert c11;
        
        c12 = new Case();
        c12.Opportunity__c = oms.id;
        c12.Bill_Date__c = date.today();
        c12.Bill_From_Date__c = date.today().addDays(-5);
        c12.Bill_To_Date__c = date.today();
        c12.Billed_Amount__c = 1500;
        c12.Status = 'Closed';
        //c12.ClosedDate = date.today().addDays(340);
        c12.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c12);
        //insert c12;
        
        c13 = new Case();
        c13.Opportunity__c = oms.id;
        c13.Bill_Date__c = date.today().addDays(-10);
        c13.Bill_From_Date__c = date.today().addDays(-5);
        c13.Bill_To_Date__c = date.today();
        c13.Billed_Amount__c = 1500;
        c13.Status = 'Closed';
        c13.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c13);
        //insert c13;
        
        
        c14 = new Case();
        c14.Opportunity__c = oms.id;
        c14.Bill_Date__c = date.today().addDays(-40);
        c14.Bill_From_Date__c = date.today().addDays(-5);
        c14.Bill_To_Date__c = date.today();
        c14.Billed_Amount__c = 1500;
        c14.Status = 'Closed';
        c14.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c14);
        //insert c14;
        
        c15 = new Case();
        c15.Opportunity__c = oms.id;
        c15.Bill_Date__c = date.today().addDays(-70);
        c15.Bill_From_Date__c = date.today().addDays(-5);
        c15.Bill_To_Date__c = date.today();
        c15.Billed_Amount__c = 1500;
        c15.Status = 'Closed';
        c15.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c15);
        //insert c15;
        
        c16 = new Case();
        c16.Opportunity__c = oms.id;
        c16.Bill_Date__c = date.today().addDays(-100);
        c16.Bill_From_Date__c = date.today().addDays(-5);
        c16.Bill_To_Date__c = date.today();
        c16.Billed_Amount__c = 1500;
        c16.Status = 'Closed';
        c16.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c16);
        //insert c16;
        
        c17 = new Case();
        c17.Opportunity__c = oms.id;
        c17.Bill_Date__c = date.today().addDays(-130);
        c17.Bill_From_Date__c = date.today().addDays(-5);
        c17.Bill_To_Date__c = date.today();
        c17.Billed_Amount__c = 1500;
        c17.Status = 'Closed';
        c17.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c17);
        //insert c17;
        
        c18 = new Case();
        c18.Opportunity__c = oms.id;
        c18.Bill_Date__c = date.today().addDays(-160);
        c18.Bill_From_Date__c = date.today().addDays(-5);
        c18.Bill_To_Date__c = date.today();
        c18.Billed_Amount__c = 1500;
        c18.Status = 'Closed';
        c18.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c18);
        //insert c18;
        
        c19 = new Case();
        c19.Opportunity__c = oms.id;
        c19.Bill_Date__c = date.today().addDays(-190);
        c19.Bill_From_Date__c = date.today().addDays(-5);
        c19.Bill_To_Date__c = date.today();
        c19.Billed_Amount__c = 1500;
        c19.Status = 'Closed';
        c19.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c19);
        //insert c19;
        
        c20 = new Case();
        c20.Opportunity__c = oms.id;
        c20.Bill_Date__c = date.today().addDays(-220);
        c20.Bill_From_Date__c = date.today().addDays(-5);
        c20.Bill_To_Date__c = date.today();
        c20.Billed_Amount__c = 1500;
        c20.Status = 'Closed';
        c20.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c20);
        //insert c20;
        
        c21 = new Case();
        c21.Opportunity__c = oms.id;
        c21.Bill_Date__c = date.today().addDays(-250);
        c21.Bill_From_Date__c = date.today().addDays(-5);
        c21.Bill_To_Date__c = date.today();
        c21.Billed_Amount__c = 1500;
        c21.Status = 'Closed';
        c21.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c21);
        //insert c21;
        
        c22 = new Case();
        c22.Opportunity__c = oms.id;
        c22.Bill_Date__c = date.today().addDays(-280);
        c22.Bill_From_Date__c = date.today().addDays(-5);
        c22.Bill_To_Date__c = date.today();
        c22.Billed_Amount__c = 1500;
        c22.Status = 'Closed';
        c22.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c22);
        //insert c22;
        
        c23 = new Case();
        c23.Opportunity__c = oms.id;
        c23.Bill_Date__c = date.today().addDays(-310);
        c23.Bill_From_Date__c = date.today().addDays(-5);
        c23.Bill_To_Date__c = date.today();
        c23.Billed_Amount__c = 1500;
        c23.Status = 'Closed';
        c23.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c23);
        //insert c23;
        
        c24 = new Case();
        c24.Opportunity__c = oms.id;
        c24.Bill_Date__c = date.today().addDays(-440);
        c24.Bill_From_Date__c = date.today().addDays(-5);
        c24.Bill_To_Date__c = date.today();
        c24.Billed_Amount__c = 1500;
        c24.Status = 'Closed';
        c24.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c24);
        // insert c24;
        
        insert caseList;
        
        cli1 = new Collection_Line_Item__c();
        cli1.Case__c = c1.id; 
        cli1.Collection_Amount__c = 100;
        cli1.Type_of_Collection__c = 'Original bill';
        cli1.Collection_Date__c = date.today().addDays(15);
        insert cli1;
        
        cli2 = new Collection_Line_Item__c();
        cli2.Case__c = c2.id; 
        cli2.Collection_Amount__c = 100;
        cli2.Type_of_Collection__c = 'Original bill';
        cli2.Collection_Date__c = date.today().addDays(45);
        insert cli2;
        
        cli3 = new Collection_Line_Item__c();
        cli3.Case__c = c3.id; 
        cli3.Collection_Amount__c = 100;
        cli3.Type_of_Collection__c = 'Original bill';
        cli3.Collection_Date__c = date.today().addDays(75);
        insert cli3;
        
        cli4 = new Collection_Line_Item__c();
        cli4.Case__c = c4.id; 
        cli4.Collection_Amount__c = 100;
        cli4.Type_of_Collection__c = 'Original bill';
        cli4.Collection_Date__c = date.today().addDays(95);
        insert cli4;
        
        cli5 = new Collection_Line_Item__c();
        cli5.Case__c = c5.id; 
        cli5.Collection_Amount__c = 100;
        cli5.Type_of_Collection__c = 'Original bill';
        cli5.Collection_Date__c = date.today().addDays(125);
        insert cli5;
        
        cli6 = new Collection_Line_Item__c();
        cli6.Case__c = c6.id; 
        cli6.Collection_Amount__c = 100;
        cli6.Type_of_Collection__c = 'Original bill';
        cli6.Collection_Date__c = date.today().addDays(165);
        insert cli6;
        
        cli7 = new Collection_Line_Item__c();
        cli7.Case__c = c7.id; 
        cli7.Collection_Amount__c = 100;
        cli7.Type_of_Collection__c = 'Original bill';
        cli7.Collection_Date__c = date.today().addDays(195);
        insert cli7;
        
        cli8 = new Collection_Line_Item__c();
        cli8.Case__c = c8.id; 
        cli8.Collection_Amount__c = 100;
        cli8.Type_of_Collection__c = 'Original bill';
        cli8.Collection_Date__c = date.today().addDays(225);
        insert cli8;
        
        cli9 = new Collection_Line_Item__c();
        cli9.Case__c = c9.id; 
        cli9.Collection_Amount__c = 100;
        cli9.Type_of_Collection__c = 'Original bill';
        cli9.Collection_Date__c = date.today().addDays(255);
        insert cli9;
        
        cli10 = new Collection_Line_Item__c();
        cli10.Case__c = c10.id; 
        cli10.Collection_Amount__c = 100;
        cli10.Type_of_Collection__c = 'Original bill';
        cli10.Collection_Date__c = date.today().addDays(285);
        insert cli10;
        
        cli11 = new Collection_Line_Item__c();
        cli11.Case__c = c11.id; 
        cli11.Collection_Amount__c = 100;
        cli11.Type_of_Collection__c = 'Original bill';
        cli11.Collection_Date__c = date.today().addDays(315);
        insert cli11;
        
        cli12 = new Collection_Line_Item__c();
        cli12.Case__c = c12.id; 
        cli12.Collection_Amount__c = 100;
        cli12.Type_of_Collection__c = 'Original bill';
        cli12.Collection_Date__c = date.today().addDays(355);
        insert cli12;
        
        
     } 
     
     public Static testmethod void test_monarchShoresOpportunities_Class(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           Utilities_Analytics.historicalInsuranceCollectionPercentages();
           
           
           
           
       }       
       test.StopTest();
             
      }
      
      public Static testmethod void Utilities_AnalyticsPageTest(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           ApexPages.currentPage().getParameters().put('Id', a2.id);
           
           accountController = new ApexPages.StandardController(a2);
           u_ap = new Utilities_AnalyticsPage(accountController); 
           
           
       }       
       test.StopTest();
             
      }
}