@isTest
private class PTMExtensionTest{
    
    public Static logInsuranceClaimCall caseController;
    Public static Opportunity opp;
    Public static Insurance_Information__c ii;
    Public static Account a;
    Public static Account insuranceProvider;
    Public static Account sunshineCenter;
    Public Static Case c;
    public static profile adminProfile;
        public static awsBucket__c AmazonBucketValue;

    Public static Fedex_Envelope_Request__c fer;
    Public static PTMExtension ptme;
    
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
        c.Appeal_for_Adjustment_Requested__c = False;
        c.PTM_Case__c = true;
        insert c;
        
        fer = new  Fedex_Envelope_Request__c();
        fer.Related_Case__c = c.id;
        insert fer; 
     }
     
       public Static testmethod void PTMExtension(){
         test.startTest();
         system.runAs(userAdmin){
            createSampleData();
            
            ApexPages.currentPage().getParameters().put('id', c.id);
            caseController = new logInsuranceClaimCall();
            ptme = new PTMExtension(caseController);
            
            List<SelectOption> statusList = ptme.getstatusValues();
            
            
            fer.Envelope_Tracking__c = '12345';
            update fer;
            
            ptme.loadData();
            ptme.addFedexReq();
            
            ptme.frEditIndex = fer.id; 
            ptme.editFedexRequest();  
            
            
            
            ptme.frSaveIndex = fer.id; 
            ptme.saveFedexRequest();  
            
            
            
            ptme.frSentIndex = fer.id; 
            ptme.sentFedexRequest();  
            
            
            fer.Status__c = 'Sent';
            update fer;
            
            ptme.loadData(); 
            ptme.addFedexReq();
            
            
            
      }      
     }       
  }