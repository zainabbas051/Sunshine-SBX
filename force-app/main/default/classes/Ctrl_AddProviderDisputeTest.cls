@isTest(SeeAllData = True)
public class Ctrl_AddProviderDisputeTest{

Public static Case insuranceCase;
    Public static Case sfdcCase;
    Public static Account a;
    Public static Opportunity oerp1;
    public Static Profile adminProfile;
    public Static ApexPages.StandardController caseController;
    public Static caseViewExt cVExt;
    
    public static void createSampleData(){
        a = new Account();
        a.Name = 'Chapters Capistrano';
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
      
        
        Test.startTest();
        
            createSampleData();
         
            ApexPages.currentPage().getParameters().put('id', insuranceCase.id);
            Ctrl_AddProviderDispute ctrlAddProvide = new Ctrl_AddProviderDispute();
            ctrlAddProvide.Enclosures = 'test 123';
            ctrlAddProvide.SelectedLetterOrigin='Sunshine BH';
            ctrlAddProvide.SelectedReasonForProviderDispute = 'Medical Necessity Reason';
            ctrlAddProvide.getLetterOrigin();
            ctrlAddProvide.getTypeofMail();
            ctrlAddProvide.getReasonsforProviderDispute();
            
            string userId = ctrlAddProvide.currentUserId;
            
            
            
            string baseUrl = ctrlAddProvide.baseurl;
            
            ctrlAddProvide.RedirectToOtherReason();
            ctrlAddProvide.createProviderDisputeUrl();
            ctrlAddProvide.CreateUrl();
            ctrlAddProvide.SelectedReasonForProviderDispute = 'Proof of Timely Filling';
            ctrlAddProvide.createProviderDisputeUrl();
            ctrlAddProvide.CreateUrl();
             ctrlAddProvide.SelectedReasonForProviderDispute = 'Others';
            ctrlAddProvide.createProviderDisputeUrl();
            ctrlAddProvide.CreateUrl();
            
           
            
            ctrlAddProvide.SelectedLetterOrigin='Insurance Provider';
            ctrlAddProvide.createProviderDisputeUrl();
            ctrlAddProvide.CreateUrl();
            
            //ctrlAddProvide.checkRequiredFieldsSave();
            
           ctrlAddProvide.cancelProcess();
            
        Test.stopTest();
    
    }
    
    static testMethod void testInsuranceCaseRedirect2() {
      
        
        Test.startTest();
        
            createSampleData();
         
            ApexPages.currentPage().getParameters().put('id', insuranceCase.id);
            Ctrl_AddProviderDispute ctrlAddProvide = new Ctrl_AddProviderDispute();
        
            ctrlAddProvide.SelectedReasonForProviderDispute = 'Others';
            
            
            ctrlAddProvide.checkRequiredFieldsSave();
            
          
            
        Test.stopTest();
    
    }
    
    static testMethod void testInsuranceCaseRedirect3() {
      
        
        Test.startTest();
        
            createSampleData();
         
            ApexPages.currentPage().getParameters().put('id', insuranceCase.id);
            Ctrl_AddProviderDispute ctrlAddProvide = new Ctrl_AddProviderDispute();
        
            ctrlAddProvide.SelectedReasonForProviderDispute = 'Medical Necessity Reason';
            
            
            ctrlAddProvide.checkRequiredFieldsSave();
            
          
            
        Test.stopTest();
    
    }
    
    static testMethod void testInsuranceCaseRedirect4() {
      
        
        Test.startTest();
        
            createSampleData();
         
            ApexPages.currentPage().getParameters().put('id', insuranceCase.id);
            Ctrl_AddProviderDispute ctrlAddProvide = new Ctrl_AddProviderDispute();
        
            ctrlAddProvide.createProviderDisputeUrl();
            
        //  ctrlAddProvide.checkRequiredFieldsSave();
            
          
            
        Test.stopTest();
    
    }
    
    
     static testMethod void testInsuranceCaseRedirect5() {
      
        
       Test.startTest();
        
            createSampleData();
         
            ApexPages.currentPage().getParameters().put('id', insuranceCase.id);
            Ctrl_AddProviderDispute ctrlAddProvide = new Ctrl_AddProviderDispute();
        
            ctrlAddProvide.SelectedLetterOrigin = 'None';
            
            ctrlAddProvide.checkRequiredFieldsSave();
            
          
            
        Test.stopTest();
    }
    static testMethod void testInsuranceCaseRedirect6() {
      
        
       Test.startTest();
        
            createSampleData();
         
            ApexPages.currentPage().getParameters().put('id', insuranceCase.id);
            Ctrl_AddProviderDispute ctrlAddProvide = new Ctrl_AddProviderDispute();
        
            ctrlAddProvide.SelectedLetterOrigin='Insurance Provider';
            ctrlAddProvide.PDisFile='false';
            ctrlAddProvide.SelectedTypeofMail = 'None';
            
            ctrlAddProvide.checkRequiredFieldsSave();
            
          
            
        Test.stopTest();
    }
    
     static testMethod void testInsuranceCaseRedirect7() {
      
        
        Test.startTest();
        
            createSampleData();
         
            ApexPages.currentPage().getParameters().put('id', insuranceCase.id);
            Ctrl_AddProviderDispute ctrlAddProvide = new Ctrl_AddProviderDispute();
            ctrlAddProvide.SelectedLetterOrigin='Insurance Provider';
        
            ctrlAddProvide.createProviderDisputeUrl();
            
        //  ctrlAddProvide.checkRequiredFieldsSave();
            
          
            
        Test.stopTest();
    
    }
    
    static testMethod void testInsuranceCaseRedirect8() {
      
        
        Test.startTest();
        
            createSampleData();
         
            ApexPages.currentPage().getParameters().put('id', insuranceCase.id);
            Ctrl_AddProviderDispute ctrlAddProvide = new Ctrl_AddProviderDispute();
            ctrlAddProvide.SelectedLetterOrigin='Insurance Provider';
            ctrlAddProvide.PDisFile='false';
        
            ctrlAddProvide.CheckFileUpload();
            
        //  ctrlAddProvide.checkRequiredFieldsSave();
            
          
            
        Test.stopTest();
    
    }
    
    
  


}