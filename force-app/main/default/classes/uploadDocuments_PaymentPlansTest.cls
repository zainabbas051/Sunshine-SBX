@isTest
private class uploadDocuments_PaymentPlansTest{
    
    public Static ApexPages.StandardController ciController;
    Public static Opportunity opp;
    Public static Payment_Plan__c ppRecord;
    public static Card_Information__c ciRecord;
    Public static Account a;
    public Static uploadDocuments_PaymentPlans uploadDocumentExt;
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
        dt1.Name = 'Credit Card Authorization';
        dt1.Is_Active__c = True;
        dt1.Is_Required__c = True;
        dt1.Object_API_Name__c = 'Card_Information__c';
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
        
        ciRecord = new Card_Information__c();
        //ciRecord.AWS_Link__c = 'Test';
        ciRecord.Card_Number__c = '1234123412341234';
        ciRecord.CVV__c = 123;
        ciRecord.Expiration_Month__c ='11';
        ciRecord.Expiration_Year__c = '20';
        ciRecord.Name_on_Card__c='John Smith';
        ciRecord.Payment_Plan__c = ppRecord.id;
        insert ciRecord;
        
    
     }
     
     public Static testmethod void uploadDocuments_PaymentPlansTest(){
         test.startTest();
         system.runAs(userAdmin){
            createSampleData();
            
            ApexPages.currentPage().getParameters().put('id', ciRecord.id);
            ciController = new ApexPages.StandardController(ciRecord);
            uploadDocumentExt = new uploadDocuments_PaymentPlans(ciController);
           
            list<uploadDocuments_PaymentPlans.docWrapper> newAttachmentList = uploadDocumentExt.setNewAttachments;
            set<String> existingAttachmentList = uploadDocumentExt.setExistingAttachments;
            
            Apexpages.currentPage().getParameters().put('message','test error');
            pageReference pr1 = uploadDocumentExt.cancelCustom();
            pageReference pr2 = uploadDocumentExt.validationError();
            
            String var1 = uploadDocuments_PaymentPlans.document_uploaded_true(ciRecord.id);
            
            uploadDocuments_InsuranceCase.docWrapper dw = new uploadDocuments_InsuranceCase.docWrapper('Credit Card Authorization',123456);
            dw.key = '235';
            dw.link = 'www.google.com';
            dw.id=ciRecord.id;
            String jsonString = JSON.Serialize(dw);
            
            String var2 = uploadDocuments_PaymentPlans.updateLink(jsonString);
            
            uploadDocuments_InsuranceCase.docWrapper dw1 = new uploadDocuments_InsuranceCase.docWrapper('Credit Card Authorization Ext1',123456);
            dw1.key = '235';
            dw1.link = 'www.google.com';
            dw1.id=ciRecord.id;
            String jsonString1 = JSON.Serialize(dw1);
            
            String var3 = uploadDocuments_PaymentPlans.updateLink(jsonString1);
            
            uploadDocuments_InsuranceCase.docWrapper dw2 = new uploadDocuments_InsuranceCase.docWrapper('Payment Plan Authorization',123456);
            dw2.key = '235';
            dw2.link = 'www.google.com';
            dw2.id=ciRecord.id;
            String jsonString2 = JSON.Serialize(dw);
            
            String var4 = uploadDocuments_PaymentPlans.updateLink(jsonString2);
            
            uploadDocuments_InsuranceCase.docWrapper dw3 = new uploadDocuments_InsuranceCase.docWrapper('Credit Card Authorization Ext2',123456);
            dw3.key = '235';
            dw3.link = 'www.google.com';
            dw3.id=ciRecord.id;
            String jsonString3 = JSON.Serialize(dw);
            
            String var5 = uploadDocuments_PaymentPlans.updateLink(jsonString3);
         }
         test.StopTest();
             
      }
      
    
}