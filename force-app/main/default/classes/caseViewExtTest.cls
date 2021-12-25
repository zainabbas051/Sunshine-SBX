@isTest
public class caseViewExtTest
{
    
    Public static Case insuranceCase;
    Public static Case sfdcCase;
    Public static Account a;
    Public static Opportunity oerp1;
    public Static Profile adminProfile;
    public Static ApexPages.StandardController caseController;
    public Static caseViewExt cVExt;
    
    public static void createSampleData(){
        
         awsBucket__c aws = new awsBucket__c();
        aws.accessKeyId__c =  'AKIAIKHBOKKMOFRNX5XQ';
        aws.secretAccessKey__c = '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';
        aws.Bucket__c = 'freepu';
        aws.Name = 'FREEPU';
        insert aws;
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        Id msRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
        Opportunity oerp1 = new Opportunity();
        oerp1.Name = 'test opp';
        oerp1.RecordTypeId = msRecTypeId;
        oerp1.Account = a;
        oerp1.Selected_Treatment_Center__c = a.id;
        oerp1.Closing_Agent__c = userAdmin.id;
        oerp1.Amount = 999;
        oerp1.StageName = 'Working';
        //oerp1.Sunshine_Center__c = ms.id;
        oerp1.LeadSource = 'Monarch Shores';
        oerp1.CloseDate = date.Today();
        oerp1.Test_Class_Checkbox__c = True;
        oerp1.Stage_Pipeline_Forcast__c = 'Working';
        insert oerp1;
        
        
        Id insuranceRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Insurance Claim').getRecordTypeId(); 
        Id sfdcRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SF Support Case').getRecordTypeId(); 
        
        insuranceCase = new Case();
        insuranceCase.RecordTypeId = insuranceRecTypeId;
        insuranceCase.Opportunity__c = oerp1.id;
        insert insuranceCase;
        
        sfdcCase = new Case();
        sfdcCase.RecordTypeId = sfdcRecTypeId;
        insert sfdcCase;
        
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
    
    static testMethod void testInsuranceCaseRedirect() {
        createSampleData();
        
        Test.startTest();
            ApexPages.currentPage().getParameters().put('id', insuranceCase.id);
            caseController = new ApexPages.StandardController(insuranceCase);
            cVExt = new caseViewExt(caseController);
            PageReference pr1 = cVExt.pageRedirect(); 
            
        Test.stopTest();
    
    }
    
    static testMethod void testSFDCCaseRedirect() {
        createSampleData();
        
        Test.startTest();
            ApexPages.currentPage().getParameters().put('id', sfdcCase.id);
            caseController = new ApexPages.StandardController(sfdcCase);
            cVExt = new caseViewExt(caseController);
            PageReference pr1 = cVExt.pageRedirect(); 
            
        Test.stopTest();
    
    }
}