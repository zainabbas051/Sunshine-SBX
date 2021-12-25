@isTest(seeAllData = True)
private class uploadDocuments_MarketingCaseTest{
    
    public Static ApexPages.StandardController caseController;
    public Static uploadDocuments_MarketingCaseSnapshots uploadDocumentExt;
    public static profile adminProfile;
    public static case c;
    
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
        
        
        c = new Case();
        c.Type = 'Problem';
        c.Subject = 'Test';
        c.Description = 'Test';
        c.Source_URL__c = 'www.google.com';
        c.Source_Website__c = 'Sunshine';
        c.SuppliedName = 'Naveen Chugh';
        c.SuppliedEmail = 'naveenc@sunshinebh.com';
        c.SuppliedPhone = '5863424795';
        c.Status='Open';
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Marketing Support Case').getRecordTypeId();
        insert c;
        
     }
     
     public Static testmethod void uploadDocuments_MarketingCaseSnapshots(){
         test.startTest();
         system.runAs(userAdmin){
            createSampleData();
            
            ApexPages.currentPage().getParameters().put('id', c.id);
            uploadDocumentExt = new uploadDocuments_MarketingCaseSnapshots();
           
            
            Apexpages.currentPage().getParameters().put('message','test error');
            pageReference pr1 = uploadDocumentExt.cancelCustom();
            pageReference pr2 = uploadDocumentExt.validationError();
            
            String var1 = uploadDocuments_MarketingCaseSnapshots.document_uploaded_true(c.id);
            
            uploadDocuments_MarketingCaseSnapshots.docWrapper dw = new uploadDocuments_MarketingCaseSnapshots.docWrapper('Snapshot 1',123456);
            dw.key = '235';
            dw.link = 'www.google.com';
            dw.id=c.id;
            String jsonString = JSON.Serialize(dw);
            
            String var2 = uploadDocuments_MarketingCaseSnapshots.updateLink(jsonString);
         }
         test.StopTest();
             
      }
      
    
}