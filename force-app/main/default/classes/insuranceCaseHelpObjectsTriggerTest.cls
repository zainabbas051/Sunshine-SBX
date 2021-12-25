@isTest
public class insuranceCaseHelpObjectsTriggerTest{
    
    Public static Opportunity opp;
    Public static Insurance_Information__c ii;
    Public static Account a;
    Public static Account insuranceProvider;
    Public static Account sunshineCenter;
    Public Static Case c;
    public static profile adminProfile;
    
    public static User userAdmin
    {
        get{
            if (userAdmin == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin  = new user (Username = 'test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
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
        insert c;
     }
     
     public Static testmethod void updateCaseStatusDMCR(){
         test.startTest();
         system.runAs(userAdmin){
            createSampleData();
            
            c.Status = 'Data Missing in Claim';
            update c;
            
            Data_Missing_in_Claim_Request__c dmcr = new Data_Missing_in_Claim_Request__c();
            dmcr.Related_Case__c = c.id;
            dmcr.Status__c = 'Open';
            insert dmcr;
            
            dmcr.Completed_Date_Time__c= Datetime.now();
            dmcr.New_Related_Case__c=c.id;
            dmcr.Status__c = 'Closed';
            update dmcr;
            
            
         }
         test.StopTest();
             
      }
      
      public Static testmethod void updateCaseStatus(){
         test.startTest();
         system.runAs(userAdmin){
            createSampleData();
            
            c.Status = 'Requesting Medical Records';
            update c;
            
            
            Insurance_Claim_Medical_Records_Request__c mrm = new Insurance_Claim_Medical_Records_Request__c();
            mrm.Related_Case__c = c.id;
            mrm.Status__c = 'Open';
            insert mrm;
            
            mrm.Related_Case__c = c.id;
            mrm.Completed_Date_TIme__c = Datetime.now();
            mrm.Status__c = 'Closed';
            update mrm;
            
            
         }
         test.StopTest();
             
      }
      
      public Static testmethod void updateCaseStateIAAR(){
         test.startTest();
         system.runAs(userAdmin){
            createSampleData();
            
            c.Status = 'Appeal Receipt Confirmation Pending';
            update c;
            
            
            Insurance_Appeal_for_Adjustment_Request__c aar = new Insurance_Appeal_for_Adjustment_Request__c();
            aar.Related_Case__c = c.id;
            aar.Status__c = 'Open';
            insert aar;
            
            aar.Status__c = 'Closed';
            update aar;
            
            
         }
         test.StopTest();
             
      }
      
    
}