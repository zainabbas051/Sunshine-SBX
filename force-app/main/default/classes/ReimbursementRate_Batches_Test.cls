@isTest
private class ReimbursementRate_Batches_Test{
    Public static Account a;
    Public static Account a2;
    Public static Account a3;
    Public static Account a4;
    Public static Account a5;
    Public static Account a6;
    Public static Insurance_Information__c insurance_oms;
    Public static Insurance_Information__c insurance_oms_ws;
    Public static Insurance_Information__c insurance_oms_msr;
    Public static Insurance_Information__c insurance_oms_ms;
    Public static Insurance_Information__c insurance_oms_cc_apr;
    Public static Insurance_Information__c insurance_oms_ws_apr;
    Public static Insurance_Information__c insurance_oms_ms_apr;
    Public static Insurance_Information__c insurance_oms_msr_apr;
    public static awsBucket__c aws;
    Public static Opportunity oms;
    Public static Opportunity oms_ws;
    Public static Opportunity oms_msr;
    Public static Opportunity oms_ms;
    Public static Opportunity oms_cc_apr;
    Public static Opportunity oms_ws_apr;
    Public static Opportunity oms_msr_apr;
    Public static Opportunity oms_ms_apr;
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
    Public static Case c25;
    Public static Case c26;
    Public static Case c27;
    Public static Case c28;
    Public static Case c29;
    Public static Case c30;
    Public static Case c31;
    Public static Case c32;
    Public static Case c33;
    Public static Case c34;
    Public static Case c35;
    Public static Case c36;
    Public static Case c37;
    Public static Case c38;
    Public static Case c39;
    Public static Case c40;
    Public static Case c41;
    Public static Case c42;
    Public static Case c43;
    Public static Case c44;
    Public static Case c45;
    Public static Case c46;
    Public static Case c47;
    Public static Case c48;
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
    Public static Collection_Line_Item__c cli14;
    Public static Collection_Line_Item__c cli15;
    Public static Collection_Line_Item__c cli16;
    Public static Collection_Line_Item__c cli17;
    Public static Collection_Line_Item__c cli18;
    Public static Collection_Line_Item__c cli19;
    Public static Collection_Line_Item__c cli20;
    Public static Collection_Line_Item__c cli21;
    Public static Collection_Line_Item__c cli22;
    Public static Collection_Line_Item__c cli23;
    Public static Collection_Line_Item__c cli24;
    Public static Collection_Line_Item__c cli25;
    Public static Collection_Line_Item__c cli26;
    Public static Collection_Line_Item__c cli27;
    Public static Collection_Line_Item__c cli28;
    Public static Collection_Line_Item__c cli29;
    Public static Collection_Line_Item__c cli30;
    Public static Collection_Line_Item__c cli31;
    Public static Collection_Line_Item__c cli32;
    Public static Collection_Line_Item__c cli33;
    Public static Collection_Line_Item__c cli34;
    Public static Collection_Line_Item__c cli35;
    Public static Collection_Line_Item__c cli36;
    Public static Collection_Line_Item__c cli37;
    Public static Collection_Line_Item__c cli38;
    Public static Collection_Line_Item__c cli39;
    Public static Collection_Line_Item__c cli40;
    Public static Collection_Line_Item__c cli41;
    Public static Collection_Line_Item__c cli42;
    Public static Collection_Line_Item__c cli43;
    Public static Collection_Line_Item__c cli44;
    Public static Collection_Line_Item__c cli45;
    Public static Collection_Line_Item__c cli46;
    Public static Collection_Line_Item__c cli47;
    Public static Collection_Line_Item__c cli48;
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
        
        a6 = new Account();
        a6.Name = 'test account 2';
        a6.Type = 'Insurance Provider';
        a6.Alpha_Prefix_Based_Insurance__c = True;
        insert a6;
        
        a = new Account();
        a.Name = 'Chapter Capistrano';
        a.Type = 'Internal Center';
        insert a;
        
        a3 = new Account();
        a3.Name = 'Willow Springs Recovery';
        a3.Type = 'Internal Center';
        insert a3;
        
        a4 = new Account();
        a4.Name = 'Mountain Springs Recovery';
        a4.Type = 'Internal Center';
        insert a4;
        
        a5 = new Account();
        a5.Name = 'Monarch Shores';
        a5.Type = 'Internal Center';
        insert a5;
        
        
        
        aws = new awsBucket__c();
        aws.name = 'FREEPU';
        aws.accessKeyId__c = '1234';
        aws.Bucket__c = 'freepu';
        aws.secretAccessKey__c = '1234';
        insert aws;
        
        
        oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        oms.Account = a;
        oms.Sunshine_Center__c = a.id;
        oms.Closing_Agent__c = userAdmin.id;
        oms.Amount = 999;
        oms.StageName = 'Working';
        oms.CloseDate = date.Today();
        oms.Test_Class_Checkbox__c = True;
        oms.Insurance_Provider__c = a2.id;
        insert oms;
        
        insurance_oms = new Insurance_Information__c();
        insurance_oms.Insurance_Provider__c = a2.id;
        insurance_oms.Opportunity__c = oms.id;
        insurance_oms.Insurance_Policy__c = '12345678';
        insert insurance_oms;
        
        oms_ws = new Opportunity();
        oms_ws.Name = 'test opp';
        oms_ws.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        oms_ws.Account = a;
        oms_ws.Sunshine_Center__c = a3.id;
        oms_ws.Closing_Agent__c = userAdmin.id;
        oms_ws.Amount = 999;
        oms_ws.StageName = 'Working';
        oms_ws.CloseDate = date.Today();
        oms_ws.Test_Class_Checkbox__c = True;
        oms_ws.Insurance_Provider__c = a2.id;
        insert oms_ws;
        
        insurance_oms_ws = new Insurance_Information__c();
        insurance_oms_ws.Insurance_Provider__c = a2.id;
        insurance_oms_ws.Opportunity__c = oms_ws.id;
        insurance_oms_ws.Insurance_Policy__c = 'ABC12345678';
        insert insurance_oms_ws;
        
        oms_ms = new Opportunity();
        oms_ms.Name = 'test opp';
        oms_ms.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        oms_ms.Account = a;
        oms_ms.Sunshine_Center__c = a4.id;
        oms_ms.Closing_Agent__c = userAdmin.id;
        oms_ms.Amount = 999;
        oms_ms.StageName = 'Working';
        oms_ms.CloseDate = date.Today();
        oms_ms.Test_Class_Checkbox__c = True;
        oms_ms.Insurance_Provider__c = a2.id;
        insert oms_ms;
        
        insurance_oms_ms = new Insurance_Information__c();
        insurance_oms_ms.Insurance_Provider__c = a2.id;
        insurance_oms_ms.Opportunity__c = oms_ms.id;
        insurance_oms_ms.Insurance_Policy__c = 'ABC12345678';
        insert insurance_oms_ms;
        
        oms_msr = new Opportunity();
        oms_msr.Name = 'test opp';
        oms_msr.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        oms_msr.Account = a;
        oms_msr.Sunshine_Center__c = a5.id;
        oms_msr.Closing_Agent__c = userAdmin.id;
        oms_msr.Amount = 999;
        oms_msr.StageName = 'Working';
        oms_msr.CloseDate = date.Today();
        oms_msr.Test_Class_Checkbox__c = True;
        oms_msr.Insurance_Provider__c = a2.id;
        insert oms_msr;
        
        insurance_oms_msr = new Insurance_Information__c();
        insurance_oms_msr.Insurance_Provider__c = a2.id;
        insurance_oms_msr.Opportunity__c = oms_msr.id;
        insurance_oms_msr.Insurance_Policy__c = 'ABC12345678';
        insert insurance_oms_msr;
        
        oms_cc_apr = new Opportunity();
        oms_cc_apr.Name = 'test opp';
        oms_cc_apr.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        oms_cc_apr.Account = a;
        oms_cc_apr.Sunshine_Center__c = a.id;
        oms_cc_apr.Closing_Agent__c = userAdmin.id;
        oms_cc_apr.Amount = 999;
        oms_cc_apr.StageName = 'Working';
        oms_cc_apr.CloseDate = date.Today();
        oms_cc_apr.Test_Class_Checkbox__c = True;
        oms_cc_apr.Insurance_Provider__c = a6.id;
        insert oms_cc_apr;
        
        insurance_oms_cc_apr = new Insurance_Information__c();
        insurance_oms_cc_apr.Insurance_Provider__c = a6.id;
        insurance_oms_cc_apr.Opportunity__c = oms_cc_apr.id;
        insurance_oms_cc_apr.Insurance_Policy__c = '12345678';
        insert insurance_oms_cc_apr;
        
        oms_ws_apr = new Opportunity();
        oms_ws_apr.Name = 'test opp';
        oms_ws_apr.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        oms_ws_apr.Account = a;
        oms_ws_apr.Sunshine_Center__c = a3.id;
        oms_ws_apr.Closing_Agent__c = userAdmin.id;
        oms_ws_apr.Amount = 999;
        oms_ws_apr.StageName = 'Working';
        oms_ws_apr.CloseDate = date.Today();
        oms_ws_apr.Test_Class_Checkbox__c = True;
        oms_ws_apr.Insurance_Provider__c = a6.id;
        insert oms_ws_apr;
        
        insurance_oms_ws_apr = new Insurance_Information__c();
        insurance_oms_ws_apr.Insurance_Provider__c = a6.id;
        insurance_oms_ws_apr.Opportunity__c = oms_ws_apr.id;
        insurance_oms_ws_apr.Insurance_Policy__c = 'ABC12345678';
        insert insurance_oms_ws_apr;
        
        oms_ms_apr = new Opportunity();
        oms_ms_apr.Name = 'test opp';
        oms_ms_apr.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        oms_ms_apr.Account = a;
        oms_ms_apr.Sunshine_Center__c = a4.id;
        oms_ms_apr.Closing_Agent__c = userAdmin.id;
        oms_ms_apr.Amount = 999;
        oms_ms_apr.StageName = 'Working';
        oms_ms_apr.CloseDate = date.Today();
        oms_ms_apr.Test_Class_Checkbox__c = True;
        oms_ms_apr.Insurance_Provider__c = a6.id;
        insert oms_ms_apr;
        
        insurance_oms_ms_apr = new Insurance_Information__c();
        insurance_oms_ms_apr.Insurance_Provider__c = a6.id;
        insurance_oms_ms_apr.Opportunity__c = oms_ms_apr.id;
        insurance_oms_ms_apr.Insurance_Policy__c = 'ABC12345678';
        insert insurance_oms_ms_apr;
        
        oms_msr_apr = new Opportunity();
        oms_msr_apr.Name = 'test opp';
        oms_msr_apr.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        oms_msr_apr.Account = a;
        oms_msr_apr.Sunshine_Center__c = a5.id;
        oms_msr_apr.Closing_Agent__c = userAdmin.id;
        oms_msr_apr.Amount = 999;
        oms_msr_apr.StageName = 'Working';
        oms_msr_apr.CloseDate = date.Today();
        oms_msr_apr.Test_Class_Checkbox__c = True;
        oms_msr_apr.Insurance_Provider__c = a6.id;
        insert oms_msr_apr;
        
        insurance_oms_msr_apr = new Insurance_Information__c();
        insurance_oms_msr_apr.Insurance_Provider__c = a6.id;
        insurance_oms_msr_apr.Opportunity__c = oms_msr_apr.id;
        insurance_oms_msr_apr.Insurance_Policy__c = 'ABC12345678';
        insert insurance_oms_msr_apr;
        
        List<Case> caseList = new List<Case>();
        
        c1 = new Case();
        c1.Opportunity__c = oms.id;
        c1.Bill_Date__c = date.today();
        c1.Bill_From_Date__c = date.today().addDays(-5);
        c1.Bill_To_Date__c = date.today();
        c1.Billed_Amount__c = 1500;
        c1.Status = 'Closed';
        c1.Level_of_Care__c = 'Detox';
        c1.Insurance_Information__c = insurance_oms.id;
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
        c2.Level_of_Care__c = 'Residential';
        c2.Insurance_Information__c = insurance_oms.id;
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
        c3.Level_of_Care__c = 'PHP';
        c3.Insurance_Information__c = insurance_oms.id;
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
        c4.Level_of_Care__c = 'IOP';
        c4.Insurance_Information__c = insurance_oms.id;
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
        c5.Level_of_Care__c = 'OP';
        c5.Insurance_Information__c = insurance_oms.id;
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
        c6.Level_of_Care__c = 'Lab Requests';
        c6.Insurance_Information__c = insurance_oms.id;
        c6.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c6);
        //insert c6;
        
        c7 = new Case();
        c7.Opportunity__c = oms_ws.id;
        c7.Bill_Date__c = date.today();
        c7.Bill_From_Date__c = date.today().addDays(-5);
        c7.Bill_To_Date__c = date.today();
        c7.Billed_Amount__c = 1500;
        c7.Status = 'Closed';
        c7.Level_of_Care__c = 'Detox';
        c7.Insurance_Information__c = insurance_oms_ws.id;
        c7.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c7);
        //insert c7;
        
        c8 = new Case();
        c8.Opportunity__c = oms_ws.id;
        c8.Bill_Date__c = date.today();
        c8.Bill_From_Date__c = date.today().addDays(-5);
        c8.Bill_To_Date__c = date.today();
        c8.Billed_Amount__c = 1500;
        c8.Status = 'Closed';
        c8.Level_of_Care__c = 'Residential';
        c8.Insurance_Information__c = insurance_oms_ws.id;
        c8.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c8);
        //insert c8;
        
        c9 = new Case();
        c9.Opportunity__c = oms_ws.id;
        c9.Bill_Date__c = date.today();
        c9.Bill_From_Date__c = date.today().addDays(-5);
        c9.Bill_To_Date__c = date.today();
        c9.Billed_Amount__c = 1500;
        c9.Status = 'Closed';
        c9.Level_of_Care__c = 'PHP';
        c9.Insurance_Information__c = insurance_oms_ws.id;
        c9.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c9);
        //insert c9;
        
        c10 = new Case();
        c10.Opportunity__c = oms_ws.id;
        c10.Bill_Date__c = date.today();
        c10.Bill_From_Date__c = date.today().addDays(-5);
        c10.Bill_To_Date__c = date.today();
        c10.Billed_Amount__c = 1500;
        c10.Status = 'Closed';
        c10.Level_of_Care__c = 'IOP';
        c10.Insurance_Information__c = insurance_oms_ws.id;
        c10.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c10);
        //insert c10;
        
        c11 = new Case();
        c11.Opportunity__c = oms_ws.id;
        c11.Bill_Date__c = date.today();
        c11.Bill_From_Date__c = date.today().addDays(-5);
        c11.Bill_To_Date__c = date.today();
        c11.Billed_Amount__c = 1500;
        c11.Status = 'Closed';
        c11.Level_of_Care__c = 'OP';
        c11.Insurance_Information__c = insurance_oms_ws.id;
        c11.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c11);
        //insert c11;
        
        c12 = new Case();
        c12.Opportunity__c = oms_ws.id;
        c12.Bill_Date__c = date.today();
        c12.Bill_From_Date__c = date.today().addDays(-5);
        c12.Bill_To_Date__c = date.today();
        c12.Billed_Amount__c = 1500;
        c12.Status = 'Closed';
        c12.Level_of_Care__c = 'Lab Requests';
        c12.Insurance_Information__c = insurance_oms_ws.id;
        c12.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c12);
        //insert c12;
        
        c13 = new Case();
        c13.Opportunity__c = oms_ms.id;
        c13.Bill_Date__c = date.today().addDays(-10);
        c13.Bill_From_Date__c = date.today().addDays(-5);
        c13.Bill_To_Date__c = date.today();
        c13.Billed_Amount__c = 1500;
        c13.Status = 'Closed';
        c13.Level_of_Care__c = 'Detox';
        c13.Insurance_Information__c = insurance_oms_ms.id;
        c13.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c13);
        //insert c13;
        
        
        c14 = new Case();
        c14.Opportunity__c = oms_ms.id;
        c14.Bill_Date__c = date.today().addDays(-40);
        c14.Bill_From_Date__c = date.today().addDays(-5);
        c14.Bill_To_Date__c = date.today();
        c14.Billed_Amount__c = 1500;
        c14.Status = 'Closed';
        c14.Level_of_Care__c = 'Residential';
        c14.Insurance_Information__c = insurance_oms_ms.id;
        c14.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c14);
        //insert c14;
        
        c15 = new Case();
        c15.Opportunity__c = oms_ms.id;
        c15.Bill_Date__c = date.today().addDays(-70);
        c15.Bill_From_Date__c = date.today().addDays(-5);
        c15.Bill_To_Date__c = date.today();
        c15.Billed_Amount__c = 1500;
        c15.Status = 'Closed';
        c15.Level_of_Care__c = 'PHP';
        c15.Insurance_Information__c = insurance_oms_ms.id;
        c15.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c15);
        //insert c15;
        
        c16 = new Case();
        c16.Opportunity__c = oms_ms.id;
        c16.Bill_Date__c = date.today().addDays(-100);
        c16.Bill_From_Date__c = date.today().addDays(-5);
        c16.Bill_To_Date__c = date.today();
        c16.Billed_Amount__c = 1500;
        c16.Status = 'Closed';
        c16.Level_of_Care__c = 'IOP';
        c16.Insurance_Information__c = insurance_oms_ms.id;
        c16.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c16);
        //insert c16;
        
        c17 = new Case();
        c17.Opportunity__c = oms_ms.id;
        c17.Bill_Date__c = date.today().addDays(-130);
        c17.Bill_From_Date__c = date.today().addDays(-5);
        c17.Bill_To_Date__c = date.today();
        c17.Billed_Amount__c = 1500;
        c17.Status = 'Closed';
        c17.Level_of_Care__c = 'OP';
        c17.Insurance_Information__c = insurance_oms_ms.id;
        c17.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c17);
        //insert c17;
        
        c18 = new Case();
        c18.Opportunity__c = oms_ms.id;
        c18.Bill_Date__c = date.today().addDays(-160);
        c18.Bill_From_Date__c = date.today().addDays(-5);
        c18.Bill_To_Date__c = date.today();
        c18.Billed_Amount__c = 1500;
        c18.Status = 'Closed';
        c18.Level_of_Care__c = 'Lab Requests';
        c18.Insurance_Information__c = insurance_oms_ms.id;
        c18.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c18);
        //insert c18;
        
        c19 = new Case();
        c19.Opportunity__c = oms_msr.id;
        c19.Bill_Date__c = date.today().addDays(-190);
        c19.Bill_From_Date__c = date.today().addDays(-5);
        c19.Bill_To_Date__c = date.today();
        c19.Billed_Amount__c = 1500;
        c19.Status = 'Closed';
        c19.Level_of_Care__c = 'Detox';
        c19.Insurance_Information__c = insurance_oms_msr.id;
        c19.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c19);
        //insert c19;
        
        c20 = new Case();
        c20.Opportunity__c = oms_msr.id;
        c20.Bill_Date__c = date.today().addDays(-220);
        c20.Bill_From_Date__c = date.today().addDays(-5);
        c20.Bill_To_Date__c = date.today();
        c20.Billed_Amount__c = 1500;
        c20.Status = 'Closed';
        c20.Level_of_Care__c = 'Residential';
        c20.Insurance_Information__c = insurance_oms_msr.id;
        c20.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c20);
        //insert c20;
        
        c21 = new Case();
        c21.Opportunity__c = oms_msr.id;
        c21.Bill_Date__c = date.today().addDays(-250);
        c21.Bill_From_Date__c = date.today().addDays(-5);
        c21.Bill_To_Date__c = date.today();
        c21.Billed_Amount__c = 1500;
        c21.Status = 'Closed';
        c21.Level_of_Care__c = 'PHP';
        c21.Insurance_Information__c = insurance_oms_msr.id;
        c21.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c21);
        //insert c21;
        
        c22 = new Case();
        c22.Opportunity__c = oms_msr.id;
        c22.Bill_Date__c = date.today().addDays(-280);
        c22.Bill_From_Date__c = date.today().addDays(-5);
        c22.Bill_To_Date__c = date.today();
        c22.Billed_Amount__c = 1500;
        c22.Status = 'Closed';
        c22.Level_of_Care__c = 'IOP';
        c22.Insurance_Information__c = insurance_oms_msr.id;
        c22.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c22);
        //insert c22;
        
        c23 = new Case();
        c23.Opportunity__c = oms_msr.id;
        c23.Bill_Date__c = date.today().addDays(-310);
        c23.Bill_From_Date__c = date.today().addDays(-5);
        c23.Bill_To_Date__c = date.today();
        c23.Billed_Amount__c = 1500;
        c23.Status = 'Closed';
        c23.Level_of_Care__c = 'OP';
        c23.Insurance_Information__c = insurance_oms_msr.id;
        c23.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c23);
        //insert c23;
        
        c24 = new Case();
        c24.Opportunity__c = oms_msr.id;
        c24.Bill_Date__c = date.today().addDays(-440);
        c24.Bill_From_Date__c = date.today().addDays(-5);
        c24.Bill_To_Date__c = date.today();
        c24.Billed_Amount__c = 1500;
        c24.Status = 'Closed';
        c24.Level_of_Care__c = 'Lab Requests';
        c24.Insurance_Information__c = insurance_oms_msr.id;
        c24.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c24);
        // insert c24;
        
        c25 = new Case();
        c25.Opportunity__c = oms_cc_apr.id;
        c25.Bill_Date__c = date.today();
        c25.Bill_From_Date__c = date.today().addDays(-5);
        c25.Bill_To_Date__c = date.today();
        c25.Billed_Amount__c = 1500;
        c25.Status = 'Closed';
        c25.Level_of_Care__c = 'Detox';
        c25.Insurance_Information__c = insurance_oms_cc_apr.id;
        c25.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c25);
        //insert c1;
        
        c26 = new Case();
        c26.Opportunity__c = oms_cc_apr.id;
        c26.Bill_Date__c = date.today();
        c26.Bill_From_Date__c = date.today().addDays(-5);
        c26.Bill_To_Date__c = date.today();
        c26.Billed_Amount__c = 1500;
        c26.Status = 'Closed';
        c26.Level_of_Care__c = 'Residential';
        c26.Insurance_Information__c = insurance_oms_cc_apr.id;
        c26.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c26);
        //insert c2;
        
        c27 = new Case();
        c27.Opportunity__c = oms_cc_apr.id;
        c27.Bill_Date__c = date.today();
        c27.Bill_From_Date__c = date.today().addDays(-5);
        c27.Bill_To_Date__c = date.today();
        c27.Billed_Amount__c = 1500;
        c27.Status = 'Closed';
        c27.Level_of_Care__c = 'PHP';
        c27.Insurance_Information__c = insurance_oms_cc_apr.id;
        c27.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c27);
        //insert c3;
        
        c28 = new Case();
        c28.Opportunity__c = oms_cc_apr.id;
        c28.Bill_Date__c = date.today();
        c28.Bill_From_Date__c = date.today().addDays(-5);
        c28.Bill_To_Date__c = date.today();
        c28.Billed_Amount__c = 1500;
        c28.Status = 'Closed';
        c28.Level_of_Care__c = 'IOP';
        c28.Insurance_Information__c = insurance_oms_cc_apr.id;
        c28.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c28);
        //insert c4;
        
        c29 = new Case();
        c29.Opportunity__c = oms_cc_apr.id;
        c29.Bill_Date__c = date.today();
        c29.Bill_From_Date__c = date.today().addDays(-5);
        c29.Bill_To_Date__c = date.today();
        c29.Billed_Amount__c = 1500;
        c29.Status = 'Closed';
        c29.Level_of_Care__c = 'OP';
        c29.Insurance_Information__c = insurance_oms_cc_apr.id;
        c29.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c29);
        //insert c5;
        
        c30 = new Case();
        c30.Opportunity__c = oms_cc_apr.id;
        c30.Bill_Date__c = date.today();
        c30.Bill_From_Date__c = date.today().addDays(-5);
        c30.Bill_To_Date__c = date.today();
        c30.Billed_Amount__c = 1500;
        c30.Status = 'Closed';
        c30.Level_of_Care__c = 'Lab Requests';
        c30.Insurance_Information__c = insurance_oms_cc_apr.id;
        c30.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c30);
        //insert c6;
        
        c31 = new Case();
        c31.Opportunity__c = oms_ws_apr.id;
        c31.Bill_Date__c = date.today();
        c31.Bill_From_Date__c = date.today().addDays(-5);
        c31.Bill_To_Date__c = date.today();
        c31.Billed_Amount__c = 1500;
        c31.Status = 'Closed';
        c31.Level_of_Care__c = 'Detox';
        c31.Insurance_Information__c = insurance_oms_ws_apr.id;
        c31.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c31);
        //insert c7;
        
        c32 = new Case();
        c32.Opportunity__c = oms_ws_apr.id;
        c32.Bill_Date__c = date.today();
        c32.Bill_From_Date__c = date.today().addDays(-5);
        c32.Bill_To_Date__c = date.today();
        c32.Billed_Amount__c = 1500;
        c32.Status = 'Closed';
        c32.Level_of_Care__c = 'Residential';
        c32.Insurance_Information__c = insurance_oms_ws_apr.id;
        c32.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c32);
        //insert c8;
        
        c33 = new Case();
        c33.Opportunity__c = oms_ws_apr.id;
        c33.Bill_Date__c = date.today();
        c33.Bill_From_Date__c = date.today().addDays(-5);
        c33.Bill_To_Date__c = date.today();
        c33.Billed_Amount__c = 1500;
        c33.Status = 'Closed';
        c33.Level_of_Care__c = 'PHP';
        c33.Insurance_Information__c = insurance_oms_ws_apr.id;
        c33.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c33);
        //insert c9;
        
        c34 = new Case();
        c34.Opportunity__c = oms_ws_apr.id;
        c34.Bill_Date__c = date.today();
        c34.Bill_From_Date__c = date.today().addDays(-5);
        c34.Bill_To_Date__c = date.today();
        c34.Billed_Amount__c = 1500;
        c34.Status = 'Closed';
        c34.Level_of_Care__c = 'IOP';
        c34.Insurance_Information__c = insurance_oms_ws_apr.id;
        c34.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c34);
        //insert c10;
        
        c35 = new Case();
        c35.Opportunity__c = oms_ws_apr.id;
        c35.Bill_Date__c = date.today();
        c35.Bill_From_Date__c = date.today().addDays(-5);
        c35.Bill_To_Date__c = date.today();
        c35.Billed_Amount__c = 1500;
        c35.Status = 'Closed';
        c35.Level_of_Care__c = 'OP';
        c35.Insurance_Information__c = insurance_oms_ws_apr.id;
        c35.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c35);
        
        c36 = new Case();
        c36.Opportunity__c = oms_ws_apr.id;
        c36.Bill_Date__c = date.today();
        c36.Bill_From_Date__c = date.today().addDays(-5);
        c36.Bill_To_Date__c = date.today();
        c36.Billed_Amount__c = 1500;
        c36.Status = 'Closed';
        c36.Level_of_Care__c = 'Lab Requests';
        c36.Insurance_Information__c = insurance_oms_ws_apr.id;
        c36.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c36);
        
        c37 = new Case();
        c37.Opportunity__c = oms_ms_apr.id;
        c37.Bill_Date__c = date.today().addDays(-10);
        c37.Bill_From_Date__c = date.today().addDays(-5);
        c37.Bill_To_Date__c = date.today();
        c37.Billed_Amount__c = 1500;
        c37.Status = 'Closed';
        c37.Level_of_Care__c = 'Detox';
        c37.Insurance_Information__c = insurance_oms_ms_apr.id;
        c37.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c37);
        
        
        c38 = new Case();
        c38.Opportunity__c = oms_ms_apr.id;
        c38.Bill_Date__c = date.today().addDays(-40);
        c38.Bill_From_Date__c = date.today().addDays(-5);
        c38.Bill_To_Date__c = date.today();
        c38.Billed_Amount__c = 1500;
        c38.Status = 'Closed';
        c38.Level_of_Care__c = 'Residential';
        c38.Insurance_Information__c = insurance_oms_ms_apr.id;
        c38.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c38);
        
        c39 = new Case();
        c39.Opportunity__c = oms_ms_apr.id;
        c39.Bill_Date__c = date.today().addDays(-70);
        c39.Bill_From_Date__c = date.today().addDays(-5);
        c39.Bill_To_Date__c = date.today();
        c39.Billed_Amount__c = 1500;
        c39.Status = 'Closed';
        c39.Level_of_Care__c = 'PHP';
        c39.Insurance_Information__c = insurance_oms_ms_apr.id;
        c39.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c39);
        
        c40 = new Case();
        c40.Opportunity__c = oms_ms_apr.id;
        c40.Bill_Date__c = date.today().addDays(-100);
        c40.Bill_From_Date__c = date.today().addDays(-5);
        c40.Bill_To_Date__c = date.today();
        c40.Billed_Amount__c = 1500;
        c40.Status = 'Closed';
        c40.Level_of_Care__c = 'IOP';
        c40.Insurance_Information__c = insurance_oms_ms_apr.id;
        c40.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c40);
        
        c41 = new Case();
        c41.Opportunity__c = oms_ms_apr.id;
        c41.Bill_Date__c = date.today().addDays(-130);
        c41.Bill_From_Date__c = date.today().addDays(-5);
        c41.Bill_To_Date__c = date.today();
        c41.Billed_Amount__c = 1500;
        c41.Status = 'Closed';
        c41.Level_of_Care__c = 'OP';
        c41.Insurance_Information__c = insurance_oms_ms_apr.id;
        c41.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c41);
        
        c42 = new Case();
        c42.Opportunity__c = oms_ms_apr.id;
        c42.Bill_Date__c = date.today().addDays(-160);
        c42.Bill_From_Date__c = date.today().addDays(-5);
        c42.Bill_To_Date__c = date.today();
        c42.Billed_Amount__c = 1500;
        c42.Status = 'Closed';
        c42.Level_of_Care__c = 'Lab Requests';
        c42.Insurance_Information__c = insurance_oms_ms_apr.id;
        c42.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c42);
        
        c43 = new Case();
        c43.Opportunity__c = oms_msr_apr.id;
        c43.Bill_Date__c = date.today().addDays(-190);
        c43.Bill_From_Date__c = date.today().addDays(-5);
        c43.Bill_To_Date__c = date.today();
        c43.Billed_Amount__c = 1500;
        c43.Status = 'Closed';
        c43.Level_of_Care__c = 'Detox';
        c43.Insurance_Information__c = insurance_oms_msr_apr.id;
        c43.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c43);
        
        c44 = new Case();
        c44.Opportunity__c = oms_msr_apr.id;
        c44.Bill_Date__c = date.today().addDays(-220);
        c44.Bill_From_Date__c = date.today().addDays(-5);
        c44.Bill_To_Date__c = date.today();
        c44.Billed_Amount__c = 1500;
        c44.Status = 'Closed';
        c44.Level_of_Care__c = 'Residential';
        c44.Insurance_Information__c = insurance_oms_msr_apr.id;
        c44.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c44);
        
        c45 = new Case();
        c45.Opportunity__c = oms_msr_apr.id;
        c45.Bill_Date__c = date.today().addDays(-250);
        c45.Bill_From_Date__c = date.today().addDays(-5);
        c45.Bill_To_Date__c = date.today();
        c45.Billed_Amount__c = 1500;
        c45.Status = 'Closed';
        c45.Level_of_Care__c = 'PHP';
        c45.Insurance_Information__c = insurance_oms_msr_apr.id;
        c45.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c45);
        
        c46 = new Case();
        c46.Opportunity__c = oms_msr_apr.id;
        c46.Bill_Date__c = date.today().addDays(-280);
        c46.Bill_From_Date__c = date.today().addDays(-5);
        c46.Bill_To_Date__c = date.today();
        c46.Billed_Amount__c = 1500;
        c46.Status = 'Closed';
        c46.Level_of_Care__c = 'IOP';
        c46.Insurance_Information__c = insurance_oms_msr_apr.id;
        c46.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c46);
        
        c47 = new Case();
        c47.Opportunity__c = oms_msr_apr.id;
        c47.Bill_Date__c = date.today().addDays(-310);
        c47.Bill_From_Date__c = date.today().addDays(-5);
        c47.Bill_To_Date__c = date.today();
        c47.Billed_Amount__c = 1500;
        c47.Status = 'Closed';
        c47.Level_of_Care__c = 'OP';
        c47.Insurance_Information__c = insurance_oms_msr_apr.id;
        c47.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c47);
        
        c48 = new Case();
        c48.Opportunity__c = oms_msr_apr.id;
        c48.Bill_Date__c = date.today().addDays(-440);
        c48.Bill_From_Date__c = date.today().addDays(-5);
        c48.Bill_To_Date__c = date.today();
        c48.Billed_Amount__c = 1500;
        c48.Status = 'Closed';
        c48.Level_of_Care__c = 'Lab Requests';
        c48.Insurance_Information__c = insurance_oms_msr_apr.id;
        c48.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId();
        caseList.add(c48);
        
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
        
        cli13 = new Collection_Line_Item__c();
        cli13.Case__c = c13.id; 
        cli13.Collection_Amount__c = 100;
        cli13.Type_of_Collection__c = 'Original bill';
        cli13.Collection_Date__c = date.today().addDays(15);
        insert cli13;
        
        cli14 = new Collection_Line_Item__c();
        cli14.Case__c = c14.id; 
        cli14.Collection_Amount__c = 100;
        cli14.Type_of_Collection__c = 'Original bill';
        cli14.Collection_Date__c = date.today().addDays(45);
        insert cli14;
        
        cli15 = new Collection_Line_Item__c();
        cli15.Case__c = c15.id; 
        cli15.Collection_Amount__c = 100;
        cli15.Type_of_Collection__c = 'Original bill';
        cli15.Collection_Date__c = date.today().addDays(75);
        insert cli15;
        
        cli16 = new Collection_Line_Item__c();
        cli16.Case__c = c16.id; 
        cli16.Collection_Amount__c = 100;
        cli16.Type_of_Collection__c = 'Original bill';
        cli16.Collection_Date__c = date.today().addDays(95);
        insert cli16;
        
        cli17 = new Collection_Line_Item__c();
        cli17.Case__c = c17.id; 
        cli17.Collection_Amount__c = 100;
        cli17.Type_of_Collection__c = 'Original bill';
        cli17.Collection_Date__c = date.today().addDays(125);
        insert cli17;
        
        cli18 = new Collection_Line_Item__c();
        cli18.Case__c = c18.id; 
        cli18.Collection_Amount__c = 100;
        cli18.Type_of_Collection__c = 'Original bill';
        cli18.Collection_Date__c = date.today().addDays(165);
        insert cli18;
        
        cli19 = new Collection_Line_Item__c();
        cli19.Case__c = c19.id; 
        cli19.Collection_Amount__c = 100;
        cli19.Type_of_Collection__c = 'Original bill';
        cli19.Collection_Date__c = date.today().addDays(195);
        insert cli19;
        
        cli20 = new Collection_Line_Item__c();
        cli20.Case__c = c20.id; 
        cli20.Collection_Amount__c = 100;
        cli20.Type_of_Collection__c = 'Original bill';
        cli20.Collection_Date__c = date.today().addDays(225);
        insert cli20;
        
        cli21 = new Collection_Line_Item__c();
        cli21.Case__c = c21.id; 
        cli21.Collection_Amount__c = 100;
        cli21.Type_of_Collection__c = 'Original bill';
        cli21.Collection_Date__c = date.today().addDays(255);
        insert cli21;
        
        cli22 = new Collection_Line_Item__c();
        cli22.Case__c = c22.id; 
        cli22.Collection_Amount__c = 100;
        cli22.Type_of_Collection__c = 'Original bill';
        cli22.Collection_Date__c = date.today().addDays(285);
        insert cli22;
        
        cli23 = new Collection_Line_Item__c();
        cli23.Case__c = c11.id; 
        cli23.Collection_Amount__c = 100;
        cli23.Type_of_Collection__c = 'Original bill';
        cli23.Collection_Date__c = date.today().addDays(315);
        insert cli23;
        
        cli24 = new Collection_Line_Item__c();
        cli24.Case__c = c24.id; 
        cli24.Collection_Amount__c = 100;
        cli24.Type_of_Collection__c = 'Original bill';
        cli24.Collection_Date__c = date.today().addDays(355);
        insert cli24;
        
        cli25 = new Collection_Line_Item__c();
        cli25.Case__c = c25.id; 
        cli25.Collection_Amount__c = 100;
        cli25.Type_of_Collection__c = 'Original bill';
        cli25.Collection_Date__c = date.today().addDays(15);
        insert cli25;
        
        cli26 = new Collection_Line_Item__c();
        cli26.Case__c = c26.id; 
        cli26.Collection_Amount__c = 100;
        cli26.Type_of_Collection__c = 'Original bill';
        cli26.Collection_Date__c = date.today().addDays(45);
        insert cli26;
        
        cli27 = new Collection_Line_Item__c();
        cli27.Case__c = c27.id; 
        cli27.Collection_Amount__c = 100;
        cli27.Type_of_Collection__c = 'Original bill';
        cli27.Collection_Date__c = date.today().addDays(75);
        insert cli27;
        
        cli28 = new Collection_Line_Item__c();
        cli28.Case__c = c28.id; 
        cli28.Collection_Amount__c = 100;
        cli28.Type_of_Collection__c = 'Original bill';
        cli28.Collection_Date__c = date.today().addDays(95);
        insert cli28;
        
        cli29 = new Collection_Line_Item__c();
        cli29.Case__c = c29.id; 
        cli29.Collection_Amount__c = 100;
        cli29.Type_of_Collection__c = 'Original bill';
        cli29.Collection_Date__c = date.today().addDays(125);
        insert cli29;
        
        cli30 = new Collection_Line_Item__c();
        cli30.Case__c = c30.id; 
        cli30.Collection_Amount__c = 100;
        cli30.Type_of_Collection__c = 'Original bill';
        cli30.Collection_Date__c = date.today().addDays(165);
        insert cli30;
        
        cli31 = new Collection_Line_Item__c();
        cli31.Case__c = c31.id; 
        cli31.Collection_Amount__c = 100;
        cli31.Type_of_Collection__c = 'Original bill';
        cli31.Collection_Date__c = date.today().addDays(195);
        insert cli31;
        
        cli32 = new Collection_Line_Item__c();
        cli32.Case__c = c32.id; 
        cli32.Collection_Amount__c = 100;
        cli32.Type_of_Collection__c = 'Original bill';
        cli32.Collection_Date__c = date.today().addDays(225);
        insert cli32;
        
        cli33 = new Collection_Line_Item__c();
        cli33.Case__c = c33.id; 
        cli33.Collection_Amount__c = 100;
        cli33.Type_of_Collection__c = 'Original bill';
        cli33.Collection_Date__c = date.today().addDays(255);
        insert cli33;
        
        cli34 = new Collection_Line_Item__c();
        cli34.Case__c = c34.id; 
        cli34.Collection_Amount__c = 100;
        cli34.Type_of_Collection__c = 'Original bill';
        cli34.Collection_Date__c = date.today().addDays(285);
        insert cli34;
        
        cli35 = new Collection_Line_Item__c();
        cli35.Case__c = c35.id; 
        cli35.Collection_Amount__c = 100;
        cli35.Type_of_Collection__c = 'Original bill';
        cli35.Collection_Date__c = date.today().addDays(315);
        insert cli35;
        
        cli36 = new Collection_Line_Item__c();
        cli36.Case__c = c36.id; 
        cli36.Collection_Amount__c = 100;
        cli36.Type_of_Collection__c = 'Original bill';
        cli36.Collection_Date__c = date.today().addDays(355);
        insert cli36;
        
        cli37 = new Collection_Line_Item__c();
        cli37.Case__c = c37.id; 
        cli37.Collection_Amount__c = 100;
        cli37.Type_of_Collection__c = 'Original bill';
        cli37.Collection_Date__c = date.today().addDays(15);
        insert cli37;
        
        cli38 = new Collection_Line_Item__c();
        cli38.Case__c = c38.id; 
        cli38.Collection_Amount__c = 100;
        cli38.Type_of_Collection__c = 'Original bill';
        cli38.Collection_Date__c = date.today().addDays(45);
        insert cli38;
        
        cli39 = new Collection_Line_Item__c();
        cli39.Case__c = c39.id; 
        cli39.Collection_Amount__c = 100;
        cli39.Type_of_Collection__c = 'Original bill';
        cli39.Collection_Date__c = date.today().addDays(75);
        insert cli39;
        
        cli40 = new Collection_Line_Item__c();
        cli40.Case__c = c40.id; 
        cli40.Collection_Amount__c = 100;
        cli40.Type_of_Collection__c = 'Original bill';
        cli4.Collection_Date__c = date.today().addDays(95);
        insert cli40;
        
        cli41 = new Collection_Line_Item__c();
        cli41.Case__c = c41.id; 
        cli41.Collection_Amount__c = 100;
        cli41.Type_of_Collection__c = 'Original bill';
        cli41.Collection_Date__c = date.today().addDays(125);
        insert cli41;
        
        cli42 = new Collection_Line_Item__c();
        cli42.Case__c = c42.id; 
        cli42.Collection_Amount__c = 100;
        cli42.Type_of_Collection__c = 'Original bill';
        cli42.Collection_Date__c = date.today().addDays(165);
        insert cli42;
        
        cli43 = new Collection_Line_Item__c();
        cli43.Case__c = c43.id; 
        cli43.Collection_Amount__c = 100;
        cli43.Type_of_Collection__c = 'Original bill';
        cli43.Collection_Date__c = date.today().addDays(195);
        insert cli43;
        
        cli44 = new Collection_Line_Item__c();
        cli44.Case__c = c44.id; 
        cli44.Collection_Amount__c = 100;
        cli44.Type_of_Collection__c = 'Original bill';
        cli44.Collection_Date__c = date.today().addDays(225);
        insert cli44;
        
        cli45 = new Collection_Line_Item__c();
        cli45.Case__c = c45.id; 
        cli45.Collection_Amount__c = 100;
        cli45.Type_of_Collection__c = 'Original bill';
        cli45.Collection_Date__c = date.today().addDays(255);
        insert cli45;
        
        cli46 = new Collection_Line_Item__c();
        cli46.Case__c = c46.id; 
        cli46.Collection_Amount__c = 100;
        cli46.Type_of_Collection__c = 'Original bill';
        cli46.Collection_Date__c = date.today().addDays(285);
        insert cli46;
        
        cli47 = new Collection_Line_Item__c();
        cli47.Case__c = c47.id; 
        cli47.Collection_Amount__c = 100;
        cli47.Type_of_Collection__c = 'Original bill';
        cli47.Collection_Date__c = date.today().addDays(315);
        insert cli47;
        
        cli48 = new Collection_Line_Item__c();
        cli48.Case__c = c48.id; 
        cli48.Collection_Amount__c = 100;
        cli48.Type_of_Collection__c = 'Original bill';
        cli48.Collection_Date__c = date.today().addDays(355);
        insert cli48;
        
        
     } 
     
     public Static testmethod void ReimbursementRate_Batches_Test(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           ReimbursementRate_Analytics_Batch b = new ReimbursementRate_Analytics_Batch();
           database.executebatch(b, 75);
           
           ReimbursementRate_Analytics_Batch b2 = new ReimbursementRate_Analytics_Batch();
           database.executebatch(b2, 75);
           
       }       
       test.StopTest();
             
      }
      
      public Static testmethod void Utilities_Analytics_Batches_Test2(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           
           ReimbursementRate_Analytics_BatchSchd m = new ReimbursementRate_Analytics_BatchSchd();
           String sch = '20 30 8 10 2 ?';
           String jobID = system.schedule('Reimbursement Batch Schedule', sch, m);
       
       }       
       test.StopTest();
             
      }
      
      public Static testmethod void Utilities_Analytics_Batches_Test3(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           ReimbursementRate_Analytics_Batch_Old b = new ReimbursementRate_Analytics_Batch_Old();
           database.executebatch(b, 75);
       
       }       
       test.StopTest();
             
      }
      
      public Static testmethod void Utilities_Analytics_Batches_Test4(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           
           ReimbursementRate_Analytics_BatchOldSchd m = new ReimbursementRate_Analytics_BatchOldSchd();
           String sch = '20 30 8 10 2 ?';
           String jobID = system.schedule('Reimbursement Batch Old Schedule', sch, m);
       
       }       
       test.StopTest();
             
      }
      
      
}