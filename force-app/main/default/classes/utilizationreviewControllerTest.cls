@isTest
private class utilizationreviewControllerTest{
    Public static Account a;
    Public static Client_Chart__c cc;
    Public static UtlizationReviewOrder__c  VitalAss;
    Public static Utilization_Review__c  UtilizationReview;
    Public static User u_test;
    public Static Profile adminProfile;
    public static awsBucket__c AmazonBucketValue;
    public static Recurring_Assessment__c  ra;
    public static Order__c ord;
    public static TabViews__c tv;
     
    public static User userAdmin
    {
        get{
            if (userAdmin == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
                            email='test@key.net', communityNickname='test0101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id , User_Role__c = NULL,
                            LanguageLocaleKey='en_US',Acess_Type__c='Admin');
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }
     
     public Static void createSampleData(){
        
        tv = new TabViews__c();
        tv.Name = 'UtilizationReview';
        tv.Button_Access_Type__c = 'Admin';
        insert tv;
         
        AmazonBucketValue = new awsBucket__c();
        AmazonBucketValue.name = 'FREEPU';
        AmazonBucketValue.accessKeyId__c = '1234';
        AmazonBucketValue.secretAccessKey__c= '1234';
        insert AmazonBucketValue;
        
        a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Treatment Center';
        a.BillingStreet ='Test';
        a.BillingState = 'CA';
        a.BillingCity = 'Test';
        a.BillingPostalCode = '12345';
        insert a;
        
        
        cc = new Client_Chart__c();
        cc.name = 'test';
        cc.RecordTypeId = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
        insert cc;
        
        UtilizationReview = new Utilization_Review__c();
        UtilizationReview.Client_Chart__c = cc.id;
        UtilizationReview.RecordTypeId = Schema.SObjectType.Utilization_Review__c.getRecordTypeInfosByName().get('Utilization Review').getRecordTypeId();
        insert UtilizationReview;  
        
        ra = new Recurring_Assessment__c(); 
        ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId(); 
        ra.Name= 'Test';
        ra.Client_Chart__c = cc.id;
        insert ra;
        
        ord = new Order__c();
        ord.Status__c = 'Active';
        ord.Client_Chart__c = cc.id;
        ord.Start_Date__c = System.now();
        insert ord;
        
        VitalAss = new UtlizationReviewOrder__c();
        VitalAss.Utilization_Review__c = UtilizationReview.id;
        VitalAss.Vital_Sign__c = ra.id;
        VitalAss.Vital_Sign__r = ra;
        insert VitalAss;
        
     }
     
     public Static testmethod void utilizationreviewControllerTest(){
     
       test.startTest();
       system.runAs(userAdmin){
          createSampleData();
           
          ApexPages.currentPage().getParameters().put('Id', cc.id);
          ApexPages.CurrentPage().getParameters().put('rId',UtilizationReview.id);
          ApexPages.CurrentPage().getParameters().put('vId',VitalAss.id);
          
          utilizationreviewController urc = new utilizationreviewController();
          
          ApexPages.CurrentPage().getParameters().put('UtilId',UtilizationReview.id);
          ApexPages.CurrentPage().getParameters().put('ID',cc.id);
          
          utilizationreviewController urc2 = new utilizationreviewController();
          
          
          string flag = urc.ImageUrlAddress;
          string flag1 = urc.SelectedSignedOption;
          string flag2 = urc.RecordType;
          
          urc2.loadRelatedVitals();
          
          urc2.GetVitals();
          urc2.submit();
          
          urc2.GetVitals();
          urc2.ActiveUtilizationReview();
          
          //urc2.UpdateMedicationList();
          
          urc2.SelectedSignedOption = 'Staff';
          urc2.ActiveUtilizationReview();
          
           Boolean FlagAccessType = urc.buttonAccessType;
           
           pageReference pr1 = urc2.AddAttachment();
           
           List<UtlizationReviewOrder__c> listOfOrder = new List<UtlizationReviewOrder__c>();
           
           listOfOrder = urc2.ListOfOrder;
           
          
                             
       }       
       test.StopTest();
             
      }
      
   
       
}