@isTest
private class UtilizationReviewHomeControllerTest2{
    Public static Account a;
    Public static Client_Chart__c cc;
    Public static Utilization_Review__c  UR;
    Public static User u_test;
    Public Static Profile adminProfile;
    Public static Insurance_Information__c ii;
    Public static Insurance_Verification__c iv;
    Public static Opportunity o;
    public static TabViews__c tv;
    public static awsBucket__c AmazonBucketValue;
    
    public static User userAdmin
    {
        get{
            if (userAdmin == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
                            email='test@key.net', communityNickname='test0101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id ,
                            LanguageLocaleKey='en_US',Acess_Type__c='Admin');
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }
     
     public Static void createSampleData(){
        
        AmazonBucketValue = new awsBucket__c();
        AmazonBucketValue.name='FREEPU';
        AmazonBucketValue.accessKeyId__c='testAcess';
        AmazonBucketValue.secretAccessKey__c='secretKey';
        AmazonBucketValue.Bucket__c='freepu';
        insert AmazonBucketValue;
        
        tv = new TabViews__c();
        tv.Name = 'UtilizationReview';
        tv.Button_Access_Type__c = 'Admin';
        insert tv;
        
        a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Treatment Center';
        a.BillingStreet ='Test';
        a.BillingState = 'CA';
        a.BillingCity = 'Test';
        a.BillingPostalCode = '12345';
        insert a;
        
        o = new Opportunity();
        o.Name = 'test opp';
        o.Account = a;
        o.Selected_Treatment_Center__c = a.id;
        o.Closing_Agent__c = userAdmin.id;
        o.Amount = 999;
        o.StageName = 'Paid';
        o.CloseDate = date.Today();
        o.recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        o.Test_Class_Checkbox__c  = true;
        o.Cash_Client__c = False;
        o.Insurance_Providers__c= 'Spectra';
        insert o;
        
        cc = new Client_Chart__c();
        cc.Treatment_Center__c = a.ID;
        cc.Opportunity__c = o.id;
        cc.Primary_Therapist__c = UserINFO.getUserID();
        cc.RecordTypeID =Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        insert cc;
        
        ii = new Insurance_Information__c();
        ii.Opportunity__c = o.id;
        ii.Insurance_Status__c = 'Primary';
        insert ii;
         
        iv = new Insurance_Verification__c();
        iv.Related_Insurance_Information__c = ii.id;
        iv.Opportunity__c = o.id;
        insert iv;
        
     }
     
     public Static testmethod void UtilizationReviewHomeControllerTest(){
     
       test.startTest();
       system.runAs(userAdmin){
            createSampleData();
           
          ApexPages.currentPage().getParameters().put('id', cc.id);
          
          UtilizationReviewHomeController urhc = new UtilizationReviewHomeController();
          
          PageReference pr1 = urhc.addUtilizationReview();
          
          urhc.closePopup();
          urhc.showPopup();
          
          urhc.CaremanagerIns.LastName = 'Test Contact';
          urhc.SaveCareManager();
          
          List<contact> contactList = urhc.getConCareManagers();
          urhc.conID =contactList[0].id;
          urhc.EditCareManger();
          urhc.UpdateCareManager();
          urhc.deleteCareManger();
          
          PageReference pr2 = urhc.SaveAuthorization();
          List<Utilization_Review__c> urList= urhc.getAuthorizationLst();
          
          urhc.EvID = urList[0].id;
          urhc.EditAuthorization();
          PageReference pr3 = urhc.UpdateAuthorization();
          
          urhc.EvID = urList[0].id;
          urhc.deleteAuthorization();
          
          ApexPages.currentPage().getParameters().put('param', 'Care Manager Concurrent Review');
          urhc.OpenNewForm();
          
          ApexPages.currentPage().getParameters().put('param', 'Concurrent Review');
          urhc.OpenNewForm();
          
          ApexPages.currentPage().getParameters().put('param', 'Utilization Review');
          urhc.OpenNewForm();
          
          urhc.back();
          
          boolean flag = urhc.displayMainPage;
          boolean flag1 = urhc.displayCareManager;
          boolean flag2 = urhc.displayReview;
          boolean flag3 = urhc.displayUR;
                
          list<Utilization_Review__c> flag4 = urhc.lstReviews ;
          
          
          Boolean FlagAccessType = urhc.buttonAccessType;
          
          
       test.StopTest();                                        
                             
       }       
       
             
      }
      

}