@isTest
private class uploadDocuments_PP_CollectionsTest{
    
    public Static ApexPages.StandardController ppliController;
    Public static Opportunity opp;
    Public static Payment_Plan__c ppRecord;
    Public static Payment_Plan_Line_Items__c ppliRecord;
    Public static Account a;
    public Static uploadDocuments_PaymentPlansCollections uploadDocumentExt;
    public static profile adminProfile;
    public static Documents_Type__c dt1;
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
        dt1.Name = 'Payment Receipt';
        dt1.Is_Active__c = True;
        dt1.Is_Required__c = True;
        dt1.Object_API_Name__c = 'Payment_Plan_Line_Items__c';
        insert dt1;
        
        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
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
        insert opp;
        
        ppRecord = new Payment_Plan__c();
        ppRecord.Opportunity__c = opp.id;
        ppRecord.Start_Date__c = date.Today();
        ppRecord.Total_Amount_To_Be_Collected__c = 1000;
        ppRecord.Payment_Plan_Type__c = 'Custom';
        insert ppRecord;
        
        ppliRecord = new Payment_Plan_Line_Items__c();
        //ciRecord.AWS_Link__c = 'Test';
        ppliRecord.Payment_Plan__c = ppRecord.id;
        insert ppliRecord;
        
    
     }
     
     public Static testmethod void uploadDocuments_PaymentPlansTest(){
         test.startTest();
         system.runAs(userAdmin){
            createSampleData();
            
            ApexPages.currentPage().getParameters().put('id', ppliRecord.id);
            ppliController = new ApexPages.StandardController(ppliRecord);
            uploadDocumentExt = new uploadDocuments_PaymentPlansCollections(ppliController);
           
            list<uploadDocuments_PaymentPlansCollections.docWrapper> newAttachmentList = uploadDocumentExt.setNewAttachments;
            set<String> existingAttachmentList = uploadDocumentExt.setExistingAttachments;
            
            Apexpages.currentPage().getParameters().put('message','test error');
            pageReference pr1 = uploadDocumentExt.cancelCustom();
            pageReference pr2 = uploadDocumentExt.validationError();
            
            String var1 = uploadDocuments_PaymentPlansCollections.document_uploaded_true(ppliRecord.id);
            
            uploadDocuments_InsuranceCase.docWrapper dw = new uploadDocuments_InsuranceCase.docWrapper('Credit Card Authorization',123456);
            dw.key = '235';
            dw.link = 'www.google.com';
            dw.id=ppliRecord.id;
            String jsonString = JSON.Serialize(dw);
            
            String var2 = uploadDocuments_PaymentPlansCollections.updateLink(jsonString);
         }
         test.StopTest();
             
      }
      
    
}