@isTest
private class newInsuranceClaimCaseTest{

    Public static Opportunity opp;
    Public static Insurance_Information__c ii;
    Public static Account a;
    Public static Account insuranceProvider;
    Public static Account sunshineCenter;
    public static profile adminProfile;
    
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
        
        
     }
    
    public Static testmethod void newInsuranceClaimCase(){
         test.startTest();
         system.runAs(userAdmin){
            createSampleData();
            
            ApexPages.currentPage().getParameters().put('oppId', opp.id);
            
            newInsuranceClaimCase nicc = new newInsuranceClaimCase();
            
            pageReference pr1 = nicc.cancelRequest();
            
            pageReference pr2 = nicc.saveNewCase();
            
            nicc.tempCaseRecord.Bill_Date__c = date.Today();
            nicc.tempCaseRecord.Billed_Amount__c = 100;
            nicc.tempCaseRecord.Bill_From_Date__c = date.today();
            nicc.tempCaseRecord.Bill_To_Date__c = date.today();
            nicc.tempCaseRecord.Claim_Type__c = 'UB04';
            
            pageReference pr3 = nicc.saveNewCase();
            
            
        }
         test.StopTest();
             
      }
}