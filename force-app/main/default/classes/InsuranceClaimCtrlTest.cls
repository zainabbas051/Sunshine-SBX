@isTest
public class InsuranceClaimCtrlTest {
    
    public Static ApexPages.StandardController caseController;
    public Static ApexPages.StandardController caseController1;

    Public static Opportunity opp;
    Public static Insurance_Information__c ii;
    Public static Account a;
    Public static Account insuranceProvider;
    Public static Account sunshineCenter;
    Public Static Case c;
    Public Static Case c1;
    public static collection_line_item__C colIns;
    public static collection_line_item__C colIns1;

    public Static InsuranceClaimCtrl insClaimCtrl;
    public Static InsuranceClaimCtrl insClaimCtrl1;

    public static profile adminProfile;
    public static Documents_Type__c dt1;
    public static Documents_Type__c dt2;
        
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

        dt1 = new Documents_Type__c();
        dt1.Name = 'Explanation of Benefits';
        dt1.Is_Active__c = True;
        dt1.Is_Required__c = True;
        dt1.Object_API_Name__c='Case';
        insert dt1;

        dt2 = new Documents_Type__c();
        dt2.Name = 'Office Ally Confirmation Receipt';
        dt2.Is_Active__c = True;
        dt2.Is_Required__c = True;
        insert dt2;

        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;

        insuranceProvider = new Account();
        insuranceProvider.Name = 'United Healthcare';
        insuranceProvider.Type = 'Insurance Provider';
        insuranceProvider.Insurance_Group_Name__c = 'United Health Care';
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
        //c.Co_Pay_Amount__c = 200;
        //c.Deductible_Amount__c = 100;
        //c.Collected_Amount__c = 1000;
        c.Appeal_for_Adjustment_Status__c = 'Appeal Denied';
        c.RecordTypeId = Constants.insuranceClaimRecordTypeId;

        insert c;

        c1 = new Case();
        c1.Opportunity__c = opp.id;
        c1.Co_Pay_Amount__c = 200;
        insert c1;

        colIns = new collection_line_item__C();
        colIns.case__c = c1.id;
        insert colIns;

        colIns1 = new collection_line_item__C();
        colIns1.case__c = c1.id;
        insert colIns1;
    }

    public static testmethod void validateInsuranceClaimCtrl(){
        test.startTest();
        system.runAs(userAdmin) {
            createSampleData();
            
            ApexPages.currentPage().getParameters().put('id', c.id);
            ApexPages.currentPage().getParameters().put('message', 'Error');
            caseController = new ApexPages.StandardController(c);
            
            
            insClaimCtrl = new InsuranceClaimCtrl(caseController);
            insClaimCtrl.SaveCustom();
            insClaimCtrl.validationError();
  
            insClaimCtrl.cancelCustom();
            InsuranceClaimCtrl.document_uploaded_true('auditID');
            InsuranceClaimCtrl.updateLink('{"name":"testfile","link":"https://testwebsite.com","Id":"'+c.Id+'","key":"testfile"}');
            insClaimCtrl.callDocParser();
            insClaimCtrl.callDocParserResult();
            
            InsuranceClaimCtrl.DocumentTotals dt = new InsuranceClaimCtrl.DocumentTotals();
            dt.carriage='100';
            dt.confidence='100';
            dt.net='100';
            dt.tax='100';
            dt.total='100';
        }
        test.stopTest();
    }
}