@isTest
private class updateDMCRRelatedCaseTest{
    
    Public static Opportunity opp;
    Public static Insurance_Information__c ii;
    Public static Account a;
    Public static Account insuranceProvider;
    Public static Account sunshineCenter;
    Public Static Case cNew;
    Public Static Case cOld;
    Public Static Data_Missing_in_Claim_Request__c dmcr;
    Public Static Insurance_Claim_Medical_Records_Request__c mrm;
    Public Static Insurance_Appeal_for_Adjustment_Request__c aar;
    Public Static Insurance_Call_Log__c icl;
    Public Static Documents__c doc;
    public static profile adminProfile;
    public static awsBucket__c bucket;
    
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
        
        bucket = new awsBucket__c();
        bucket.Name = 'FREEPU';
        bucket.accessKeyId__c = '1234';
        bucket.Bucket__c = 'FREEPU';
        bucket.secretAccessKey__c = '1234';
        insert bucket; 
        
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
        
        cNew = new Case();
        cNew.Opportunity__c = opp.id;
        cNew.Bill_Date__c = date.today();
        cNew.Bill_From_Date__c = date.today().addDays(-5);
        cNew.Bill_To_Date__c = date.today();
        cNew.Billed_Amount__c = 1500;
        insert cNew;
        
        cOld = new Case();
        cOld.Opportunity__c = opp.id;
        cOld.Bill_Date__c = date.today();
        cOld.Bill_From_Date__c = date.today().addDays(-5);
        cOld.Bill_To_Date__c = date.today();
        cOld.Billed_Amount__c = 1500;
        insert cOld;
        
        dmcr = new Data_Missing_in_Claim_Request__c();
        dmcr.Related_Case__c = cOld.id;
        dmcr.Status__c = 'Open';
        insert dmcr;
        
        mrm = new Insurance_Claim_Medical_Records_Request__c();
        mrm.Related_Case__c = cOld.id;
        mrm.Status__c = 'Open';
        insert mrm;
        
        aar = new Insurance_Appeal_for_Adjustment_Request__c();
        aar.Related_Case__c = cOld.id;
        aar.Status__c = 'Open';
        insert aar;
        
        icl = new Insurance_Call_Log__c();
        icl.Related_Case__c = cOld.Id;
        insert icl;
        
        doc = new Documents__c();
        doc.case__c = cOld.Id;
        doc.AWS_Link__c = 'www.google.com';
        insert doc;
     }
     
     public Static testmethod void updateDMCRRelatedCase(){
         test.startTest();
         system.runAs(userAdmin){
            createSampleData();
            
            dmcr.Status__c = 'Closed';
            dmcr.New_Related_Case__c = cNew.id;
            dmcr.Completed_Date_Time__c = DateTime.Now();
            update dmcr;
            
         }
         test.StopTest();
             
      }
      
}