@isTest
private class msInsuranceCaseOwnerUpdateTest{
    
    Public static Opportunity opp;
    Public static Insurance_Information__c ii;
    Public static Account a;
    Public static Account insuranceProvider;
    Public static Account sunshineCenter;
    Public Static Case c;
    Public Static Case c1;
    public static profile adminProfile;
    PUBLIC static Trigger_Custom_Setting__c tcs;
    public static awsBucket__c AmazonBucketValue;
    public static OpportunityShare os;
    

    
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
    
    public static User userAdmin2
    {
        get{
            if (userAdmin2 == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin2  = new user (Username = ' test2@key.net', FirstName = 'FirstTest', LastName ='LastTest2', alias = 'FLast2', 
                            email='test@key.net', communityNickname='test0101012', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id ,
                            LanguageLocaleKey='en_US');
                insert userAdmin2;             
             }
             return userAdmin2;
            }
        set;
    }
    
    public Static void createSampleData(){
        
        Id recTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId(); 
        
        tcs = new Trigger_Custom_Setting__c();
        tcs.Name = 'Default';
        tcs.Disable_msInsuranceCaseOwnerUpdate__c = False;
        tcs.Disable_attachInsurance__c = False;
        tcs.Disable_updateCaseOwner__c = False;
        tcs.Disable_OpportunityupdateFirstBilledTrig__c  = false;
        insert tcs;
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        insuranceProvider = new Account();
        insuranceProvider.Name = 'United Healthcare';
        insuranceProvider.Type = 'Insurance Provider';
        insert insuranceProvider;
        
        sunshineCenter = new Account();
        sunshineCenter.Name = 'Chapters Capistrano';
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
        opp.Insurance_Collector__c = userAdmin2.id;
        insert opp;
        
        os = new OpportunityShare(OpportunityId=opp.id, OpportunityAccessLevel='Edit', UserOrGroupId=userAdmin2.id, RowCause='Manual');
        insert os;  
        
        ii = new Insurance_Information__c();
        ii.Opportunity__c = opp.id;
        ii.Insurance_Status__c = 'Primary';
        insert ii;
        
        AmazonBucketValue = new awsBucket__c();
        AmazonBucketValue.name='FREEPU';
        AmazonBucketValue.accessKeyId__c='testAcess';
    AmazonBucketValue.secretAccessKey__c='secretKey';
    AmazonBucketValue.Bucket__c='freepu';
    insert AmazonBucketValue;
        
        c = new Case();
        c.Opportunity__c = opp.id;
        c.Bill_Date__c = date.today();
        c.Bill_From_Date__c = date.today().addDays(-5);
        c.Bill_To_Date__c = date.today();
        c.Billed_Amount__c = 1500;
        insert c;
        
        
        
        c1 = new Case();
        c1.Opportunity__c = opp.id;
        c1.Bill_Date__c = date.today();
        c1.Bill_From_Date__c = date.today().addDays(-5);
        c1.Bill_To_Date__c = date.today();
        c1.Billed_Amount__c = 1500;
        //c1.isClosed = False;
        insert c1;
        
        
     }
     
     public Static testmethod void msInsuranceCaseOwnerUpdate(){
         test.startTest();
         //system.runAs(userAdmin2){
            createSampleData();
            
            opp.Insurance_Collector__c = userAdmin.id;
            update opp;
            
            c.Status = 'Closed';
            update c;
             c1.Status = 'Closed';
             //c1.IsClosed= False;
             update c1;
         //}
         test.StopTest();
             
      }
      
    
}