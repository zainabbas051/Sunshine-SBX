@isTest
private class createCollectionLineItemsTest {

    Public static Opportunity opp;
    Public static Insurance_Information__c ii;
    Public static Account a;
    Public static Account insuranceProvider;
    Public static Account sunshineCenter;
    Public Static Case c;
     public static profile adminProfile;
    public static User userAdmin {
        get{
            if (userAdmin == null ) {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName = 'LastTest', alias = 'FLast',
                email = 'test@key.net', communityNickname = 'test0101019', TimeZoneSidKey = 'America/New_York',
                LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', ProfileId = adminProfile.Id ,
                LanguageLocaleKey = 'en_US');
                insert userAdmin;
            }
            return userAdmin;
        }
        set;
    }

    public Static void createSampleData() {
        
         awsBucket__c aws = new awsBucket__c();
        aws.accessKeyId__c =  'AKIAIKHBOKKMOFRNX5XQ';
        aws.secretAccessKey__c = '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';
        aws.Bucket__c = 'freepu';
        aws.Name = 'FREEPU';
        insert aws;
        
        Id recTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();

        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;

        insuranceProvider = new Account();
        insuranceProvider.Name = 'United Healthcare';
        insuranceProvider.Type = 'Insurance Provider';
        insert insuranceProvider;

        sunshineCenter = new Account();
        sunshineCenter.Name = 'Monarch Shores';
        sunshineCenter.Type = 'Internal Center';
        insert sunshineCenter;

        opp = new Opportunity();
        opp.Name = 'test opp';
        opp.Account = a;
        opp.Selected_Treatment_Center__c = a.id;
        opp.Closing_Agent__c = userAdmin.id;
        opp.Amount = 999;
        opp.StageName = 'Paid';
        opp.CloseDate = date.Today();
        opp.recordTypeId = recTypeIdOpp;
        opp.Test_Class_Checkbox__c  = true;
        opp.Cash_Client__c = False;
        opp.Insurance_Providers__c = 'Spectra';
        opp.Insurance_Provider__c = insuranceProvider.id;
        opp.Sunshine_Center__c = sunshineCenter.id;
        insert opp;

        ii = new Insurance_Information__c();
        ii.Opportunity__c = opp.id;
        ii.Insurance_Status__c = 'Primary';
        insert ii;

        c = new Case();
        c.Opportunity__c = opp.id;
        c.Bill_Date__c = date.today();
        c.Bill_From_Date__c = date.today().addDays(-5);
        c.Bill_To_Date__c = date.today();
        c.Billed_Amount__c = 1500;
        c.Claim_Number__c = '123456789';
        c.Appeal_for_Adjustment_Status__c = 'Appeal Denied';
        c.RecordTypeId = Constants.insuranceClaimRecordTypeId;

        insert c;
    }

    public Static testmethod void createCollectionLineItems() {
        test.startTest();
        system.runAs(userAdmin) {
            createSampleData();

            Temp_Payment_Line_Items__c pli = new Temp_Payment_Line_Items__c();
            pli.Patient_Full_Name__c = 'test opp';
            pli.Charge_Claim_ID__c = '123456789';
            pli.Charge_From_Date__c  = date.today().addDays(-5);
            pli.Charge_Amount__c = 1500.00;
            pli.Deductible_Amount__c = 100.00;
            pli.Co_Insurance__c = 1000.00;
            pli.Charge_Total_Adjustments__c = 100.00;
            pli.Payment_Total_Paid__c = 100.00;
            pli.Payment_Check__c = '123456';
            pli.Case__c = c.id;
            //pli.Remark_Code_s__c = 
            pli.Sunshine_Center__c = sunshineCenter.id;
            insert pli;
            
        }
        test.StopTest();

    }




}