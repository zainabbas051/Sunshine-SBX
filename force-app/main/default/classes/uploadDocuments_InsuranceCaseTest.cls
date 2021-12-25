@isTest
private class uploadDocuments_InsuranceCaseTest{
    
    public Static ApexPages.StandardController caseController;
    Public static Opportunity opp;
    Public static Insurance_Information__c ii;
    Public static Account a;
    Public static Account insuranceProvider;
    Public static Account sunshineCenter;
    Public Static Case c;
    public Static uploadDocuments_InsuranceCase uploadDocumentExt;
    public static profile adminProfile;
    public static Documents_Type__c dt1;
    public static Documents_Type__c dt2;
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
        bucket.Name = 'salesforce';
        bucket.accessKeyId__c = '1234';
        bucket.Bucket__c = 'revenuecollections';
        bucket.secretAccessKey__c = '1234';
        insert bucket; 
        
        dt1 = new Documents_Type__c();
        dt1.Name = 'Explanation of Benefits';
        dt1.Is_Active__c = True;
        dt1.Is_Required__c = True;
        dt1.Object_API_Name__c = 'Case';
        insert dt1;
        
        dt2 = new Documents_Type__c();
        dt2.Name = 'Office Ally Confirmation Receipt';
        dt2.Is_Active__c = True;
        dt2.Is_Required__c = True;
        dt2.Object_API_Name__c = 'Case';
        insert dt2;
        
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
     
     public Static testmethod void uploadDocuments_InsuranceCase(){
         test.startTest();
         system.runAs(userAdmin){
            createSampleData();
            
            ApexPages.currentPage().getParameters().put('id', c.id);
            caseController = new ApexPages.StandardController(c);
            uploadDocumentExt = new uploadDocuments_InsuranceCase(caseController);
           
            list<uploadDocuments_InsuranceCase.docWrapper> newAttachmentList = uploadDocumentExt.setNewAttachments;
            set<String> existingAttachmentList = uploadDocumentExt.setExistingAttachments;
            
            Apexpages.currentPage().getParameters().put('message','test error');
            pageReference pr1 = uploadDocumentExt.cancelCustom();
            pageReference pr2 = uploadDocumentExt.validationError();
            
            String var1 = uploadDocuments_InsuranceCase.document_uploaded_true(c.id);
            
            uploadDocuments_InsuranceCase.docWrapper dw = new uploadDocuments_InsuranceCase.docWrapper('Explanation of Benefits',123456);
            dw.key = '235';
            dw.link = 'www.google.com';
            dw.id=c.id;
            String jsonString = JSON.Serialize(dw);
            
            String var2 = uploadDocuments_InsuranceCase.updateLink(jsonString);
         }
         test.StopTest();
             
      }
      
    
}